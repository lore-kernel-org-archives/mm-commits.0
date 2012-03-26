From: akpm@linux-foundation.org
Subject: [merged] coredump-add-vm_nodump-madv_nodump-madv_clear_nodump.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:32:40 -0700
Message-ID: <20120326193240.93E18A00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:58080 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204Ab2CZTcl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:32:41 -0400
Received: by mail-gx0-f202.google.com with SMTP id d2so830938ggn.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:32:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbaron@redhat.com, avi@redhat.com, cmetcalf@tilera.com, deller@gmx.de, ink@jurassic.park.msu.ru, jejb@parisc-linux.org, mattst88@gmail.com, ralf@linux-mips.org, roland@hack.frob.com, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: add VM_NODUMP, MADV_NODUMP, MADV_CLEAR_NODUMP
has been removed from the -mm tree.  Its filename was
     coredump-add-vm_nodump-madv_nodump-madv_clear_nodump.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jason Baron <jbaron@redhat.com>
Subject: coredump: add VM_NODUMP, MADV_NODUMP, MADV_CLEAR_NODUMP

Since we no longer need the VM_ALWAYSDUMP flag, let's use the freed bit for
'VM_NODUMP' flag. The idea is is to add a new madvise() flag: MADV_DONTDUMP,
which can be set by applications to specifically request memory regions which
should not dump core. The specific application I have in mind is qemu: we
can add a flag there that wouldn't dump all of guest memory when qemu dumps
core. This flag might also be useful for security sensitive apps that want to
absolutely make sure that parts of memory are not dumped. To clear the flag
use: MADV_DODUMP.

[akpm@linux-foundation.org: s/MADV_NODUMP/MADV_DONTDUMP/, s/MADV_CLEAR_NODUMP/MADV_DODUMP/, per Roland]
[akpm@linux-foundation.org: fix up the architectures which broke]
Signed-off-by: Jason Baron <jbaron@redhat.com>
Acked-by: Roland McGrath <roland@hack.frob.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/mman.h     |    4 ++++
 arch/mips/include/asm/mman.h      |    4 ++++
 arch/parisc/include/asm/mman.h    |    4 ++++
 arch/xtensa/include/asm/mman.h    |    4 ++++
 fs/binfmt_elf.c                   |    3 +++
 include/asm-generic/mman-common.h |    4 ++++
 include/linux/mm.h                |    1 +
 mm/madvise.c                      |    8 ++++++++
 8 files changed, 32 insertions(+)

diff -puN arch/alpha/include/asm/mman.h~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump arch/alpha/include/asm/mman.h
--- a/arch/alpha/include/asm/mman.h~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump
+++ a/arch/alpha/include/asm/mman.h
@@ -56,6 +56,10 @@
 #define MADV_HUGEPAGE	14		/* Worth backing with hugepages */
 #define MADV_NOHUGEPAGE	15		/* Not worth backing with hugepages */
 
+#define MADV_DONTDUMP   16		/* Explicity exclude from the core dump,
+					   overrides the coredump filter bits */
+#define MADV_DODUMP	17		/* Clear the MADV_NODUMP flag */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
diff -puN arch/mips/include/asm/mman.h~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump arch/mips/include/asm/mman.h
--- a/arch/mips/include/asm/mman.h~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump
+++ a/arch/mips/include/asm/mman.h
@@ -80,6 +80,10 @@
 #define MADV_HUGEPAGE	14		/* Worth backing with hugepages */
 #define MADV_NOHUGEPAGE	15		/* Not worth backing with hugepages */
 
+#define MADV_DONTDUMP   16		/* Explicity exclude from the core dump,
+					   overrides the coredump filter bits */
+#define MADV_DODUMP	17		/* Clear the MADV_NODUMP flag */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
diff -puN arch/parisc/include/asm/mman.h~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump arch/parisc/include/asm/mman.h
--- a/arch/parisc/include/asm/mman.h~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump
+++ a/arch/parisc/include/asm/mman.h
@@ -62,6 +62,10 @@
 #define MADV_HUGEPAGE	67		/* Worth backing with hugepages */
 #define MADV_NOHUGEPAGE	68		/* Not worth backing with hugepages */
 
+#define MADV_DONTDUMP   69		/* Explicity exclude from the core dump,
+					   overrides the coredump filter bits */
+#define MADV_DODUMP	70		/* Clear the MADV_NODUMP flag */
+
 /* compatibility flags */
 #define MAP_FILE	0
 #define MAP_VARIABLE	0
diff -puN arch/xtensa/include/asm/mman.h~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump arch/xtensa/include/asm/mman.h
--- a/arch/xtensa/include/asm/mman.h~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump
+++ a/arch/xtensa/include/asm/mman.h
@@ -86,6 +86,10 @@
 #define MADV_HUGEPAGE	14		/* Worth backing with hugepages */
 #define MADV_NOHUGEPAGE	15		/* Not worth backing with hugepages */
 
+#define MADV_DONTDUMP   16		/* Explicity exclude from the core dump,
+					   overrides the coredump filter bits */
+#define MADV_DODUMP	17		/* Clear the MADV_NODUMP flag */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
diff -puN fs/binfmt_elf.c~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump
+++ a/fs/binfmt_elf.c
@@ -1127,6 +1127,9 @@ static unsigned long vma_dump_size(struc
 	if (always_dump_vma(vma))
 		goto whole;
 
+	if (vma->vm_flags & VM_NODUMP)
+		return 0;
+
 	/* Hugetlb memory check */
 	if (vma->vm_flags & VM_HUGETLB) {
 		if ((vma->vm_flags & VM_SHARED) && FILTER(HUGETLB_SHARED))
diff -puN include/asm-generic/mman-common.h~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump include/asm-generic/mman-common.h
--- a/include/asm-generic/mman-common.h~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump
+++ a/include/asm-generic/mman-common.h
@@ -48,6 +48,10 @@
 #define MADV_HUGEPAGE	14		/* Worth backing with hugepages */
 #define MADV_NOHUGEPAGE	15		/* Not worth backing with hugepages */
 
+#define MADV_DONTDUMP   16		/* Explicity exclude from the core dump,
+					   overrides the coredump filter bits */
+#define MADV_DODUMP	17		/* Clear the MADV_NODUMP flag */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
diff -puN include/linux/mm.h~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump include/linux/mm.h
--- a/include/linux/mm.h~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump
+++ a/include/linux/mm.h
@@ -111,6 +111,7 @@ extern unsigned int kobjsize(const void 
 #define VM_HUGEPAGE	0x01000000	/* MADV_HUGEPAGE marked this vma */
 #endif
 #define VM_INSERTPAGE	0x02000000	/* The vma has had "vm_insert_page()" done on it */
+#define VM_NODUMP	0x04000000	/* Do not include in the core dump */
 
 #define VM_CAN_NONLINEAR 0x08000000	/* Has ->fault & does nonlinear pages */
 #define VM_MIXEDMAP	0x10000000	/* Can contain "struct page" and pure PFN pages */
diff -puN mm/madvise.c~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump mm/madvise.c
--- a/mm/madvise.c~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump
+++ a/mm/madvise.c
@@ -65,6 +65,12 @@ static long madvise_behavior(struct vm_a
 		}
 		new_flags &= ~VM_DONTCOPY;
 		break;
+	case MADV_DONTDUMP:
+		new_flags |= VM_NODUMP;
+		break;
+	case MADV_DODUMP:
+		new_flags &= ~VM_NODUMP;
+		break;
 	case MADV_MERGEABLE:
 	case MADV_UNMERGEABLE:
 		error = ksm_madvise(vma, start, end, behavior, &new_flags);
@@ -293,6 +299,8 @@ madvise_behavior_valid(int behavior)
 	case MADV_HUGEPAGE:
 	case MADV_NOHUGEPAGE:
 #endif
+	case MADV_DONTDUMP:
+	case MADV_DODUMP:
 		return 1;
 
 	default:
_

Patches currently in -mm which might be from jbaron@redhat.com are

origin.patch
linux-next.patch

