From: akpm@linux-foundation.org
Subject: [merged]
 drivers-net-ethernet-mellanox-mlx5-core-en_mainc-fix-build-with-gcc-444.patch removed from -mm tree
Date: Tue, 04 Apr 2017 12:11:09 -0700
Message-ID: <58e3efcd.pQ6ADeEIQPj4MR3o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46390 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752477AbdDDTLK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Apr 2017 15:11:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, saeedm@mellanox.com, tariqt@mellanox.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/net/ethernet/mellanox/mlx5/core/en_main.c: fix build with gcc-4.4.4
has been removed from the -mm tree.  Its filename was
     drivers-net-ethernet-mellanox-mlx5-core-en_mainc-fix-build-with-gcc-444.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/net/ethernet/mellanox/mlx5/core/en_main.c: fix build with gcc-4.4.4

drivers/net/ethernet/mellanox/mlx5/core/en_main.c: In function 'mlx5e_redirect_rqts':
drivers/net/ethernet/mellanox/mlx5/core/en_main.c:2210: error: unknown field 'rqn' specified in initializer
drivers/net/ethernet/mellanox/mlx5/core/en_main.c:2211: warning: missing braces around initializer
drivers/net/ethernet/mellanox/mlx5/core/en_main.c:2211: warning: (near initialization for 'direct_rrp.<anonymous>')
drivers/net/ethernet/mellanox/mlx5/core/en_main.c: In function 'mlx5e_redirect_rqts_to_channels':
drivers/net/ethernet/mellanox/mlx5/core/en_main.c:2227: error: unknown field 'rss' specified in initializer
drivers/net/ethernet/mellanox/mlx5/core/en_main.c:2227: warning: missing braces around initializer
drivers/net/ethernet/mellanox/mlx5/core/en_main.c:2227: warning: (near initialization for 'rrp.<anonymous>')
drivers/net/ethernet/mellanox/mlx5/core/en_main.c:2227: warning: initialization makes integer from pointer without a cast
drivers/net/ethernet/mellanox/mlx5/core/en_main.c:2228: error: unknown field 'rss' specified in initializer
drivers/net/ethernet/mellanox/mlx5/core/en_main.c:2229: warning: excess elements in struct initializer
drivers/net/ethernet/mellanox/mlx5/core/en_main.c:2229: warning: (near initialization for 'rrp')
drivers/net/ethernet/mellanox/mlx5/core/en_main.c: In function 'mlx5e_redirect_rqts_to_drop':
drivers/net/ethernet/mellanox/mlx5/core/en_main.c:2238: error: unknown field 'rqn' specified in initializer
drivers/net/ethernet/mellanox/mlx5/core/en_main.c:2239: warning: missing braces around initializer
drivers/net/ethernet/mellanox/mlx5/core/en_main.c:2239: warning: (near initialization for 'drop_rrp.<anonymous>')

gcc-4.4.4 has issues with anonymous union initializers.  Work around this.

Cc: Saeed Mahameed <saeedm@mellanox.com>
Cc: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |   16 +++++++++---
 1 file changed, 12 insertions(+), 4 deletions(-)

diff -puN drivers/net/ethernet/mellanox/mlx5/core/en_main.c~drivers-net-ethernet-mellanox-mlx5-core-en_mainc-fix-build-with-gcc-444 drivers/net/ethernet/mellanox/mlx5/core/en_main.c
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c~drivers-net-ethernet-mellanox-mlx5-core-en_mainc-fix-build-with-gcc-444
+++ a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2207,7 +2207,9 @@ static void mlx5e_redirect_rqts(struct m
 	for (ix = 0; ix < priv->profile->max_nch(priv->mdev); ix++) {
 		struct mlx5e_redirect_rqt_param direct_rrp = {
 			.is_rss = false,
-			.rqn    = mlx5e_get_direct_rqn(priv, ix, rrp)
+			{
+				.rqn    = mlx5e_get_direct_rqn(priv, ix, rrp)
+			},
 		};
 
 		/* Direct RQ Tables */
@@ -2224,8 +2226,12 @@ static void mlx5e_redirect_rqts_to_chann
 {
 	struct mlx5e_redirect_rqt_param rrp = {
 		.is_rss        = true,
-		.rss.channels  = chs,
-		.rss.hfunc     = chs->params.rss_hfunc
+		{
+			.rss = {
+				.channels  = chs,
+				.hfunc     = chs->params.rss_hfunc,
+			}
+		},
 	};
 
 	mlx5e_redirect_rqts(priv, rrp);
@@ -2235,7 +2241,9 @@ static void mlx5e_redirect_rqts_to_drop(
 {
 	struct mlx5e_redirect_rqt_param drop_rrp = {
 		.is_rss = false,
-		.rqn = priv->drop_rq.rqn
+		{
+			.rqn = priv->drop_rq.rqn,
+		},
 	};
 
 	mlx5e_redirect_rqts(priv, drop_rrp);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-move-madv_free-pages-into-lru_inactive_file-list-checkpatch-fixes.patch
mm-use-is_migrate_highatomic-to-simplify-the-code-fix.patch
mm-introduce-memalloc_nofs_saverestore-api-fix.patch
jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context-fix.patch
jbd2-make-the-whole-kjournald2-kthread-nofs-safe-checkpatch-fixes.patch
mm-page_alloc-count-movable-pages-when-stealing-from-pageblock-fix.patch
swap-add-warning-if-swap-slots-cache-failed-to-initialize-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drm-use-set_memoryh-header-fix.patch
drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

