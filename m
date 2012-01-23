From: akpm@linux-foundation.org
Subject: [merged] kdump-define-kexec_note_bytes-arch-specific-for-s390x.patch removed from -mm tree
Date: Mon, 23 Jan 2012 12:21:48 -0800
Message-ID: <20120123202148.C14F910004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:58337 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab2AWUVt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jan 2012 15:21:49 -0500
Received: by mail-gy0-f202.google.com with SMTP id g20so288772ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Jan 2012 12:21:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holzheu@linux.vnet.ibm.com, ebiederm@xmission.com, heiko.carstens@de.ibm.com, horms@verge.net.au, schwidefsky@de.ibm.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kdump: define KEXEC_NOTE_BYTES arch specific for s390x
has been removed from the -mm tree.  Its filename was
     kdump-define-kexec_note_bytes-arch-specific-for-s390x.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Subject: kdump: define KEXEC_NOTE_BYTES arch specific for s390x

kdump only allocates memory for the prstatus ELF note.  For s390x, besides
of prstatus multiple ELF notes for various different register types are
stored.  Therefore the currently allocated memory is not sufficient.  With
this patch the KEXEC_NOTE_BYTES macro can be defined by architecture code
and for s390x it is set to the correct size now.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Reviewed-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/kexec.h |   18 ++++++++++++++++++
 include/linux/kexec.h         |    2 ++
 2 files changed, 20 insertions(+)

diff -puN arch/s390/include/asm/kexec.h~kdump-define-kexec_note_bytes-arch-specific-for-s390x arch/s390/include/asm/kexec.h
--- a/arch/s390/include/asm/kexec.h~kdump-define-kexec_note_bytes-arch-specific-for-s390x
+++ a/arch/s390/include/asm/kexec.h
@@ -42,6 +42,24 @@
 /* The native architecture */
 #define KEXEC_ARCH KEXEC_ARCH_S390
 
+/*
+ * Size for s390x ELF notes per CPU
+ *
+ * Seven notes plus zero note at the end: prstatus, fpregset, timer,
+ * tod_cmp, tod_reg, control regs, and prefix
+ */
+#define KEXEC_NOTE_BYTES \
+	(ALIGN(sizeof(struct elf_note), 4) * 8 + \
+	 ALIGN(sizeof("CORE"), 4) * 7 + \
+	 ALIGN(sizeof(struct elf_prstatus), 4) + \
+	 ALIGN(sizeof(elf_fpregset_t), 4) + \
+	 ALIGN(sizeof(u64), 4) + \
+	 ALIGN(sizeof(u64), 4) + \
+	 ALIGN(sizeof(u32), 4) + \
+	 ALIGN(sizeof(u64) * 16, 4) + \
+	 ALIGN(sizeof(u32), 4) \
+	)
+
 /* Provide a dummy definition to avoid build failures. */
 static inline void crash_setup_regs(struct pt_regs *newregs,
 					struct pt_regs *oldregs) { }
diff -puN include/linux/kexec.h~kdump-define-kexec_note_bytes-arch-specific-for-s390x include/linux/kexec.h
--- a/include/linux/kexec.h~kdump-define-kexec_note_bytes-arch-specific-for-s390x
+++ a/include/linux/kexec.h
@@ -50,9 +50,11 @@
  * note header.  For kdump, the code in vmcore.c runs in the context
  * of the second kernel to combine them into one note.
  */
+#ifndef KEXEC_NOTE_BYTES
 #define KEXEC_NOTE_BYTES ( (KEXEC_NOTE_HEAD_BYTES * 2) +		\
 			    KEXEC_CORE_NOTE_NAME_BYTES +		\
 			    KEXEC_CORE_NOTE_DESC_BYTES )
+#endif
 
 /*
  * This structure is used to hold the arguments that are used when loading
_

Patches currently in -mm which might be from holzheu@linux.vnet.ibm.com are

origin.patch

