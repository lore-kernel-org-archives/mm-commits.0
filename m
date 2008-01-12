From: akpm@linux-foundation.org
Subject: + driver-core-build-with-sysfs=n.patch added to -mm tree
Date: Fri, 11 Jan 2008 17:46:01 -0800
Message-ID: <200801120146.m0C1k1JD008437@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36494 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756709AbYALBqS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jan 2008 20:46:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, greg@kroah.com, kay.sievers@vrfy.org, sam@ravnborg.org


The patch titled
     driver core: build with SYSFS=n
has been added to the -mm tree.  Its filename is
     driver-core-build-with-sysfs=n.patch

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
Subject: driver core: build with SYSFS=n
From: Randy Dunlap <randy.dunlap@oracle.com>

When SYSFS=n and MODULES=y, build ends with:

linux-2.6.24-rc6-mm1/drivers/base/module.c: In function 'module_add_driver':
linux-2.6.24-rc6-mm1/drivers/base/module.c:49: error: 'module_kset' undeclared (first use in this function)
make[3]: *** [drivers/base/module.o] Error 1

Below is one possible fix.
Build-tested with all 4 config combinations of SYSFS & MODULES.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/Makefile |    2 ++
 drivers/base/base.h   |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/base/Makefile~driver-core-build-with-sysfs=n drivers/base/Makefile
--- a/drivers/base/Makefile~driver-core-build-with-sysfs=n
+++ a/drivers/base/Makefile
@@ -11,7 +11,9 @@ obj-$(CONFIG_FW_LOADER)	+= firmware_clas
 obj-$(CONFIG_NUMA)	+= node.o
 obj-$(CONFIG_MEMORY_HOTPLUG_SPARSE) += memory.o
 obj-$(CONFIG_SMP)	+= topology.o
+ifeq ($(CONFIG_SYSFS),y)
 obj-$(CONFIG_MODULES)	+= module.o
+endif
 obj-$(CONFIG_SYS_HYPERVISOR) += hypervisor.o
 
 ifeq ($(CONFIG_DEBUG_DRIVER),y)
diff -puN drivers/base/base.h~driver-core-build-with-sysfs=n drivers/base/base.h
--- a/drivers/base/base.h~driver-core-build-with-sysfs=n
+++ a/drivers/base/base.h
@@ -79,7 +79,7 @@ extern char *make_class_name(const char 
 
 extern int devres_release_all(struct device *dev);
 
-#ifdef CONFIG_MODULES
+#if defined(CONFIG_MODULES) && defined(CONFIG_SYSFS)
 extern void module_add_driver(struct module *mod, struct device_driver *drv);
 extern void module_remove_driver(struct device_driver *drv);
 #else
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

scsi-qla2xxx-qla_osc-section-fix.patch
cciss-section-mismatch.patch
advansys-fix-section-mismatch-warning.patch
uvesafb-fix-section-mismatch-warnings.patch
driver-core-build-with-sysfs=n.patch
git-dvb.patch
dvb-av7110-fix-section-mismatch.patch
git-kbuild.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
pcmcia-include-bad-cis-filename-in-error-message.patch
git-scsi-misc.patch
megaraid-fix-section-mismatch.patch
git-unionfs.patch
hostap-section-mismatch-warning.patch
git-ipwireless_cs.patch
git-x86.patch
x86-discover_ebda-section-mismatch.patch
register_cpu-__devinit-or-__cpuinit.patch
cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
dio-fix-kernel-doc-notation.patch
tpm-infineon-section-mismatch.patch
tdfxfb-fix-section-mismatch-warnings.patch
uvesafb-small-cleanups.patch
documentation-move-dnotifytxt-to-filesystems.patch
documentation-move-sharedsubtreestxt-to-filesystems.patch
documentation-create-new-scheduler-subdirectory.patch
reporting-bugs-cc-the-mailing-list-too.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch
