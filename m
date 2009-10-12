From: akpm@linux-foundation.org
Subject: + sn-unsigned-cannot-be-less-than-0-in-sn_hwperf_ioctl.patch added to -mm tree
Date: Mon, 12 Oct 2009 16:12:10 -0700
Message-ID: <200910122312.n9CNCA1I001861@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58601 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757149AbZJLXMv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Oct 2009 19:12:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, jes@sgi.com, tony.luck@intel.com


The patch titled
     sn: unsigned cannot be less than 0 in sn_hwperf_ioctl()
has been added to the -mm tree.  Its filename is
     sn-unsigned-cannot-be-less-than-0-in-sn_hwperf_ioctl.patch

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
Subject: sn: unsigned cannot be less than 0 in sn_hwperf_ioctl()
From: Roel Kluin <roel.kluin@gmail.com>

struct sn_hwperf_ioctl_args member arg (u64) cannot be less than 0.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Jes Sorensen <jes@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN arch/ia64/sn/kernel/sn2/sn_hwperf.c~sn-unsigned-cannot-be-less-than-0-in-sn_hwperf_ioctl arch/ia64/sn/kernel/sn2/sn_hwperf.c
--- a/arch/ia64/sn/kernel/sn2/sn_hwperf.c~sn-unsigned-cannot-be-less-than-0-in-sn_hwperf_ioctl
+++ a/arch/ia64/sn/kernel/sn2/sn_hwperf.c
@@ -786,17 +786,18 @@ sn_hwperf_ioctl(struct inode *in, struct
 		break;
 
 	case SN_HWPERF_GET_OBJ_NODE:
-		if (a.sz != sizeof(u64) || a.arg < 0) {
+		i = a.arg;
+		if (a.sz != sizeof(u64) || i < 0) {
 			r = -EINVAL;
 			goto error;
 		}
 		if ((r = sn_hwperf_enum_objects(&nobj, &objs)) == 0) {
-			if (a.arg >= nobj) {
+			if (i >= nobj) {
 				r = -EINVAL;
 				vfree(objs);
 				goto error;
 			}
-			if (objs[(i = a.arg)].id != a.arg) {
+			if (objs[i].id != a.arg) {
 				for (i = 0; i < nobj; i++) {
 					if (objs[i].id == a.arg)
 						break;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
sn-unsigned-cannot-be-less-than-0-in-sn_hwperf_ioctl.patch
hfc_usb-fix-read-buffer-overflow.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
st-fix-test-of-value-range-in-st_set_options.patch
drivers-staging-octeon-ethernet-rgmiic-dont-ignore-request_irq-return-code.patch
page-types-unsigned-cannot-be-less-than-0-in-add_page.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
gpio-fix-test-on-unsigned-in-lnw_irq_type.patch

