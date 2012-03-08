From: akpm@linux-foundation.org
Subject: + coredump-add-vm_nodump-madv_nodump-madv_clear_nodump.patch added to -mm tree
Date: Thu, 08 Mar 2012 15:06:30 -0800
Message-ID: <20120308230630.2E925A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:59439 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758603Ab2CHXGd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Mar 2012 18:06:33 -0500
Received: by eaaq10 with SMTP id q10so35327eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Mar 2012 15:06:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbaron@redhat.com, avi@redhat.com, cmetcalf@tilera.com, roland@hack.frob.com


The patch titled
     Subject: coredump: add VM_NODUMP, MADV_NODUMP, MADV_CLEAR_NODUMP
has been added to the -mm tree.  Its filename is
     coredump-add-vm_nodump-madv_nodump-madv_clear_nodump.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Jason Baron <jbaron@redhat.com>
Acked-by: Roland McGrath <roland@hack.frob.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Avi Kivity <avi@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c                   |    3 +++
 include/asm-generic/mman-common.h |    4 ++++
 include/linux/mm.h                |    1 +
 mm/madvise.c                      |    8 ++++++++
 4 files changed, 16 insertions(+)

diff -puN fs/binfmt_elf.c~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump
+++ a/fs/binfmt_elf.c
@@ -1129,6 +1129,9 @@ static unsigned long vma_dump_size(struc
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
 
+#define MADV_NODUMP 16			/* Explicity exclude from the core dump,
+					   overrides the coredump filter bits */
+#define MADV_CLEAR_NODUMP 17		/* Clear the MADV_NODUMP flag */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
diff -puN include/linux/mm.h~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump include/linux/mm.h
--- a/include/linux/mm.h~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump
+++ a/include/linux/mm.h
@@ -112,6 +112,7 @@ extern unsigned int kobjsize(const void 
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
+	case MADV_NODUMP:
+		new_flags |= VM_NODUMP;
+		break;
+	case MADV_CLEAR_NODUMP:
+		new_flags &= ~VM_NODUMP;
+		break;
 	case MADV_MERGEABLE:
 	case MADV_UNMERGEABLE:
 		error = ksm_madvise(vma, start, end, behavior, &new_flags);
@@ -293,6 +299,8 @@ madvise_behavior_valid(int behavior)
 	case MADV_HUGEPAGE:
 	case MADV_NOHUGEPAGE:
 #endif
+	case MADV_NODUMP:
+	case MADV_CLEAR_NODUMP:
 		return 1;
 
 	default:
_
Subject: Subject: coredump: add VM_NODUMP, MADV_NODUMP, MADV_CLEAR_NODUMP

Patches currently in -mm which might be from jbaron@redhat.com are

origin.patch
linux-next.patch
epoll-remove-unneeded-variable-in-reverse_path_check.patch
coredump-remove-vm_alwaysdump-flag.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix.patch

