Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90BC5C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 00:55:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79B6461474
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 00:55:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236324AbhGAA5e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 20:57:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:58130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232066AbhGAA5e (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 20:57:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91B86610A7;
        Thu,  1 Jul 2021 00:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625100904;
        bh=hcy8AE9T880ojXg1t+Ur4hA/uSFatqNPzJmkGCr0GdY=;
        h=Date:From:To:Subject:From;
        b=NyqHybNgAgRpIkYBFHq3CsqHVFeG9ALMjVXx/s9pWZ2RSiemmdIsh7yVHLswhruMk
         We7DEsMEihUIpgWwQnrxj7JlG9n5SiDA0QoGOAhc0CT6XPb+LVklBTzX/PHwdH/RYw
         qIwlN2duqvRJjaiQfI09H7n9jXdoBcK0BK4OuZ6A=
Date:   Wed, 30 Jun 2021 17:55:04 -0700
From:   akpm@linux-foundation.org
To:     feng.tang@intel.com, mhocko@suse.com, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-mempolicy-dont-handle-mpol=5Flocal-like-a-fake-mpol=5Fp?=
 =?US-ASCII?Q?referred-policy-v4-fix.patch?= removed from -mm tree
Message-ID: <20210701005504.ZQNGGXU2L%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mempolicy-dont-handle-mpol_local-like-a-fake-mpol_preferred-policy-v4-fix
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-dont-handle-mpol_local-like-a-fake-mpol_preferred-policy-v4-fix.patch

This patch was dropped because it was folded into mm-mempolicy-dont-handle-mpol_local-like-a-fake-mpol_preferred-policy.patch

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
mm-mempolicy-unify-the-parameter-sanity-check-for-mbind-and-set_mempolicy.patch
mm-mempolicy-unify-the-parameter-sanity-check-for-mbind-and-set_mempolicy-v4.patch

