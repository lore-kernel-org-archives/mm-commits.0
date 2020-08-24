Return-Path: <SRS0=GeP8=CC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CC68C433E3
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 20:18:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4647E2074D
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 20:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598300307;
	bh=HNilDAcwX/+fZzbtfBxZW4tKRxPcbHEYUMAq/eOJpSQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=on+TPweY6F3HLwQ/xKydakJta8jxKAsriNUOZHYf+80QSQX6Mfb+mNkwU3d2oAMbu
	 sm+x4zpYPJMwoenJJcRA+EPFJD9qhm8oaA8bzRCM6rqJYF7AXCtq9Qj/ccsOTr8VVc
	 iiXSYL1/1O8HWjSL+iBVFQsMZBnhAgzyvRtwA7mA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgHXUS1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Aug 2020 16:18:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:41374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726531AbgHXUSZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Aug 2020 16:18:25 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1AE52074D;
        Mon, 24 Aug 2020 20:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598300303;
        bh=HNilDAcwX/+fZzbtfBxZW4tKRxPcbHEYUMAq/eOJpSQ=;
        h=Date:From:To:Subject:From;
        b=aCUO481R1acFE2tiGeVpEb1qHNno2AguJjTOHMJhFAf8eSYbluk/1lLChHgYE6xUL
         aat3im5EjaXt0EP7E7lgXK63S3bwUL5PHraiNLHA4I3QSsxPb8owzWG/CCSWVYFdVL
         /fj9EoV0PMNGxzoEnXDkxy+xxiXcmc6/wU88xyu0=
Date:   Mon, 24 Aug 2020 13:18:22 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  +
 lib-dynamic_queue_limits-delete-duplicated-words-fix-typo.patch added to
 -mm tree
Message-ID: <20200824201822.TE4tpElWx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: dynamic_queue_limits: delete duplicated words + fix typo
has been added to the -mm tree.  Its filename is
     lib-dynamic_queue_limits-delete-duplicated-words-fix-typo.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-dynamic_queue_limits-delete-duplicated-words-fix-typo.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-dynamic_queue_limits-delete-duplicated-words-fix-typo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: lib: dynamic_queue_limits: delete duplicated words + fix typo

Drop the repeated word "the".
Fix spelling of "excess".

Link: https://lkml.kernel.org/r/20200823040449.25946-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dynamic_queue_limits.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/dynamic_queue_limits.c~lib-dynamic_queue_limits-delete-duplicated-words-fix-typo
+++ a/lib/dynamic_queue_limits.c
@@ -60,8 +60,8 @@ void dql_completed(struct dql *dql, unsi
 		 * A decrease is only considered if the queue has been busy in
 		 * the whole interval (the check above).
 		 *
-		 * If there is slack, the amount of execess data queued above
-		 * the the amount needed to prevent starvation, the queue limit
+		 * If there is slack, the amount of excess data queued above
+		 * the amount needed to prevent starvation, the queue limit
 		 * can be decreased.  To avoid hysteresis we consider the
 		 * minimum amount of slack found over several iterations of the
 		 * completion routine.
_

Patches currently in -mm which might be from rdunlap@infradead.org are

fs-ocfs2-delete-repeated-words-in-comments.patch
fs-configfs-delete-repeated-words-in-comments.patch
lib-bitmap-delete-duplicated-words.patch
lib-libcrc32c-delete-duplicated-words.patch
lib-decompress_bunzip2-delete-duplicated-words.patch
lib-devres-delete-duplicated-words.patch
lib-dynamic_queue_limits-delete-duplicated-words-fix-typo.patch
lib-earlycpio-delete-duplicated-words.patch
lib-radix-tree-delete-duplicated-words.patch
lib-syscall-delete-duplicated-words.patch
lib-test_sysctl-delete-duplicated-words.patch

