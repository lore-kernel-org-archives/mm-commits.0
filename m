From: akpm@osdl.org
Subject: - megaraid-build-with-proc_fs=n.patch removed from -mm tree
Date: Wed, 20 Dec 2006 19:57:00 -0800
Message-ID: <200612210357.kBL3v030015032@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35468 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422685AbWLUD5H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 22:57:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     megaraid: build with PROC_FS=n
has been removed from the -mm tree.  Its filename was
     megaraid-build-with-proc_fs=n.patch

This patch was dropped because I already had it

------------------------------------------------------
Subject: megaraid: build with PROC_FS=n
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix megaraid build error when PROC_FS=n:

drivers/built-in.o: In function `megaraid_probe_one':
megaraid.c:(.text.megaraid_probe_one+0xf68): undefined reference to `mega_create_proc_entry'
make: *** [.tmp_vmlinux1] Error 1

and these warnings:
drivers/scsi/megaraid.h:1004: warning: 'mega_print_inquiry' declared 'static' but never defined
drivers/scsi/megaraid.c:4362: warning: 'mega_adapinq' defined but not used
drivers/scsi/megaraid.c:4397: warning: 'mega_internal_dev_inquiry' defined but not used

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/megaraid.c |   11 ++++++++++-
 drivers/scsi/megaraid.h |    5 +++--
 2 files changed, 13 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/megaraid.c~megaraid-build-with-proc_fs=n drivers/scsi/megaraid.c
--- a/drivers/scsi/megaraid.c~megaraid-build-with-proc_fs=n
+++ a/drivers/scsi/megaraid.c
@@ -3178,6 +3178,12 @@ proc_rdrv(adapter_t *adapter, char *page
 	return len;
 }
 
+#else
+
+static inline void mega_create_proc_entry(int index,
+					struct proc_dir_entry *parent)
+{}
+
 #endif
 
 
@@ -4343,6 +4349,7 @@ mega_support_cluster(adapter_t *adapter)
 }
 
 
+#ifdef CONFIG_PROC_FS
 /**
  * mega_adapinq()
  * @adapter - pointer to our soft state
@@ -4447,6 +4454,7 @@ mega_internal_dev_inquiry(adapter_t *ada
 
 	return rval;
 }
+#endif
 
 
 /**
@@ -4965,7 +4973,6 @@ megaraid_remove_one(struct pci_dev *pdev
 {
 	struct Scsi_Host *host = pci_get_drvdata(pdev);
 	adapter_t *adapter = (adapter_t *)host->hostdata;
-	char	buf[12] = { 0 };
 
 	scsi_remove_host(host);
 
@@ -4982,6 +4989,8 @@ megaraid_remove_one(struct pci_dev *pdev
 
 #ifdef CONFIG_PROC_FS
 	if (adapter->controller_proc_dir_entry) {
+		char buf[12];
+
 		remove_proc_entry("stat", adapter->controller_proc_dir_entry);
 		remove_proc_entry("config",
 				adapter->controller_proc_dir_entry);
diff -puN drivers/scsi/megaraid.h~megaraid-build-with-proc_fs=n drivers/scsi/megaraid.h
--- a/drivers/scsi/megaraid.h~megaraid-build-with-proc_fs=n
+++ a/drivers/scsi/megaraid.h
@@ -1002,7 +1002,9 @@ static int megaraid_reset(Scsi_Cmnd *);
 static int megaraid_abort_and_reset(adapter_t *, Scsi_Cmnd *, int);
 static int megaraid_biosparam(struct scsi_device *, struct block_device *,
 		sector_t, int []);
+#ifdef CONFIG_PROC_FS
 static int mega_print_inquiry(char *, char *);
+#endif
 
 static int mega_build_sglist (adapter_t *adapter, scb_t *scb,
 			      u32 *buffer, u32 *length);
@@ -1040,10 +1042,9 @@ static int proc_rdrv_20(char *, char **,
 static int proc_rdrv_30(char *, char **, off_t, int, int *, void *);
 static int proc_rdrv_40(char *, char **, off_t, int, int *, void *);
 static int proc_rdrv(adapter_t *, char *, int, int);
-#endif
-
 static int mega_adapinq(adapter_t *, dma_addr_t);
 static int mega_internal_dev_inquiry(adapter_t *, u8, u8, dma_addr_t);
+#endif
 
 static int mega_support_ext_cdb(adapter_t *);
 static mega_passthru* mega_prepare_passthru(adapter_t *, scb_t *,
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

fix-kernel-doc-warnings-in-2620-rc1.patch
add-a-new-section-to-codingstyle-promoting-include-linux-kernelh.patch
handle-slob-with-sparsemen.patch
git-acpi.patch
git-alsa.patch
cpufreq-select-consistently-re-2619-rc5-mm1.patch
git-gfs2-nmw.patch
git-mtd.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
megaraid-build-with-proc_fs=n.patch
reiser4-use-null-for-pointers.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
profile_likely-export-do_check_likely.patch

