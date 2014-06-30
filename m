From: akpm@linux-foundation.org
Subject: +
 fs-asus_atk0110-fix-define_simple_attribute-semicolon-definition-and-use.patch added to -mm tree
Date: Mon, 30 Jun 2014 16:19:51 -0700
Message-ID: <53b1f097.aQYlPIJDn9Znm3ab%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:62574 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302AbaF3XTw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jun 2014 19:19:52 -0400
Received: by mail-pd0-f201.google.com with SMTP id v10so1470294pde.2
        for <mm-commits@vger.kernel.org>; Mon, 30 Jun 2014 16:19:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, kronos.it@gmail.com, linux@roeck-us.net, mm-commits@vger.kernel.org


The patch titled
     Subject: fs.h, drivers/hwmon/asus_atk0110.c: fix DEFINE_SIMPLE_ATTRIBUTE semicolon definition and use
has been added to the -mm tree.  Its filename is
     fs-asus_atk0110-fix-define_simple_attribute-semicolon-definition-and-use.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-asus_atk0110-fix-define_simple_attribute-semicolon-definition-and-use.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-asus_atk0110-fix-define_simple_attribute-semicolon-definition-and-use.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: fs.h, drivers/hwmon/asus_atk0110.c: fix DEFINE_SIMPLE_ATTRIBUTE semicolon definition and use

The DEFINE_SIMPLE_ATTRIBUTE macro should not end in a ; Fix the one use in
the kernel tree that did not have a semicolon.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Luca Tettamanti <kronos.it@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/asus_atk0110.c |    2 +-
 include/linux/fs.h           |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/hwmon/asus_atk0110.c~fs-asus_atk0110-fix-define_simple_attribute-semicolon-definition-and-use drivers/hwmon/asus_atk0110.c
--- a/drivers/hwmon/asus_atk0110.c~fs-asus_atk0110-fix-define_simple_attribute-semicolon-definition-and-use
+++ a/drivers/hwmon/asus_atk0110.c
@@ -688,7 +688,7 @@ static int atk_debugfs_gitm_get(void *p,
 DEFINE_SIMPLE_ATTRIBUTE(atk_debugfs_gitm,
 			atk_debugfs_gitm_get,
 			NULL,
-			"0x%08llx\n")
+			"0x%08llx\n");
 
 static int atk_acpi_print(char *buf, size_t sz, union acpi_object *obj)
 {
diff -puN include/linux/fs.h~fs-asus_atk0110-fix-define_simple_attribute-semicolon-definition-and-use include/linux/fs.h
--- a/include/linux/fs.h~fs-asus_atk0110-fix-define_simple_attribute-semicolon-definition-and-use
+++ a/include/linux/fs.h
@@ -2688,7 +2688,7 @@ static const struct file_operations __fo
 	.read	 = simple_attr_read,					\
 	.write	 = simple_attr_write,					\
 	.llseek	 = generic_file_llseek,					\
-};
+}
 
 static inline __printf(1, 2)
 void __simple_attr_check_format(const char *fmt, ...)
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-check-git-commit-descriptions.patch
fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array.patch
fs-asus_atk0110-fix-define_simple_attribute-semicolon-definition-and-use.patch
printk-make-dynamic-kernel-ring-buffer-alignment-explicit.patch
printk-move-power-of-2-practice-of-ring-buffer-size-to-a-helper.patch
printk-make-dynamic-units-clear-for-the-kernel-ring-buffer.patch
printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus.patch
printk-tweak-do_syslog-to-match-comments.patch
mm-utilc-add-kstrimdup.patch
kernelh-remove-deprecated-pack_hex_byte.patch
checkpatch-attempt-to-find-unnecessary-out-of-memory-messages.patch
checkpatch-warn-on-unnecessary-else-after-return-or-break.patch
checkpatch-fix-complex-macro-false-positive-for-escaped-constant-char.patch
checkpatch-fix-function-pointers-in-blank-line-needed-after-declarations-test.patch
checkpatch-ignore-email-headers-better.patch
checkpatchpl-also-suggest-else-if-when-if-follows-brace.patch
checkpatch-add-test-for-blank-lines-after-function-struct-union-enum.patch
checkpatch-add-test-for-blank-lines-after-function-struct-union-enum-declarations.patch
checkpatch-add-a-multiple-blank-lines-test.patch
checkpatch-change-blank-line-after-declaration-type-to-line_spacing.patch
checkpatch-quiet-kconfig-help-message-checking.patch
checkpatch-warn-on-unnecessary-parentheses-around-references-of-foo-bar.patch
checkpatch-allow-multiple-const-types.patch
fs-isofs-logging-clean-up.patch
proc-constify-seq_operations.patch
sysctl-remove-now-unused-typedef-ctl_table.patch
sysctl-remove-now-unused-typedef-ctl_table-fix.patch
adfs-add-__printf-verification-fix-format-argument-mismatches.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
linux-next.patch
pci-dma-compat-add-pci_zalloc_consistent-helper.patch
atm-use-pci_zalloc_consistent.patch
block-use-pci_zalloc_consistent.patch
crypto-use-pci_zalloc_consistent.patch
infiniband-use-pci_zalloc_consistent.patch
i810-use-pci_zalloc_consistent.patch
media-use-pci_zalloc_consistent.patch
amd-use-pci_zalloc_consistent.patch
atl1e-use-pci_zalloc_consistent.patch
enic-use-pci_zalloc_consistent.patch
sky2-use-pci_zalloc_consistent.patch
micrel-use-pci_zalloc_consistent.patch
qlogic-use-pci_zalloc_consistent.patch
irda-use-pci_zalloc_consistent.patch
ipw2100-use-pci_zalloc_consistent.patch
mwl8k-use-pci_zalloc_consistent.patch
rtl818x-use-pci_zalloc_consistent.patch
rtlwifi-use-pci_zalloc_consistent.patch
scsi-use-pci_zalloc_consistent.patch
staging-use-pci_zalloc_consistent.patch
synclink_gt-use-pci_zalloc_consistent.patch
vme-bridges-use-pci_zalloc_consistent.patch
amd-neaten-and-remove-unnecessary-oom-messages.patch

