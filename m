From: akpm@linux-foundation.org
Subject: [merged] alpha-ptr_err-overwrites-einval-in-syscall-osf_mount.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:05:03 -0800
Message-ID: <201003091905.o29J53bp031092@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755790Ab0CITFd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:05:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, ink@jurassic.park.msu.ru, mattst88@gmail.com, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: PTR_ERR overwrites -EINVAL in syscall osf_mount
has been removed from the -mm tree.  Its filename was
     alpha-ptr_err-overwrites-einval-in-syscall-osf_mount.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
score-fix-dereference-of-null-pointer-in-local_flush_tlb_page.patch
isdn-misplaced-parenthesis-in-pof_handle_data.patch
obsolete-config-in-kernel-source-use_internal_timer.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
dc395x-decrease-iteration-for-tag_number-of-max_command-in-start_scsi.patch
mpt2sas-fix-confusion-in-_scsih_sas_device_status_change_event.patch
lpfc-positive-error-return-into-negative.patch
scsi-bfa-correct-onstack-wait_queue_head-declaration.patch
paride-fix-off-by-one-test.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch
w1-fix-test-in-ds2482_wait_1wire_idle.patch

