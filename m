Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03F66C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:48:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236760AbiCVVtv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236898AbiCVVtg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:49:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A15EBC97
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:48:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4438EB81DC6
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:48:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2891C340EC;
        Tue, 22 Mar 2022 21:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985685;
        bh=z4mrUtnlH4ASlAaRrDE7qBye07gqXWEm8RyBeOgfDUg=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=pRCETW4PfGSJG7SNdsnvUnmZ9SbeV6hGwg+H7+R8b0nxEdqFvqHypdVf5nE9IzaTX
         mAnUkPczsvQTBJeCua8MVUfIza7RQvr4Lq9+T8sobQLyTSV1Op1TraRLpJw3xRvLnb
         Rk967EdWg+/9meC3yyq2fg8uwWAFcq8C8TO4pnsM=
Date:   Tue, 22 Mar 2022 14:48:04 -0700
To:     linux@treblig.org, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 188/227] mm/page_table_check.c: use strtobool for param parsing
Message-Id: <20220322214804.F2891C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
