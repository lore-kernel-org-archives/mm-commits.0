From: akpm@linux-foundation.org
Subject: - proc-remove-proc_bus-fix.patch removed from -mm tree
Date: Tue, 29 Apr 2008 00:13:19 -0700
Message-ID: <200804290713.m3T7DJa8006790@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754269AbYD2HNW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 03:13:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     proc-remove-proc_bus-fix
has been removed from the -mm tree.  Its filename was
     proc-remove-proc_bus-fix.patch

This patch was dropped because it was folded into proc-remove-proc_bus.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc-remove-proc_bus-fix
From: Andrew Morton <akpm@linux-foundation.org>

pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch is -mm only :(

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/pcmcia_ioctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/pcmcia/pcmcia_ioctl.c~proc-remove-proc_bus-fix drivers/pcmcia/pcmcia_ioctl.c
--- a/drivers/pcmcia/pcmcia_ioctl.c~proc-remove-proc_bus-fix
+++ a/drivers/pcmcia/pcmcia_ioctl.c
@@ -787,7 +787,7 @@ void __init pcmcia_setup_ioctl(void) {
 		major_dev = i;
 
 #ifdef CONFIG_PROC_FS
-	proc_pccard = proc_mkdir("pccard", proc_bus);
+	proc_pccard = proc_mkdir("bus/pccard", NULL);
 	if (proc_pccard)
 		create_proc_read_entry("drivers",0,proc_pccard,proc_read_drivers,NULL);
 #endif
@@ -798,7 +798,7 @@ void __exit pcmcia_cleanup_ioctl(void) {
 #ifdef CONFIG_PROC_FS
 	if (proc_pccard) {
 		remove_proc_entry("drivers", proc_pccard);
-		remove_proc_entry("pccard", proc_bus);
+		remove_proc_entry("bus/pccard", NULL);
 	}
 #endif
 	if (major_dev != -1)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
make-dev-kmem-a-config-option.patch
misc-phantom-add-compat-ioctl.patch
sysrq-add-show-backtrace-on-all-cpus-function.patch
codafs-fix-build-warning.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations.patch
lib-swiotlbc-cleanups.patch
fs-inodec-use-hlist_for_each_entry.patch
ecryptfs-integrate-ecryptfs-device-handle-into-the-module.patch
ecryptfs-make-key-module-subsystem-respect-namespaces.patch
x86-olpc-add-one-laptop-per-child-architecture-support.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
cgroups-implement-device-whitelist-v6.patch
add-a-document-describing-the-resource-counter-abstraction-v2.patch
memcgroup-implement-failcounter-reset.patch
use-vmalloc-for-mem_cgroup-allocation-v3.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies.patch
ipc-use-ipc_buildid-directly-from-ipc_addid.patch
ipc-add-definitions-of-ushort_max-and-others.patch
ipc-sysvsem-refuse-cloneclone_sysvsemclone_newipc.patch
ipmi-run-to-completion-fixes.patch
ipmi-style-fixes-in-the-system-interface-code.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
keys-add-keyctl-function-to-get-a-security-label.patch
procfs-task-exe-symlink.patch
proc-remove-proc_bus.patch
proc-remove-proc_bus-fix.patch
edd-add-default-mode-config_edd_off=n-override-with-edd=onoff.patch
idr-create-idr_layer_cache-at-boot-time.patch
edac-add-e752x-parameter-for-sysbus_parity-selection.patch
ncpfs-use-get-put_unaligned_-helpers.patch
relayfs-support-larger-relay-buffer-take-3.patch

