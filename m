From: akpm@osdl.org
Subject: - ipmi-fix-proc_fs=n-warnings.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:17:54 -0800
Message-ID: <200612072317.kB7NHsaC030976@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53950 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163886AbWLGXSL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:18:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, minyard@acm.org, mm-commits@vger.kernel.org


The patch titled
     IPMI: fix PROC_FS=n warnings
has been removed from the -mm tree.  Its filename was
     ipmi-fix-proc_fs=n-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: IPMI: fix PROC_FS=n warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build warnings for PROC_FS=n.

drivers/char/ipmi/ipmi_poweroff.c:707: warning: label 'out_err' defined but not used

drivers/char/ipmi/ipmi_msghandler.c:1774: warning: 'ipmb_file_read_proc' defined but not used
drivers/char/ipmi/ipmi_msghandler.c:1790: warning: 'version_file_read_proc' defined but not used
drivers/char/ipmi/ipmi_msghandler.c:1801: warning: 'stat_file_read_proc' defined but not used

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Corey Minyard <minyard@acm.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/ipmi/ipmi_msghandler.c |    2 ++
 drivers/char/ipmi/ipmi_poweroff.c   |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/char/ipmi/ipmi_msghandler.c~ipmi-fix-proc_fs=n-warnings drivers/char/ipmi/ipmi_msghandler.c
--- a/drivers/char/ipmi/ipmi_msghandler.c~ipmi-fix-proc_fs=n-warnings
+++ a/drivers/char/ipmi/ipmi_msghandler.c
@@ -1769,6 +1769,7 @@ int ipmi_request_supply_msgs(ipmi_user_t
 			      -1, 0);
 }
 
+#ifdef CONFIG_PROC_FS
 static int ipmb_file_read_proc(char *page, char **start, off_t off,
 			       int count, int *eof, void *data)
 {
@@ -1857,6 +1858,7 @@ static int stat_file_read_proc(char *pag
 
 	return (out - ((char *) page));
 }
+#endif /* CONFIG_PROC_FS */
 
 int ipmi_smi_add_proc_entry(ipmi_smi_t smi, char *name,
 			    read_proc_t *read_proc, write_proc_t *write_proc,
diff -puN drivers/char/ipmi/ipmi_poweroff.c~ipmi-fix-proc_fs=n-warnings drivers/char/ipmi/ipmi_poweroff.c
--- a/drivers/char/ipmi/ipmi_poweroff.c~ipmi-fix-proc_fs=n-warnings
+++ a/drivers/char/ipmi/ipmi_poweroff.c
@@ -702,9 +702,9 @@ static int ipmi_poweroff_init (void)
 		printk(KERN_ERR PFX "Unable to register SMI watcher: %d\n", rv);
 		goto out_err;
 	}
-#endif
 
  out_err:
+#endif
 	return rv;
 }
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
git-alsa.patch
cpufreq-select-consistently-re-2619-rc5-mm1.patch
git-ieee1394.patch
git-input.patch
git-mtd.patch
mtd-esb2rom-uses-pci.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
generic-bug-implementation-handle-bug=n.patch
reiser4-use-null-for-pointers.patch
visws-sgivwfb-is-module-needs-exports.patch
linux-fbdev-devel-is-subscribers-only.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
kvm-fix-null-and-c99-init-sparse-warnings.patch
profile_likely-export-do_check_likely.patch

