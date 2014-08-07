From: akpm@linux-foundation.org
Subject: [merged]
 fs-asus_atk0110-fix-define_simple_attribute-semicolon-definition-and-use.patch removed from -mm tree
Date: Thu, 07 Aug 2014 13:07:05 -0700
Message-ID: <53e3dc69.1Xk+Qq+7IPAuq6Cb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:42197 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807AbaHGUHG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:07:06 -0400
Received: by mail-oa0-f74.google.com with SMTP id eb12so839592oac.5
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:07:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, kronos.it@gmail.com, linux@roeck-us.net, mm-commits@vger.kernel.org


The patch titled
     Subject: fs.h, drivers/hwmon/asus_atk0110.c: fix DEFINE_SIMPLE_ATTRIBUTE semicolon definition and use
has been removed from the -mm tree.  Its filename was
     fs-asus_atk0110-fix-define_simple_attribute-semicolon-definition-and-use.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
mm-utilc-add-kstrimdup.patch
fs-befs-linuxvfsc-check-superblock-before-dump-operation.patch
fs-isofs-logging-clean-up.patch
proc-constify-seq_operations.patch
sysctl-remove-now-unused-typedef-ctl_table.patch
sysctl-remove-now-unused-typedef-ctl_table-fix.patch
adfs-add-__printf-verification-fix-format-argument-mismatches.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
scripts-coccinelle-free-add-null-test-before-freeing-functions.patch
linux-next.patch
maintainers-remove-two-ancient-eata-sections.patch
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
maintainers-update-microcode-patterns.patch
maintainers-update-cifs-location.patch
maintainers-use-the-correct-efi-stub-location.patch
maintainers-update-clk-sirf-patterns.patch
maintainers-fix-ssbi-pattern.patch
maintainers-use-correct-filename-for-sdhci-bcm-kona.patch
maintainers-fix-pxa3xx-nand-flash-driver-pattern.patch
maintainers-update-picoxcell-patterns.patch
maintainers-remove-section-cirrus-logic-ep93xx-ohci-usb-host-driver.patch
maintainers-remove-metag-imgdafs-pattern.patch
maintainers-remove-unused-radeon-drm-pattern.patch
maintainers-remove-unusd-arm-qualcomm-msm-pattern.patch
maintainers-remove-unused-nfsd-pattern.patch
fsh-remove-unnecessary-extern-prototypes.patch
fsh-whitespace-neatening.patch
fsh-a-few-more-whitespace-neatenings.patch
fsh-add-argument-names-to-struct-file_lock_operations-funcs.patch
fsh-add-member-argument-descriptions-to-lock_manager_operations.patch
dlm-plock-add-argument-descriptions-to-notify.patch
dlm-fs-remove-unused-conf-from-lm_grant.patch
dlm-plock-reduce-indentation-by-rearranging-order.patch
maintainers-update-dma-buffer-sharing-patterns.patch
maintainers-update-usb-gadget-patterns.patch
maintainers-update-nomadik-patterns.patch

