From: akpm@linux-foundation.org
Subject: + linux-kernel-markers-support-multiple-probes-update.patch added to -mm tree
Date: Tue, 04 Dec 2007 12:40:12 -0800
Message-ID: <200712042040.lB4KeC9j004025@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42718 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754170AbXLDUkV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 15:40:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca


The patch titled
     linux-kernel-markers-support-multiple-probes update
has been added to the -mm tree.  Its filename is
     linux-kernel-markers-support-multiple-probes-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: linux-kernel-markers-support-multiple-probes update
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

- Add comments requested by Andrew.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/marker.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN kernel/marker.c~linux-kernel-markers-support-multiple-probes-update kernel/marker.c
--- a/kernel/marker.c~linux-kernel-markers-support-multiple-probes-update
+++ a/kernel/marker.c
@@ -49,6 +49,7 @@ static DEFINE_MUTEX(markers_mutex);
  * between two consecutive operation (add or remove) on a given marker.  It is
  * also used to delay the free of multiple probes array until a quiescent state
  * is reached.
+ * marker entries modifications are protected by the markers_mutex.
  */
 struct marker_entry {
 	struct hlist_node hlist;
@@ -102,6 +103,11 @@ void marker_probe_cb(const struct marker
 	va_list args;
 	char ptype;
 
+	/*
+	 * disabling preemption to make sure the teardown of the callbacks can
+	 * be done correctly when they are in modules and they insure RCU read
+	 * coherency.
+	 */
 	preempt_disable();
 	ptype = ACCESS_ONCE(mdata->ptype);
 	if (likely(!ptype)) {
@@ -196,7 +202,7 @@ static void free_old_closure(struct rcu_
 	entry->rcu_pending = 0;
 }
 
-static inline void debug_print_probes(struct marker_entry *entry)
+static void debug_print_probes(struct marker_entry *entry)
 {
 	int i;
 
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

git-x86.patch
add-cmpxchg_local-to-asm-generic-for-per-cpu-atomic-operations.patch
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
add-cmpxchg_local-to-sparc-move-__cmpxchg-to-systemh.patch
add-cmpxchg_local-to-sparc64.patch
add-cmpxchg_local-to-v850.patch
add-cmpxchg_local-to-xtensa.patch
modules-handle-symbols-that-have-a-zero-value.patch
linux-kernel-markers-support-multiple-probes.patch
linux-kernel-markers-support-multiple-probes-update.patch
linux-kernel-markers-create-modpost-file.patch
