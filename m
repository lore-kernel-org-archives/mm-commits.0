Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0FE32C7A
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 06:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OkKF6wH9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17A3C433F1;
	Wed, 10 Jan 2024 06:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704867796;
	bh=BHYtfk3Q/RuIuAxO69d5B58jyQ/Fs/bb0/i06VO2kBs=;
	h=Date:To:From:Subject:From;
	b=OkKF6wH91lazCAsVSq9beSmJaIrxftj3Q7AUmf+y8H24lggH1UaMPJfR01+lEvYqv
	 jyWm7VrsR2HVNOk9+CIi98RvG3N+dsF1b29shA8bxnf+YfNJA6Nc1g8XfUn24U6Yg7
	 LMJPRpTh+eAoabxNd88Qc0+ttPB1h/K2Ternmtv0=
Date: Tue, 09 Jan 2024 22:23:16 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,paulmck@kernel.org,oleksiy.avramchenko@sony.com,lstoakes@gmail.com,Liam.Howlett@oracle.com,k-hagio-ab@nec.com,joel@joelfernandes.org,hch@lst.de,david@fromorbit.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-rename-adjust_va_to_fit_type-function.patch added to mm-unstable branch
Message-Id: <20240110062316.A17A3C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmalloc: rename adjust_va_to_fit_type() function
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-rename-adjust_va_to_fit_type-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-rename-adjust_va_to_fit_type-function.patch

This patch will later appear in the mm-unstable branch at
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
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm: vmalloc: rename adjust_va_to_fit_type() function
Date: Tue, 2 Jan 2024 19:46:24 +0100

This patch renames the adjust_va_to_fit_type() function to va_clip() which
is shorter and more expressive.

There is no a functional change as a result of this patch.

Link: https://lkml.kernel.org/r/20240102184633.748113-3-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Kazuhito Hagio <k-hagio-ab@nec.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-rename-adjust_va_to_fit_type-function
+++ a/mm/vmalloc.c
@@ -1382,9 +1382,9 @@ classify_va_fit_type(struct vmap_area *v
 }
 
 static __always_inline int
-adjust_va_to_fit_type(struct rb_root *root, struct list_head *head,
-		      struct vmap_area *va, unsigned long nva_start_addr,
-		      unsigned long size)
+va_clip(struct rb_root *root, struct list_head *head,
+		struct vmap_area *va, unsigned long nva_start_addr,
+		unsigned long size)
 {
 	struct vmap_area *lva = NULL;
 	enum fit_type type = classify_va_fit_type(va, nva_start_addr, size);
@@ -1500,7 +1500,7 @@ va_alloc(struct vmap_area *va,
 		return vend;
 
 	/* Update the free vmap_area. */
-	ret = adjust_va_to_fit_type(root, head, va, nva_start_addr, size);
+	ret = va_clip(root, head, va, nva_start_addr, size);
 	if (WARN_ON_ONCE(ret))
 		return vend;
 
@@ -4155,9 +4155,8 @@ retry:
 			/* It is a BUG(), but trigger recovery instead. */
 			goto recovery;
 
-		ret = adjust_va_to_fit_type(&free_vmap_area_root,
-					    &free_vmap_area_list,
-					    va, start, size);
+		ret = va_clip(&free_vmap_area_root,
+			&free_vmap_area_list, va, start, size);
 		if (WARN_ON_ONCE(unlikely(ret)))
 			/* It is a BUG(), but trigger recovery instead. */
 			goto recovery;
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-add-va_alloc-helper.patch
mm-vmalloc-rename-adjust_va_to_fit_type-function.patch
mm-vmalloc-move-vmap_init_free_space-down-in-vmallocc.patch
mm-vmalloc-remove-global-vmap_area_root-rb-tree.patch
mm-vmalloc-remove-global-purge_vmap_area_root-rb-tree.patch
mm-vmalloc-offload-free_vmap_area_lock-lock.patch
mm-vmalloc-support-multiple-nodes-in-vread_iter.patch
mm-vmalloc-support-multiple-nodes-in-vmallocinfo.patch
mm-vmalloc-set-nr_nodes-based-on-cpus-in-a-system.patch
mm-vmalloc-add-a-shrinker-to-drain-vmap-pools.patch

