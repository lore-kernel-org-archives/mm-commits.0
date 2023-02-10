Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C5B5C61DA4
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:55:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbjBJAzd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:55:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbjBJAyi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:54:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E99721FD
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:53:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9092D61C32
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:53:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E125AC433EF;
        Fri, 10 Feb 2023 00:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990422;
        bh=WPrLSSjJ9zO2OTZqcqyDCCEwsAD9xVew+Mu/jFj15fc=;
        h=Date:To:From:Subject:From;
        b=a7F6H0aLVNlv5DuJDk7JhNPQJ18RxezhtOCyo7p2CVCPI7igFeD7AAb4BTL/+PDOZ
         L7yBJ/H8ZR9UGQwzWqZps3ulCkNIQXPcHeyoG1IrKP84tgp0g44iH7xxLRiotmE5ie
         9SUVBO0682YFUnhdwlOvTiPj9UkOWi91x/Y+mb+k=
Date:   Thu, 09 Feb 2023 16:53:41 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        vbabka@suse.cz, songliubraving@fb.com, soheil@google.com,
        shakeelb@google.com, sebastian.reichel@collabora.com,
        rppt@kernel.org, rientjes@google.com, punit.agrawal@bytedance.com,
        posk@google.com, peterz@infradead.org, peterx@redhat.com,
        paulmck@kernel.org, mingo@redhat.com, minchan@google.com,
        mhocko@suse.com, mgorman@techsingularity.net, luto@kernel.org,
        lstoakes@gmail.com, Liam.Howlett@Oracle.com, ldufour@linux.ibm.com,
        kent.overstreet@linux.dev, joelaf@google.com, jannh@google.com,
        hughd@google.com, hannes@cmpxchg.org, gthelen@google.com,
        edumazet@google.com, dhowells@redhat.com, david@redhat.com,
        dave@stgolabs.net, bigeasy@linutronix.de, axelrasmussen@google.com,
        arjunroy@google.com, surenb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-replace-vm_locked_clear_mask-with-vm_locked_mask.patch removed from -mm tree
Message-Id: <20230210005341.E125AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: replace VM_LOCKED_CLEAR_MASK with VM_LOCKED_MASK
has been removed from the -mm tree.  Its filename was
     mm-replace-vm_locked_clear_mask-with-vm_locked_mask.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: replace VM_LOCKED_CLEAR_MASK with VM_LOCKED_MASK
Date: Thu, 26 Jan 2023 11:37:48 -0800

To simplify the usage of VM_LOCKED_CLEAR_MASK in vm_flags_clear(), replace
it with VM_LOCKED_MASK bitmask and convert all users.

Link: https://lkml.kernel.org/r/20230126193752.297968-4-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arjun Roy <arjunroy@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joel Fernandes <joelaf@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Minchan Kim <minchan@google.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Peter Oskolkov <posk@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Punit Agrawal <punit.agrawal@bytedance.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Sebastian Reichel <sebastian.reichel@collabora.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 ++--
 kernel/fork.c      |    2 +-
 mm/hugetlb.c       |    4 ++--
 mm/mlock.c         |    6 +++---
 mm/mmap.c          |    6 +++---
 mm/mremap.c        |    2 +-
 6 files changed, 12 insertions(+), 12 deletions(-)

--- a/include/linux/mm.h~mm-replace-vm_locked_clear_mask-with-vm_locked_mask
+++ a/include/linux/mm.h
@@ -421,8 +421,8 @@ extern unsigned int kobjsize(const void
 /* This mask defines which mm->def_flags a process can inherit its parent */
 #define VM_INIT_DEF_MASK	VM_NOHUGEPAGE
 
-/* This mask is used to clear all the VMA flags used by mlock */
-#define VM_LOCKED_CLEAR_MASK	(~(VM_LOCKED | VM_LOCKONFAULT))
+/* This mask represents all the VMA flag bits used by mlock */
+#define VM_LOCKED_MASK	(VM_LOCKED | VM_LOCKONFAULT)
 
 /* Arch-specific flags to clear when updating VM flags on protection change */
 #ifndef VM_ARCH_CLEAR
--- a/kernel/fork.c~mm-replace-vm_locked_clear_mask-with-vm_locked_mask
+++ a/kernel/fork.c
@@ -659,7 +659,7 @@ static __latent_entropy int dup_mmap(str
 			tmp->anon_vma = NULL;
 		} else if (anon_vma_fork(tmp, mpnt))
 			goto fail_nomem_anon_vma_fork;
-		tmp->vm_flags &= ~(VM_LOCKED | VM_LOCKONFAULT);
+		vm_flags_clear(tmp, VM_LOCKED_MASK);
 		file = tmp->vm_file;
 		if (file) {
 			struct address_space *mapping = file->f_mapping;
--- a/mm/hugetlb.c~mm-replace-vm_locked_clear_mask-with-vm_locked_mask
+++ a/mm/hugetlb.c
@@ -6969,8 +6969,8 @@ static unsigned long page_table_shareabl
 	unsigned long s_end = sbase + PUD_SIZE;
 
 	/* Allow segments to share if only one is marked locked */
-	unsigned long vm_flags = vma->vm_flags & VM_LOCKED_CLEAR_MASK;
-	unsigned long svm_flags = svma->vm_flags & VM_LOCKED_CLEAR_MASK;
+	unsigned long vm_flags = vma->vm_flags & ~VM_LOCKED_MASK;
+	unsigned long svm_flags = svma->vm_flags & ~VM_LOCKED_MASK;
 
 	/*
 	 * match the virtual addresses, permission and the alignment of the
--- a/mm/mlock.c~mm-replace-vm_locked_clear_mask-with-vm_locked_mask
+++ a/mm/mlock.c
@@ -497,7 +497,7 @@ static int apply_vma_lock_flags(unsigned
 		if (vma->vm_start != tmp)
 			return -ENOMEM;
 
-		newflags = vma->vm_flags & VM_LOCKED_CLEAR_MASK;
+		newflags = vma->vm_flags & ~VM_LOCKED_MASK;
 		newflags |= flags;
 		/* Here we know that  vma->vm_start <= nstart < vma->vm_end. */
 		tmp = vma->vm_end;
@@ -661,7 +661,7 @@ static int apply_mlockall_flags(int flag
 	struct vm_area_struct *vma, *prev = NULL;
 	vm_flags_t to_add = 0;
 
-	current->mm->def_flags &= VM_LOCKED_CLEAR_MASK;
+	current->mm->def_flags &= ~VM_LOCKED_MASK;
 	if (flags & MCL_FUTURE) {
 		current->mm->def_flags |= VM_LOCKED;
 
@@ -681,7 +681,7 @@ static int apply_mlockall_flags(int flag
 	for_each_vma(vmi, vma) {
 		vm_flags_t newflags;
 
-		newflags = vma->vm_flags & VM_LOCKED_CLEAR_MASK;
+		newflags = vma->vm_flags & ~VM_LOCKED_MASK;
 		newflags |= to_add;
 
 		/* Ignore errors */
--- a/mm/mmap.c~mm-replace-vm_locked_clear_mask-with-vm_locked_mask
+++ a/mm/mmap.c
@@ -2668,7 +2668,7 @@ expanded:
 		if ((vm_flags & VM_SPECIAL) || vma_is_dax(vma) ||
 					is_vm_hugetlb_page(vma) ||
 					vma == get_gate_vma(current->mm))
-			vma->vm_flags &= VM_LOCKED_CLEAR_MASK;
+			vm_flags_clear(vma, VM_LOCKED_MASK);
 		else
 			mm->locked_vm += (len >> PAGE_SHIFT);
 	}
@@ -3338,8 +3338,8 @@ static struct vm_area_struct *__install_
 	vma->vm_start = addr;
 	vma->vm_end = addr + len;
 
-	vma->vm_flags = vm_flags | mm->def_flags | VM_DONTEXPAND | VM_SOFTDIRTY;
-	vma->vm_flags &= VM_LOCKED_CLEAR_MASK;
+	vm_flags_init(vma, (vm_flags | mm->def_flags |
+		      VM_DONTEXPAND | VM_SOFTDIRTY) & ~VM_LOCKED_MASK);
 	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 
 	vma->vm_ops = ops;
--- a/mm/mremap.c~mm-replace-vm_locked_clear_mask-with-vm_locked_mask
+++ a/mm/mremap.c
@@ -687,7 +687,7 @@ static unsigned long move_vma(struct vm_
 
 	if (unlikely(!err && (flags & MREMAP_DONTUNMAP))) {
 		/* We always clear VM_LOCKED[ONFAULT] on the old vma */
-		vma->vm_flags &= VM_LOCKED_CLEAR_MASK;
+		vm_flags_clear(vma, VM_LOCKED_MASK);
 
 		/*
 		 * anon_vma links of the old vma is no longer needed after its page
_

Patches currently in -mm which might be from surenb@google.com are


