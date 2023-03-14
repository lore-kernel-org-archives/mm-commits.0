Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F77BC05027
	for <mm-commits@archiver.kernel.org>; Tue, 14 Mar 2023 20:52:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbjCNUwC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Mar 2023 16:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjCNUwC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Mar 2023 16:52:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2662BEE8
        for <mm-commits@vger.kernel.org>; Tue, 14 Mar 2023 13:52:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 645B7B81AB7
        for <mm-commits@vger.kernel.org>; Tue, 14 Mar 2023 20:51:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21BCBC433EF;
        Tue, 14 Mar 2023 20:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678827118;
        bh=s5GV3De5dW0CwLomQujSO/oiyQidEPB/8j7tMywBczM=;
        h=Date:To:From:Subject:From;
        b=eQ0S0Rj9FqBaUTgJI4BRMxzRpOkbKCX/AaKChwHVz0/0RuzMm4e/wjX54yWSkQBaH
         bfJnivbUu0ynn+EfPgNaZNLLCRzY95l7Fzedgkw8/jZs6C8frCDwSnoJPIeVyQ2Pg8
         y8q7xx4LFZUyEKu6PdVgIQNJl9J0SvPMi/kaeAeE=
Date:   Tue, 14 Mar 2023 13:51:57 -0700
To:     mm-commits@vger.kernel.org, kernel@gpiccoli.net,
        gpiccoli@igalia.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + notifiers-add-tracepoints-to-the-notifiers-infrastructure-checkpatch-fixes.patch added to mm-nonmm-unstable branch
Message-Id: <20230314205158.21BCBC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: notifiers-add-tracepoints-to-the-notifiers-infrastructure-checkpatch-fixes
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     notifiers-add-tracepoints-to-the-notifiers-infrastructure-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/notifiers-add-tracepoints-to-the-notifiers-infrastructure-checkpatch-fixes.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: notifiers-add-tracepoints-to-the-notifiers-infrastructure-checkpatch-fixes
Date: Tue Mar 14 01:51:03 PM PDT 2023

ERROR: "(foo*)" should be "(foo *)"
#117: FILE: kernel/notifier.c:43:
+	trace_notifiers_register((void*)n->notifier_call);

ERROR: "(foo*)" should be "(foo *)"
#125: FILE: kernel/notifier.c:53:
+			trace_notifiers_unregister((void*)n->notifier_call);

ERROR: "(foo*)" should be "(foo *)"
#133: FILE: kernel/notifier.c:92:
+		trace_notifiers_run((void*)nb->notifier_call);

total: 3 errors, 0 warnings, 99 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/notifiers-add-tracepoints-to-the-notifiers-infrastructure.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc: Guilherme G. Piccoli <kernel@gpiccoli.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/kernel/notifier.c~notifiers-add-tracepoints-to-the-notifiers-infrastructure-checkpatch-fixes
+++ a/kernel/notifier.c
@@ -40,7 +40,7 @@ static int notifier_chain_register(struc
 	}
 	n->next = *nl;
 	rcu_assign_pointer(*nl, n);
-	trace_notifiers_register((void*)n->notifier_call);
+	trace_notifiers_register((void *)n->notifier_call);
 	return 0;
 }
 
@@ -50,7 +50,7 @@ static int notifier_chain_unregister(str
 	while ((*nl) != NULL) {
 		if ((*nl) == n) {
 			rcu_assign_pointer(*nl, n->next);
-			trace_notifiers_unregister((void*)n->notifier_call);
+			trace_notifiers_unregister((void *)n->notifier_call);
 			return 0;
 		}
 		nl = &((*nl)->next);
@@ -89,7 +89,7 @@ static int notifier_call_chain(struct no
 			continue;
 		}
 #endif
-		trace_notifiers_run((void*)nb->notifier_call);
+		trace_notifiers_run((void *)nb->notifier_call);
 		ret = nb->notifier_call(nb, val, v);
 
 		if (nr_calls)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-reduce-page-alloc-free-sanity-checks-checkpatch-fixes.patch
mm-page_alloc-reduce-page-alloc-free-sanity-checks-fix.patch
mm-userfaultfd-support-wp-on-multiple-vmas-fix.patch
mm-add-new-api-to-enable-ksm-per-process-fix.patch
vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold-fix.patch
scripts-link-vmlinuxsh-fix-error-message-presentation.patch
notifiers-add-tracepoints-to-the-notifiers-infrastructure-checkpatch-fixes.patch

