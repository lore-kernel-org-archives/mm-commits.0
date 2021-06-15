Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E5EDC48BE8
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 22:49:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2804A6023E
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 22:49:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbhFOWvb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Jun 2021 18:51:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:38160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229898AbhFOWva (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Jun 2021 18:51:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF03A61246;
        Tue, 15 Jun 2021 22:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623797365;
        bh=0i5AcW3kaYkFALky3gHZTWMpee+iJ7do4P8THxuNwRc=;
        h=Date:From:To:Subject:From;
        b=OPWBuI+qDwQFo8nimyW/+XPzCS8+Bp6Fwnk/4qtoZsUwiD+nbLuG1Vw+YFZ2jBcvG
         nl8QiQwAAvxPm2bemiUgjSnkmpC+ye28kHQKrZ5Mv2pEUcnPKNjdUKy3CqjeF2PHUx
         bgUWbCO5mpuNw4jItkORRuqIrLMCkHIuF6PSJ5/Q=
Date:   Tue, 15 Jun 2021 15:49:25 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, mm-commits@vger.kernel.org, willy@infradead.org
Subject:  +
 =?US-ASCII?Q?writeback-cgroup-release-dying-cgwbs-by-switching-attache?=
 =?US-ASCII?Q?d-inodes-fix-3.patch?= added to -mm tree
Message-ID: <20210615224925.voqVNc_x0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm writeback,cgroup: fix documentation
has been added to the -mm tree.  Its filename is
     writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes-fix-3.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes-fix-3.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm writeback,cgroup: fix documentation

cleanup_offline_cgwbs_workfn() is a static function, so it doesn't need
kernel-doc.  Also remove the inaccurate comment about the locking.

Link: https://lkml.kernel.org/r/20210615200242.1716568-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/backing-dev.c~writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes-fix-3
+++ a/mm/backing-dev.c
@@ -645,15 +645,12 @@ static void cgwb_bdi_unregister(struct b
 	mutex_unlock(&bdi->cgwb_release_mutex);
 }
 
-/**
- * cleanup_offline_cgwbs - try to release dying cgwbs
+/*
+ * cleanup_offline_cgwbs_workfn - try to release dying cgwbs
  *
  * Try to release dying cgwbs by switching attached inodes to the nearest
  * living ancestor's writeback. Processed wbs are placed at the end
  * of the list to guarantee the forward progress.
- *
- * Should be called with the acquired cgwb_lock lock, which might
- * be released and re-acquired in the process.
  */
 static void cleanup_offline_cgwbs_workfn(struct work_struct *work)
 {
_

Patches currently in -mm which might be from willy@infradead.org are

mm-mark-idle-page-tracking-as-broken.patch
writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes-fix-3.patch
mm-make-__dump_page-static.patch
mm-debug-factor-pagepoisoned-out-of-__dump_page.patch
mm-page_owner-constify-dump_page_owner.patch
mm-make-compound_head-const-preserving.patch
mm-constify-get_pfnblock_flags_mask-and-get_pfnblock_migratetype.patch
mm-constify-page_count-and-page_ref_count.patch
mm-optimise-nth_page-for-contiguous-memmap.patch

