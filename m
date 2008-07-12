From: akpm@linux-foundation.org
Subject: + firmware-fix-memmap-printk-format-warnings.patch added to -mm tree
Date: Fri, 11 Jul 2008 17:38:04 -0700
Message-ID: <200807120038.m6C0c4el012659@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50674 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754918AbYGLAid (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 20:38:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, bwalle@suse.de, mingo@elte.hu


The patch titled
     firmware: fix memmap printk format warnings
has been added to the -mm tree.  Its filename is
     firmware-fix-memmap-printk-format-warnings.patch

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
Subject: firmware: fix memmap printk format warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix firmware/memmap printk format warnings:

linux-next-20080711/drivers/firmware/memmap.c:156: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'resource_size_t'
linux-next-20080711/drivers/firmware/memmap.c:161: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'resource_size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Bernhard Walle <bwalle@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/memmap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/firmware/memmap.c~firmware-fix-memmap-printk-format-warnings drivers/firmware/memmap.c
--- a/drivers/firmware/memmap.c~firmware-fix-memmap-printk-format-warnings
+++ a/drivers/firmware/memmap.c
@@ -153,12 +153,14 @@ int __init firmware_map_add_early(resour
 
 static ssize_t start_show(struct firmware_map_entry *entry, char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "0x%llx\n", entry->start);
+	return snprintf(buf, PAGE_SIZE, "0x%llx\n",
+		(unsigned long long)entry->start);
 }
 
 static ssize_t end_show(struct firmware_map_entry *entry, char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "0x%llx\n", entry->end);
+	return snprintf(buf, PAGE_SIZE, "0x%llx\n",
+		(unsigned long long)entry->end);
 }
 
 static ssize_t type_show(struct firmware_map_entry *entry, char *buf)
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
acpi-utmisc-use-warn_on-instead-of-warn_on_slowpath.patch
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
bluetooth-hci_bcsp-fix-bitrev-kconfig.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
git-scsi-misc-fix-scsi_dh-build-errors.patch
lkdtm-fix-for-config_scsi=n.patch
compat_ioctl-handle-block=n-scsi=n.patch
git-unionfs.patch
vmallocinfo-add-numa-information.patch
vmallocinfo-add-numa-information-fix.patch
pm-remove-obsolete-piece-of-pm-documentation-rev-2.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
kallsyms-unify-32-and-64-bit-code.patch
procfs-guide-drop-pointless-nbsp-entities.patch
bsdacct-stir-up-comments-around-acct_process.patch
documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections.patch
profile-likely-unlikely-macros.patch
firmware-fix-memmap-printk-format-warnings.patch

