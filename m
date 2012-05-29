From: akpm@linux-foundation.org
Subject: [folded] memcg-decrement-static-keys-at-real-destroy-time-v6-fix.patch removed from -mm tree
Date: Tue, 29 May 2012 14:48:08 -0700
Message-ID: <20120529214808.DF9A4A037F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:38595 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab2E2VsM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 May 2012 17:48:12 -0400
Received: by lbbgp10 with SMTP id gp10so245513lbb.1
        for <mm-commits@vger.kernel.org>; Tue, 29 May 2012 14:48:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, lizefan@huawei.com, mhocko@suse.cz, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-decrement-static-keys-at-real-destroy-time-v6-fix
has been removed from the -mm tree.  Its filename was
     memcg-decrement-static-keys-at-real-destroy-time-v6-fix.patch

This patch was dropped because it was folded into memcg-decrement-static-keys-at-real-destroy-time.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-decrement-static-keys-at-real-destroy-time-v6-fix

- move enum sock_flag_bits into sock.h

- document enum sock_flag_bits

- convert memcg_proto_active() and memcg_proto_activated() to test_bit()

- redo tcp_update_limit() comment to 80 cols

Cc: Glauber Costa <glommer@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    5 -----
 include/net/sock.h         |   15 +++++++++++++--
 net/ipv4/tcp_memcontrol.c  |   30 +++++++++++++++---------------
 3 files changed, 28 insertions(+), 22 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-decrement-static-keys-at-real-destroy-time-v6-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-decrement-static-keys-at-real-destroy-time-v6-fix
+++ a/include/linux/memcontrol.h
@@ -405,11 +405,6 @@ enum {
 	OVER_LIMIT,
 };
 
-enum sock_flag_bits {
-	MEMCG_SOCK_ACTIVE,
-	MEMCG_SOCK_ACTIVATED,
-};
-
 struct sock;
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
 void sock_update_memcg(struct sock *sk);
diff -puN include/net/sock.h~memcg-decrement-static-keys-at-real-destroy-time-v6-fix include/net/sock.h
--- a/include/net/sock.h~memcg-decrement-static-keys-at-real-destroy-time-v6-fix
+++ a/include/net/sock.h
@@ -46,6 +46,7 @@
 #include <linux/list_nulls.h>
 #include <linux/timer.h>
 #include <linux/cache.h>
+#include <linux/bitops.h>
 #include <linux/lockdep.h>
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>	/* struct sk_buff */
@@ -921,6 +922,16 @@ struct proto {
 #endif
 };
 
+/*
+ * Bits in struct cg_proto.flags
+ */
+enum sock_flag_bits {
+	/* Currently active and new sockets should be assigned to cgroups */
+	MEMCG_SOCK_ACTIVE,
+	/* It was ever activated; we must disarm static keys on destruction */
+	MEMCG_SOCK_ACTIVATED,
+};
+
 struct cg_proto {
 	void			(*enter_memory_pressure)(struct sock *sk);
 	struct res_counter	*memory_allocated;	/* Current allocated memory. */
@@ -945,12 +956,12 @@ extern void proto_unregister(struct prot
 
 static inline bool memcg_proto_active(struct cg_proto *cg_proto)
 {
-	return cg_proto->flags & (1 << MEMCG_SOCK_ACTIVE);
+	return test_bit(MEMCG_SOCK_ACTIVE, &cg_proto->flags);
 }
 
 static inline bool memcg_proto_activated(struct cg_proto *cg_proto)
 {
-	return cg_proto->flags & (1 << MEMCG_SOCK_ACTIVATED);
+	return test_bit(MEMCG_SOCK_ACTIVATED, &cg_proto->flags);
 }
 
 #ifdef SOCK_REFCNT_DEBUG
diff -puN net/ipv4/tcp_memcontrol.c~memcg-decrement-static-keys-at-real-destroy-time-v6-fix net/ipv4/tcp_memcontrol.c
--- a/net/ipv4/tcp_memcontrol.c~memcg-decrement-static-keys-at-real-destroy-time-v6-fix
+++ a/net/ipv4/tcp_memcontrol.c
@@ -108,24 +108,24 @@ static int tcp_update_limit(struct mem_c
 		clear_bit(MEMCG_SOCK_ACTIVE, &cg_proto->flags);
 	else if (val != RESOURCE_MAX) {
 		/*
-		 *  The active bit needs to be written after the static_key update.
-		 *  This is what guarantees that the socket activation function
-		 *  is the last one to run. See sock_update_memcg() for details,
-		 *  and note that we don't mark any socket as belonging to this
-		 *  memcg until that flag is up.
+		 * The active bit needs to be written after the static_key
+		 * update.  This is what guarantees that the socket activation
+		 * function is the last one to run.  See sock_update_memcg() for
+		 * details, and note that we don't mark any socket as belonging
+		 * to this memcg until that flag is up.
 		 *
-		 *  We need to do this, because static_keys will span multiple
-		 *  sites, but we can't control their order. If we mark a socket
-		 *  as accounted, but the accounting functions are not patched in
-		 *  yet, we'll lose accounting.
+		 * We need to do this, because static_keys will span multiple
+		 * sites, but we can't control their order.  If we mark a socket
+		 * as accounted, but the accounting functions are not patched in
+		 * yet, we'll lose accounting.
 		 *
-		 *  We never race with the readers in sock_update_memcg(), because
-		 *  when this value change, the code to process it is not patched in
-		 *  yet.
+		 * We never race with the readers in sock_update_memcg(),
+		 * because when this value change, the code to process it is not
+		 * patched in yet.
 		 *
-		 *  The activated bit is used to guarantee that no two writers will
-		 *  do the update in the same memcg. Without that, we can't properly
-		 *  shutdown the static key.
+		 * The activated bit is used to guarantee that no two writers
+		 * will do the update in the same memcg. Without that, we can't
+		 * properly shutdown the static key.
 		 */
 		if (!test_and_set_bit(MEMCG_SOCK_ACTIVATED, &cg_proto->flags))
 			static_key_slow_inc(&memcg_socket_limit_enabled);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-mmapc-find_vma-remove-unnecessary-ifmm-check.patch
mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already-on-a-correct-node.patch
mm-do_migrate_pages-rename-arguments.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy.patch
mm-rename-is_mlocked_vma-to-mlocked_vma_newpage.patch
mm-page_allocc-remove-pageblock_default_order.patch
mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator.patch
tmpfs-support-seek_data-and-seek_hole.patch
mm-page_allocc-cleanups.patch
mm-fix-slab-page-flags-corruption.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch
mm-memcg-print-statistics-from-live-counters.patch
memcg-always-free-struct-memcg-through-schedule_work.patch
memcg-decrement-static-keys-at-real-destroy-time.patch
drivers-video-backlight-apple_blc-include-header-for-exported-symbol-prototypes-fix.patch
backlight-add-lm3533-backlight-driver-fix.patch
backlight-add-lm3533-backlight-driver-fix-fix.patch
backlight-use-pr_warn-and-pr_debug-instead-of-printk-fix.patch
backlight-apple_bl-use-pr_debug-pr_err-instead-of-printk-fix.patch
backlight-cr_bllcd-use-pr_err-pr_info-instead-of-printk-fix.patch
backlight-generic_bl-use-pr_info-instead-of-printk-fix.patch
backlight-jornada720-use-pr_err-pr_info-instead-of-printk-fix.patch
backlight-omap1-use-pr_info-instead-of-printk-fix.patch
backlight-progear-use-pr_err-instead-of-printk-fix.patch
leds-led-module-for-da9052-53-pmic-v2-fix.patch
leds-heartbeat-stop-on-shutdown-checkpatch-fixes.patch
drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds-fix.patch
lib-string_helpersc-make-arrays-static.patch
lib-bitmapc-fix-documentation-for-scnprintf-functions.patch
drivers-rtc-rtc-pcf8563c-add-rtc_vl_read-rtc_vl_clr-ioctl-feature-fix.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch

