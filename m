From: akpm@linux-foundation.org
Subject: + qla2x-fix-printk-format-warnings.patch added to -mm tree
Date: Thu, 19 Feb 2009 13:54:04 -0800
Message-ID: <200902192154.n1JLs4lq025518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38433 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756808AbZBSVzA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 16:55:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, James.Bottomley@HansenPartnership.com, seokmann.ju@qlogic.com


The patch titled
     qla2x: fix printk format warnings
has been added to the -mm tree.  Its filename is
     qla2x-fix-printk-format-warnings.patch

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
Subject: qla2x: fix printk format warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix qla2xxx printk format warnings:

drivers/scsi/qla2xxx/qla_sup.c:915: warning: long long unsigned int format, u64 arg (arg 5)
drivers/scsi/qla2xxx/qla_sup.c:915: warning: long long unsigned int format, u64 arg (arg 6)
drivers/scsi/qla2xxx/qla_sup.c:923: warning: long long unsigned int format, u64 arg (arg 5)
drivers/scsi/qla2xxx/qla_sup.c:923: warning: long long unsigned int format, u64 arg (arg 6)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Seokmann Ju <seokmann.ju@qlogic.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/qla2xxx/qla_sup.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/qla2xxx/qla_sup.c~qla2x-fix-printk-format-warnings drivers/scsi/qla2xxx/qla_sup.c
--- a/drivers/scsi/qla2xxx/qla_sup.c~qla2x-fix-printk-format-warnings
+++ a/drivers/scsi/qla2xxx/qla_sup.c
@@ -914,7 +914,9 @@ qla2xxx_flash_npiv_conf(scsi_qla_host_t 
 
 		DEBUG2(qla_printk(KERN_DEBUG, ha, "NPIV[%02x]: wwpn=%llx "
 			"wwnn=%llx vf_id=0x%x Q_qos=0x%x F_qos=0x%x.\n", cnt,
-			vid.port_name, vid.node_name, le16_to_cpu(entry->vf_id),
+			(unsigned long long)vid.port_name,
+			(unsigned long long)vid.node_name,
+			le16_to_cpu(entry->vf_id),
 			entry->q_qos, entry->f_qos));
 
 		if (i < QLA_PRECONFIG_VPORTS) {
@@ -923,7 +925,8 @@ qla2xxx_flash_npiv_conf(scsi_qla_host_t 
 				qla_printk(KERN_INFO, ha,
 				"NPIV-Config: Failed to create vport [%02x]: "
 				"wwpn=%llx wwnn=%llx.\n", cnt,
-				vid.port_name, vid.node_name);
+				(unsigned long long)vid.port_name,
+				(unsigned long long)vid.node_name);
 		}
 	}
 done:
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
x86-oqo-depends-on-input_polldev.patch
kgdb-fix-kernel-doc-error.patch
auditsc-fix-kernel-doc-notation.patch
input-ad7879-touchscreen-driver.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
esp-fix-section-mismatch-warning.patch
qla2x-fix-printk-format-warnings.patch
vfs-update-fsh-to-use-inline-functions-when-no-file-locking-set.patch
vfs-further-changes-from-macro-to-inline-function-in-fsh.patch
max3100-spi-uart-driver.patch
mm-add-proc-controls-for-pdflush-threads-fix-99.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems-99.patch
atyfb-fix-header-file-trailing-whitespace.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix2.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-fix.patch
asiliantfb-fix-cmap-memory-leaks-fix.patch
documentation-ignore-byproducts-from-latex.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
linuxpps-core-support.patch
linuxpps-core-support-v2.patch
reiser4-export-remove_from_page_cache-fix.patch

