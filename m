Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9DCAC7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:51:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234973AbjDFCv1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234978AbjDFCvM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:51:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8251C49CC
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB0FB62ABF
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412D1C433D2;
        Thu,  6 Apr 2023 02:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749417;
        bh=yX1oPimZnZoqaL1FZHTxhwD4p8EcyJrg+irBE6cVK1k=;
        h=Date:To:From:Subject:From;
        b=uLpHgdHNjAkgMXE8ZoZglHZhRKn00fMdwIzE5LhV0mQgUrLfVRpb+lJjwk6/qV4wp
         ZzImWoQIFXxX7s5FkKuixccrXllrtazViloc0f2oMHK1xuhKONyodXx7eTf3EQlCcS
         V9/mh43Rceyml3jui1WvjN0Pno0Roe2Cht05EIJk=
Date:   Wed, 05 Apr 2023 19:50:16 -0700
To:     mm-commits@vger.kernel.org, kernel@gpiccoli.net,
        gpiccoli@igalia.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] notifiers-add-tracepoints-to-the-notifiers-infrastructure-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20230406025017.412D1C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: notifiers-add-tracepoints-to-the-notifiers-infrastructure-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     notifiers-add-tracepoints-to-the-notifiers-infrastructure-checkpatch-fixes.patch

This patch was dropped because it was folded into notifiers-add-tracepoints-to-the-notifiers-infrastructure.patch

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

 kernel/notifier.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/notifier.c~notifiers-add-tracepoints-to-the-notifiers-infrastructure-checkpatch-fixes
+++ a/kernel/notifier.c
@@ -40,7 +40,7 @@ static int notifier_chain_register(struc
 	}
 	n->next = *nl;
 	rcu_assign_pointer(*nl, n);
-	trace_notifier_register((void*)n->notifier_call);
+	trace_notifier_register((void *)n->notifier_call);
 	return 0;
 }
 
@@ -50,7 +50,7 @@ static int notifier_chain_unregister(str
 	while ((*nl) != NULL) {
 		if ((*nl) == n) {
 			rcu_assign_pointer(*nl, n->next);
-			trace_notifier_unregister((void*)n->notifier_call);
+			trace_notifier_unregister((void *)n->notifier_call);
 			return 0;
 		}
 		nl = &((*nl)->next);
@@ -89,7 +89,7 @@ static int notifier_call_chain(struct no
 			continue;
 		}
 #endif
-		trace_notifier_run((void*)nb->notifier_call);
+		trace_notifier_run((void *)nb->notifier_call);
 		ret = nb->notifier_call(nb, val, v);
 
 		if (nr_calls)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-khugepaged-fix-kernel-bug-in-hpage_collapse_scan_file-fix.patch
mm-add-new-api-to-enable-ksm-per-process-fix.patch
memcg-do-not-drain-charge-pcp-caches-on-remote-isolated-cpus-fix.patch
vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold-fix.patch
lib-test_vmallocc-add-vm_map_ram-vm_unmap_ram-test-case-fix.patch
scripts-link-vmlinuxsh-fix-error-message-presentation.patch
notifiers-add-tracepoints-to-the-notifiers-infrastructure.patch

