Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F990C64E7B
	for <mm-commits@archiver.kernel.org>; Wed,  2 Dec 2020 23:45:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA54622201
	for <mm-commits@archiver.kernel.org>; Wed,  2 Dec 2020 23:45:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbgLBXpl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Dec 2020 18:45:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:45688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726108AbgLBXpk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 2 Dec 2020 18:45:40 -0500
Date:   Wed, 02 Dec 2020 15:44:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606952694;
        bh=fWCVxDolV9w4trce3Uc5WpYRb4z5odq7tmSDnKJds1I=;
        h=From:To:Subject:From;
        b=yE+leouYBrNsjoCSMwp7Nkp1Uww3BSaelJ9LLKMjP7/sQgL5XofzK2OmlaXLbtcdb
         DLAjO2NCmHFKXO4OMZuWCNT9hk0oSg3vZSAhkp7kaIASpcaEqxfvtaO2Dq9QnusHEl
         EqEZBUNDNQwiM+ct//syI1M1/6HfzjhLiSP9X9aw=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, dwaipayanray1@gmail.com,
        joe@perches.com, mm-commits@vger.kernel.org, yepeilin.cs@gmail.com
Subject:  +
 checkpatch-fix-typo_spelling-check-for-words-with-apostrophe-fix.patch
 added to -mm tree
Message-ID: <20201202234453.A0_vy6-V_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch-fix-typo_spelling-check-for-words-with-apostrophe-fix
has been added to the -mm tree.  Its filename is
     checkpatch-fix-typo_spelling-check-for-words-with-apostrophe-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-fix-typo_spelling-check-for-words-with-apostrophe-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-fix-typo_spelling-check-for-words-with-apostrophe-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: checkpatch-fix-typo_spelling-check-for-words-with-apostrophe-fix

make matched misspelling more obvious, per Joe

Link: https://lkml.kernel.org/r/09c24ef1aa2f1c4fe909d76f5426f08780b9d81c.camel@perches.com
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Peilin Ye <yepeilin.cs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-fix-typo_spelling-check-for-words-with-apostrophe-fix
+++ a/scripts/checkpatch.pl
@@ -3185,7 +3185,7 @@ sub process {
 			while ($rawline =~ /(?:^|[^\w\-'`])($misspellings)(?:[^\w\-'`]|$)/gi) {
 				my $typo = $1;
 				my $blank = copy_spacing($rawline);
-				my $ptr = substr($blank, 0, $-[1]) . "^";
+				my $ptr = substr($blank, 0, $-[1]) . "^" x length($typo);
 				my $hereptr = "$hereline$ptr\n";
 				my $typo_fix = $spelling_fix{lc($typo)};
 				$typo_fix = ucfirst($typo_fix) if ($typo =~ /^[A-Z]/);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kthread_worker-document-cpu-hotplug-handling-fix.patch
mm.patch
mm-remove-the-unuseful-else-after-a-return-checkpatch-fixes.patch
mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
mm-truncateshmem-handle-truncates-that-split-thps-fix-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix.patch
ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
checkpatch-fix-typo_spelling-check-for-words-with-apostrophe-fix.patch
resource-fix-kernel-doc-markups-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

