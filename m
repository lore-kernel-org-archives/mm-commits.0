From: akpm@linux-foundation.org
Subject: + ipmi-remove-write_proc-code.patch added to -mm tree
Date: Mon, 14 Apr 2008 23:29:53 -0700
Message-ID: <200804150629.m3F6Trwg014753@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56114 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751336AbYDOG36 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 02:29:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, minyard@acm.org


The patch titled
     ipmi: remove ->write_proc code
has been added to the -mm tree.  Its filename is
     ipmi-remove-write_proc-code.patch

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
Subject: ipmi: remove ->write_proc code
From: Alexey Dobriyan <adobriyan@gmail.com>

IPMI code theoretically allows ->write_proc users, but nobody uses this thus
far.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Corey Minyard <minyard@acm.org>
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

fbdev-fix-proc-fb-oops-after-module-removal.patch
v4l-fix-concurrent-read-from-proc-videocodecs.patch
tags-add-menuconfig-symbols-as-well.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
remove-the-macro-get_personality.patch
nv-drop-useless-module-ifdefs.patch
nv-drop-useless-config_pci-checks.patch
nv-fix-sparse-noise.patch
ipmi-remove-write_proc-code.patch
procfs-mem-permission-cleanup.patch
proc-simplify-locking-in-remove_proc_entry.patch
proc-less-special-case-in-xlate-code.patch
proc-drop-several-pde-valid-invalid-checks.patch
proc-remove-proc_bus.patch
proc-remove-proc_root_fs.patch
proc-remove-proc_root_driver.patch
proc-remove-proc_root-from-drivers.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

