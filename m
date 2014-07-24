From: akpm@linux-foundation.org
Subject: + kexec-verify-the-signature-of-signed-pe-bzimage.patch added to
 -mm tree
Date: Thu, 24 Jul 2014 15:06:48 -0700
Message-ID: <53d18378.m8SaZgTU+L9h1AUh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:48154 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbaGXWGt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Jul 2014 18:06:49 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so946607pab.2
        for <mm-commits@vger.kernel.org>; Thu, 24 Jul 2014 15:06:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@redhat.com, bhe@redhat.com, bp@suse.de, chaowang@redhat.com, dhowells@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, greg@kroah.com, hpa@zytor.com, luto@amacapital.net, matt@console-pimps.org, mjg59@srcf.ucam.org, mtk.manpages@gmail.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: verify the signature of signed PE bzImage
has been added to the -mm tree.  Its filename is
     kexec-verify-the-signature-of-signed-pe-bzimage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-verify-the-signature-of-signed-pe-bzimage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-verify-the-signature-of-signed-pe-bzimage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vivek Goyal <vgoyal@redhat.com>
Subject: kexec: verify the signature of signed PE bzImage

This is the final piece of the puzzle of verifying kernel image signature
during kexec_file_load() syscall.

This patch calls into PE file routines to verify signature of bzImage.  If
signature are valid, kexec_file_load() succeeds otherwise it fails.

Two new config options have been introduced.  First one is
CONFIG_KEXEC_VERIFY_SIG.  This option enforces that kernel has to be
validly signed otherwise kernel load will fail.  If this option is not
set, no signature verification will be done.  Only exception will be when
secureboot is enabled.  In that case signature verification should be
automatically enforced when secureboot is enabled.  But that will happen
when secureboot patches are merged.

Second config option is CONFIG_KEXEC_BZIMAGE_VERIFY_SIG.  This option
enables signature verification support on bzImage.  If this option is not
set and previous one is set, kernel image loading will fail because kernel
does not have support to verify signature of bzImage.

I tested these patches with both "pesign" and "sbsign" signed bzImages.

I used signing_key.priv key and signing_key.x509 cert for signing as
generated during kernel build process (if module signing is enabled).

Used following method to sign bzImage.

pesign
======
- Convert DER format cert to PEM format cert
openssl x509 -in signing_key.x509 -inform DER -out signing_key.x509.PEM -outform
PEM

- Generate a .p12 file from existing cert and private key file
openssl pkcs12 -export -out kernel-key.p12 -inkey signing_key.priv -in
signing_key.x509.PEM

- Import .p12 file into pesign db
pk12util -i /tmp/kernel-key.p12 -d /etc/pki/pesign

- Sign bzImage
pesign -i /boot/vmlinuz-3.16.0-rc3+ -o /boot/vmlinuz-3.16.0-rc3+.signed.pesign
-c "Glacier signing key - Magrathea" -s

sbsign
======
sbsign --key signing_key.priv --cert signing_key.x509.PEM --output
/boot/vmlinuz-3.16.0-rc3+.signed.sbsign /boot/vmlinuz-3.16.0-rc3+



Patch details:

Well all the hard work is done in previous patches.  Now bzImage loader
has just call into that code and verify whether bzImage signature are
valid or not.

Also create two config options.  First one is CONFIG_KEXEC_VERIFY_SIG. 
This option enforces that kernel has to be validly signed otherwise kernel
load will fail.  If this option is not set, no signature verification will
be done.  Only exception will be when secureboot is enabled.  In that case
signature verification should be automatically enforced when secureboot is
enabled.  But that will happen when secureboot patches are merged.

Second config option is CONFIG_KEXEC_BZIMAGE_VERIFY_SIG.  This option
enables signature verification support on bzImage.  If this option is not
set and previous one is set, kernel image loading will fail because kernel
does not have support to verify signature of bzImage.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: WANG Chao <chaowang@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig                   |   22 ++++++++++++++++++++++
 arch/x86/kernel/kexec-bzimage64.c  |   21 +++++++++++++++++++++
 arch/x86/kernel/machine_kexec_64.c |   11 +++++++++++
 include/linux/kexec.h              |    3 +++
 kernel/kexec.c                     |   15 +++++++++++++++
 5 files changed, 72 insertions(+)

diff -puN arch/x86/Kconfig~kexec-verify-the-signature-of-signed-pe-bzimage arch/x86/Kconfig
--- a/arch/x86/Kconfig~kexec-verify-the-signature-of-signed-pe-bzimage
+++ a/arch/x86/Kconfig
@@ -1598,6 +1598,28 @@ config KEXEC
 	  interface is strongly in flux, so no good recommendation can be
 	  made.
 
+config KEXEC_VERIFY_SIG
+	bool "Verify kernel signature during kexec_file_load() syscall"
+	depends on KEXEC
+	---help---
+	  This option makes kernel signature verification mandatory for
+	  kexec_file_load() syscall. If kernel is signature can not be
+	  verified, kexec_file_load() will fail.
+
+	  This option enforces signature verification at generic level.
+	  One needs to enable signature verification for type of kernel
+	  image being loaded to make sure it works. For example, enable
+	  bzImage signature verification option to be able to load and
+	  verify signatures of bzImage. Otherwise kernel loading will fail.
+
+config KEXEC_BZIMAGE_VERIFY_SIG
+	bool "Enable bzImage signature verification support"
+	depends on KEXEC_VERIFY_SIG
+	depends on SIGNED_PE_FILE_VERIFICATION
+	select SYSTEM_TRUSTED_KEYRING
+	---help---
+	  Enable bzImage signature verification support.
+
 config CRASH_DUMP
 	bool "kernel crash dumps"
 	depends on X86_64 || (X86_32 && HIGHMEM)
diff -puN arch/x86/kernel/kexec-bzimage64.c~kexec-verify-the-signature-of-signed-pe-bzimage arch/x86/kernel/kexec-bzimage64.c
--- a/arch/x86/kernel/kexec-bzimage64.c~kexec-verify-the-signature-of-signed-pe-bzimage
+++ a/arch/x86/kernel/kexec-bzimage64.c
@@ -19,6 +19,8 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/efi.h>
+#include <linux/verify_pefile.h>
+#include <keys/system_keyring.h>
 
 #include <asm/bootparam.h>
 #include <asm/setup.h>
@@ -525,8 +527,27 @@ int bzImage64_cleanup(void *loader_data)
 	return 0;
 }
 
+#ifdef CONFIG_KEXEC_BZIMAGE_VERIFY_SIG
+int bzImage64_verify_sig(const char *kernel, unsigned long kernel_len)
+{
+	bool trusted;
+	int ret;
+
+	ret = verify_pefile_signature(kernel, kernel_len,
+				      system_trusted_keyring, &trusted);
+	if (ret < 0)
+		return ret;
+	if (!trusted)
+		return -EKEYREJECTED;
+	return 0;
+}
+#endif
+
 struct kexec_file_ops kexec_bzImage64_ops = {
 	.probe = bzImage64_probe,
 	.load = bzImage64_load,
 	.cleanup = bzImage64_cleanup,
+#ifdef CONFIG_KEXEC_BZIMAGE_VERIFY_SIG
+	.verify_sig = bzImage64_verify_sig,
+#endif
 };
diff -puN arch/x86/kernel/machine_kexec_64.c~kexec-verify-the-signature-of-signed-pe-bzimage arch/x86/kernel/machine_kexec_64.c
--- a/arch/x86/kernel/machine_kexec_64.c~kexec-verify-the-signature-of-signed-pe-bzimage
+++ a/arch/x86/kernel/machine_kexec_64.c
@@ -372,6 +372,17 @@ int arch_kimage_file_post_load_cleanup(s
 	return image->fops->cleanup(image->image_loader_data);
 }
 
+int arch_kexec_kernel_verify_sig(struct kimage *image, void *kernel,
+				 unsigned long kernel_len)
+{
+	if (!image->fops || !image->fops->verify_sig) {
+		pr_debug("kernel loader does not support signature verification.");
+		return -EKEYREJECTED;
+	}
+
+	return image->fops->verify_sig(kernel, kernel_len);
+}
+
 /*
  * Apply purgatory relocations.
  *
diff -puN include/linux/kexec.h~kexec-verify-the-signature-of-signed-pe-bzimage include/linux/kexec.h
--- a/include/linux/kexec.h~kexec-verify-the-signature-of-signed-pe-bzimage
+++ a/include/linux/kexec.h
@@ -191,11 +191,14 @@ typedef void *(kexec_load_t)(struct kima
 			     unsigned long initrd_len, char *cmdline,
 			     unsigned long cmdline_len);
 typedef int (kexec_cleanup_t)(void *loader_data);
+typedef int (kexec_verify_sig_t)(const char *kernel_buf,
+				 unsigned long kernel_len);
 
 struct kexec_file_ops {
 	kexec_probe_t *probe;
 	kexec_load_t *load;
 	kexec_cleanup_t *cleanup;
+	kexec_verify_sig_t *verify_sig;
 };
 
 /* kexec interface functions */
diff -puN kernel/kexec.c~kexec-verify-the-signature-of-signed-pe-bzimage kernel/kexec.c
--- a/kernel/kexec.c~kexec-verify-the-signature-of-signed-pe-bzimage
+++ a/kernel/kexec.c
@@ -415,6 +415,12 @@ void __weak arch_kimage_file_post_load_c
 {
 }
 
+int __weak arch_kexec_kernel_verify_sig(struct kimage *image, void *buf,
+					unsigned long buf_len)
+{
+	return -EKEYREJECTED;
+}
+
 /* Apply relocations of type RELA */
 int __weak
 arch_kexec_apply_relocations_add(const Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
@@ -493,6 +499,15 @@ kimage_file_prepare_segments(struct kima
 	if (ret)
 		goto out;
 
+#ifdef CONFIG_KEXEC_VERIFY_SIG
+	ret = arch_kexec_kernel_verify_sig(image, image->kernel_buf,
+					   image->kernel_buf_len);
+	if (ret) {
+		pr_debug("kernel signature verification failed.\n");
+		goto out;
+	}
+	pr_debug("kernel signature verification successful.\n");
+#endif
 	/* It is possible that there no initramfs is being loaded */
 	if (!(flags & KEXEC_FILE_NO_INITRAMFS)) {
 		ret = copy_file_from_fd(initrd_fd, &image->initrd_buf,
_

Patches currently in -mm which might be from vgoyal@redhat.com are

mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors.patch
mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4.patch
mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v6.patch
linux-next.patch
bin2c-move-bin2c-in-scripts-basic.patch
kernel-build-bin2c-based-on-config-option-config_build_bin2c.patch
kexec-rename-unusebale_pages-to-unusable_pages.patch
kexec-move-segment-verification-code-in-a-separate-function.patch
kexec-use-common-function-for-kimage_normal_alloc-and-kimage_crash_alloc.patch
resource-provide-new-functions-to-walk-through-resources.patch
kexec-make-kexec_segment-user-buffer-pointer-a-union.patch
kexec-new-syscall-kexec_file_load-declaration.patch
kexec-implementation-of-new-syscall-kexec_file_load.patch
kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes.patch
kexec-implementation-of-new-syscall-kexec_file_load-fix.patch
purgatory-sha256-provide-implementation-of-sha256-in-purgaotory-context.patch
purgatory-core-purgatory-functionality.patch
purgatory-core-purgatory-functionality-fix.patch
kexec-load-and-relocate-purgatory-at-kernel-load-time.patch
kexec-load-and-relocate-purgatory-at-kernel-load-time-fix.patch
kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry.patch
kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry-fix.patch
kexec-support-for-kexec-on-panic-using-new-system-call.patch
kexec-support-for-kexec-on-panic-using-new-system-call-fix.patch
kexec-support-kexec-kdump-on-efi-systems.patch
kexec-support-kexec-kdump-on-efi-systems-fix.patch
kexec-verify-the-signature-of-signed-pe-bzimage.patch

