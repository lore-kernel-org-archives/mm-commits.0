Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EA74C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:03:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EE45214D8
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709436;
	bh=c1wWo/WYHWcuEM8czQbE86tk0J4vP3Uruq6gPvDQK7w=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=A8ThvIBKIVhQGG++OhaNCU1uBQtoEUQELhGmvADMz9cmaheyILIOrebZpOXGT9GzY
	 o9UiX4vNYE/FjNehvmVFDAEGw+AI2BL/fwbgmz46Pc4DindxLzOD9RPC8zEQVKzaeL
	 UESwifRinJHhTZ3zvi6YO2wSbq9Mo3LSVGUwUNJM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730622AbgJNVD4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:03:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:53626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgJNVD4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:03:56 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96395206B2;
        Wed, 14 Oct 2020 21:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709435;
        bh=c1wWo/WYHWcuEM8czQbE86tk0J4vP3Uruq6gPvDQK7w=;
        h=Date:From:To:Subject:From;
        b=w6nUioxFZ9cczmNaSEbAMopXTxo3F++0aUgyZeTRBMb2sNswP1WxLUnLLwWnl5vJW
         trAEBUGPTLJTTpkR830yecJJLaB/QcTN1OkrV/W+fQqlDQO4F9vADyK2XopDDo94Nq
         Dn3v04abYvRugfrd3vOD1bAmViqEQOjp0t4SPrHg=
Date:   Wed, 14 Oct 2020 14:03:55 -0700
From:   akpm@linux-foundation.org
To:     mateusznosek0@gmail.com, mm-commits@vger.kernel.org
Subject:  [merged]
 include-linux-compactionh-clean-code-by-removing-unused-enum-value.patch
 removed from -mm tree
Message-ID: <20201014210355.fBCHWCyrR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/compaction.h: clean code by removing unused enum value
has been removed from the -mm tree.  Its filename was
     include-linux-compactionh-clean-code-by-removing-unused-enum-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm-page_poisonc-replace-bool-variable-with-static-key.patch

