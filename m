From: akpm@linux-foundation.org
Subject: - firmware-fix-memmap-printk-format-warnings.patch removed from -mm tree
Date: Mon, 28 Jul 2008 14:10:58 -0700
Message-ID: <200807282110.m6SLAwC1027615@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57132 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761517AbYG1VTE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 17:19:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, bwalle@suse.de, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     firmware: fix memmap printk format warnings
has been removed from the -mm tree.  Its filename was
     firmware-fix-memmap-printk-format-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
lkdtm-fix-for-config_scsi=n.patch
git-unionfs.patch
profile-likely-unlikely-macros.patch

