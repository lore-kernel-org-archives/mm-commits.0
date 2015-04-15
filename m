From: akpm@linux-foundation.org
Subject: [folded-merged]
 lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch removed from
 -mm tree
Date: Wed, 15 Apr 2015 15:45:36 -0700
Message-ID: <552eea10.cFOogUMc5fEtba8y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52035 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780AbbDOWph (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 18:45:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, corbet@lwn.net, geert+renesas@glider.be, mturquette@linaro.org, penguin-kernel@I-love.SAKURA.ne.jp, sboyd@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix
has been removed from the -mm tree.  Its filename was
     lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch

This patch was dropped because it was folded into lib-vsprintf-add-%pcnr-format-specifiers-for-clocks.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix

omit code if !CONFIG_HAVE_CLK

Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/vsprintf.c~lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix
+++ a/lib/vsprintf.c
@@ -1320,7 +1320,7 @@ static noinline_for_stack
 char *clock(char *buf, char *end, struct clk *clk, struct printf_spec spec,
 	    const char *fmt)
 {
-	if (!clk)
+	if (!IS_ENABLED(CONFIG_HAVE_CLK) || !clk)
 		return string(buf, end, NULL, spec);
 
 	switch (fmt[1]) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
document-interaction-between-compaction-and-the-unevictable-lru.patch
mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp.patch
mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation.patch
mm-mmapc-use-while-instead-of-ifgoto.patch
mm-hugetlb-introduce-pagehugeactive-flag.patch
mm-hugetlb-cleanup-using-pagehugeactive-flag.patch
mm-memblock-add-debug-output-for-the-memblock_add.patch
mm-uninline-and-cleanup-page-mapping-related-helpers.patch
mm-cma-add-functions-to-get-region-pages-counters.patch
mm-cma_debugc-remove-blank-lines-before-define_simple_attribute.patch
mm-memory-print-also-a_ops-readpage-in-print_bad_pte.patch
mm-compactionc-fix-suitable_migration_target-unused-warning.patch
zsmalloc-support-compaction.patch
proc-pid-status-show-all-sets-of-pid-according-to-ns.patch
kernel-conditionally-support-non-root-users-groups-and-capabilities.patch
lib-vsprintf-add-%pcnr-format-specifiers-for-clocks.patch

