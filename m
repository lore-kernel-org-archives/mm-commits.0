From: akpm@linux-foundation.org
Subject: + ima-on-soft-reboot-save-the-measurement-list-v3.patch added to
 -mm tree
Date: Tue, 06 Sep 2016 13:29:59 -0700
Message-ID: <57cf2747.cjnbKyRTEmSc+PXg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59658 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933647AbcIFUaA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2016 16:30:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bauerman@linux.vnet.ibm.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ima: on soft reboot, save the measurement list
has been added to the -mm tree.  Its filename is
     ima-on-soft-reboot-save-the-measurement-list-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ima-on-soft-reboot-save-the-measurement-list-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ima-on-soft-reboot-save-the-measurement-list-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: ima: on soft reboot, save the measurement list

Changelog v3:
- Request a kexec segment for storing the measurement list a half page,
not a full page, more than needed for additional measurements.
- Added binary_runtime_size overflow test
- Limit maximum number of pages needed for kexec_segment_size to half
of totalram_pages. (Dave Young)

Link: http://lkml.kernel.org/r/1473170584-15094-6-git-send-email-zohar@linux.vnet.ibm.com
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/integrity/ima/ima_kexec.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff -puN security/integrity/ima/ima_kexec.c~ima-on-soft-reboot-save-the-measurement-list-v3 security/integrity/ima/ima_kexec.c
--- a/security/integrity/ima/ima_kexec.c~ima-on-soft-reboot-save-the-measurement-list-v3
+++ a/security/integrity/ima/ima_kexec.c
@@ -93,8 +93,7 @@ static int ima_update_kexec_buffer(struc
 		return NOTIFY_OK;
 
 	kexec_buffer_size = ima_get_binary_runtime_size();
-	if (kexec_buffer_size >
-	    (kexec_segment_size - sizeof(struct ima_kexec_hdr))) {
+	if (kexec_buffer_size > kexec_segment_size) {
 		pr_err("Binary measurement list grew too large.\n");
 		goto out;
 	}
@@ -123,19 +122,28 @@ struct notifier_block update_buffer_nb =
  */
 void ima_add_kexec_buffer(struct kimage *image)
 {
-	static int registered = 0;
+	static int registered;
 	struct kexec_buf kbuf = { .image = image, .buf_align = PAGE_SIZE,
 				  .buf_min = 0, .buf_max = ULONG_MAX,
 				  .top_down = true, .skip_checksum = true };
+	unsigned long binary_runtime_size;
 	int ret;
 
 	if (!kexec_can_hand_over_buffer())
 		return;
 
-	kexec_segment_size = ALIGN(ima_get_binary_runtime_size() + PAGE_SIZE,
-				   PAGE_SIZE);
-
-	if (kexec_segment_size >= (ULONG_MAX - sizeof(long))) {
+	/*
+	 * Reserve at least an extra half page of memory for additional
+	 * measurements between kexec load and execute.
+	 */
+	binary_runtime_size = ima_get_binary_runtime_size();
+	if (binary_runtime_size >= ULONG_MAX - PAGE_SIZE)
+		kexec_segment_size = ULONG_MAX;
+	else
+		kexec_segment_size = ALIGN(ima_get_binary_runtime_size() +
+					   PAGE_SIZE / 2, PAGE_SIZE);
+	if ((kexec_segment_size == ULONG_MAX) ||
+	    ((kexec_segment_size >> PAGE_SHIFT) > totalram_pages / 2)) {
 		pr_err("Binary measurement list too large.\n");
 		return;
 	}
_

Patches currently in -mm which might be from bauerman@linux.vnet.ibm.com are

kexec_file-allow-arch-specific-memory-walking-for-kexec_add_buffer.patch
kexec_file-change-kexec_add_buffer-to-take-kexec_buf-as-argument.patch
kexec_file-factor-out-kexec_locate_mem_hole-from-kexec_add_buffer.patch
powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead.patch
powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c.patch
powerpc-generalize-elf64_apply_relocate_add.patch
powerpc-adapt-elf64_apply_relocate_add-for-kexec_file_load.patch
powerpc-add-functions-to-read-elf-files-of-any-endianness.patch
powerpc-implement-kexec_file_load.patch
powerpc-add-code-to-work-with-device-trees-in-kexec_file_load.patch
powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load.patch
powerpc-add-purgatory-for-kexec_file_load-implementation.patch
powerpc-add-purgatory-for-kexec_file_load-implementation-fix.patch
powerpc-enable-config_kexec_file-in-powerpc-server-defconfigs.patch
kexec_file-add-buffer-hand-over-support-for-the-next-kernel.patch
powerpc-kexec_file-add-buffer-hand-over-support-for-the-next-kernel.patch
kexec_file-allow-skipping-checksum-calculation-for-some-segments.patch
kexec_file-add-mechanism-to-update-kexec-segments.patch
ima-on-soft-reboot-save-the-measurement-list.patch
ima-on-soft-reboot-save-the-measurement-list-v3.patch

