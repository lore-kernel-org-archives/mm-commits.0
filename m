From: akpm@linux-foundation.org
Subject: [merged] arch-s390-kvm-sigpc-fix-read-buffer-overflow.patch removed from -mm tree
Date: Tue, 04 Aug 2009 12:35:35 -0700
Message-ID: <200908041935.n74JZZP5029453@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40900 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752680AbZHDTfz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2009 15:35:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, avi@redhat.com, borntraeger@de.ibm.com, cotte@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     arch/s390/kvm/sigp.c: fix read buffer overflow
has been removed from the -mm tree.  Its filename was
     arch-s390-kvm-sigpc-fix-read-buffer-overflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/s390/kvm/sigp.c: fix read buffer overflow
From: Roel Kluin <roel.kluin@gmail.com>

Check whether index is within bounds before testing the element.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kvm/sigp.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN arch/s390/kvm/sigp.c~arch-s390-kvm-sigpc-fix-read-buffer-overflow arch/s390/kvm/sigp.c
--- a/arch/s390/kvm/sigp.c~arch-s390-kvm-sigpc-fix-read-buffer-overflow
+++ a/arch/s390/kvm/sigp.c
@@ -181,7 +181,7 @@ static int __sigp_set_prefix(struct kvm_
 			     unsigned long *reg)
 {
 	struct kvm_s390_float_interrupt *fi = &vcpu->kvm->arch.float_int;
-	struct kvm_s390_local_interrupt *li;
+	struct kvm_s390_local_interrupt *li = NULL;
 	struct kvm_s390_interrupt_info *inti;
 	int rc;
 	u8 tmp;
@@ -201,9 +201,10 @@ static int __sigp_set_prefix(struct kvm_
 		return 2; /* busy */
 
 	spin_lock(&fi->lock);
-	li = fi->local_int[cpu_addr];
+	if (cpu_addr < KVM_MAX_VCPUS)
+		li = fi->local_int[cpu_addr];
 
-	if ((cpu_addr >= KVM_MAX_VCPUS) || (li == NULL)) {
+	if (li == NULL) {
 		rc = 1; /* incorrect state */
 		*reg &= SIGP_STAT_INCORRECT_STATE;
 		kfree(inti);
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
x86-fix-buffer-overflow-in-efi_init.patch
kgdb-remove-redundant-test.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
powerpc-fsl-booke-read-buffer-overflow.patch
media-strncpy-does-not-null-terminate-string.patch
siano-read-buffer-overflow.patch
drivers-media-video-bw-qcamc-fix-read-buffer-overflow.patch
stk-webcam-read-buffer-overflow.patch
hid-fix-read-buffer-overflow.patch
ipath-strncpy-does-not-null-terminate-string.patch
kvm-fix-read-buffer-overflow.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
mips-read-buffer-overflow.patch
slram-read-buffer-overflow.patch
slram-read-buffer-overflow-cleanup.patch
mtd-fix-read-buffer-overflow.patch
irda-fix-read-buffer-overflow.patch
hfc_usb-fix-read-buffer-overflow.patch
atlx-strncpy-does-not-null-terminate-string.patch
ext4-remove-redundant-test-on-unsigned.patch
ocfs2-keep-index-within-status_map.patch
drivers-parisc-pdc_stablec-fix-read-buffer-overflow.patch
cyclades-read-buffer-overflow.patch
perf-fix-read-buffer-overflow.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-iprh-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
usb-gadget-read-buffer-overflow.patch
i915-fix-read-outside-array-bounds.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
blackfin-fix-read-buffer-overflow.patch
arch-alpha-boot-tools-objstripc-wrong-variable-tested-after-open.patch
m32r-remove-redundant-tests-on-unsigned.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
dme1737-keep-index-within-pwm_config.patch
ncpfs-read-buffer-overflow.patch
smbfs-read-buffer-overflow.patch
platinumfb-misplaced-parenthesis.patch
sisfb-read-buffer-overflow.patch
drivers-video-console-newport_conc-fix-read-outside-array-bounds.patch
adfs-remove-redundant-test-on-unsigned.patch

