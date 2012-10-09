From: akpm@linux-foundation.org
Subject: [merged] mm-prepare-vm_dontdump-for-using-in-drivers.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:06:16 -0700
Message-ID: <20121009180617.1FFE21E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:40838 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2JISGS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:06:18 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so573446yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:06:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, a.p.zijlstra@chello.nl, cmetcalf@tilera.com, cotte@de.ibm.com, eparis@redhat.com, gorcunov@openvz.org, hpa@zytor.com, hughd@google.com, james.l.morris@oracle.com, jbaron@redhat.com, matthltc@us.ibm.com, mingo@redhat.com, npiggin@kernel.dk, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, robert.richter@amd.com, suresh.b.siddha@intel.com, takedakn@nttdata.co.jp, torvalds@linux-foundation.org, venki@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: prepare VM_DONTDUMP for using in drivers
has been removed from the -mm tree.  Its filename was
     mm-prepare-vm_dontdump-for-using-in-drivers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm: prepare VM_DONTDUMP for using in drivers

Rename VM_NODUMP into VM_DONTDUMP: this name matches other negative flags:
VM_DONTEXPAND, VM_DONTCOPY.  Currently this flag used only for
sys_madvise.  The next patch will use it for replacing the outdated flag
VM_RESERVED.

Also forbid madvise(MADV_DODUMP) for special kernel mappings VM_SPECIAL
(VM_IO | VM_DONTEXPAND | VM_RESERVED | VM_PFNMAP)

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Carsten Otte <cotte@de.ibm.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Eric Paris <eparis@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Venkatesh Pallipadi <venki@google.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c    |    2 +-
 include/linux/mm.h |    2 +-
 mm/madvise.c       |    8 ++++++--
 3 files changed, 8 insertions(+), 4 deletions(-)

diff -puN fs/binfmt_elf.c~mm-prepare-vm_dontdump-for-using-in-drivers fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~mm-prepare-vm_dontdump-for-using-in-drivers
+++ a/fs/binfmt_elf.c
@@ -1123,7 +1123,7 @@ static unsigned long vma_dump_size(struc
 	if (always_dump_vma(vma))
 		goto whole;
 
-	if (vma->vm_flags & VM_NODUMP)
+	if (vma->vm_flags & VM_DONTDUMP)
 		return 0;
 
 	/* Hugetlb memory check */
diff -puN include/linux/mm.h~mm-prepare-vm_dontdump-for-using-in-drivers include/linux/mm.h
--- a/include/linux/mm.h~mm-prepare-vm_dontdump-for-using-in-drivers
+++ a/include/linux/mm.h
@@ -102,7 +102,7 @@ extern unsigned int kobjsize(const void 
 #define VM_HUGETLB	0x00400000	/* Huge TLB Page VM */
 #define VM_NONLINEAR	0x00800000	/* Is non-linear (remap_file_pages) */
 #define VM_ARCH_1	0x01000000	/* Architecture-specific flag */
-#define VM_NODUMP	0x04000000	/* Do not include in the core dump */
+#define VM_DONTDUMP	0x04000000	/* Do not include in the core dump */
 
 #define VM_MIXEDMAP	0x10000000	/* Can contain "struct page" and pure PFN pages */
 #define VM_HUGEPAGE	0x20000000	/* MADV_HUGEPAGE marked this vma */
diff -puN mm/madvise.c~mm-prepare-vm_dontdump-for-using-in-drivers mm/madvise.c
--- a/mm/madvise.c~mm-prepare-vm_dontdump-for-using-in-drivers
+++ a/mm/madvise.c
@@ -69,10 +69,14 @@ static long madvise_behavior(struct vm_a
 		new_flags &= ~VM_DONTCOPY;
 		break;
 	case MADV_DONTDUMP:
-		new_flags |= VM_NODUMP;
+		new_flags |= VM_DONTDUMP;
 		break;
 	case MADV_DODUMP:
-		new_flags &= ~VM_NODUMP;
+		if (new_flags & VM_SPECIAL) {
+			error = -EINVAL;
+			goto out;
+		}
+		new_flags &= ~VM_DONTDUMP;
 		break;
 	case MADV_MERGEABLE:
 	case MADV_UNMERGEABLE:
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch

