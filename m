Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590E478C9C
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423578; cv=none; b=lLw7i2SjfyIgudUT/eziMqGDOcRhf4Fd2OPuPSEuT//GINjTDNV9NflMNaIVTBHNp+M9pZ5qr3Tl0+PjpoTbkiOVObO2fz62lFXLcZW35hFBXnGbzur+ojaehJJ4aR0XcdTRSp1l9w6tcR5GAd4UfVKrZEAtsqEQ7w1HbcRpwbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423578; c=relaxed/simple;
	bh=XsdWSJKNMPQKOxgSs1hhxgcDDGKe8kWUsBnNGsoI9NY=;
	h=Date:To:From:Subject:Message-Id; b=o66ze/IG64x2GkP8l5VZAUoOryWI3L6hJJGiSYeAFst9dMS+9tzTFtfkqszdCad2pf1J1BfAxSYSnGrWMN7NeBZVWtUN4bnS+4p/DFzuROry8kGr+4JqL2IS8k3gDSXm01uys4OZRGG8OLVQe4uz8rMJ/S6IDyBnNHV2dcwECBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y+00U94C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y+00U94C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E68AC4CEC2;
	Wed,  4 Sep 2024 04:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423578;
	bh=XsdWSJKNMPQKOxgSs1hhxgcDDGKe8kWUsBnNGsoI9NY=;
	h=Date:To:From:Subject:From;
	b=Y+00U94CBXB/4ZhLJJaoxw+V4tU+yXb7YLABTChFhvf6Ukfd0Gs50uqEolPSIuK4s
	 JdtKHzUEBXaW6JVSCz58wCzg+ZvTv3rFjHdkQIcjoUhgaAPWURcJ0xlOJ4Npjqyann
	 pdJs+WEQdZT8UkdIZF0h0kRql8mDd9S2/EQPLPVM=
Date: Tue, 03 Sep 2024 21:19:37 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,lorenzo.stoakes@oracle.com,kees@kernel.org,jeffxu@chromium.org,broonie@kernel.org,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmah-optimise-vma_munmap_struct.patch removed from -mm tree
Message-Id: <20240904041938.2E68AC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma.h: optimise vma_munmap_struct
has been removed from the -mm tree.  Its filename was
     mm-vmah-optimise-vma_munmap_struct.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/vma.h: optimise vma_munmap_struct
Date: Fri, 30 Aug 2024 00:01:01 -0400

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

Link: https://lkml.kernel.org/r/20240830040101.822209-22-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Bert Karwatzki <spasswolf@web.de>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Jiri Olsa <olsajiri@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
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


