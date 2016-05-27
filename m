From: akpm@linux-foundation.org
Subject: [merged]
 kexec-introduce-a-protection-mechanism-for-the-crashkernel-reserved-memory.patch removed from -mm tree
Date: Fri, 27 May 2016 11:43:33 -0700
Message-ID: <57489555.9ozlO06BC4E0Dde2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42503 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbcE0Sne (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:43:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xlpang@redhat.com, bhe@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, mhuang@redhat.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: introduce a protection mechanism for the crashkernel reserved memory
has been removed from the -mm tree.  Its filename was
     kexec-introduce-a-protection-mechanism-for-the-crashkernel-reserved-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xunlei Pang <xlpang@redhat.com>
Subject: kexec: introduce a protection mechanism for the crashkernel reserved memory

For the cases that some kernel (module) path stamps the crash reserved
memory(already mapped by the kernel) where has been loaded the second
kernel data, the kdump kernel will probably fail to boot when panic
happens (or even not happens) leaving the culprit at large, this is
unacceptable.

The patch introduces a mechanism for detecting such cases:

1) After each crash kexec loading, it simply marks the reserved memory
   regions readonly since we no longer access it after that.  When someone
   stamps the region, the first kernel will panic and trigger the kdump. 
   The weak arch_kexec_protect_crashkres() is introduced to do the actual
   protection.

2) To allow multiple loading, once 1) was done we also need to remark
   the reserved memory to readwrite each time a system call related to
   kdump is made.  The weak arch_kexec_unprotect_crashkres() is introduced
   to do the actual protection.

The architecture can make its specific implementation by overriding
arch_kexec_protect_crashkres() and arch_kexec_unprotect_crashkres().

Signed-off-by: Xunlei Pang <xlpang@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Minfei Huang <mhuang@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec.h |    2 ++
 kernel/kexec.c        |    9 ++++++++-
 kernel/kexec_core.c   |    6 ++++++
 kernel/kexec_file.c   |    8 +++++++-
 4 files changed, 23 insertions(+), 2 deletions(-)

diff -puN include/linux/kexec.h~kexec-introduce-a-protection-mechanism-for-the-crashkernel-reserved-memory include/linux/kexec.h
--- a/include/linux/kexec.h~kexec-introduce-a-protection-mechanism-for-the-crashkernel-reserved-memory
+++ a/include/linux/kexec.h
@@ -317,6 +317,8 @@ int __weak arch_kexec_apply_relocations_
 					Elf_Shdr *sechdrs, unsigned int relsec);
 int __weak arch_kexec_apply_relocations(const Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
 					unsigned int relsec);
+void arch_kexec_protect_crashkres(void);
+void arch_kexec_unprotect_crashkres(void);
 
 #else /* !CONFIG_KEXEC_CORE */
 struct pt_regs;
diff -puN kernel/kexec.c~kexec-introduce-a-protection-mechanism-for-the-crashkernel-reserved-memory kernel/kexec.c
--- a/kernel/kexec.c~kexec-introduce-a-protection-mechanism-for-the-crashkernel-reserved-memory
+++ a/kernel/kexec.c
@@ -167,8 +167,12 @@ SYSCALL_DEFINE4(kexec_load, unsigned lon
 		return -EBUSY;
 
 	dest_image = &kexec_image;
-	if (flags & KEXEC_ON_CRASH)
+	if (flags & KEXEC_ON_CRASH) {
 		dest_image = &kexec_crash_image;
+		if (kexec_crash_image)
+			arch_kexec_unprotect_crashkres();
+	}
+
 	if (nr_segments > 0) {
 		unsigned long i;
 
@@ -211,6 +215,9 @@ SYSCALL_DEFINE4(kexec_load, unsigned lon
 	image = xchg(dest_image, image);
 
 out:
+	if ((flags & KEXEC_ON_CRASH) && kexec_crash_image)
+		arch_kexec_protect_crashkres();
+
 	mutex_unlock(&kexec_mutex);
 	kimage_free(image);
 
diff -puN kernel/kexec_core.c~kexec-introduce-a-protection-mechanism-for-the-crashkernel-reserved-memory kernel/kexec_core.c
--- a/kernel/kexec_core.c~kexec-introduce-a-protection-mechanism-for-the-crashkernel-reserved-memory
+++ a/kernel/kexec_core.c
@@ -1563,3 +1563,9 @@ void __weak crash_map_reserved_pages(voi
 
 void __weak crash_unmap_reserved_pages(void)
 {}
+
+void __weak arch_kexec_protect_crashkres(void)
+{}
+
+void __weak arch_kexec_unprotect_crashkres(void)
+{}
diff -puN kernel/kexec_file.c~kexec-introduce-a-protection-mechanism-for-the-crashkernel-reserved-memory kernel/kexec_file.c
--- a/kernel/kexec_file.c~kexec-introduce-a-protection-mechanism-for-the-crashkernel-reserved-memory
+++ a/kernel/kexec_file.c
@@ -274,8 +274,11 @@ SYSCALL_DEFINE5(kexec_file_load, int, ke
 		return -EBUSY;
 
 	dest_image = &kexec_image;
-	if (flags & KEXEC_FILE_ON_CRASH)
+	if (flags & KEXEC_FILE_ON_CRASH) {
 		dest_image = &kexec_crash_image;
+		if (kexec_crash_image)
+			arch_kexec_unprotect_crashkres();
+	}
 
 	if (flags & KEXEC_FILE_UNLOAD)
 		goto exchange;
@@ -324,6 +327,9 @@ SYSCALL_DEFINE5(kexec_file_load, int, ke
 exchange:
 	image = xchg(dest_image, image);
 out:
+	if ((flags & KEXEC_FILE_ON_CRASH) && kexec_crash_image)
+		arch_kexec_protect_crashkres();
+
 	mutex_unlock(&kexec_mutex);
 	kimage_free(image);
 	return ret;
_

Patches currently in -mm which might be from xlpang@redhat.com are


