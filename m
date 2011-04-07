From: akpm@linux-foundation.org
Subject: + drivers-scsi-mpt2sas-mpt2sas_ctlc-fix-unbounded-copy_to_user.patch added to -mm tree
Date: Thu, 07 Apr 2011 16:56:45 -0700
Message-ID: <201104072356.p37Nujmo007901@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757120Ab1DGX4v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Apr 2011 19:56:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com, drosenberg@vsecurity.com, eric.moore@lsi.com, eugeneteo@kernel.sg, kashyap.desai@lsi.com, stable@kernel.org


The patch titled
     drivers/scsi/mpt2sas/mpt2sas_ctl.c: fix unbounded copy_to_user()
has been added to the -mm tree.  Its filename is
     drivers-scsi-mpt2sas-mpt2sas_ctlc-fix-unbounded-copy_to_user.patch

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
Subject: drivers/scsi/mpt2sas/mpt2sas_ctl.c: fix unbounded copy_to_user()
From: Andrew Morton <akpm@linux-foundation.org>

In _ctl_diag_read_buffer() on line 2019, user-supplied values are
used to determine the size of a copy_to_user() as well as the offset
into the buffer to be read, with no bounds checking.  I'm not familiar
with this code, so I'm not sure what checks would be appropriate, but
letting unprivileged users read arbitrary kernel memory probably isn't
intended.

Reported-by: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Eric Moore <eric.moore@lsi.com>
Cc: Desai Kashyap <kashyap.desai@lsi.com>
Cc: Eugene Teo <eugeneteo@kernel.sg>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/mpt2sas/mpt2sas_ctl.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/scsi/mpt2sas/mpt2sas_ctl.c~drivers-scsi-mpt2sas-mpt2sas_ctlc-fix-unbounded-copy_to_user drivers/scsi/mpt2sas/mpt2sas_ctl.c
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c~drivers-scsi-mpt2sas-mpt2sas_ctlc-fix-unbounded-copy_to_user
+++ a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -2011,6 +2011,9 @@ _ctl_diag_read_buffer(void __user *arg, 
 	    "offset(%d), sz(%d)\n", ioc->name, __func__,
 	    diag_data, karg.starting_offset, karg.bytes_to_read));
 
+	if (karg.bytes_to_read != sizeof(uarg->diagnostic_data))
+		return -EINVAL;
+
 	if (copy_to_user((void __user *)uarg->diagnostic_data,
 	    diag_data, karg.bytes_to_read)) {
 		printk(MPT2SAS_ERR_FMT "%s: Unable to write "
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-i2c-busses-i2c-designware-corec-needs-delayh.patch
fs-partitions-ldmc-fix-oops-caused-by-corrupted-partition-table-checkpatch-fixes.patch
mm-add-vm-counters-for-transparent-hugepages.patch
drivers-scsi-mpt2sas-mpt2sas_ctlc-fix-unbounded-copy_to_user.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drbd-fix-warning.patch
mm.patch
mm-nommu-sort-mm-mmap-list-properly-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-checkpatch-fixes.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-fix.patch
lru_cache-use-correct-type-in-sizeof-for-allocation-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
drivers-tty-vt-vt_ioctlc-repair-insane-expression.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
add-the-pagefault-count-into-memcg-stats-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

