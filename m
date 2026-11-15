Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794712660;
	b=fT6vSP4MZrP1iXICwqZX+gSrCGCcMMu4ZYKLsXgGYeG7ZXe8+xBg7sqTK5tKn0Pudr/Y
	 SB2MYt4n0ovV38CGHF4vCyWycZxMFXsh8VbvPOK48fp2g1a9QKZ64rJHPC6s8SpD8V4Kk
	 2i80024FKIKl05+eksFnzl4KmJiTXYa5V+r57cC7XRWgglMwO7+SPaLN6XGWewRzj/4Jc
	 AqKQoBONmrJjoXx70GkrbyVEudAvUZBapZFYiQU3JTMghI+d/vvmYahUmtXACSZMUkbAF
	 oUzWozXqPDB2Ts+wOOWOu9wXFNzmTJsurobJfusK6mEXe9/yVDER90BLoYbVmgkTt3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794712660;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=J1/xLtC+Oc+FHp5F/IqmigeM38URmv/n3kMpWZHMx8c=;
	b=ko82gz0CN8KHGIFnrMOjUK3puw26uYGkifBuzm9IXdrSyiGo175UIRRY7Sl1V6NQoZ5S
	 KIxtViG5b2drDCPH26vFijLs7q28N1P+sVgX8Uxl8EbiGJCHg8vYlYnamaaffTN6y9eMZ
	 Fwc3qcz8vNXptIPrk0wJktNUBaskBHGFsdHXk8qx0os26xfMcEQiOZBAv2MQJzKhEXpQB
	 BXv3X+cecDifEgYWzodya1bSr8gq1NTKnG7zPVdh0Jw+eltPkYneZFgLj/J6VUKgXWf9i
	 mWSg0oWaimeGMbI8fOoR1hv/0+WRgsmDkmLwH4SfY+KtLNRKDVAJMpDhwhqomM/Ef8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WUnCWxxz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C8D606A329
	for <mm-commits@vger.kernel.org>; Sun, 15 Nov 2026 03:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WUnCWxxz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F17621F000C4;
	Sun, 15 Nov 2026 03:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794712660;
	bh=J1/xLtC+Oc+FHp5F/IqmigeM38URmv/n3kMpWZHMx8c=;
	h=Date:To:From:Subject;
	b=WUnCWxxzF41J7RBEQT7A9otimjk/1P53CiMaQ7OCP1a6jSL+cUmNy2tv28tcB5x7I
	 c6V5Uy5w4RHk2oCah3+ox3mR0GNaW9qRwMKq38zxgm519LilEgt//TtpeeQDnGecUH
	 nNSTOtk0O3PMhCVV58OI07s/wBflwN1dc5E16BtY=
Date: Sat, 14 Nov 2026 19:17:39 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tujinjiang@huawei.com,
	shardul.b@mpiricsoftware.com,janak@mpiricsoftware.com,dev.jain@arm.com,
	david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_xarray-check-unused-spare-node-after-range-creation.patch added to mm-new branch
Message-Id: <20261115031739.F17621F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: lib/test_xarray: check unused spare node after range creation
has been added to the -mm mm-new branch.  Its filename is
     lib-test_xarray-check-unused-spare-node-after-range-creation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_xarray-check-unused-spare-node-after-range-creation.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib/test_xarray: check unused spare node after range creation
Date: Sun, 15 Nov 2026 00:10:24 +0000

Shardul Bankar's "[PATCH v4] lib: xarray: free unused spare node in
xas_create_range()" [1] releases a spare node left over after range
creation.  Exercise the case without depending on allocator failures or
timing: let xas_nomem() reserve a node, then populate the relevant XArray
node through a separate operation before xas_create_range() retries.

Check that the retry succeeds and releases the unused spare node.

Link: https://lore.kernel.org/r/20251204142625.1763372-1-shardul.b@mpiricsoftware.com [1]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Shardul Bankar <shardul.b@mpiricsoftware.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand (ARM) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: <janak@mpiricsoftware.com>
Cc: Jinjiang Tu <tujinjiang@huawei.com>

 lib/test_xarray.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

--- a/lib/test_xarray.c~lib-test_xarray-check-unused-spare-node-after-range-creation
+++ a/lib/test_xarray.c
@@ -1834,6 +1834,34 @@ static noinline void check_create_range_
 	xa_destroy(xa);
 }
 
+#ifdef CONFIG_XARRAY_MULTI
+static noinline void check_create_range_spare(struct xarray *xa)
+{
+	XA_STATE_ORDER(xas, xa, 0, XA_CHUNK_SHIFT);
+	bool spare_left;
+
+	XA_BUG_ON(xa, !xa_empty(xa));
+
+	/* Model a failed allocation followed by a successful xas_nomem(). */
+	xas_set_err(&xas, -ENOMEM);
+	XA_BUG_ON(xa, !xas_nomem(&xas, GFP_KERNEL));
+
+	/* Model another user populating the tree before the retry. */
+	xa_insert_index(xa, 0);
+	xa_insert_index(xa, 1);
+
+	xas_lock(&xas);
+	xas_create_range(&xas);
+	xas_unlock(&xas);
+
+	XA_BUG_ON(xa, xas_error(&xas));
+	spare_left = xas.xa_alloc != NULL;
+	xas_destroy(&xas);
+	XA_BUG_ON(xa, spare_left);
+	xa_destroy(xa);
+}
+#endif
+
 static noinline void check_create_range(struct xarray *xa)
 {
 	unsigned int order;
@@ -1867,6 +1895,9 @@ static noinline void check_create_range(
 	}
 
 	check_create_range_3();
+#ifdef CONFIG_XARRAY_MULTI
+	check_create_range_spare(xa);
+#endif
 }
 
 static noinline void __check_store_range(struct xarray *xa, unsigned long first,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-list_lru-dont-use-a-new-memcgs-lists-for-an-offline-memcg-fix.patch
shmem-consume-the-reserved-xattr-space-despite-remount.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch
mm-cma-simplify-cma_declare_contiguous_multi-fix.patch
selftests-mm-allocate-nr_pages-based-on-pmd-size-for-uffd-pmd_move-tests-fix.patch
selftests-mm-retain-move-pmd-coverage-and-verify-huge-pmds.patch
mm-mremap-reject-gaps-before-fixed-moves.patch
lib-test_xarray-check-unused-spare-node-after-range-creation.patch
profile-account-for-partial-proc-profile-reads.patch
profile-simplify-proc-profile-read-layout.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

