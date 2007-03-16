From: akpm@linux-foundation.org
Subject: + allow-i386-crash-kernels-to-handle-x86_64-dumps.patch added to -mm tree
Date: Fri, 16 Mar 2007 03:51:57 -0800
Message-ID: <200703161151.l2GBpvWw010479@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42999 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964983AbXCPLwf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Mar 2007 07:52:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ian.campbell@xensource.com, ak@suse.de, ebiederm@xmission.com, horms@verge.net.au, magnus.damm@gmail.com, vgoyal@in.ibm.com


The patch titled
     Allow i386 crash kernels to handle x86_64 dumps.
has been added to the -mm tree.  Its filename is
     allow-i386-crash-kernels-to-handle-x86_64-dumps.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Allow i386 crash kernels to handle x86_64 dumps.
From: Ian Campbell <ian.campbell@xensource.com>

The specific case I am encountering is kdump under Xen with a 64 bit
hypervisor and 32 bit kernel/userspace.  The dump created is 64 bit due to
the hypervisor but the dump kernel is 32 bit for maximum compatibility.

It's possibly less likely to be useful in a purely native scenario but I
see no reason to disallow it.

Signed-off-by: Ian Campbell <ian.campbell@xensource.com>
Acked-by: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Horms <horms@verge.net.au>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c           |    2 +-
 include/asm-i386/kexec.h   |    3 +++
 include/linux/crash_dump.h |    8 ++++++++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff -puN fs/proc/vmcore.c~allow-i386-crash-kernels-to-handle-x86_64-dumps fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~allow-i386-crash-kernels-to-handle-x86_64-dumps
+++ a/fs/proc/vmcore.c
@@ -514,7 +514,7 @@ static int __init parse_crash_elf64_head
 	/* Do some basic Verification. */
 	if (memcmp(ehdr.e_ident, ELFMAG, SELFMAG) != 0 ||
 		(ehdr.e_type != ET_CORE) ||
-		!elf_check_arch(&ehdr) ||
+		!vmcore_elf_check_arch(&ehdr) ||
 		ehdr.e_ident[EI_CLASS] != ELFCLASS64 ||
 		ehdr.e_ident[EI_VERSION] != EV_CURRENT ||
 		ehdr.e_version != EV_CURRENT ||
diff -puN include/asm-i386/kexec.h~allow-i386-crash-kernels-to-handle-x86_64-dumps include/asm-i386/kexec.h
--- a/include/asm-i386/kexec.h~allow-i386-crash-kernels-to-handle-x86_64-dumps
+++ a/include/asm-i386/kexec.h
@@ -42,6 +42,9 @@
 /* The native architecture */
 #define KEXEC_ARCH KEXEC_ARCH_386
 
+/* We can also handle crash dumps from 64 bit kernel. */
+#define vmcore_elf_check_arch_cross(x) ((x)->e_machine == EM_X86_64)
+
 #define MAX_NOTE_BYTES 1024
 
 /* CPU does not save ss and esp on stack if execution is already
diff -puN include/linux/crash_dump.h~allow-i386-crash-kernels-to-handle-x86_64-dumps include/linux/crash_dump.h
--- a/include/linux/crash_dump.h~allow-i386-crash-kernels-to-handle-x86_64-dumps
+++ a/include/linux/crash_dump.h
@@ -14,5 +14,13 @@ extern ssize_t copy_oldmem_page(unsigned
 extern const struct file_operations proc_vmcore_operations;
 extern struct proc_dir_entry *proc_vmcore;
 
+/* Architecture code defines this if there are other possible ELF
+ * machine types, e.g. on bi-arch capable hardware. */
+#ifndef vmcore_elf_check_arch_cross(x)
+#define vmcore_elf_check_arch_cross(x) 0
+#endif
+
+#define vmcore_elf_check_arch(x) (elf_check_arch(x) || vmcore_elf_check_arch_cross(x))
+
 #endif /* CONFIG_CRASH_DUMP */
 #endif /* LINUX_CRASHDUMP_H */
_

Patches currently in -mm which might be from ian.campbell@xensource.com are

allow-i386-crash-kernels-to-handle-x86_64-dumps.patch
