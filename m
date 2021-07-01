Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FC05C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:03:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F6A961469
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:03:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238296AbhGABFi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:05:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:59564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238280AbhGABFh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:05:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52ABB61424;
        Thu,  1 Jul 2021 01:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625101387;
        bh=GypuV+ddpj4E9mAp7/L9Yk8asFXrNRvhFlgd9rweh3w=;
        h=Date:From:To:Subject:From;
        b=YRRSjOlS9dv20qadQ0oycv51NBa1/MrcIIYtejFQDxkw/V+b3r4FXVsBe3n2YnJim
         /vbClhNMeRHrmS41IydUv2WXNZk9wFrw+OQ1UttAGOHjIOVGPqHxApBY4l8y6eZzDs
         dhyVdWjxn9ABPAx30ejoDEpWzDNR17lis1gkYv1U=
Date:   Wed, 30 Jun 2021 18:03:06 -0700
From:   akpm@linux-foundation.org
To:     andy.shevchenko@gmail.com, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au
Subject:  [folded-merged]
 kernelh-split-out-kstrtox-and-simple_strtox-to-a-separate-header-fix.patch
 removed from -mm tree
Message-ID: <20210701010306.CqiZbRUaX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kstrtox: fix documentation references
has been removed from the -mm tree.  Its filename was
     kernelh-split-out-kstrtox-and-simple_strtox-to-a-separate-header-fix.patch

This patch was dropped because it was folded into kernelh-split-out-kstrtox-and-simple_strtox-to-a-separate-header.patch

------------------------------------------------------
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: kstrtox: fix documentation references

After moving declarations of kstrto*() to a separate header, update the doc.

Link: https://lkml.kernel.org/r/20210615220003.377901-1-andy.shevchenko@gmail.com
Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/kernel-api.rst |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/Documentation/core-api/kernel-api.rst~kernelh-split-out-kstrtox-and-simple_strtox-to-a-separate-header-fix
+++ a/Documentation/core-api/kernel-api.rst
@@ -24,11 +24,8 @@ String Conversions
 .. kernel-doc:: lib/vsprintf.c
    :export:
 
-.. kernel-doc:: include/linux/kernel.h
-   :functions: kstrtol
-
-.. kernel-doc:: include/linux/kernel.h
-   :functions: kstrtoul
+.. kernel-doc:: include/linux/kstrtox.h
+   :functions: kstrtol kstrtoul
 
 .. kernel-doc:: lib/kstrtox.c
    :export:
_

Patches currently in -mm which might be from andy.shevchenko@gmail.com are

kernelh-split-out-kstrtox-and-simple_strtox-to-a-separate-header.patch

