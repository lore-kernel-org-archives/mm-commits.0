Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A58A1C25B08
	for <mm-commits@archiver.kernel.org>; Sat, 20 Aug 2022 20:35:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbiHTUfy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 20 Aug 2022 16:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbiHTUfx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 20 Aug 2022 16:35:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68BC825C4E
        for <mm-commits@vger.kernel.org>; Sat, 20 Aug 2022 13:35:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECA6A60C1F
        for <mm-commits@vger.kernel.org>; Sat, 20 Aug 2022 20:35:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B7A4C433D7;
        Sat, 20 Aug 2022 20:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661027751;
        bh=DU1RHO3nnCS8O/gwDzqY0OzsFiQrdzjnFsYAEUTeP2M=;
        h=Date:To:From:Subject:From;
        b=DeCRhWTWimil94EUMgy0GcJ0/No4EXG9WGP0YSMqJsRij2L1xAg8L/NgRed6r7WOG
         z+2LSy5bUyZqH8XNszwXl14qt/O742MbeZEx1jXLdK7XfJv4sxybI5uvNRYNJvybrI
         QPKFGpFq5VQA1tjJ/TgMnPRFAuoGkZtkSy2oo5Uo=
Date:   Sat, 20 Aug 2022 13:35:50 -0700
To:     mm-commits@vger.kernel.org, aneesh.kumar@linux.ibm.com,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix.patch added to mm-unstable branch
Message-Id: <20220820203551.3B7A4C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/sched/fair: include missed header file, memory-tiers.h
has been added to the -mm mm-unstable branch.  Its filename is
     mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: SeongJae Park <sj@kernel.org>
Subject: kernel/sched/fair: include missed header file, memory-tiers.h
Date: Sat, 20 Aug 2022 19:07:20 +0000

Commit f66f3c261487 ("mm/demotion: update node_is_toptier to work with
memory tiers") of the 'mm-unstable' tree moved the declaration of
'node_is_toptier()' from 'node.h' to 'memory-tiers.h' but didn't include
the header in a source file using the function, 'kernel/sched/fair.c'.
As a result, build fails as below:

    linux/kernel/sched/fair.c: In function `should_numa_migrate_memory':
    linux/kernel/sched/fair.c:1571:7: error: implicit declaration of function `node_is_toptier' [-Werror=implicit-function-declaration]
     1571 |      !node_is_toptier(src_nid)) {
          |       ^~~~~~~~~~~~~~~
    cc1: some warnings being treated as errors

This commit fixes the error by including the missed header file.

Link: https://lkml.kernel.org/r/20220820190720.248704-1-sj@kernel.org
Fixes: f66f3c261487 ("mm/demotion: update node_is_toptier to work with memory tiers") on mm-unstable
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/fair.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/sched/fair.c~mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix
+++ a/kernel/sched/fair.c
@@ -40,6 +40,7 @@
 
 #include <linux/cpuidle.h>
 #include <linux/interrupt.h>
+#include <linux/memory-tiers.h>
 #include <linux/mempolicy.h>
 #include <linux/mutex_api.h>
 #include <linux/profile.h>
_

Patches currently in -mm which might be from sj@kernel.org are

mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix.patch

