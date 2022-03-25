Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98E24C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 19:39:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbiCYTkg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 15:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233537AbiCYTkK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 15:40:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C597620832C
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 12:12:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7F6EB829A5
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 18:35:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68881C2BBE4;
        Fri, 25 Mar 2022 18:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648233314;
        bh=uspCMhKyzl3Rc3qG/RkMG5pnC5zl9CdtKOuw7p2jK3c=;
        h=Date:To:From:Subject:From;
        b=XvYklnecQzKCYNX3Vbltm44BFxGYPP6tiT52gSNEp93baIZHOlP83f0xpuM+mN2lP
         4Kg3hNqf4feVul71Rm/pfV6yIRr0Fr/MmbpBc8CGPTnMgjkhMR7pFImLp+HyRBZWiu
         v5BkW9WWg56IJ+PT3SSOsj2fG0wVDspWJVy1drKQ=
Date:   Fri, 25 Mar 2022 11:35:13 -0700
To:     mm-commits@vger.kernel.org, yi.zhang@huawei.com, vbabka@suse.cz,
        torvalds@linux-foundation.org, surenb@google.com, rppt@kernel.org,
        mgorman@techsingularity.net, dave.hansen@linux.intel.com,
        corbet@lwn.net, charante@codeaurora.org, jsavitz@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-sysctl-document-page_lock_unfairness.patch added to -mm tree
Message-Id: <20220325183514.68881C2BBE4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/sysctl: document page_lock_unfairness
has been added to the -mm tree.  Its filename is
     documentation-sysctl-document-page_lock_unfairness.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/documentation-sysctl-document-page_lock_unfairness.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/documentation-sysctl-document-page_lock_unfairness.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joel Savitz <jsavitz@redhat.com>
Subject: Documentation/sysctl: document page_lock_unfairness

commit 5ef64cc8987a ("mm: allow a controlled amount of unfairness in the
page lock") introduced a new systctl but no accompanying documentation.

Add a simple entry to the documentation.

Link: https://lkml.kernel.org/r/20220325164437.120246-1-jsavitz@redhat.com
Signed-off-by: Joel Savitz <jsavitz@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: Charan Teja Reddy <charante@codeaurora.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/vm.rst |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/Documentation/admin-guide/sysctl/vm.rst~documentation-sysctl-document-page_lock_unfairness
+++ a/Documentation/admin-guide/sysctl/vm.rst
@@ -62,6 +62,7 @@ Currently, these files are in /proc/sys/
 - overcommit_memory
 - overcommit_ratio
 - page-cluster
+- page_lock_unfairness
 - panic_on_oom
 - percpu_pagelist_high_fraction
 - stat_interval
@@ -754,6 +755,14 @@ extra faults and I/O delays for followin
 that consecutive pages readahead would have brought in.
 
 
+page_lock_unfairness
+====================
+
+This value determines the number of times that the page lock can be
+stolen from under a waiter. After the lock is stolen the number of times
+specified in this file (default is 5), the "fair lock handoff" semantics
+will apply, and the waiter will only be awakened if the lock can be taken.
+
 panic_on_oom
 ============
 
_

Patches currently in -mm which might be from jsavitz@redhat.com are

documentation-sysctl-document-page_lock_unfairness.patch

