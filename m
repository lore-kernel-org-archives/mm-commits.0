From: akpm@linux-foundation.org
Subject: + alpha-ptr_err-overwrites-einval-in-syscall-osf_mount.patch added to -mm tree
Date: Wed, 03 Feb 2010 15:24:05 -0800
Message-ID: <201002032324.o13NO5Qh025747@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42106 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757847Ab0BCXYr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 18:24:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, ink@jurassic.park.msu.ru, mattst88@gmail.com, rth@twiddle.net


The patch titled
     alpha: PTR_ERR overwrites -EINVAL in syscall osf_mount
has been added to the -mm tree.  Its filename is
     alpha-ptr_err-overwrites-einval-in-syscall-osf_mount.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: PTR_ERR overwrites -EINVAL in syscall osf_mount
From: Roel Kluin <roel.kluin@gmail.com>

The initial -EINVAL value is overwritten by `retval = PTR_ERR(name)'.  If
this isn't an error pointer and typenr is not 1, 6 or 9, then this retval,
a pointer cast to a long, is returned.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/osf_sys.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/alpha/kernel/osf_sys.c~alpha-ptr_err-overwrites-einval-in-syscall-osf_mount arch/alpha/kernel/osf_sys.c
--- a/arch/alpha/kernel/osf_sys.c~alpha-ptr_err-overwrites-einval-in-syscall-osf_mount
+++ a/arch/alpha/kernel/osf_sys.c
@@ -361,7 +361,7 @@ osf_procfs_mount(char *dirname, struct p
 SYSCALL_DEFINE4(osf_mount, unsigned long, typenr, char __user *, path,
 		int, flag, void __user *, data)
 {
-	int retval = -EINVAL;
+	int retval;
 	char *name;
 
 	name = getname(path);
@@ -379,6 +379,7 @@ SYSCALL_DEFINE4(osf_mount, unsigned long
 		retval = osf_procfs_mount(name, data, flag);
 		break;
 	default:
+		retval = -EINVAL;
 		printk("osf_mount(%ld, %x)\n", typenr, flag);
 	}
 	putname(name);
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
acpi-fix-confusion-in-acpi_evaluate_string-in-comment.patch
asus-acpi-remove-duplicate-comparison-of-asus_model-strings.patch
thinkpad-acpi-wrong-thermal-attribute_group-removed-in-thermal_exit.patch
gemini-wrong-registers-used-to-set-reg_level-in-gpio_set_irq_type.patch
dma-cases-ipu_pix_fmt_bgra32-bgr32-and-abgr32-are-the-same-in-ipu_ch_param_set_size.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
drivers-gpu-drm-drm_crtc_helperc-fix-setting-of-fb_changed-in-drm_crtc_helper_set_config.patch
drivers-media-dvb-dvb-usb-dvb-usb-initc-return-enomem-if-kzalloc-failed-in-dvb_usb_device_init.patch
ia64-wrong-attribute-of-hub-chip-written-in-uv_setup.patch
mtd-hot-spin-and-code-duplication-in-nand_bcm_umi_bch_read_oobecc.patch
mtd-change-positive-error-return-into-negative-in-mtd_do_writeoob.patch
hisax-timeout-off-by-one-in-waitrecmsg.patch
misdn-positive-error-return-should-be-negative-in-mode_hfcmulti.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
dc395x-decrease-iteration-for-tag_number-of-max_command-in-start_scsi.patch
mpt2sas-fix-confusion-in-_scsih_sas_device_status_change_event.patch
lpfc-two-branches-the-same-in-lpfc_decode_firmware_rev.patch
lpfc-positive-error-return-into-negative.patch
qla2xxx-negative-error-return-in-qla2x00_change_queue_depth.patch
paride-fix-off-by-one-test.patch
musb-test-always-evaluates-to-false.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-ptr_err-overwrites-einval-in-syscall-osf_mount.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
cris-v32-typo-in-crisv32_arbiter_unwatch.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch
w1-fix-test-in-ds2482_wait_1wire_idle.patch

