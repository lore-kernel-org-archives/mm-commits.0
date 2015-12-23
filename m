From: akpm@linux-foundation.org
Subject: +
 kexec-introduce-a-protection-mechanism-for-the-crashkernel-reserved-memory.patch added to -mm tree
Date: Wed, 23 Dec 2015 12:30:10 -0800
Message-ID: <567b0452.dze2X3NejkxlS25t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42005 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbbLWUaL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Dec 2015 15:30:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xlpang@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: Introduce a protection mechanism for the crashkernel reserved memory
has been added to the -mm tree.  Its filename is
     kexec-introduce-a-protection-mechanism-for-the-crashkernel-reserved-memory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-introduce-a-protection-mechanism-for-the-crashkernel-reserved-memory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-introduce-a-protection-mechanism-for-the-crashkernel-reserved-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xunlei Pang <xlpang@redhat.com>
Subject: kexec: Introduce a protection mechanism for the crashkernel reserved memory

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
@@ -316,6 +316,8 @@ int __weak arch_kexec_apply_relocations_
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
@@ -1529,3 +1529,9 @@ void __weak crash_map_reserved_pages(voi
 
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
@@ -329,8 +329,11 @@ SYSCALL_DEFINE5(kexec_file_load, int, ke
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
@@ -379,6 +382,9 @@ SYSCALL_DEFINE5(kexec_file_load, int, ke
 exchange:
 	image = xchg(dest_image, image);
 out:
+	if ((flags & KEXEC_ON_CRASH) && kexec_crash_image)
+		arch_kexec_protect_crashkres();
+
 	mutex_unlock(&kexec_mutex);
 	kimage_free(image);
 	return ret;
_

Patches currently in -mm which might be from xlpang@redhat.com are

kexec-set-kexec_type_crash-before-sanity_check_segment_list.patch
kexec-move-some-memembers-and-definitions-within-the-scope-of-config_kexec_file.patch
kexec-introduce-a-protection-mechanism-for-the-crashkernel-reserved-memory.patch
kexec-provide-arch_kexec_protectunprotect_crashkres.patch

