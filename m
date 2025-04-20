Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4570F158218
	for <mm-commits@vger.kernel.org>; Sun, 20 Apr 2025 21:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745184300; cv=none; b=gauD9TGE/vlw/PgU3Li8aAz5M1t3yvOb3SxM5mtAAT35hODRQ3Eo0P24ZRW3UlIpXbZHxPvZJV0+7t5jjTuqb/FNtrIA9Pc//muMUFtuWn5SWvhHpYJ0SqdYGxh4ln2uYQNvU/n9NFCqvPbbgY5y9ul7MtFXOyrYknIkRopdXUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745184300; c=relaxed/simple;
	bh=U9NtzYJKRx2NwlnUQ49GJlenczrY3URDWQvXUm1gwD8=;
	h=Date:To:From:Subject:Message-Id; b=HbzWfSEt9SzifFhcP0y4LDjclS83YhI1Bo4jiGUqAqp9I55zVxrFTgHKoW4/03jIxJLGmXhMspwVlNw5FbU7ICJSiQvJ7UivZ1d2jykZbyiyDydNGwkVQY68nwVIvfhY5rs9Ge9VqfFawMknEd1ntcUFoJJ7VYVuGk0Jia+AZLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W1/hrNLR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W1/hrNLR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B2DC4CEE2;
	Sun, 20 Apr 2025 21:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745184299;
	bh=U9NtzYJKRx2NwlnUQ49GJlenczrY3URDWQvXUm1gwD8=;
	h=Date:To:From:Subject:From;
	b=W1/hrNLRxGQ9KUDuv/nZJWn9PrfkpekmddwOmeZLkyB98yEu6302kSTPP8otj9Imw
	 P2fu+BSzoAY9GbYGlvbUB03EN1s5qKYrBBc3QuISntRbj5iqorDiXg9RB1Nduvkjnd
	 qYLj2is1RTSbg/JS1e7Rt9lZqEkpiLZb6gC2rMqQ=
Date: Sun, 20 Apr 2025 14:24:59 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,urezki@gmail.com,shivankg@amd.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmallocc-optimize-code-in-decay_va_pool_node-a-little-bit.patch added to mm-new branch
Message-Id: <20250420212459.A8B2DC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc.c: optimize code in decay_va_pool_node() a little bit
has been added to the -mm mm-new branch.  Its filename is
     mm-vmallocc-optimize-code-in-decay_va_pool_node-a-little-bit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmallocc-optimize-code-in-decay_va_pool_node-a-little-bit.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/vmalloc.c: optimize code in decay_va_pool_node() a little bit
Date: Sat, 19 Apr 2025 06:36:51 +0800

When purge lazily freed vmap areas, VA stored in vn->pool[] will also be
taken away into free vmap tree partially or completely accordingly, that
is done in decay_va_pool_node().  When doing that, for each pool of node,
the whole list is detached from the pool for handling.  At this time, that
pool is empty.  It's not necessary to update the pool size each time when
one VA is removed and addded into free vmap tree.

Here change code to update the pool size when attaching the pool back.

Link: https://lkml.kernel.org/r/20250418223653.243436-4-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Shivank Garg <shivankg@amd.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/mm/vmalloc.c~mm-vmallocc-optimize-code-in-decay_va_pool_node-a-little-bit
+++ a/mm/vmalloc.c
@@ -2149,7 +2149,7 @@ decay_va_pool_node(struct vmap_node *vn,
 	LIST_HEAD(decay_list);
 	struct rb_root decay_root = RB_ROOT;
 	struct vmap_area *va, *nva;
-	unsigned long n_decay;
+	unsigned long n_decay, pool_len;
 	int i;
 
 	for (i = 0; i < MAX_VA_SIZE_PAGES; i++) {
@@ -2163,22 +2163,20 @@ decay_va_pool_node(struct vmap_node *vn,
 		list_replace_init(&vn->pool[i].head, &tmp_list);
 		spin_unlock(&vn->pool_lock);
 
-		if (full_decay)
-			WRITE_ONCE(vn->pool[i].len, 0);
+		pool_len = n_decay = vn->pool[i].len;
+		WRITE_ONCE(vn->pool[i].len, 0);
 
 		/* Decay a pool by ~25% out of left objects. */
-		n_decay = vn->pool[i].len >> 2;
+		if (!full_decay)
+			n_decay >>= 2;
+		pool_len -= n_decay;
 
 		list_for_each_entry_safe(va, nva, &tmp_list, list) {
+			if (!n_decay--)
+				break;
+
 			list_del_init(&va->list);
 			merge_or_add_vmap_area(va, &decay_root, &decay_list);
-
-			if (!full_decay) {
-				WRITE_ONCE(vn->pool[i].len, vn->pool[i].len - 1);
-
-				if (!--n_decay)
-					break;
-			}
 		}
 
 		/*
@@ -2187,9 +2185,10 @@ decay_va_pool_node(struct vmap_node *vn,
 		 * can populate the pool therefore a simple list replace
 		 * operation takes place here.
 		 */
-		if (!full_decay && !list_empty(&tmp_list)) {
+		if (!list_empty(&tmp_list)) {
 			spin_lock(&vn->pool_lock);
 			list_replace_init(&tmp_list, &vn->pool[i].head);
+			WRITE_ONCE(vn->pool[i].len, pool_len);
 			spin_unlock(&vn->pool_lock);
 		}
 	}
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-gup-remove-unneeded-checking-in-follow_page_pte.patch
mm-gup-remove-gup_fast_pgd_leaf-and-clean-up-the-relevant-codes.patch
mm-gup-clean-up-codes-in-fault_in_xxx-functions.patch
mm-gup-clean-up-codes-in-fault_in_xxx-functions-v5.patch
mm-vmallocc-change-purge_ndoes-as-local-static-variable.patch
mm-vmallocc-find-the-vmap-of-vmap_nodes-in-reverse-order.patch
mm-vmallocc-optimize-code-in-decay_va_pool_node-a-little-bit.patch
mm-vmalloc-optimize-function-vm_unmap_aliases.patch
mm-vmallocc-return-explicit-error-value-in-alloc_vmap_area.patch

