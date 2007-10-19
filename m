From: akpm@linux-foundation.org
Subject: - linux-kernel-markers-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:35:17 -0700
Message-ID: <200710190435.l9J4ZHKk015379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43801 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752066AbXJSEfu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:35:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fche@redhat.com, hch@infradead.org, mathieu.desnoyers@polymtl.ca, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     linux-kernel-markers-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     linux-kernel-markers-checkpatch-fixes.patch

This patch was dropped because it was folded into linux-kernel-markers.patch

------------------------------------------------------
Subject: linux-kernel-markers-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

Cc: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/marker.h |    2 +-
 kernel/marker.c        |    4 ++--
 kernel/module.c        |    3 ++-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff -puN include/linux/marker.h~linux-kernel-markers-checkpatch-fixes include/linux/marker.h
--- a/include/linux/marker.h~linux-kernel-markers-checkpatch-fixes
+++ a/include/linux/marker.h
@@ -61,7 +61,7 @@ struct __mark_marker {
 		__attribute__((section("__markers"))) =			\
 		{ __mstrtab_name_##name, __mstrtab_format_##name,	\
 		0, __mark_empty_function, NULL };			\
-		asm volatile ( "" : : "i" (&__mark_##name));		\
+		asm volatile("" : : "i" (&__mark_##name));		\
 		__mark_check_format(format, ## args);			\
 		if (unlikely(__mark_##name.state)) {			\
 			preempt_disable();				\
diff -puN kernel/marker.c~linux-kernel-markers-checkpatch-fixes kernel/marker.c
--- a/kernel/marker.c~linux-kernel-markers-checkpatch-fixes
+++ a/kernel/marker.c
@@ -435,7 +435,7 @@ EXPORT_SYMBOL_GPL(marker_probe_unregiste
  */
 int marker_arm(const char *name)
 {
-	struct marker_entry * entry;
+	struct marker_entry *entry;
 	int ret = 0, need_update = 0;
 
 	mutex_lock(&markers_mutex);
@@ -468,7 +468,7 @@ EXPORT_SYMBOL_GPL(marker_arm);
  */
 int marker_disarm(const char *name)
 {
-	struct marker_entry * entry;
+	struct marker_entry *entry;
 	int ret = 0, need_update = 0;
 
 	mutex_lock(&markers_mutex);
diff -puN kernel/module.c~linux-kernel-markers-checkpatch-fixes kernel/module.c
--- a/kernel/module.c~linux-kernel-markers-checkpatch-fixes
+++ a/kernel/module.c
@@ -1942,7 +1942,8 @@ static struct module *load_module(void _
 	}
 #endif
 	markersindex = find_sec(hdr, sechdrs, secstrings, "__markers");
- 	markersstringsindex = find_sec(hdr, sechdrs, secstrings, "__markers_strings");
+ 	markersstringsindex = find_sec(hdr, sechdrs, secstrings,
+					"__markers_strings");
 
 	/* Now do relocations. */
 	for (i = 1; i < hdr->e_shnum; i++) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
console-keyboard-events-and-accessibility.patch
add-kernel-notifierc.patch
console-events-and-accessibility.patch
fix-random-hard-freeze-with-avm-cards-using-b1dma.patch
jbd-config_jbd_debug-cannot-create-proc-entry.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
add-containerstats-v3.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
lockdep-fix-mismatched-lockdep_depth-curr_chain_hash-checkpatch-fixes.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids.patch
pid-namespaces-changes-to-show-virtual-ids-to-user.patch
cpuset-sched_load_balance-flag.patch
cpusets-decrustify-cpuset-mask-update-code.patch
fix-cpusets-update_cpumask.patch
remove-bits_to_type-macro.patch
use-helpers-to-obtain-task-pid-in-printks.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified.patch
ipc-integrate-ipc_checkid-into-ipc_lock.patch
hook-up-group-scheduler-with-control-groups.patch
linux-kernel-markers.patch
linux-kernel-markers-checkpatch-fixes.patch
linux-kernel-markers-samples-checkpatch-fixes.patch
uninline-forkc-exitc-checkpatch-fixes.patch
