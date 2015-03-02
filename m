From: akpm@linux-foundation.org
Subject: + lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch
 added to -mm tree
Date: Mon, 02 Mar 2015 12:48:34 -0800
Message-ID: <54f4cca2.OAZ1RXswRaTfxAX5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43358 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746AbbCBUsf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2015 15:48:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, corbet@lwn.net, geert+renesas@glider.be, mturquette@linaro.org, penguin-kernel@I-love.SAKURA.ne.jp, sboyd@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix
has been added to the -mm tree.  Its filename is
     lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-vsprintf-add-%25pcnr-format-specifiers-for-clocks-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-vsprintf-add-%25pcnr-format-specifiers-for-clocks-fix.patch

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
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm.patch
mm-cma-release-trigger-checkpatch-fixes.patch
mm-cma-allocation-trigger-fix.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes.patch
mm-hide-per-cpu-lists-in-output-of-show_mem-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch
lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch
lib-find__bit-reimplementation-fix.patch
binfmt_misc-simplify-entry_status-fix.patch
fs-fat-remove-unnecessary-includes-fix.patch
kconfig-use-macros-which-are-already-defined-fix.patch
linux-next.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

