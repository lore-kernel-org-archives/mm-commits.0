Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794293150;
	b=OAijdSa9f05GWmEBaVJoMjmZn5jIdmKsynjHEoYmLnzsEDTY/FsyRiZ5JWGpTBc6CuQ+
	 k9SRXkbdWqu6ta4vDbqyUdVgO0z+gso7pGhjPN4abszaGsPT7ev3w7sRvqGoiaA1oGRZp
	 EayGFEnzLRQBVncSNqoafQtNtUDunsNXSIHZ/fMZVLOPSpGYTWc6VCEfGfVRQKzxJIF+v
	 t1mIE3YfiPZQIRnZ62Js2oFr7bRvf7DtY150pbTp22UZA7PNWVTmALFQOy3qyP73F7rsC
	 7ZdClP1sH8JxK/gdfFhyEqK8dsOf4Z9a3zP6IQRjlYaIWm1QaCvhKEv2MbdR/ZJXhhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794293150;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=PNLKcWUha+JxcIEEd1NXMITrvwxwhq9sUaHV9y3fNCY=;
	b=ZJjjO6TzurOupitkA3jKpYKu7op6qLCFbhKkEGJW6ueByzYcUGoZ+cMHj45Trqh2bHI5
	 VMBHjuLI1mwnqU9FaUrCB6UeKvyxEJAMagCU2bcdQs+AxPtih9KZMsN7CMNxjN43QAyxg
	 GzsG1JpLeZDI0Q0hNoOoAKo9gFug4xHjhg/V7b6Og4lSqOYe1O1b03fVZ/3cuhmWR0l/+
	 jkiCJeuCnhRCCgTXttVTBRwkvzbPsuhqobTrpnviq+GT25sgeHJaXvd2wxaidhsW7E6FF
	 X0btkkyl81II89OM1R8+z5Q74C0E5HfSVWp7qtdKjSQ9Bi8H6VTJfoCRd8PJiKftqTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=NCKbpNeZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA8F606A64D;
	Tue, 10 Nov 2026 06:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=NCKbpNeZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E331F0089F;
	Tue, 10 Nov 2026 06:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794293149;
	bh=PNLKcWUha+JxcIEEd1NXMITrvwxwhq9sUaHV9y3fNCY=;
	h=Date:To:From:Subject;
	b=NCKbpNeZUbS/ARjGGCU92p+9vFOka3OLTr+oqSy8zlWMQmFAm0q/RPMQ2wr3pSDL9
	 CC1WxIATd4e1Rn+NfAzVaWrlRJOuN26Ie65Km/eZ3wC1a/sVYwAY4LNtpOpz8e3ugn
	 yl54xnP+20LhyfDBE0VHnV7aDhKYrP5GhwLw9LoI=
Date: Mon, 09 Nov 2026 22:45:49 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,
	syzbot+b72767277f29b6407083@syzkaller.appspotmail.com,stable@vger.kernel.org,
	rppt@kernel.org,jose.fernandez@linux.dev,krystianmkaniewski@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] xarray-fix-index-jumping-backwards-in-xas_find.patch removed from -mm tree
Message-Id: <20261110064549.C6E331F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: xarray: fix index jumping backwards in xas_find()
has been removed from the -mm tree.  Its filename was
     xarray-fix-index-jumping-backwards-in-xas_find.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
Subject: xarray: fix index jumping backwards in xas_find()
Date: Fri, 4 Sep 2026 14:12:59 +0200

A bug in the XArray iterator xas_find() causes the iterator's index
(xas->xa_index) to jump backwards when iterating over a multi-index entry
(like a THP) that resides in a non-leaf node and is concurrently split.

When iterating over a multi-index entry in a non-leaf node, xas_load()
sets xas->xa_offset to the base offset of the entry, but leaves
xas->xa_index at the requested index.  When the caller subsequently wants
to advance to the next entry, xas_find() is called.  xas_find() attempts
to synchronize xas->xa_offset with xas->xa_index before advancing. 
However, the fixup logic was incorrectly restricted to leaf nodes
(!xas->xa_node->shift).  Because the THP resides in a non-leaf node, the
fixup is skipped.

As a result, xas_find() simply increments xas->xa_offset and recalculates
xas->xa_index based on this new offset.  This causes xas->xa_index to jump
backwards.  If the THP was concurrently split, the entry at the new offset
is a node pointer, so xas_find() descends into it and returns the folio at
the backwards index.  The caller (filemap_map_pages()) then calculates the
PTE pointer based on this backwards index, resulting in an invalid memory
access such as an out-of-bounds read or use-after-free on a page-table
page freed via tlb_remove_table_rcu().

A userspace access that faults in a file-backed mapping can trigger this
path.  When the index moves backwards, filemap_map_pages() can calculate a
PTE outside the page locked for fault-around and dereference a freed
page-table page, resulting in a KASAN-detected use-after-free read.

To fix this, check if xas->xa_offset matches get_offset(xas->xa_index,
xas->xa_node).  If it does not and the node is a non-leaf node, set
xas->xa_offset to get_offset(xas->xa_index, xas->xa_node) before
advancing.  Also add test cases in test_xarray to verify xas_find()
behavior when iterating over and splitting multi-index entries.

Link: https://lore.kernel.org/20260904121301.200049-1-krystianmkaniewski@gmail.com
Fixes: b803b42823d0 ("xarray: Add XArray iterators")
Reported-by: syzbot+b72767277f29b6407083@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b72767277f29b6407083
Closes: https://syzkaller.appspot.com/ai_job?id=a01c56bd-74d0-411c-afb4-ee6f0cb6cb61
Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
  Link: https://lore.kernel.org/20261104-jf-filemap-v2-pedro-reply-r2-74c87c6fbcf@linux.dev
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: <stable@vger.kernel.org>
---

 lib/test_xarray.c |   70 ++++++++++++++++++++++++++++++++++++++++++++
 lib/xarray.c      |    8 +++--
 2 files changed, 75 insertions(+), 3 deletions(-)

--- a/lib/test_xarray.c~xarray-fix-index-jumping-backwards-in-xas_find
+++ a/lib/test_xarray.c
@@ -1247,6 +1247,75 @@ static noinline void check_multi_find_3(
 	}
 }
 
+static noinline void check_multi_find_4(struct xarray *xa)
+{
+#ifdef CONFIG_XARRAY_MULTI
+	unsigned int order = XA_CHUNK_SHIFT + 1;
+	unsigned long next = 1UL << order;
+	unsigned long start = next - 1;
+	XA_STATE(xas, xa, start);
+	XA_STATE_ORDER(split, xa, 0, 0);
+	void *entry;
+	unsigned long i;
+
+	/* Multi-index entry in two slots of a non-leaf node. */
+	xa_store_order(xa, 0, order, xa_mk_index(0), GFP_KERNEL);
+	XA_BUG_ON(xa, xa_store_index(xa, next, GFP_KERNEL) != NULL);
+
+	rcu_read_lock();
+	entry = xas_find(&xas, ULONG_MAX);
+	XA_BUG_ON(xa, entry != xa_mk_index(0));
+	XA_BUG_ON(xa, xas.xa_index != start);
+
+	entry = xas_find(&xas, ULONG_MAX);
+	XA_BUG_ON(xa, entry != xa_mk_index(next));
+	XA_BUG_ON(xa, xas.xa_index != next);
+
+	entry = xas_find(&xas, ULONG_MAX);
+	XA_BUG_ON(xa, entry != NULL);
+	rcu_read_unlock();
+
+	xa_erase_index(xa, next);
+	xa_erase_index(xa, 0);
+	XA_BUG_ON(xa, !xa_empty(xa));
+
+	/* Split the multi-index entry after a lookup begins inside it. */
+	xa_store_order(xa, 0, order, xa_mk_index(0), GFP_KERNEL);
+	XA_BUG_ON(xa, xa_store_index(xa, next, GFP_KERNEL) != NULL);
+
+	xas_set(&xas, start);
+	rcu_read_lock();
+	entry = xas_find(&xas, ULONG_MAX);
+	XA_BUG_ON(xa, entry != xa_mk_index(0));
+	XA_BUG_ON(xa, xas.xa_index != start);
+	rcu_read_unlock();
+
+	xas_split_alloc(&split, xa_mk_index(0), order, GFP_KERNEL);
+	if (xas_error(&split)) {
+		XA_BUG_ON(xa, true);
+		goto out;
+	}
+	xas_lock(&split);
+	xas_split(&split, xa_mk_index(0), order);
+	for (i = 0; i < next; i++)
+		__xa_store(xa, i, xa_mk_index(i), 0);
+	xas_unlock(&split);
+
+	rcu_read_lock();
+	entry = xas_find(&xas, ULONG_MAX);
+	XA_BUG_ON(xa, entry != xa_mk_index(next));
+	XA_BUG_ON(xa, xas.xa_index != next);
+
+	entry = xas_find(&xas, ULONG_MAX);
+	XA_BUG_ON(xa, entry != NULL);
+	rcu_read_unlock();
+
+out:
+	xa_destroy(xa);
+	XA_BUG_ON(xa, !xa_empty(xa));
+#endif
+}
+
 static noinline void check_find_1(struct xarray *xa)
 {
 	unsigned long i, j, k;
@@ -1370,6 +1439,7 @@ static noinline void check_find(struct x
 		check_multi_find_1(xa, i);
 	check_multi_find_2(xa);
 	check_multi_find_3(xa);
+	check_multi_find_4(xa);
 }
 
 /* See find_swap_entry() in mm/shmem.c */
--- a/lib/xarray.c~xarray-fix-index-jumping-backwards-in-xas_find
+++ a/lib/xarray.c
@@ -1410,9 +1410,11 @@ void *xas_find(struct xa_state *xas, uns
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


