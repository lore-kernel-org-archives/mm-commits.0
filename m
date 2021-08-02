Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF57CC4338F
	for <mm-commits@archiver.kernel.org>; Mon,  2 Aug 2021 19:48:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91784610A0
	for <mm-commits@archiver.kernel.org>; Mon,  2 Aug 2021 19:48:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbhHBTsQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 2 Aug 2021 15:48:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:59810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229607AbhHBTsQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 2 Aug 2021 15:48:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5577360F36;
        Mon,  2 Aug 2021 19:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627933686;
        bh=av6RMN8eWdQnDwV6IeWaq/3fmSKJ1GOqwQblycGAy9w=;
        h=Date:From:To:Subject:From;
        b=uhjbneK2KfC12EbH++3cR1QUJucGlH+jpQIUHGo9ofZD4uZhORf4nA/S+/eP+11h0
         lwUVHlLMWfACZJpInqXCS4mnA39NXW8rgvGHMoWIUOTSFglbd4FNsME+L8oeeS3jT8
         0bM5hH5fmAdOYWxVOAEJgFEbj/fixmiCYXN1/DkE=
Date:   Mon, 02 Aug 2021 12:48:02 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, yzaikin@google.com,
        vinmenon@codeaurora.org, vbabka@suse.cz, rppt@kernel.org,
        rientjes@google.com, nigupta@nvidia.com,
        mgorman@techsingularity.net, mcgrof@kernel.org,
        khalid.aziz@oracle.com, keescook@chromium.org,
        dave.hansen@linux.intel.com, corbet@lwn.net,
        charante@codeaurora.org, akpm@linux-foundation.org
Subject:  +
 mm-compaction-support-triggering-of-proactive-compaction-by-user-fix.patch
 added to -mm tree
Message-ID: <20210802194802.JHi0d%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-support-triggering-of-proactive-compaction-by-user-fix
has been added to the -mm tree.  Its filename is
     mm-compaction-support-triggering-of-proactive-compaction-by-user-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-support-triggering-of-proactive-compaction-by-user-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-support-triggering-of-proactive-compaction-by-user-fix.patch

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
Subject: mm-compaction-support-triggering-of-proactive-compaction-by-user-fix

tweak vm.rst, per Mike

Cc: Mike Rapoport <rppt@kernel.org>
Cc: Charan Teja Reddy <charante@codeaurora.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Nitin Gupta <nigupta@nvidia.com>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/vm.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/sysctl/vm.rst~mm-compaction-support-triggering-of-proactive-compaction-by-user-fix
+++ a/Documentation/admin-guide/sysctl/vm.rst
@@ -118,7 +118,7 @@ compaction_proactiveness
 
 This tunable takes a value in the range [0, 100] with a default value of
 20. This tunable determines how aggressively compaction is done in the
-background. On write of non zero value to this tunable will immediately
+background. Write of a non zero value to this tunable will immediately
 trigger the proactive compaction. Setting it to 0 disables proactive compaction.
 
 Note that compaction has a non-trivial system-wide impact as pages
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
mm-compaction-optimize-proactive-compaction-deferrals-fix.patch
mm-compaction-support-triggering-of-proactive-compaction-by-user-fix.patch
mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

