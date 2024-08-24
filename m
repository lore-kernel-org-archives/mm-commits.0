Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C36BB669
	for <mm-commits@vger.kernel.org>; Sat, 24 Aug 2024 01:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724464733; cv=none; b=F0ZJTupDwSKhf9VGS1mpUh7uuD00KKdwDYqn9qsVXmRD2HmCCvXStFmTxVJcHcensEzEclhGJ5xxcn7B1aQvKBu4wJtBalsa5EM1xLv2nPht9FKfr/2PW/Iuxhmy0zdSQzai0DSBIgeww8Xmp1Dh59E0YozGCzvnxUQhP/a8CCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724464733; c=relaxed/simple;
	bh=FGAI7gyxjfJ+6F7KIekd9Qt8d1w2wAXko7TbbLCRDhk=;
	h=Date:To:From:Subject:Message-Id; b=r4l+j5sY2lOvMTuRoaJ5akNA5llTzkKrrBoY1SmsVcsal/ZUGtgFChpcAgyQzRw4kIpuLPSGdgkqesO/rStoHb08WRWoerNCYmLGiYo7n4Shp4XdqZ852Zm/J0rsWa87gn2yNiU6aiY7XZgQ2PsGNC9ywudGD4LWD7QQSPInFn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PcyarBAn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PcyarBAn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFEB1C32786;
	Sat, 24 Aug 2024 01:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724464733;
	bh=FGAI7gyxjfJ+6F7KIekd9Qt8d1w2wAXko7TbbLCRDhk=;
	h=Date:To:From:Subject:From;
	b=PcyarBAnw2SbkQW2E+uA9UTvV2ejViImkl4MNBwQ3VoDvSaXKsOgFWeyZMOBY5sEo
	 MGib+6Nfx0MUmDinhpMlb3wRWdyIY8D+dT+BBVo6MYoeXYgDCkVLFjDHpQqRilV0EI
	 LcnLxLUvZGdOgEsD5ig6Nn3xlgNa6xKThkZw+gj4=
Date: Fri, 23 Aug 2024 18:58:52 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,lorenzo.stoakes@oracle.com,kees@kernel.org,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmah-optimise-vma_munmap_struct.patch added to mm-unstable branch
Message-Id: <20240824015852.DFEB1C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma.h: optimise vma_munmap_struct
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmah-optimise-vma_munmap_struct.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmah-optimise-vma_munmap_struct.patch

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
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/vma.h: optimise vma_munmap_struct
Date: Thu, 22 Aug 2024 15:25:43 -0400

The vma_munmap_struct has a hole of 4 bytes and pushes the struct to three
cachelines.  Relocating the three booleans upwards allows for the struct
to only use two cachelines (as reported by pahole on amd64).

Before:
struct vma_munmap_struct {
        struct vma_iterator *      vmi;                  /*     0     8 */
        struct vm_area_struct *    vma;                  /*     8     8 */
        struct vm_area_struct *    prev;                 /*    16     8 */
        struct vm_area_struct *    next;                 /*    24     8 */
        struct list_head *         uf;                   /*    32     8 */
        long unsigned int          start;                /*    40     8 */
        long unsigned int          end;                  /*    48     8 */
        long unsigned int          unmap_start;          /*    56     8 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        long unsigned int          unmap_end;            /*    64     8 */
        int                        vma_count;            /*    72     4 */

        /* XXX 4 bytes hole, try to pack */

        long unsigned int          nr_pages;             /*    80     8 */
        long unsigned int          locked_vm;            /*    88     8 */
        long unsigned int          nr_accounted;         /*    96     8 */
        long unsigned int          exec_vm;              /*   104     8 */
        long unsigned int          stack_vm;             /*   112     8 */
        long unsigned int          data_vm;              /*   120     8 */
        /* --- cacheline 2 boundary (128 bytes) --- */
        bool                       unlock;               /*   128     1 */
        bool                       clear_ptes;           /*   129     1 */
        bool                       closed_vm_ops;        /*   130     1 */

        /* size: 136, cachelines: 3, members: 19 */
        /* sum members: 127, holes: 1, sum holes: 4 */
        /* padding: 5 */
        /* last cacheline: 8 bytes */
};

After:
struct vma_munmap_struct {
        struct vma_iterator *      vmi;                  /*     0     8 */
        struct vm_area_struct *    vma;                  /*     8     8 */
        struct vm_area_struct *    prev;                 /*    16     8 */
        struct vm_area_struct *    next;                 /*    24     8 */
        struct list_head *         uf;                   /*    32     8 */
        long unsigned int          start;                /*    40     8 */
        long unsigned int          end;                  /*    48     8 */
        long unsigned int          unmap_start;          /*    56     8 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        long unsigned int          unmap_end;            /*    64     8 */
        int                        vma_count;            /*    72     4 */
        bool                       unlock;               /*    76     1 */
        bool                       clear_ptes;           /*    77     1 */
        bool                       closed_vm_ops;        /*    78     1 */

        /* XXX 1 byte hole, try to pack */

        long unsigned int          nr_pages;             /*    80     8 */
        long unsigned int          locked_vm;            /*    88     8 */
        long unsigned int          nr_accounted;         /*    96     8 */
        long unsigned int          exec_vm;              /*   104     8 */
        long unsigned int          stack_vm;             /*   112     8 */
        long unsigned int          data_vm;              /*   120     8 */

        /* size: 128, cachelines: 2, members: 19 */
        /* sum members: 127, holes: 1, sum holes: 1 */
};

Link: https://lkml.kernel.org/r/20240822192543.3359552-22-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Bert Karwatzki <spasswolf@web.de>
Cc: Jiri Olsa <olsajiri@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/vma.h~mm-vmah-optimise-vma_munmap_struct
+++ a/mm/vma.h
@@ -40,15 +40,16 @@ struct vma_munmap_struct {
 	unsigned long unmap_start;      /* Unmap PTE start */
 	unsigned long unmap_end;        /* Unmap PTE end */
 	int vma_count;                  /* Number of vmas that will be removed */
+	bool unlock;                    /* Unlock after the munmap */
+	bool clear_ptes;                /* If there are outstanding PTE to be cleared */
+	bool closed_vm_ops;		/* call_mmap() was encountered, so vmas may be closed */
+	/* 1 byte hole */
 	unsigned long nr_pages;         /* Number of pages being removed */
 	unsigned long locked_vm;        /* Number of locked pages */
 	unsigned long nr_accounted;     /* Number of VM_ACCOUNT pages */
 	unsigned long exec_vm;
 	unsigned long stack_vm;
 	unsigned long data_vm;
-	bool unlock;                    /* Unlock after the munmap */
-	bool clear_ptes;                /* If there are outstanding PTE to be cleared */
-	bool closed_vm_ops;		/* call_mmap() was encountered, so vmas may be closed */
 };
 
 #ifdef CONFIG_DEBUG_VM_MAPLE_TREE
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are

maple_tree-remove-rcu_read_lock-from-mt_validate.patch
mm-vma-correctly-position-vma_iterator-in-__split_vma.patch
mm-vma-introduce-abort_munmap_vmas.patch
mm-vma-introduce-vmi_complete_munmap_vmas.patch
mm-vma-extract-the-gathering-of-vmas-from-do_vmi_align_munmap.patch
mm-vma-introduce-vma_munmap_struct-for-use-in-munmap-operations.patch
mm-vma-change-munmap-to-use-vma_munmap_struct-for-accounting-and-surrounding-vmas.patch
mm-vma-change-munmap-to-use-vma_munmap_struct-for-accounting-and-surrounding-vmas-fix.patch
mm-vma-extract-validate_mm-from-vma_complete.patch
mm-vma-inline-munmap-operation-in-mmap_region.patch
mm-vma-expand-mmap_region-munmap-call.patch
mm-vma-support-vma-==-null-in-init_vma_munmap.patch
mm-mmap-reposition-vma-iterator-in-mmap_region.patch
mm-vma-track-start-and-end-for-munmap-in-vma_munmap_struct.patch
mm-clean-up-unmap_region-argument-list.patch
mm-mmap-avoid-zeroing-vma-tree-in-mmap_region.patch
mm-change-failure-of-map_fixed-to-restoring-the-gap-on-failure.patch
mm-mmap-use-phys_pfn-in-mmap_region.patch
mm-mmap-use-vms-accounted-pages-in-mmap_region.patch
ipc-shm-mm-drop-do_vma_munmap.patch
mm-move-may_expand_vm-check-in-mmap_region.patch
mm-vma-drop-incorrect-comment-from-vms_gather_munmap_vmas.patch
mm-vmah-optimise-vma_munmap_struct.patch

