Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75EF7C00A5A
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 00:44:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbjARAo6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 17 Jan 2023 19:44:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbjARAnv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2023 19:43:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F35222E9
        for <mm-commits@vger.kernel.org>; Tue, 17 Jan 2023 16:23:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF98E61596
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 00:23:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA49C433EF;
        Wed, 18 Jan 2023 00:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674001413;
        bh=oLkh933GcGexnSVGja86Xds7o5ID31pEOEakwpWNrfk=;
        h=Date:To:From:Subject:From;
        b=orFhQIxswgiPq7978HP+x7mwfVbthOr3yVbgCG9exIow4t+JyuHALU6Q4xBMCQzb4
         hv5qfKLA0wQ5G6CfPc905hvcRFeGb4s1pblrSBy9DnDmMEqmbpPGkL+nCn4KHj7DEE
         e+xbW5GOX9ePlQd7eqcPplJ37TwdsZD9ZCYzUC6o=
Date:   Tue, 17 Jan 2023 16:23:32 -0800
To:     mm-commits@vger.kernel.org, rppt@kernel.org, mgorman@suse.de,
        david@redhat.com, anshuman.khandual@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-repalce-with-deferred_pages_enabled-wherever-applicable.patch added to mm-unstable branch
Message-Id: <20230118002333.0DA49C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: use deferred_pages_enabled() wherever applicable
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-repalce-with-deferred_pages_enabled-wherever-applicable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-repalce-with-deferred_pages_enabled-wherever-applicable.patch

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
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/page_alloc: use deferred_pages_enabled() wherever applicable
Date: Thu, 5 Jan 2023 13:55:06 +0530

Instead of directly accessing static deferred_pages, replace such
instances with the helper deferred_pages_enabled().  No functional change
is intended.

Link: https://lkml.kernel.org/r/20230105082506.241529-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/page_alloc.c~mm-page_alloc-repalce-with-deferred_pages_enabled-wherever-applicable
+++ a/mm/page_alloc.c
@@ -4288,7 +4288,7 @@ retry:
 			 * Watermark failed for this zone, but see if we can
 			 * grow this zone if it contains deferred pages.
 			 */
-			if (static_branch_unlikely(&deferred_pages)) {
+			if (deferred_pages_enabled()) {
 				if (_deferred_grow_zone(zone, order))
 					goto try_this_zone;
 			}
@@ -4337,7 +4337,7 @@ try_this_zone:
 		} else {
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 			/* Try again if zone has deferred pages */
-			if (static_branch_unlikely(&deferred_pages)) {
+			if (deferred_pages_enabled()) {
 				if (_deferred_grow_zone(zone, order))
 					goto try_this_zone;
 			}
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-page_alloc-repalce-with-deferred_pages_enabled-wherever-applicable.patch

