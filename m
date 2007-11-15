From: akpm@linux-foundation.org
Subject: - linux-kernel-markers-fix-marker-mutex-not-taken-upon-module-load.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:09:58 -0800
Message-ID: <200711152109.lAFL9wsi015503@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35306 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759565AbXKOVRe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:17:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, haveblue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Linux Kernel Markers: fix marker mutex not taken upon module load
has been removed from the -mm tree.  Its filename was
     linux-kernel-markers-fix-marker-mutex-not-taken-upon-module-load.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Linux Kernel Markers: fix marker mutex not taken upon module load
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Upon module load, we must take the markers mutex.  It implies that the marker
mutex must be nested inside the module mutex.

It implies changing the nesting order : now the marker mutex nests inside the
module mutex.  Make the necessary changes to reverse the order in which the
mutexes are taken.

Includes some cleanup from Dave Hansen <haveblue@us.ibm.com>.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/marker.c |   41 +++++++++++++++++------------------------
 1 file changed, 17 insertions(+), 24 deletions(-)

diff -puN kernel/marker.c~linux-kernel-markers-fix-marker-mutex-not-taken-upon-module-load kernel/marker.c
--- a/kernel/marker.c~linux-kernel-markers-fix-marker-mutex-not-taken-upon-module-load
+++ a/kernel/marker.c
@@ -28,7 +28,7 @@ extern struct marker __start___markers[]
 extern struct marker __stop___markers[];
 
 /*
- * module_mutex nests inside markers_mutex. Markers mutex protects the builtin
+ * markers_mutex nests inside module_mutex. Markers mutex protects the builtin
  * and module markers, the hash table and deferred_sync.
  */
 static DEFINE_MUTEX(markers_mutex);
@@ -257,7 +257,6 @@ static void disable_marker(struct marker
  * @refcount: number of references left to the given probe_module (out)
  *
  * Updates the probe callback corresponding to a range of markers.
- * Must be called with markers_mutex held.
  */
 void marker_update_probe_range(struct marker *begin,
 	struct marker *end, struct module *probe_module,
@@ -266,6 +265,7 @@ void marker_update_probe_range(struct ma
 	struct marker *iter;
 	struct marker_entry *mark_entry;
 
+	mutex_lock(&markers_mutex);
 	for (iter = begin; iter < end; iter++) {
 		mark_entry = get_marker(iter->name);
 		if (mark_entry && mark_entry->refcount) {
@@ -281,6 +281,7 @@ void marker_update_probe_range(struct ma
 			disable_marker(iter);
 		}
 	}
+	mutex_unlock(&markers_mutex);
 }
 
 /*
@@ -293,7 +294,6 @@ static void marker_update_probes(struct 
 {
 	int refcount = 0;
 
-	mutex_lock(&markers_mutex);
 	/* Core kernel markers */
 	marker_update_probe_range(__start___markers,
 			__stop___markers, probe_module, &refcount);
@@ -303,7 +303,6 @@ static void marker_update_probes(struct 
 		synchronize_sched();
 		deferred_sync = 0;
 	}
-	mutex_unlock(&markers_mutex);
 }
 
 /**
@@ -320,7 +319,7 @@ int marker_probe_register(const char *na
 			marker_probe_func *probe, void *private)
 {
 	struct marker_entry *entry;
-	int ret = 0, need_update = 0;
+	int ret = 0;
 
 	mutex_lock(&markers_mutex);
 	entry = get_marker(name);
@@ -335,11 +334,11 @@ int marker_probe_register(const char *na
 	ret = add_marker(name, format, probe, private);
 	if (ret)
 		goto end;
-	need_update = 1;
+	mutex_unlock(&markers_mutex);
+	marker_update_probes(NULL);
+	return ret;
 end:
 	mutex_unlock(&markers_mutex);
-	if (need_update)
-		marker_update_probes(NULL);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(marker_probe_register);
@@ -355,7 +354,6 @@ void *marker_probe_unregister(const char
 	struct module *probe_module;
 	struct marker_entry *entry;
 	void *private;
-	int need_update = 0;
 
 	mutex_lock(&markers_mutex);
 	entry = get_marker(name);
@@ -368,11 +366,11 @@ void *marker_probe_unregister(const char
 	probe_module = __module_text_address((unsigned long)entry->probe);
 	private = remove_marker(name);
 	deferred_sync = 1;
-	need_update = 1;
+	mutex_unlock(&markers_mutex);
+	marker_update_probes(probe_module);
+	return private;
 end:
 	mutex_unlock(&markers_mutex);
-	if (need_update)
-		marker_update_probes(probe_module);
 	return private;
 }
 EXPORT_SYMBOL_GPL(marker_probe_unregister);
@@ -392,7 +390,6 @@ void *marker_probe_unregister_private_da
 	struct marker_entry *entry;
 	int found = 0;
 	unsigned int i;
-	int need_update = 0;
 
 	mutex_lock(&markers_mutex);
 	for (i = 0; i < MARKER_TABLE_SIZE; i++) {
@@ -414,11 +411,11 @@ iter_end:
 	probe_module = __module_text_address((unsigned long)entry->probe);
 	private = remove_marker(entry->name);
 	deferred_sync = 1;
-	need_update = 1;
+	mutex_unlock(&markers_mutex);
+	marker_update_probes(probe_module);
+	return private;
 end:
 	mutex_unlock(&markers_mutex);
-	if (need_update)
-		marker_update_probes(probe_module);
 	return private;
 }
 EXPORT_SYMBOL_GPL(marker_probe_unregister_private_data);
@@ -434,7 +431,7 @@ EXPORT_SYMBOL_GPL(marker_probe_unregiste
 int marker_arm(const char *name)
 {
 	struct marker_entry *entry;
-	int ret = 0, need_update = 0;
+	int ret = 0;
 
 	mutex_lock(&markers_mutex);
 	entry = get_marker(name);
@@ -447,11 +444,9 @@ int marker_arm(const char *name)
 	 */
 	if (entry->refcount++)
 		goto end;
-	need_update = 1;
 end:
 	mutex_unlock(&markers_mutex);
-	if (need_update)
-		marker_update_probes(NULL);
+	marker_update_probes(NULL);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(marker_arm);
@@ -467,7 +462,7 @@ EXPORT_SYMBOL_GPL(marker_arm);
 int marker_disarm(const char *name)
 {
 	struct marker_entry *entry;
-	int ret = 0, need_update = 0;
+	int ret = 0;
 
 	mutex_lock(&markers_mutex);
 	entry = get_marker(name);
@@ -486,11 +481,9 @@ int marker_disarm(const char *name)
 		ret = -EPERM;
 		goto end;
 	}
-	need_update = 1;
 end:
 	mutex_unlock(&markers_mutex);
-	if (need_update)
-		marker_update_probes(NULL);
+	marker_update_probes(NULL);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(marker_disarm);
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
add-cmpxchg_local-to-asm-generic-for-per-cpu-atomic-operations.patch
fall-back-on-interrupt-disable-in-cmpxchg8b-on-80386-and-80486.patch
add-cmpxchg64-and-cmpxchg64_local-to-alpha.patch
add-cmpxchg64-and-cmpxchg64_local-to-mips.patch
add-cmpxchg64-and-cmpxchg64_local-to-powerpc.patch
add-cmpxchg64-and-cmpxchg64_local-to-x86_64.patch
add-cmpxchg_local-to-arm.patch
add-cmpxchg_local-to-avr32.patch
add-cmpxchg_local-to-blackfin-replace-__cmpxchg-by-generic-cmpxchg.patch
add-cmpxchg_local-to-cris.patch
add-cmpxchg_local-to-frv.patch
add-cmpxchg_local-to-h8300.patch
add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64.patch
new-cmpxchg_local-optimized-for-up-case-for-m32r.patch
fix-m32r-__xchg.patch
m32r-build-fix-of-arch-m32r-kernel-smpbootc.patch
local_t-m32r-use-architecture-specific-cmpxchg_local.patch
add-cmpxchg_local-to-m86k.patch
add-cmpxchg_local-to-m68knommu.patch
add-cmpxchg_local-to-parisc.patch
add-cmpxchg_local-to-ppc.patch
add-cmpxchg_local-to-s390.patch
add-cmpxchg_local-to-sh-use-generic-cmpxchg-instead-of-cmpxchg_u32.patch
add-cmpxchg_local-to-sh64.patch
add-cmpxchg_local-to-sparc-move-__cmpxchg-to-systemh.patch
add-cmpxchg_local-to-sparc64.patch
add-cmpxchg_local-to-v850.patch
add-cmpxchg_local-to-xtensa.patch
