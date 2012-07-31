From: akpm@linux-foundation.org
Subject: [merged] clk-validate-pointer-in-__clk_disable.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:49:05 -0700
Message-ID: <20120731184906.1D3B35C0063@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:51872 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756179Ab2GaStJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2012 14:49:09 -0400
Received: by lagr15 with SMTP id r15so292127lag.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:49:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, paul.gortmaker@windriver.com, rmk@arm.linux.org.uk, viresh.kumar@st.com, viresh.linux@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: clk: validate pointer in __clk_disable()
has been removed from the -mm tree.  Its filename was
     clk-validate-pointer-in-__clk_disable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: clk: validate pointer in __clk_disable()

clk_get() returns -ENOENT on error and some careless caller might
dereference it without error checking:

In mxc_rnga_remove():

        struct clk *clk = clk_get(&pdev->dev, "rng");

	// ...

        clk_disable(clk);

Since it's insane to audit the lots of existing and future clk users,
let's add a check in the callee to avoid kernel panic and warn about
any buggy user.

Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Viresh Kumar <viresh.kumar@st.com>
Cc: viresh kumar <viresh.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clk/clk.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/clk/clk.c~clk-validate-pointer-in-__clk_disable drivers/clk/clk.c
--- a/drivers/clk/clk.c~clk-validate-pointer-in-__clk_disable
+++ a/drivers/clk/clk.c
@@ -465,6 +465,9 @@ static void __clk_disable(struct clk *cl
 	if (!clk)
 		return;
 
+	if (WARN_ON(IS_ERR(clk)))
+		return;
+
 	if (WARN_ON(clk->enable_count == 0))
 		return;
 
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
xtensa-select-generic-atomic64_t-support.patch
mm-prepare-for-removal-of-obsolete-proc-sys-vm-nr_pdflush_threads.patch
mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator-again.patch
mm-slb-add-knowledge-of-pfmemalloc-reserve-pages-fix.patch
nfs-enable-swap-on-nfs-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-further-prevent-oom-with-too-many-dirty-pages.patch
memcg-add-mem_cgroup_from_css-helper-fix-2.patch
linux-next.patch
rbtree-performance-and-correctness-test-fix.patch

