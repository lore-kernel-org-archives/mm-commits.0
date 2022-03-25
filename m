Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C74EC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357464AbiCYBge (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345772AbiCYBfR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7306C1C85
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:33:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56956B82725
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:33:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E9EBC340EC;
        Fri, 25 Mar 2022 01:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171979;
        bh=Hu2OmJP+EVSvP6il5dEkE/3MTagjyE1XDAU9QenOkC4=;
        h=Date:To:From:Subject:From;
        b=Qvh2CWpX4ZCZuI8dg8e+WOGFl0zl4cqzosezbjBW08B+K8IKR8EVcBlhPAOwgumoN
         yT+AyveJ1mKat6qhMzbIoBokxKPWxuOFbWNQmR1dadzqKyaDeKMehlqvrhudPi1+v2
         mmNKvhB72CJxBn974oE4j8Sed67cYBu2rRoWtTT4=
Date:   Thu, 24 Mar 2022 18:32:58 -0700
To:     mm-commits@vger.kernel.org, linux@treblig.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-use-strtobool-for-param-parsing.patch removed from -mm tree
Message-Id: <20220325013259.0E9EBC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_table_check.c: use strtobool for param parsing
has been removed from the -mm tree.  Its filename was
     mm-use-strtobool-for-param-parsing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Dr. David Alan Gilbert" <linux@treblig.org>
Subject: mm/page_table_check.c: use strtobool for param parsing

Use strtobool rather than open coding "on" and "off" parsing.

Link: https://lkml.kernel.org/r/20220227181038.126926-1-linux@treblig.org
Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_table_check.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/mm/page_table_check.c~mm-use-strtobool-for-param-parsing
+++ a/mm/page_table_check.c
@@ -23,15 +23,7 @@ EXPORT_SYMBOL(page_table_check_disabled)
 
 static int __init early_page_table_check_param(char *buf)
 {
-	if (!buf)
-		return -EINVAL;
-
-	if (strcmp(buf, "on") == 0)
-		__page_table_check_enabled = true;
-	else if (strcmp(buf, "off") == 0)
-		__page_table_check_enabled = false;
-
-	return 0;
+	return strtobool(buf, &__page_table_check_enabled);
 }
 
 early_param("page_table_check", early_page_table_check_param);
_

Patches currently in -mm which might be from linux@treblig.org are


