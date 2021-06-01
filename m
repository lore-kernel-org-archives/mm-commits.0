Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A0A9C47092
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 20:34:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26FDD613C0
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 20:34:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234783AbhFAUfo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Jun 2021 16:35:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234513AbhFAUfn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 1 Jun 2021 16:35:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F33B861026;
        Tue,  1 Jun 2021 20:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622579641;
        bh=8OvxQQF8sB9dnV0ceYf2QlP7QBkOxegMVpVKPgwOFRw=;
        h=Date:From:To:Subject:From;
        b=wVZOnqRtUjUsCfTMnmSFs4kBQj3VDZcPoneWhCpz2B21ZKA5SuneGXUR/q2PodJNi
         ZHjU9y3Z9I/bVBlCdX05FdWozkk2DhhVZkGCgYW1KrymEsNWzppyE8QY6vEt3VIe0Y
         1O9H7RERJsBn/nKYjjoR/OXkxO8uC1Bin3EB43tE=
Date:   Tue, 01 Jun 2021 13:34:00 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, ak@linux.intel.com, ben.widawsky@intel.com,
        dan.j.williams@intel.com, dave.hansen@intel.com,
        feng.tang@intel.com, mgorman@techsingularity.net,
        mhocko@kernel.org, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        rientjes@google.com, vbabka@suse.cz, ying.huang@intel.com
Subject:  +
 =?US-ASCII?Q?mm-mempolicy-unify-the-parameter-sanity-check-for-mbind-an?=
 =?US-ASCII?Q?d-set=5Fmempolicy-v4.patch?= added to -mm tree
Message-ID: <20210601203400.At6aDRYh4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: unify the parameter sanity check for mbind and set_mempolicy
has been added to the -mm tree.  Its filename is
     mm-mempolicy-unify-the-parameter-sanity-check-for-mbind-and-set_mempolicy-v4.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-unify-the-parameter-sanity-check-for-mbind-and-set_mempolicy-v4.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-unify-the-parameter-sanity-check-for-mbind-and-set_mempolicy-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Feng Tang <feng.tang@intel.com>
Subject: mm/mempolicy: unify the parameter sanity check for mbind and set_mempolicy

add comment

Link: https://lkml.kernel.org/r/1622560492-1294-4-git-send-email-feng.tang@intel.com
Signed-off-by: Feng Tang <feng.tang@intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/mempolicy.c~mm-mempolicy-unify-the-parameter-sanity-check-for-mbind-and-set_mempolicy-v4
+++ a/mm/mempolicy.c
@@ -1440,6 +1440,7 @@ static int copy_nodes_to_user(unsigned l
 	return copy_to_user(mask, nodes_addr(*nodes), copy) ? -EFAULT : 0;
 }
 
+/* Basic parameter sanity check used by both mbind() and set_mempolicy() */
 static inline int sanitize_mpol_flags(int *mode, unsigned short *flags)
 {
 	*flags = *mode & MPOL_MODE_FLAGS;
_

Patches currently in -mm which might be from feng.tang@intel.com are

mm-mempolicy-cleanup-nodemask-intersection-check-for-oom.patch
mm-mempolicy-dont-handle-mpol_local-like-a-fake-mpol_preferred-policy.patch
mm-mempolicy-dont-handle-mpol_local-like-a-fake-mpol_preferred-policy-v4.patch
mm-mempolicy-unify-the-parameter-sanity-check-for-mbind-and-set_mempolicy.patch
mm-mempolicy-unify-the-parameter-sanity-check-for-mbind-and-set_mempolicy-v4.patch

