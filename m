Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90DB2C43463
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 03:33:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5637521897
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 03:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600486432;
	bh=GQEiYJPp95810r4O+Rd/PPJtV98KjbJ037qaQ3jseyk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=14UUAwLRZE/0nSRUHk7YW154/Z4acdbaHcVTZ0+feO+jKj5VoFodFdamYFH5jcMM1
	 gkZwJdt6qGKS1hIR8joc1tgqgEhx93HBAXmA4NEAWjIUiWzLjXYjrI4dhC3llTqyZq
	 r/giovFiBidiKg5KbpJFr+VSXfWdw07586pv2xWc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgISDdw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Sep 2020 23:33:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbgISDdv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Sep 2020 23:33:51 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39DF421707;
        Sat, 19 Sep 2020 03:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600486431;
        bh=GQEiYJPp95810r4O+Rd/PPJtV98KjbJ037qaQ3jseyk=;
        h=Date:From:To:Subject:From;
        b=rqXeU8BxP6w0V49oLjuBUu+BwivAEqtf1M1HbgVRNkjD5m/Su0B1v/eJiQsn/jR29
         CsJ7x7XaaiMlVB9vtl26BPoxqV2xasxUYjrMDZIMhaq7wtKWvhS5vpZXuEFKB9kalc
         4dd25vFTA+G2jYRiZfMRBJbVuL+quTIfLD2sHhTo=
Date:   Fri, 18 Sep 2020 20:33:50 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mateusznosek0@gmail.com
Subject:  +
 include-linux-compactionh-clean-code-by-removing-unused-enum-value.patch
 added to -mm tree
Message-ID: <20200919033350.b9bRr%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/compaction.h: clean code by removing unused enum value
has been added to the -mm tree.  Its filename is
     include-linux-compactionh-clean-code-by-removing-unused-enum-value.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/include-linux-compactionh-clean-code-by-removing-unused-enum-value.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/include-linux-compactionh-clean-code-by-removing-unused-enum-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mateusz Nosek <mateusznosek0@gmail.com>
Subject: include/linux/compaction.h: clean code by removing unused enum value

The enum value 'COMPACT_INACTIVE' is never used so can be removed.

Link: https://lkml.kernel.org/r/20200917110750.12015-1-mateusznosek0@gmail.com
Signed-off-by: Mateusz Nosek <mateusznosek0@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |    3 ---
 1 file changed, 3 deletions(-)

--- a/include/linux/compaction.h~include-linux-compactionh-clean-code-by-removing-unused-enum-value
+++ a/include/linux/compaction.h
@@ -29,9 +29,6 @@ enum compact_result {
 	/* compaction didn't start as it was deferred due to past failures */
 	COMPACT_DEFERRED,
 
-	/* compaction not active last round */
-	COMPACT_INACTIVE = COMPACT_DEFERRED,
-
 	/* For more detailed tracepoint output - internal to compaction */
 	COMPACT_NO_SUITABLE_PAGE,
 	/* compaction should continue to another pageblock */
_

Patches currently in -mm which might be from mateusznosek0@gmail.com are

mm-slabc-clean-code-by-removing-redundant-if-condition.patch
mm-page_allocc-clean-code-by-removing-unnecessary-initialization.patch
mm-page_allocc-micro-optimization-remove-unnecessary-branch.patch
mm-page_allocc-fix-early-params-garbage-value-accesses.patch
mm-page_allocc-clean-code-by-merging-two-functions.patch
mmzone-clean-code-by-removing-unused-macro-parameter.patch
mm-compactionc-micro-optimization-remove-unnecessary-branch.patch
include-linux-compactionh-clean-code-by-removing-unused-enum-value.patch

