Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20783955F5;
	Thu,  3 Sep 2026 18:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788459777; cv=none; b=jEk7Tu6e3X3zTuzE/8KdStbz4DygymtfoDOF+g0BQcA7BLJea2x9H2ieSf0WT/zpAeQlkvG8xhSTxYOmVJvaTCMOTjxHuoiUi7zrUMb1gPkkK91ndibLPqQI3s99kqTcbldLQsb5zpLIqIZR4K661W+5U/U9JyD8MoWB34Mssd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788459777; c=relaxed/simple;
	bh=92Ycwo0Ow8DQ55GAY+sGEngY6g3FpzxkTrsqdUhxQFs=;
	h=Date:To:From:Subject:Message-Id; b=gAval40RgZYaY57Tv8tZd7ZQfvmoT7sGlsT3JWQ+06iXsaobgESRWORgJFodUR3UG37rQw7LavHJ5OGtSsiI77ALMojEvqN/9WkMPhMSXNQ2JZuQZ/knnM1iDOAt9HsOFFErshNdkeJ4AneVRNEjwVj/Dq2kPb42HYNwAPmOoYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HAG8PmQN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HAG8PmQN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 902311F000E9;
	Thu,  3 Sep 2026 18:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788459775;
	bh=Nk8LlCJouLacWDu0IjKvUq0f6wbxIFnm6uBePRjeQT0=;
	h=Date:To:From:Subject;
	b=HAG8PmQN4Lky37Dm9HorRt53VU0OtHCHG97c/i7aGp3vePRkzOOsBFJpj8fADe3dG
	 /QMRf5eQL9TkUf66sDfUEn/vQQdSB2fi2vFHmr2t3E49LWRWxSFhIQo6LWIKgHowwS
	 /J826VL9RwohJdpFBPX0DQIu1xszx3OessqnCpLY=
Date: Thu, 03 Sep 2026 11:22:55 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,krystianmkaniewski@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xarray-fix-index-jumping-backwards-in-xas_find.patch added to mm-hotfixes-unstable branch
Message-Id: <20260903182255.902311F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xarray: fix index jumping backwards in xas_find()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     xarray-fix-index-jumping-backwards-in-xas_find.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xarray-fix-index-jumping-backwards-in-xas_find.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

xarray-fix-index-jumping-backwards-in-xas_find.patch

