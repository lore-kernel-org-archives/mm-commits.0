From: akpm@linux-foundation.org
Subject: + kvm-ia64-dereference-of-null-pointer-in-set_pal_result.patch added to -mm tree
Date: Tue, 12 Jan 2010 14:11:28 -0800
Message-ID: <201001122211.o0CMBSxg030700@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58996 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753486Ab0ALWLr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jan 2010 17:11:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, avi@redhat.com, mtosatti@redhat.com, tony.luck@intel.com, xiantao.zhang@intel.com


The patch titled
     kvm/ia64: dereference of NULL pointer in set_pal_result()
has been added to the -mm tree.  Its filename is
     kvm-ia64-dereference-of-null-pointer-in-set_pal_result.patch

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
Subject: kvm/ia64: dereference of NULL pointer in set_pal_result()
From: Roel Kluin <roel.kluin@gmail.com>

Do not dereference a NULL pointer

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Xiantao Zhang <xiantao.zhang@intel.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kvm/kvm_fw.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN arch/ia64/kvm/kvm_fw.c~kvm-ia64-dereference-of-null-pointer-in-set_pal_result arch/ia64/kvm/kvm_fw.c
--- a/arch/ia64/kvm/kvm_fw.c~kvm-ia64-dereference-of-null-pointer-in-set_pal_result
+++ a/arch/ia64/kvm/kvm_fw.c
@@ -75,9 +75,11 @@ static void set_pal_result(struct kvm_vc
 	struct exit_ctl_data *p;
 
 	p = kvm_get_exit_data(vcpu);
-	if (p && p->exit_reason == EXIT_REASON_PAL_CALL) {
+	if (!p)
+		return;
+	if (p->exit_reason == EXIT_REASON_PAL_CALL) {
 		p->u.pal_data.ret = result;
-		return ;
+		return;
 	}
 	INIT_PAL_STATUS_UNIMPLEMENTED(p->u.pal_data.ret);
 }
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
acpi-fix-confusion-in-acpi_evaluate_string-in-comment.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
v4l-dvb-wrong-variable-tested.patch
kvm-ia64-dereference-of-null-pointer-in-set_pal_result.patch
hisax-timeout-off-by-one-in-waitrecmsg.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
dc395x-decrease-iteration-for-tag_number-of-max_command-in-start_scsi.patch
mpt2sas-fix-confusion-in-_scsih_sas_device_status_change_event.patch
paride-fix-off-by-one-test.patch
80211core-fix-confusion.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch
w1-fix-test-in-ds2482_wait_1wire_idle.patch

