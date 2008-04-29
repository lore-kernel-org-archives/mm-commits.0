From: akpm@linux-foundation.org
Subject: - relayfs-support-larger-relay-buffer-take-3-cleanup.patch removed from -mm tree
Date: Mon, 28 Apr 2008 23:07:26 -0700
Message-ID: <200804290607.m3T67QQW004478@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52325 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757355AbYD2GIa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 02:08:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dwilder@us.ibm.com, mhiramat@redhat.com, zanussi@comcast.net, mm-commits@vger.kernel.org


The patch titled
     relayfs-support-larger-relay-buffer-take-3-cleanup
has been removed from the -mm tree.  Its filename was
     relayfs-support-larger-relay-buffer-take-3-cleanup.patch

This patch was dropped because it was folded into relayfs-support-larger-relay-buffer-take-3.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: relayfs-support-larger-relay-buffer-take-3-cleanup
From: Andrew Morton <akpm@linux-foundation.org>

Cc: David Wilder <dwilder@us.ibm.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Tom Zanussi <zanussi@comcast.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/relay.c~relayfs-support-larger-relay-buffer-take-3-cleanup kernel/relay.c
--- a/kernel/relay.c~relayfs-support-larger-relay-buffer-take-3-cleanup
+++ a/kernel/relay.c
@@ -71,14 +71,14 @@ static struct vm_operations_struct relay
 static struct page **relay_alloc_page_array(unsigned int n_pages)
 {
 	struct page **array;
-	unsigned int pa_size = n_pages * sizeof(struct page *);
+	size_t pa_size = n_pages * sizeof(struct page *);
 
 	if (pa_size > PAGE_SIZE) {
 		array = vmalloc(pa_size);
 		if (array)
 			memset(array, 0, pa_size);
 	} else {
-		array = kcalloc(n_pages, sizeof(struct page *), GFP_KERNEL);
+		array = kzalloc(pa_size, GFP_KERNEL);
 	}
 	return array;
 }
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
proc-switch-to-proc_create.patch
edd-add-default-mode-config_edd_off=n-override-with-edd=onoff.patch
idr-create-idr_layer_cache-at-boot-time.patch
edac-add-e752x-parameter-for-sysbus_parity-selection.patch
ncpfs-use-get-put_unaligned_-helpers.patch
relayfs-support-larger-relay-buffer-take-3.patch
relayfs-support-larger-relay-buffer-take-3-cleanup.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

