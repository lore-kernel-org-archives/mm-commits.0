From: akpm@linux-foundation.org
Subject: + pcmcia-kill-in_card_services.patch added to -mm tree
Date: Tue, 06 May 2008 11:36:23 -0700
Message-ID: <200805061836.m46IaNIU021201@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48861 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752966AbYEFSgg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 14:36:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org


The patch titled
     pcmcia: kill IN_CARD_SERVICES
has been added to the -mm tree.  Its filename is
     pcmcia-kill-in_card_services.patch

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
Subject: pcmcia: kill IN_CARD_SERVICES
From: Adrian Bunk <bunk@kernel.org>

IN_CARD_SERVICES was #define'd but not used, so let's remove it.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/cardbus.c         |    1 -
 drivers/pcmcia/cs.c              |    1 -
 drivers/pcmcia/ds.c              |    1 -
 drivers/pcmcia/pcmcia_ioctl.c    |    1 -
 drivers/pcmcia/pcmcia_resource.c |    1 -
 drivers/pcmcia/socket_sysfs.c    |    1 -
 6 files changed, 6 deletions(-)

diff -puN drivers/pcmcia/cardbus.c~pcmcia-kill-in_card_services drivers/pcmcia/cardbus.c
--- a/drivers/pcmcia/cardbus.c~pcmcia-kill-in_card_services
+++ a/drivers/pcmcia/cardbus.c
@@ -30,7 +30,6 @@
 #include <asm/irq.h>
 #include <asm/io.h>
 
-#define IN_CARD_SERVICES
 #include <pcmcia/cs_types.h>
 #include <pcmcia/ss.h>
 #include <pcmcia/cs.h>
diff -puN drivers/pcmcia/cs.c~pcmcia-kill-in_card_services drivers/pcmcia/cs.c
--- a/drivers/pcmcia/cs.c~pcmcia-kill-in_card_services
+++ a/drivers/pcmcia/cs.c
@@ -32,7 +32,6 @@
 #include <asm/system.h>
 #include <asm/irq.h>
 
-#define IN_CARD_SERVICES
 #include <pcmcia/cs_types.h>
 #include <pcmcia/ss.h>
 #include <pcmcia/cs.h>
diff -puN drivers/pcmcia/ds.c~pcmcia-kill-in_card_services drivers/pcmcia/ds.c
--- a/drivers/pcmcia/ds.c~pcmcia-kill-in_card_services
+++ a/drivers/pcmcia/ds.c
@@ -25,7 +25,6 @@
 #include <linux/kref.h>
 #include <linux/dma-mapping.h>
 
-#define IN_CARD_SERVICES
 #include <pcmcia/cs_types.h>
 #include <pcmcia/cs.h>
 #include <pcmcia/cistpl.h>
diff -puN drivers/pcmcia/pcmcia_ioctl.c~pcmcia-kill-in_card_services drivers/pcmcia/pcmcia_ioctl.c
--- a/drivers/pcmcia/pcmcia_ioctl.c~pcmcia-kill-in_card_services
+++ a/drivers/pcmcia/pcmcia_ioctl.c
@@ -29,7 +29,6 @@
 #include <linux/pci.h>
 #include <linux/workqueue.h>
 
-#define IN_CARD_SERVICES
 #include <pcmcia/cs_types.h>
 #include <pcmcia/cs.h>
 #include <pcmcia/cistpl.h>
diff -puN drivers/pcmcia/pcmcia_resource.c~pcmcia-kill-in_card_services drivers/pcmcia/pcmcia_resource.c
--- a/drivers/pcmcia/pcmcia_resource.c~pcmcia-kill-in_card_services
+++ a/drivers/pcmcia/pcmcia_resource.c
@@ -21,7 +21,6 @@
 #include <linux/pci.h>
 #include <linux/device.h>
 
-#define IN_CARD_SERVICES
 #include <pcmcia/cs_types.h>
 #include <pcmcia/ss.h>
 #include <pcmcia/cs.h>
diff -puN drivers/pcmcia/socket_sysfs.c~pcmcia-kill-in_card_services drivers/pcmcia/socket_sysfs.c
--- a/drivers/pcmcia/socket_sysfs.c~pcmcia-kill-in_card_services
+++ a/drivers/pcmcia/socket_sysfs.c
@@ -27,7 +27,6 @@
 #include <asm/system.h>
 #include <asm/irq.h>
 
-#define IN_CARD_SERVICES
 #include <pcmcia/cs_types.h>
 #include <pcmcia/ss.h>
 #include <pcmcia/cs.h>
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
md-make-dm_dirty_log_initexit-static.patch
drm-make-drm_minors_cleanup-static.patch
git-udf.patch
nfs-make-nfs4_drop_state_owner-static.patch
show_schedstat-fix-memleak.patch
if-0-ses_match_host.patch
git-watchdog.patch
xen-drivers-xen-balloonc-make-a-function-static.patch
reiser4.patch
remove-is_tty.patch
make-cgroup_seqfile_release-static.patch
make-kprobe_blacklist-static.patch
make-pnp_add_card_id-static.patch
mfd-sm501c-if-0-unused-functions.patch
pcmcia-kill-in_card_services.patch
video-sis-remove-compat-code.patch
make-struct-mpt_proc_root_dir-static.patch
make-parport_cs_release-static.patch
parport-sharec-proper-externs.patch
remove-include-asm-h8300-keyboardh.patch
proper-spawn_ksoftirqd-prototype.patch
proper-pidhashmap_init-prototypes.patch
mm-migratec-should-include-linux-syscallsh.patch
make-mm-sparsec-make-a-function-static.patch
mm-allocpercpuc-make-4-functions-static.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
minix-remove-no_truncate-code.patch
remove-the-v850-port.patch
mm-vmstatc-proper-externs.patch
mm-hugetlbc-fix-duplicate-variable.patch
drivers-char-rtcc-make-2-functions-static.patch
make-init-do_mountsc-root_device_name-static.patch
init-do_mountsc-should-include-linux-initrdh.patch
proper-prototype-for-acpi_processor_tstate_has_changed.patch
if-0-hpet_unregister.patch
tpm_biosc-make-2-structs-static.patch
proper-extern-for-mwave_s_mdd.patch
xtensa-remove-the-nonexisting-highmem-support.patch
serial-8250_gscc-add-module_license.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
unexport-proc_clear_tty.patch
unexport-uts_sem.patch

