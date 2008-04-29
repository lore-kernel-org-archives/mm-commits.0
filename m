From: akpm@linux-foundation.org
Subject: + drivers-scsi-mvsasc-fix-printk-warnings.patch added to -mm tree
Date: Tue, 29 Apr 2008 00:56:50 -0700
Message-ID: <200804290756.m3T7uouu008479@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43174 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751411AbYD2H5M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 03:57:12 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m3T7uoJ8017724
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 29 Apr 2008 00:56:51 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     drivers/scsi/mvsas.c: fix printk warnings
has been added to the -mm tree.  Its filename is
     drivers-scsi-mvsasc-fix-printk-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/scsi/mvsas.c: fix printk warnings
From: Andrew Morton <akpm@linux-foundation.org>

sparc64:

drivers/scsi/mvsas.c: In function `mvs_update_phyinfo':
drivers/scsi/mvsas.c:2822: warning: long long unsigned int format, u64 arg (arg 5)
drivers/scsi/mvsas.c:2822: warning: long long unsigned int format, u64 arg (arg 6)

We do not know what type the architecture uses for u64 and must cast it.



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/mvsas.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/mvsas.c~drivers-scsi-mvsasc-fix-printk-warnings drivers/scsi/mvsas.c
--- a/drivers/scsi/mvsas.c~drivers-scsi-mvsasc-fix-printk-warnings
+++ a/drivers/scsi/mvsas.c
@@ -2822,7 +2822,9 @@ static void mvs_update_phyinfo(struct mv
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			"phy[%d] Get Attached Address 0x%llX ,"
 			" SAS Address 0x%llX\n",
-			i, phy->att_dev_sas_addr, phy->dev_sas_addr);
+			i,
+			(unsigned long long)phy->att_dev_sas_addr,
+			(unsigned long long)phy->dev_sas_addr);
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			"Rate = %x , type = %d\n",
 			sas_phy->linkrate, phy->phy_type);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
make-dev-kmem-a-config-option.patch
misc-phantom-add-compat-ioctl.patch
sysrq-add-show-backtrace-on-all-cpus-function.patch
codafs-fix-build-warning.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations.patch
lib-swiotlbc-cleanups.patch
fs-inodec-use-hlist_for_each_entry.patch
ecryptfs-integrate-ecryptfs-device-handle-into-the-module.patch
ecryptfs-make-key-module-subsystem-respect-namespaces.patch
x86-olpc-add-one-laptop-per-child-architecture-support.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
cgroups-implement-device-whitelist-v6.patch
add-a-document-describing-the-resource-counter-abstraction-v2.patch
memcgroup-implement-failcounter-reset.patch
use-vmalloc-for-mem_cgroup-allocation-v3.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies.patch
ipc-use-ipc_buildid-directly-from-ipc_addid.patch
ipc-add-definitions-of-ushort_max-and-others.patch
ipc-sysvsem-refuse-cloneclone_sysvsemclone_newipc.patch
ipmi-run-to-completion-fixes.patch
ipmi-style-fixes-in-the-system-interface-code.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
keys-add-keyctl-function-to-get-a-security-label.patch
procfs-task-exe-symlink.patch
edd-add-default-mode-config_edd_off=n-override-with-edd=onoff.patch
idr-create-idr_layer_cache-at-boot-time.patch
edac-add-e752x-parameter-for-sysbus_parity-selection.patch
ncpfs-use-get-put_unaligned_-helpers.patch
relayfs-support-larger-relay-buffer-take-3.patch
drivers-scsi-mvsasc-fix-printk-warnings.patch

