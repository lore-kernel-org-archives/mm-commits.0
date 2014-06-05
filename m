From: akpm@linux-foundation.org
Subject: [merged] jump_label-expose-the-reference-count.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:52:21 -0700
Message-ID: <5390ca75.lO+ZUS/L3EpHnjaa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56333 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbaFETwW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:52:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, tytso@mit.edu, riel@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com, oleg@redhat.com, mhocko@suse.cz, jack@suse.cz, hughd@google.com, hannes@cmpxchg.org, dave.hansen@intel.com, mgorman@suse.de

Subject: [merged] jump_label-expose-the-reference-count.patch removed from -mm tree
To: mgorman@suse.de,dave.hansen@intel.com,hannes@cmpxchg.org,hughd@google.com,jack@suse.cz,mhocko@suse.cz,oleg@redhat.com,paulmck@linux.vnet.ibm.com,peterz@infradead.org,riel@redhat.com,tytso@mit.edu,vbabka@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:52:21 -0700


The patch titled
     Subject: include/linux/jump_label.h: expose the reference count
has been removed from the -mm tree.  Its filename was
     jump_label-expose-the-reference-count.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: include/linux/jump_label.h: expose the reference count

This patch exposes the jump_label reference count in preparation for the
next patch.  cpusets cares about both the jump_label being enabled and how
many users of the cpusets there currently are.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/jump_label.h |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff -puN include/linux/jump_label.h~jump_label-expose-the-reference-count include/linux/jump_label.h
--- a/include/linux/jump_label.h~jump_label-expose-the-reference-count
+++ a/include/linux/jump_label.h
@@ -69,6 +69,10 @@ struct static_key {
 
 # include <asm/jump_label.h>
 # define HAVE_JUMP_LABEL
+#else
+struct static_key {
+	atomic_t enabled;
+};
 #endif	/* CC_HAVE_ASM_GOTO && CONFIG_JUMP_LABEL */
 
 enum jump_label_type {
@@ -79,6 +83,12 @@ enum jump_label_type {
 struct module;
 
 #include <linux/atomic.h>
+
+static inline int static_key_count(struct static_key *key)
+{
+	return atomic_read(&key->enabled);
+}
+
 #ifdef HAVE_JUMP_LABEL
 
 #define JUMP_LABEL_TYPE_FALSE_BRANCH	0UL
@@ -134,10 +144,6 @@ extern void jump_label_apply_nops(struct
 
 #else  /* !HAVE_JUMP_LABEL */
 
-struct static_key {
-	atomic_t enabled;
-};
-
 static __always_inline void jump_label_init(void)
 {
 	static_key_initialized = true;
@@ -145,14 +151,14 @@ static __always_inline void jump_label_i
 
 static __always_inline bool static_key_false(struct static_key *key)
 {
-	if (unlikely(atomic_read(&key->enabled) > 0))
+	if (unlikely(static_key_count(key) > 0))
 		return true;
 	return false;
 }
 
 static __always_inline bool static_key_true(struct static_key *key)
 {
-	if (likely(atomic_read(&key->enabled) > 0))
+	if (likely(static_key_count(key) > 0))
 		return true;
 	return false;
 }
@@ -194,7 +200,7 @@ static inline int jump_label_apply_nops(
 
 static inline bool static_key_enabled(struct static_key *key)
 {
-	return (atomic_read(&key->enabled) > 0);
+	return static_key_count(key) > 0;
 }
 
 #endif	/* _LINUX_JUMP_LABEL_H */
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-v5.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
linux-next.patch

