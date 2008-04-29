From: akpm@linux-foundation.org
Subject: + drivers-base-topologyc-add-conditionals-around-show_cpumap.patch added to -mm tree
Date: Mon, 28 Apr 2008 23:24:10 -0700
Message-ID: <200804290624.m3T6OA7k005115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752586AbYD2GZC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 02:25:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu, travis@sgi.com


The patch titled
     drivers/base/topology.c: add conditionals around show_cpumap()
has been added to the -mm tree.  Its filename is
     drivers-base-topologyc-add-conditionals-around-show_cpumap.patch

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
Subject: drivers/base/topology.c: add conditionals around show_cpumap()
From: Andrew Morton <akpm@linux-foundation.org>

drivers/base/topology.c:44: warning: 'show_cpumap' defined but not used

Cc: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/topology.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/base/topology.c~drivers-base-topologyc-add-conditionals-around-show_cpumap drivers/base/topology.c
--- a/drivers/base/topology.c~drivers-base-topologyc-add-conditionals-around-show_cpumap
+++ a/drivers/base/topology.c
@@ -40,6 +40,7 @@ static ssize_t show_##name(struct sys_de
 	return sprintf(buf, "%d\n", topology_##name(cpu));	\
 }
 
+#if defined(topology_thread_siblings) || defined(topology_core_siblings)
 static ssize_t show_cpumap(int type, cpumask_t *mask, char *buf)
 {
 	ptrdiff_t len = PTR_ALIGN(buf + PAGE_SIZE - 1, PAGE_SIZE) - buf;
@@ -54,6 +55,7 @@ static ssize_t show_cpumap(int type, cpu
 	}
 	return n;
 }
+#endif
 
 #define define_siblings_show_map(name)					\
 static inline ssize_t show_##name(struct sys_device *dev, char *buf)	\
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
drivers-base-topologyc-add-conditionals-around-show_cpumap.patch

