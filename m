From: akpm@osdl.org
Subject: + fix-warnings-in-kobjecth-with-hotplug=n.patch added to -mm tree
Date: Mon, 18 Dec 2006 16:56:35 -0800
Message-ID: <200612190056.kBJ0uZ8G018852@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37300 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932556AbWLSA4u (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Dec 2006 19:56:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, greg@kroah.com


The patch titled
     fix warnings in kobject.h with HOTPLUG=n
has been added to the -mm tree.  Its filename is
     fix-warnings-in-kobjecth-with-hotplug=n.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix warnings in kobject.h with HOTPLUG=n
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix inline kobject functions to return 0 when CONFIG_HOTPLUG=n.

include/linux/kobject.h: In function 'kobject_uevent':
include/linux/kobject.h:277: warning: no return statement in function returning non-void
include/linux/kobject.h: In function 'kobject_uevent_env':
include/linux/kobject.h:281: warning: no return statement in function returning non-void

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/kobject.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/kobject.h~fix-warnings-in-kobjecth-with-hotplug=n include/linux/kobject.h
--- a/include/linux/kobject.h~fix-warnings-in-kobjecth-with-hotplug=n
+++ a/include/linux/kobject.h
@@ -274,11 +274,12 @@ int add_uevent_var(char **envp, int num_
 			const char *format, ...)
 	__attribute__((format (printf, 7, 8)));
 #else
-static inline int kobject_uevent(struct kobject *kobj, enum kobject_action action) { }
+static inline int kobject_uevent(struct kobject *kobj, enum kobject_action action)
+{ return 0; }
 static inline int kobject_uevent_env(struct kobject *kobj,
 				      enum kobject_action action,
 				      char *envp[])
-{ }
+{ return 0; }
 
 static inline int add_uevent_var(char **envp, int num_envp, int *cur_index,
 				      char *buffer, int buffer_size, int *cur_len, 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

fix-kernel-doc-warnings-in-2620-rc1.patch
add-a-new-section-to-codingstyle-promoting-include-linux-kernelh.patch
fix-warnings-in-kobjecth-with-hotplug=n.patch
git-acpi.patch
git-alsa.patch
cpufreq-select-consistently-re-2619-rc5-mm1.patch
git-gfs2-nmw.patch
git-mtd.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
reiser4-use-null-for-pointers.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
profile_likely-export-do_check_likely.patch

