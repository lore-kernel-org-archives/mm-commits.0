From: akpm@osdl.org
Subject: - cciss-build-with-proc_fs=n.patch removed from -mm tree
Date: Mon, 01 Jan 2007 23:24:32 -0800
Message-ID: <200701020724.l027OW3f012955@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37333 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932775AbXABHYk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 02:24:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, jens.axboe@oracle.com, mike.miller@hp.com, mm-commits@vger.kernel.org


The patch titled
     cciss: build with PROC_FS=n
has been removed from the -mm tree.  Its filename was
     cciss-build-with-proc_fs=n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cciss: build with PROC_FS=n
From: Randy Dunlap <randy.dunlap@oracle.com>

RAID_UNKNOWN is used even when PROC_FS=n, so move it outside of the
CONFIG_PROC_FS block.

drivers/block/cciss.c:1910: error: 'RAID_UNKNOWN' undeclared (first use in this function)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: <mike.miller@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/block/cciss.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/block/cciss.c~cciss-build-with-proc_fs=n drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-build-with-proc_fs=n
+++ a/drivers/block/cciss.c
@@ -225,6 +225,8 @@ static inline CommandList_struct *remove
 
 #include "cciss_scsi.c"		/* For SCSI tape support */
 
+#define RAID_UNKNOWN 6
+
 #ifdef CONFIG_PROC_FS
 
 /*
@@ -232,7 +234,6 @@ static inline CommandList_struct *remove
  */
 #define ENG_GIG 1000000000
 #define ENG_GIG_FACTOR (ENG_GIG/512)
-#define RAID_UNKNOWN 6
 static const char *raid_label[] = { "0", "4", "1(1+0)", "5", "5+1", "ADG",
 	"UNKNOWN"
 };
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-alsa.patch
git-cpufreq.patch
git-gfs2-nmw.patch
qconf-immediately-update-integer-and-string-values-in-xconfig-display.patch
git-mtd.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
reiser4-use-null-for-pointers.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
profile_likely-export-do_check_likely.patch
