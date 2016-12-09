From: akpm@linux-foundation.org
Subject: [obsolete]
 drivers-clk-uniphier-clk-uniphierh-fix-build-with-old-gcc.patch removed
 from -mm tree
Date: Fri, 09 Dec 2016 12:59:48 -0800
Message-ID: <584b1b44.ArcyEnp7MmG+N0kl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34188 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751610AbcLIU7u (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2016 15:59:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, sboyd@codeaurora.org, yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/clk/uniphier/clk-uniphier.h: fix build with old gcc
has been removed from the -mm tree.  Its filename was
     drivers-clk-uniphier-clk-uniphierh-fix-build-with-old-gcc.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/clk/uniphier/clk-uniphier.h: fix build with old gcc

gcc-4.4.4 (at least) has issues with anon uniion initializers.  Work
around this.

drivers/clk/uniphier/clk-uniphier-sys.c:45: error: unknown field 'factor' specified in initializer
drivers/clk/uniphier/clk-uniphier-sys.c:45: error: unknown field 'parent_name' specified in initializer
drivers/clk/uniphier/clk-uniphier-sys.c:45: warning: missing braces around initializer
drivers/clk/uniphier/clk-uniphier-sys.c:45: warning: (near initialization for 'uniphier_sld3_sys_clk_data[0].<anonymous>.cpugear')
drivers/clk/uniphier/clk-uniphier-sys.c:45: error: unknown field 'mult' specified in initializer
drivers/clk/uniphier/clk-uniphier-sys.c:45: warning: excess elements in union initializer
drivers/clk/uniphier/clk-uniphier-sys.c:45: warning: (near initialization for 'uniphier_sld3_sys_clk_data[0].<anonymous>')
drivers/clk/uniphier/clk-uniphier-sys.c:45: error: unknown field 'div' specified in initializer
drivers/clk/uniphier/clk-uniphier-sys.c:45: warning: excess elements in union initializer
...

Fixes: 734d82f4a678e897 ("clk: uniphier: add core support code for UniPhier clock driver")
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clk/uniphier/clk-uniphier.h |   36 +++++++++++++++-----------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff -puN drivers/clk/uniphier/clk-uniphier.h~drivers-clk-uniphier-clk-uniphierh-fix-build-with-old-gcc drivers/clk/uniphier/clk-uniphier.h
--- a/drivers/clk/uniphier/clk-uniphier.h~drivers-clk-uniphier-clk-uniphierh-fix-build-with-old-gcc
+++ a/drivers/clk/uniphier/clk-uniphier.h
@@ -81,12 +81,14 @@ struct uniphier_clk_data {
 		.name = (_name),				\
 		.type = UNIPHIER_CLK_TYPE_CPUGEAR,		\
 		.idx = (_idx),					\
-		.cpugear = {					\
-			.parent_names = { __VA_ARGS__ },	\
-			.num_parents = (_num_parents),		\
-			.regbase = (_regbase),			\
-			.mask = (_mask)				\
-		 },						\
+		{						\
+			.cpugear = {				\
+				.parent_names = { __VA_ARGS__ },\
+				.num_parents = (_num_parents),	\
+				.regbase = (_regbase),		\
+				.mask = (_mask)			\
+			 },					\
+		}						\
 	}
 
 #define UNIPHIER_CLK_FACTOR(_name, _idx, _parent, _mult, _div)	\
@@ -94,10 +96,12 @@ struct uniphier_clk_data {
 		.name = (_name),				\
 		.type = UNIPHIER_CLK_TYPE_FIXED_FACTOR,		\
 		.idx = (_idx),					\
-		.factor = {					\
-			.parent_name = (_parent),		\
-			.mult = (_mult),			\
-			.div = (_div),				\
+		{						\
+			.factor = {				\
+				.parent_name = (_parent),	\
+				.mult = (_mult),		\
+				.div = (_div),			\
+			},					\
 		},						\
 	}
 
@@ -106,11 +110,13 @@ struct uniphier_clk_data {
 		.name = (_name),				\
 		.type = UNIPHIER_CLK_TYPE_GATE,			\
 		.idx = (_idx),					\
-		.gate = {					\
-			.parent_name = (_parent),		\
-			.reg = (_reg),				\
-			.bit = (_bit),				\
-		},						\
+		{						\
+			.gate = {				\
+				.parent_name = (_parent),	\
+				.reg = (_reg),			\
+				.bit = (_bit),			\
+			},					\
+		}						\
 	}
 
 #define UNIPHIER_CLK_DIV(parent, div)				\
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
prctl-remove-one-shot-limitation-for-changing-exe-link-fix.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
mm-compaction-allow-compaction-for-gfp_nofs-requests-fix.patch
mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist-checkpatch-fixes.patch
mm-disable-numa-migration-faults-for-dax-vmas-fix.patch
filemap-add-comment-for-confusing-logic-in-page_cache_tree_insert-fix.patch
include-linux-backing-dev-defsh-shrink-struct-backing_dev_info.patch
mm-thp-page-cache-support-for-ppc64-fix.patch
mm-rmap-handle-anon_vma_prepare-common-case-inline-checkpatch-fixes.patch
scripts-checkpatchpl-fix-spelling.patch
init-reduce-rootwait-polling-interval-time-to-5ms-fix.patch
debug-more-properly-delay-for-secondary-cpus-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
drivers-clk-uniphier-clk-uniphier-mioc-fix-build-for-older-gcc.patch
ipc-sem-rework-task-wakeups-checkpatch-fixes.patch
ipc-sem-optimize-perform_atomic_semop-checkpatch-fixes.patch
ipc-sem-simplify-wait-wake-loop-checkpatch-fixes.patch
mm-unexport-__get_user_pages_unlocked-checkpatch-fixes.patch
vfs-make-may_umount_tree-mount-propogation-aware-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

