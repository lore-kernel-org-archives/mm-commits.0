Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB3E3C77B78
	for <mm-commits@archiver.kernel.org>; Wed,  3 May 2023 02:18:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjECCSF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 May 2023 22:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjECCSC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 May 2023 22:18:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F083C17
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 19:17:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 749FA62A1E
        for <mm-commits@vger.kernel.org>; Wed,  3 May 2023 02:17:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F05C433EF;
        Wed,  3 May 2023 02:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683080274;
        bh=ShldFITP6OtMC2EA2scJEpEliK8KpSHC6XTd9E+nM+0=;
        h=Date:To:From:Subject:From;
        b=d809p7xO0zlq+kphfvPDJps1NS7sQfLgtQRTf6WI8e3DFCfHOozY/hZ7tgo6jLt1X
         HC6V+ufPaN+Zit1xGzcWUl4OhyVXRydzZAXqn18wxktrHFVx/bmc+OeUm0XUt0InFH
         DqY5PV7DV3V4Km0t/03jyIGOuAkMt4JIgV7j153s=
Date:   Tue, 02 May 2023 19:17:54 -0700
To:     mm-commits@vger.kernel.org, william.lam@bytedance.com,
        wenyang.linux@foxmail.com, wefu@redhat.com, pintu@codeaurora.org,
        osalvador@suse.de, mgorman@techsingularity.net,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide-fix.patch added to mm-unstable branch
Message-Id: <20230503021754.C8F05C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide-fix
Date: Tue May  2 01:47:48 PM PDT 2023

add __read_mostly, per Mel

Cc: Fu Wei <wefu@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pintu Kumar <pintu@codeaurora.org>
Cc: Wen Yang <wenyang.linux@foxmail.com>
Cc: William Lam <william.lam@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide-fix
+++ a/mm/compaction.c
@@ -1736,7 +1736,7 @@ static int sysctl_compact_unevictable_al
  */
 static unsigned int __read_mostly sysctl_compaction_proactiveness = 20;
 static int sysctl_extfrag_threshold = 500;
-static int sysctl_compact_memory;
+static int __read_mostly sysctl_compact_memory;
 
 static inline void
 update_fast_start_pfn(struct compact_control *cc, unsigned long pfn)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide-fix.patch
mm-gup-disallow-foll_longterm-gup-fast-writing-to-file-backed-mappings-fix.patch

