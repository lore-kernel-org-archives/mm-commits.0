Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53CBDC6377C
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jul 2021 20:50:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3925B61248
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jul 2021 20:50:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbhGUUJx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Jul 2021 16:09:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:58616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229604AbhGUUJx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 21 Jul 2021 16:09:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE7F961244;
        Wed, 21 Jul 2021 20:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626900628;
        bh=ffgQKyNUbUa0CwQRCrPkCX4TJ3OuT1ecXQwflcJlO6Y=;
        h=Date:From:To:Subject:From;
        b=wirjqp/JgT8h8GpC7Vrg4q4cOxj/XSnr1Ll25mE45hcxXbxfA8X/36l1yzpien5GO
         DzeHVSJbUzxjI42K7C6fGw+O/sltED9JVTiweCMJR6g3nXGwKGBNbrGVzCpyxf57h8
         3l3kGqi/Fq4YVuqjiWbFLZ/iQSmzb/zN9pJ4NSx4=
Date:   Wed, 21 Jul 2021 13:50:27 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vinmenon@codeaurora.org,
        vbabka@suse.cz, rientjes@google.com, nigupta@nvidia.com,
        khalid.aziz@oracle.com, charante@codeaurora.org,
        akpm@linux-foundation.org
Subject:  +
 mm-compaction-optimize-proactive-compaction-deferrals-fix.patch added to -mm
 tree
Message-ID: <20210721205027.gcghG%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-optimize-proactive-compaction-deferrals-fix
has been added to the -mm tree.  Its filename is
     mm-compaction-optimize-proactive-compaction-deferrals-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-optimize-proactive-compaction-deferrals-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-optimize-proactive-compaction-deferrals-fix.patch

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
Subject: mm-compaction-optimize-proactive-compaction-deferrals-fix

tweak comment

Cc: Charan Teja Reddy <charante@codeaurora.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Nitin Gupta <nigupta@nvidia.com>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/compaction.c~mm-compaction-optimize-proactive-compaction-deferrals-fix
+++ a/mm/compaction.c
@@ -2909,11 +2909,11 @@ static int kcompactd(void *p)
 			kcompactd_do_work(pgdat);
 			psi_memstall_leave(&pflags);
 			/*
-			 * Reset the timeout value. The defer timeout by
-			 * proactive compaction can effectively lost
-			 * here but that is fine as the condition of the
-			 * zone changed substantionally and carrying on
-			 * with the previous defer is not useful.
+			 * Reset the timeout value. The defer timeout from
+			 * proactive compaction is lost here but that is fine
+			 * as the condition of the zone changing substantionally
+			 * then carrying on with the previous defer interval is
+			 * not useful.
 			 */
 			timeout = default_timeout;
 			continue;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
mm-compaction-optimize-proactive-compaction-deferrals-fix.patch
mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

