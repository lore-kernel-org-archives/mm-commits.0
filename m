From: akpm@linux-foundation.org
Subject: - ipmi-remove-write_proc-code.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:44:59 -0700
Message-ID: <200804300544.m3U5ixfq029458@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40916 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755182AbYD3Fpd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:45:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, minyard@acm.org, mm-commits@vger.kernel.org


The patch titled
     ipmi: remove ->write_proc code
has been removed from the -mm tree.  Its filename was
     ipmi-remove-write_proc-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipmi: remove ->write_proc code
From: Alexey Dobriyan <adobriyan@gmail.com>

IPMI code theoretically allows ->write_proc users, but nobody uses this thus
far.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Corey Minyard <minyard@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_msghandler.c |    9 ++++-----
 drivers/char/ipmi/ipmi_si_intf.c    |    6 +++---
 include/linux/ipmi_smi.h            |    2 +-
 3 files changed, 8 insertions(+), 9 deletions(-)

diff -puN drivers/char/ipmi/ipmi_msghandler.c~ipmi-remove-write_proc-code drivers/char/ipmi/ipmi_msghandler.c
--- a/drivers/char/ipmi/ipmi_msghandler.c~ipmi-remove-write_proc-code
+++ a/drivers/char/ipmi/ipmi_msghandler.c
@@ -1941,7 +1941,7 @@ static int stat_file_read_proc(char *pag
 #endif /* CONFIG_PROC_FS */
 
 int ipmi_smi_add_proc_entry(ipmi_smi_t smi, char *name,
-			    read_proc_t *read_proc, write_proc_t *write_proc,
+			    read_proc_t *read_proc,
 			    void *data, struct module *owner)
 {
 	int                    rv = 0;
@@ -1968,7 +1968,6 @@ int ipmi_smi_add_proc_entry(ipmi_smi_t s
 	} else {
 		file->data = data;
 		file->read_proc = read_proc;
-		file->write_proc = write_proc;
 		file->owner = owner;
 
 		mutex_lock(&smi->proc_entry_lock);
@@ -1997,17 +1996,17 @@ static int add_proc_entries(ipmi_smi_t s
 
 	if (rv == 0)
 		rv = ipmi_smi_add_proc_entry(smi, "stats",
-					     stat_file_read_proc, NULL,
+					     stat_file_read_proc,
 					     smi, THIS_MODULE);
 
 	if (rv == 0)
 		rv = ipmi_smi_add_proc_entry(smi, "ipmb",
-					     ipmb_file_read_proc, NULL,
+					     ipmb_file_read_proc,
 					     smi, THIS_MODULE);
 
 	if (rv == 0)
 		rv = ipmi_smi_add_proc_entry(smi, "version",
-					     version_file_read_proc, NULL,
+					     version_file_read_proc,
 					     smi, THIS_MODULE);
 #endif /* CONFIG_PROC_FS */
 
diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-remove-write_proc-code drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-remove-write_proc-code
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -2892,7 +2892,7 @@ static int try_smi_init(struct smi_info 
 	}
 
 	rv = ipmi_smi_add_proc_entry(new_smi->intf, "type",
-				     type_file_read_proc, NULL,
+				     type_file_read_proc,
 				     new_smi, THIS_MODULE);
 	if (rv) {
 		printk(KERN_ERR
@@ -2902,7 +2902,7 @@ static int try_smi_init(struct smi_info 
 	}
 
 	rv = ipmi_smi_add_proc_entry(new_smi->intf, "si_stats",
-				     stat_file_read_proc, NULL,
+				     stat_file_read_proc,
 				     new_smi, THIS_MODULE);
 	if (rv) {
 		printk(KERN_ERR
@@ -2912,7 +2912,7 @@ static int try_smi_init(struct smi_info 
 	}
 
 	rv = ipmi_smi_add_proc_entry(new_smi->intf, "params",
-				     param_read_proc, NULL,
+				     param_read_proc,
 				     new_smi, THIS_MODULE);
 	if (rv) {
 		printk(KERN_ERR
diff -puN include/linux/ipmi_smi.h~ipmi-remove-write_proc-code include/linux/ipmi_smi.h
--- a/include/linux/ipmi_smi.h~ipmi-remove-write_proc-code
+++ a/include/linux/ipmi_smi.h
@@ -229,7 +229,7 @@ static inline void ipmi_free_smi_msg(str
    directory for this interface.  Note that the entry will
    automatically be dstroyed when the interface is destroyed. */
 int ipmi_smi_add_proc_entry(ipmi_smi_t smi, char *name,
-			    read_proc_t *read_proc, write_proc_t *write_proc,
+			    read_proc_t *read_proc,
 			    void *data, struct module *owner);
 
 #endif /* __LINUX_IPMI_SMI_H */
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
drivers-use-non-racy-method-for-proc-entries-creation-2-rio.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
git-xfs.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

