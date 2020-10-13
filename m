Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DD23C4363A
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:57:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF60B22248
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633424;
	bh=SEUFeky0vEF7n+XQJ4Hq3rZmdE6BRm0SbiP4Z75ncRY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=oWQwGK6NgJxcFrQrBZUivpopv31wIFDWt4BmaH0cK3xcxI0gTDuDRvBp7uTGI5t0X
	 7iRGoOQcohYMklYFUpPFix/dfH9TQz8pJXq8J8Tm4bDFBvQAD+OhXuhF+COrQtVJlE
	 4CAtddw7ZclchhBtiZY+pOnDkqbYPVhALr9Avt7w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387742AbgJMX5D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:57:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:42814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389233AbgJMX5C (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:57:02 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2598D2223F;
        Tue, 13 Oct 2020 23:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633422;
        bh=SEUFeky0vEF7n+XQJ4Hq3rZmdE6BRm0SbiP4Z75ncRY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=loiZMj47oe9oBYU6aLCnVxRfCmAUIDevyXMEhfLL85fZKeQj/9YN1Gsh3R/qbmVew
         WS/JKZDuD/KUoCW98OjYnLhuL/ekyinxIKjN2GAUpPLarnItCDf2w4qpCyLeVLKbNS
         7hsEEoLogZVHQ/D6OOqpH6VDHkwMbhdUslWG5WnU=
Date:   Tue, 13 Oct 2020 16:57:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mateusznosek0@gmail.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 157/181] include/linux/compaction.h: clean code by
 removing unused enum value
Message-ID: <20201013235701.o_FDdlld5%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
