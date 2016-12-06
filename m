From: akpm@linux-foundation.org
Subject: +
 drivers-clk-uniphier-clk-uniphier-mioc-fix-build-for-older-gcc.patch added
 to -mm tree
Date: Tue, 06 Dec 2016 15:03:20 -0800
Message-ID: <584743b8.XW2r7Im7J/OGwM0m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47190 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752041AbcLFXCu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Dec 2016 18:02:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, robh@kernel.org, sboyd@codeaurora.org, yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/clk/uniphier/clk-uniphier-mio.c: fix build for older gcc
has been added to the -mm tree.  Its filename is
     drivers-clk-uniphier-clk-uniphier-mioc-fix-build-for-older-gcc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-clk-uniphier-clk-uniphier-mioc-fix-build-for-older-gcc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-clk-uniphier-clk-uniphier-mioc-fix-build-for-older-gcc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/clk/uniphier/clk-uniphier-mio.c: fix build for older gcc

gcc-4.4.4 (at least) has issues with anon union initializers.

drivers/clk/uniphier/clk-uniphier-mio.c:81: error: unknown field 'mux' specified in initializer
drivers/clk/uniphier/clk-uniphier-mio.c:81: error: unknown field 'parent_names' specified in initializer
drivers/clk/uniphier/clk-uniphier-mio.c:81: warning: missing braces around initializer
drivers/clk/uniphier/clk-uniphier-mio.c:81: warning: (near initialization for 'uniphier_sld3_mio_clk_data[8].<anonymous>.cpugear.parent_names')
drivers/clk/uniphier/clk-uniphier-mio.c:81: error: unknown field 'num_parents' specified in initializer
drivers/clk/uniphier/clk-uniphier-mio.c:81: warning: excess elements in union initializer
drivers/clk/uniphier/clk-uniphier-mio.c:81: warning: (near initialization for 'uniphier_sld3_mio_clk_data[8].<anonymous>')
drivers/clk/uniphier/clk-uniphier-mio.c:81: error: unknown field 'reg' specified in initializer
...


Fixes: 7f4d3b52b6b69f ("clk: uniphier: add clock data for UniPhier SoCs")
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clk/uniphier/clk-uniphier-mio.c |   66 +++++++++++-----------
 1 file changed, 34 insertions(+), 32 deletions(-)

diff -puN drivers/clk/uniphier/clk-uniphier-mio.c~drivers-clk-uniphier-clk-uniphier-mioc-fix-build-for-older-gcc drivers/clk/uniphier/clk-uniphier-mio.c
--- a/drivers/clk/uniphier/clk-uniphier-mio.c~drivers-clk-uniphier-clk-uniphier-mioc-fix-build-for-older-gcc
+++ a/drivers/clk/uniphier/clk-uniphier-mio.c
@@ -30,38 +30,40 @@
 		.name = "sd" #ch "-sel",				\
 		.type = UNIPHIER_CLK_TYPE_MUX,				\
 		.idx = -1,						\
-		.mux = {						\
-			.parent_names = {				\
-				"sd-44m",				\
-				"sd-33m",				\
-				"sd-50m",				\
-				"sd-67m",				\
-				"sd-100m",				\
-				"sd-40m",				\
-				"sd-25m",				\
-				"sd-22m",				\
-			},						\
-			.num_parents = 8,				\
-			.reg = 0x30 + 0x200 * (ch),			\
-			.masks = {					\
-				0x00031000,				\
-				0x00031000,				\
-				0x00031000,				\
-				0x00031000,				\
-				0x00001300,				\
-				0x00001300,				\
-				0x00001300,				\
-				0x00001300,				\
-			},						\
-			.vals = {					\
-				0x00000000,				\
-				0x00010000,				\
-				0x00020000,				\
-				0x00030000,				\
-				0x00001000,				\
-				0x00001100,				\
-				0x00001200,				\
-				0x00001300,				\
+		{							\
+			.mux = {					\
+				.parent_names = {			\
+					"sd-44m",			\
+					"sd-33m",			\
+					"sd-50m",			\
+					"sd-67m",			\
+					"sd-100m",			\
+					"sd-40m",			\
+					"sd-25m",			\
+					"sd-22m",			\
+				},					\
+				.num_parents = 8,			\
+				.reg = 0x30 + 0x200 * (ch),		\
+				.masks = {				\
+					0x00031000,			\
+					0x00031000,			\
+					0x00031000,			\
+					0x00031000,			\
+					0x00001300,			\
+					0x00001300,			\
+					0x00001300,			\
+					0x00001300,			\
+				},					\
+				.vals = {				\
+					0x00000000,			\
+					0x00010000,			\
+					0x00020000,			\
+					0x00030000,			\
+					0x00001000,			\
+					0x00001100,			\
+					0x00001200,			\
+					0x00001300,			\
+				},					\
 			},						\
 		},							\
 	},								\
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
debug-more-properly-delay-for-secondary-cpus-fix.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
drivers-clk-uniphier-clk-uniphierh-fix-build-with-old-gcc.patch
ipc-sem-rework-task-wakeups-checkpatch-fixes.patch
ipc-sem-optimize-perform_atomic_semop-checkpatch-fixes.patch
ipc-sem-simplify-wait-wake-loop-checkpatch-fixes.patch
mm-unexport-__get_user_pages_unlocked-checkpatch-fixes.patch
vfs-make-may_umount_tree-mount-propogation-aware-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
drivers-clk-uniphier-clk-uniphier-mioc-fix-build-for-older-gcc.patch

