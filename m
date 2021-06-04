Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7425C47082
	for <mm-commits@archiver.kernel.org>; Fri,  4 Jun 2021 02:35:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9498661407
	for <mm-commits@archiver.kernel.org>; Fri,  4 Jun 2021 02:35:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbhFDCgp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Jun 2021 22:36:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhFDCgp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Jun 2021 22:36:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A95846140A;
        Fri,  4 Jun 2021 02:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622774086;
        bh=5eB4j3d0Mk+a6IO1kG2vWjwvndRheyEv1/SnslN0i18=;
        h=Date:From:To:Subject:From;
        b=o+5vjZes/ExCEBLatHLUzTAtnsx/v55/9DUUbEralYr8KcLAv9S1Chhpgp6sSYNgK
         rQCnvO7cETynYvYxTs8vKaEV22iYkNwux65XNI7UkXSz7Y9fORFS6uzaVTMFpOawdo
         fh+8LrXwBRsBLaphJEGwt9g5odv2BHRDZGdDIWLg=
Date:   Thu, 03 Jun 2021 19:34:46 -0700
From:   akpm@linux-foundation.org
To:     feng.tang@intel.com, mhocko@suse.com, mm-commits@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?mm-mempolicy-dont-handle-mpol=5Flocal-like-a-fake-mpol=5Fp?=
 =?US-ASCII?Q?referred-policy-v4-fix.patch?= added to -mm tree
Message-ID: <20210604023446.Dtl-7iYb3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mempolicy-dont-handle-mpol_local-like-a-fake-mpol_preferred-policy-v4-fix
has been added to the -mm tree.  Its filename is
     mm-mempolicy-dont-handle-mpol_local-like-a-fake-mpol_preferred-policy-v4-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-dont-handle-mpol_local-like-a-fake-mpol_preferred-policy-v4-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-dont-handle-mpol_local-like-a-fake-mpol_preferred-policy-v4-fix.patch

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
Subject: mm-mempolicy-dont-handle-mpol_local-like-a-fake-mpol_preferred-policy-v4-fix

refine code and comments of mpol_set_nodemask(), per Michal

Link: https://lkml.kernel.org/r/20210603081807.GE56979@shbuild999.sh.intel.com
Signed-off-by: Feng Tang <feng.tang@intel.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-dont-handle-mpol_local-like-a-fake-mpol_preferred-policy-v4-fix
+++ a/mm/mempolicy.c
@@ -226,11 +226,12 @@ static int mpol_set_nodemask(struct memp
 {
 	int ret;
 
-	/* if mode is MPOL_DEFAULT, pol is NULL. This is right. */
-	if (pol == NULL)
-		return 0;
-
-	if (pol->mode == MPOL_LOCAL)
+	/*
+	 * Default (pol==NULL) resp. local memory policies are not a
+	 * subject of any remapping. They also do not need any special
+	 * constructor.
+	 */
+	if (!pol || pol->mode == MPOL_LOCAL)
 		return 0;
 
 	/* Check N_MEMORY */
_

Patches currently in -mm which might be from feng.tang@intel.com are

mm-mempolicy-cleanup-nodemask-intersection-check-for-oom.patch
mm-mempolicy-dont-handle-mpol_local-like-a-fake-mpol_preferred-policy.patch
mm-mempolicy-dont-handle-mpol_local-like-a-fake-mpol_preferred-policy-v4.patch
mm-mempolicy-dont-handle-mpol_local-like-a-fake-mpol_preferred-policy-v4-fix.patch
mm-mempolicy-unify-the-parameter-sanity-check-for-mbind-and-set_mempolicy.patch
mm-mempolicy-unify-the-parameter-sanity-check-for-mbind-and-set_mempolicy-v4.patch

