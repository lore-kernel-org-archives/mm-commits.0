From: akpm@linux-foundation.org
Subject: + dm_multipath_rdac-scsi_normalize_sense-undefined.patch added to -mm tree
Date: Mon, 27 Aug 2007 14:45:16 -0700
Message-ID: <200708272145.l7RLjGhC029997@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43239 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763719AbXH0VqJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Aug 2007 17:46:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, agk@redhat.com, akpm@linux-foundation.org, sekharan@us.ibm.com


The patch titled
     DM_MULTIPATH_RDAC: "scsi_normalize_sense" undefined
has been added to the -mm tree.  Its filename is
     dm_multipath_rdac-scsi_normalize_sense-undefined.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: DM_MULTIPATH_RDAC: "scsi_normalize_sense" undefined
From: Randy Dunlap <randy.dunlap@oracle.com>

DM_MULTIPATH_RDAC uses SCSI API(s) and is for a SCSI device, so add SCSI to
its depends on to prevent build errors.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/md/Kconfig~dm_multipath_rdac-scsi_normalize_sense-undefined drivers/md/Kconfig
--- a/drivers/md/Kconfig~dm_multipath_rdac-scsi_normalize_sense-undefined
+++ a/drivers/md/Kconfig
@@ -263,7 +263,7 @@ config DM_MULTIPATH_EMC
 
 config DM_MULTIPATH_RDAC
 	tristate "LSI/Engenio RDAC multipath support (EXPERIMENTAL)"
-	depends on DM_MULTIPATH && BLK_DEV_DM && EXPERIMENTAL
+	depends on DM_MULTIPATH && BLK_DEV_DM && SCSI && EXPERIMENTAL
 	---help---
 	  Multipath support for LSI/Engenio RDAC.
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
maintainers-update-dco-info.patch
git-acpi.patch
fix-auditscc-kernel-doc.patch
git-mtd.patch
pci-aer-fix-warnings-when-pcieaer=n.patch
git-unionfs.patch
git-ipwireless_cs.patch
dm_multipath_rdac-scsi_normalize_sense-undefined.patch
security-convert-lsm-into-a-static-interface-fix-2-fix.patch
profile-likely-unlikely-macros.patch
