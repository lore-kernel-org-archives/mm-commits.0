Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 299C4C433EF
	for <mm-commits@archiver.kernel.org>; Sun, 27 Feb 2022 21:51:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbiB0Vvv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 27 Feb 2022 16:51:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbiB0Vvv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 27 Feb 2022 16:51:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2916E517C5
        for <mm-commits@vger.kernel.org>; Sun, 27 Feb 2022 13:51:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B34626113C
        for <mm-commits@vger.kernel.org>; Sun, 27 Feb 2022 21:51:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08FC5C340E9;
        Sun, 27 Feb 2022 21:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645998673;
        bh=t98CYAxnSVQ9rTqA22rbHcPHPHragw6NTavW2UoXugA=;
        h=Date:To:From:Subject:From;
        b=yX0Uc4W0DeSrb5+ze+CX3OVShvwtr7zaPkaFVapNSc7tWb+gmRp8vSqCU2CxmJK7a
         UKb7JUO/m4M3ta3hIbD1zDUdXtRLV6VJ3cL39LLWnx1zJ75NvQqTY/R1tPoQv8y78m
         trYX2+1gy2zjTPB6HNLxfJzzvdT0NVYlSd8cRaFQ=
Date:   Sun, 27 Feb 2022 13:51:12 -0800
To:     mm-commits@vger.kernel.org, linux@treblig.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-strtobool-for-param-parsing.patch added to -mm tree
Message-Id: <20220227215113.08FC5C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_table_check.c: use strtobool for param parsing
has been added to the -mm tree.  Its filename is
     mm-use-strtobool-for-param-parsing.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-use-strtobool-for-param-parsing.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-use-strtobool-for-param-parsing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-use-strtobool-for-param-parsing.patch

