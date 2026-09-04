Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02683509F0D;
	Fri,  4 Sep 2026 17:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788543616; cv=none; b=Y2+FExrooCVsPUAeMN0Iy9qpIzi42iIu+mk/4SSDP4xuzuBwARyf2dUrtYxH8pi6l1tcqItr9Zx3n7cewO0Urni5Otk3jgryormWT0/MuwYvmPPlJ8//3MCcRcOILJJp4J2Xmz0eeKw+Yzw0i3CZtsCBASn4wPWES+kmiEGplnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788543616; c=relaxed/simple;
	bh=PXi0k0PSY3qoZhYiBXiyXuEK3cOChCB5kr8CujFOREM=;
	h=Date:To:From:Subject:Message-Id; b=e0a+b4VK/acGhwu3mdl9/VHMb3ok/n9nHGlf+1wMJDMuY/h8Yhy4yxWwmRZN4nsbIkxriwwK16TMhXz9Yc1iW18avi2QT8AWJN24LwUuY5ojiXbxd4/gOcdpbejDzbC25D+g4cPaiXFDtoRdRktopNQg2C+3vATZMFaSBO2AKkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0HQMqm5G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0HQMqm5G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50CB51F00A3D;
	Fri,  4 Sep 2026 17:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788543614;
	bh=veZnheyTMc/rz+CO0oCbMAZ2pnGVn4tasnlGfPfwB2c=;
	h=Date:To:From:Subject;
	b=0HQMqm5GNnwandN/AogO7pOWkccRthmQa+AGc+n4eIYdwIDtquyr0NtTg7FZ/YS4B
	 +qXDfaps5ZQ6yg3+FsmPa0kg9w5ryQX8clGo7OMzPdwxVlaXAUgozjnG59RX0rb6aX
	 IcvyhBc6x4eKRsgiQKll+s50NQ3Rrvdw2oon8t58=
Date: Fri, 04 Sep 2026 10:40:13 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,krystianmkaniewski@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] xarray-fix-index-jumping-backwards-in-xas_find.patch removed from -mm tree
Message-Id: <20260904174014.50CB51F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xarray: fix index jumping backwards in xas_find()
has been removed from the -mm tree.  Its filename was
     xarray-fix-index-jumping-backwards-in-xas_find.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
Subject: xarray: fix index jumping backwards in xas_find()
Date: Thu, 3 Sep 2026 13:48:55 +0000 (UTC)

A bug in the XArray iterator xas_find() causes the iterator's index
(xas->xa_index) to jump backwards when iterating over a multi-index entry
(like a THP) that resides in a non-leaf node and is concurrently split.

This results in a use-after-free in ptep_get(), detected by KASAN [1].

When iterating over a multi-index entry in a non-leaf node, xas_load() sets
xas->xa_offset to the base offset of the entry, but leaves xas->xa_index at
the requested index. When the caller subsequently wants to advance to the
next entry, xas_find() is called. xas_find() attempts to synchronize
xas->xa_offset with xas->xa_index before advancing. However, the fixup
logic was incorrectly restricted to leaf nodes (!xas->xa_node->shift).
Because the THP resides in a non-leaf node, the fixup is skipped.

As a result, xas_find() simply increments xas->xa_offset and recalculates
xas->xa_index based on this new offset. This causes xas->xa_index to jump
backwards. If the THP was concurrently split, the entry at the new offset
is a node pointer, so xas_find() descends into it and returns the folio at
the backwards index. The caller (filemap_map_pages()) then calculates the
PTE pointer based on this backwards index, resulting in an invalid memory
access such as an out-of-bounds read or use-after-free on a page-table page
freed via tlb_remove_table_rcu().

To fix this, check if xas->xa_offset matches get_offset(xas->xa_index,
xas->xa_node). If it does not and the node is a non-leaf node, set
xas->xa_offset to get_offset(xas->xa_index, xas->xa_node) before advancing.
Also add test cases in test_xarray to verify xas_find() behavior when
iterating over and splitting multi-index entries.

Link: https://lore.kernel.org/2992424b-2120-489e-9010-f45f46ed52c8@mail.kernel.org
Fixes: b803b42823d0 ("xarray: Add XArray iterators")
Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>
Assisted-by: Gemini:gemini-3.7-flash syzbot
Reported-by: syzbot+b72767277f29b6407083@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b72767277f29b6407083 [1]
Link: https://syzkaller.appspot.com/ai_job?id=a01c56bd-74d0-411c-afb4-ee6f0cb6cb61
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_xarray.c |   62 ++++++++++++++++++++++++++++++++++++++++++++
 lib/xarray.c      |    8 +++--
 2 files changed, 67 insertions(+), 3 deletions(-)

--- a/lib/test_xarray.c~xarray-fix-index-jumping-backwards-in-xas_find
+++ a/lib/test_xarray.c
@@ -1247,6 +1247,67 @@ static noinline void check_multi_find_3(
 	}
 }
 
+static noinline void check_multi_find_4(struct xarray *xa)
+{
+#ifdef CONFIG_XARRAY_MULTI
+	XA_STATE(xas, xa, 100);
+	XA_STATE_ORDER(split, xa, 0, 0);
+	void *entry;
+	unsigned long i;
+
+	/* (1) Order-7 entry (0-127) with adjacent entry at 128, starting at 100 */
+	xa_store_order(xa, 0, 7, xa_mk_index(0), GFP_KERNEL);
+	XA_BUG_ON(xa, xa_store_index(xa, 128, GFP_KERNEL) != NULL);
+
+	rcu_read_lock();
+	entry = xas_find(&xas, ULONG_MAX);
+	XA_BUG_ON(xa, entry != xa_mk_index(0));
+	XA_BUG_ON(xa, xas.xa_index != 100);
+
+	entry = xas_find(&xas, ULONG_MAX);
+	XA_BUG_ON(xa, entry != xa_mk_index(128));
+	XA_BUG_ON(xa, xas.xa_index != 128);
+
+	entry = xas_find(&xas, ULONG_MAX);
+	XA_BUG_ON(xa, entry != NULL);
+	rcu_read_unlock();
+
+	xa_erase_index(xa, 128);
+	xa_erase_index(xa, 0);
+	XA_BUG_ON(xa, !xa_empty(xa));
+
+	/* (2) Splitting a multi-index entry after a lookup begins inside it */
+	xa_store_order(xa, 0, 7, xa_mk_index(0), GFP_KERNEL);
+	XA_BUG_ON(xa, xa_store_index(xa, 128, GFP_KERNEL) != NULL);
+
+	xas_set(&xas, 100);
+	rcu_read_lock();
+	entry = xas_find(&xas, ULONG_MAX);
+	XA_BUG_ON(xa, entry != xa_mk_index(0));
+	XA_BUG_ON(xa, xas.xa_index != 100);
+	rcu_read_unlock();
+
+	xas_split_alloc(&split, xa_mk_index(0), 7, GFP_KERNEL);
+	xas_lock(&split);
+	xas_split(&split, xa_mk_index(0), 7);
+	for (i = 0; i < 128; i++)
+		__xa_store(xa, i, xa_mk_index(i), 0);
+	xas_unlock(&split);
+
+	rcu_read_lock();
+	entry = xas_find(&xas, ULONG_MAX);
+	XA_BUG_ON(xa, entry != xa_mk_index(128));
+	XA_BUG_ON(xa, xas.xa_index != 128);
+
+	entry = xas_find(&xas, ULONG_MAX);
+	XA_BUG_ON(xa, entry != NULL);
+	rcu_read_unlock();
+
+	xa_destroy(xa);
+	XA_BUG_ON(xa, !xa_empty(xa));
+#endif
+}
+
 static noinline void check_find_1(struct xarray *xa)
 {
 	unsigned long i, j, k;
@@ -1370,6 +1431,7 @@ static noinline void check_find(struct x
 		check_multi_find_1(xa, i);
 	check_multi_find_2(xa);
 	check_multi_find_3(xa);
+	check_multi_find_4(xa);
 }
 
 /* See find_swap_entry() in mm/shmem.c */
--- a/lib/xarray.c~xarray-fix-index-jumping-backwards-in-xas_find
+++ a/lib/xarray.c
@@ -1409,9 +1409,11 @@ void *xas_find(struct xa_state *xas, uns
 		entry = xas_load(xas);
 		if (entry || xas_not_node(xas->xa_node))
 			return entry;
-	} else if (!xas->xa_node->shift &&
-		    xas->xa_offset != (xas->xa_index & XA_CHUNK_MASK)) {
-		xas->xa_offset = ((xas->xa_index - 1) & XA_CHUNK_MASK) + 1;
+	} else if (xas->xa_offset != get_offset(xas->xa_index, xas->xa_node)) {
+		if (!xas->xa_node->shift)
+			xas->xa_offset = ((xas->xa_index - 1) & XA_CHUNK_MASK) + 1;
+		else
+			xas->xa_offset = get_offset(xas->xa_index, xas->xa_node);
 	}
 
 	xas_next_offset(xas);
_

Patches currently in -mm which might be from krystianmkaniewski@gmail.com are


