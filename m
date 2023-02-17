Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CF25C05027
	for <mm-commits@archiver.kernel.org>; Fri, 17 Feb 2023 04:44:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjBQEoX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Feb 2023 23:44:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjBQEoW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Feb 2023 23:44:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD1B37F06
        for <mm-commits@vger.kernel.org>; Thu, 16 Feb 2023 20:44:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A0C760FF1
        for <mm-commits@vger.kernel.org>; Fri, 17 Feb 2023 04:44:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 600D3C433D2;
        Fri, 17 Feb 2023 04:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676609060;
        bh=gFUOY1BP0VsZonbZ8rM0hU0eiD4p+Qi2ym2+yvBQdwk=;
        h=Date:To:From:Subject:From;
        b=rQPwpU+dixc79RrQ2SebyJdTBBIxyQlKbtkssZbZz2Pio8pBhHULoTwh3imeJoQa2
         6oeT1+wqBBBDDo2+O9gmoBwBTTw3xIQbzk3fjHcDG/eSK37EnLxHj6lEabPRhgH8JH
         4Zt4gtc+eHrccbPYSDtNhDNdI/6Fmxy70hqm7BOU=
Date:   Thu, 16 Feb 2023 20:44:19 -0800
To:     mm-commits@vger.kernel.org, glider@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-stackdepot-use-pr_fmt-to-define-message-format.patch removed from -mm tree
Message-Id: <20230217044420.600D3C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/stackdepot: use pr_fmt to define message format
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-use-pr_fmt-to-define-message-format.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: lib/stackdepot: use pr_fmt to define message format
Date: Fri, 10 Feb 2023 22:15:50 +0100

Use pr_fmt to define the format for printing stack depot messages instead
of duplicating the "Stack Depot" prefix in each message.

Link: https://lkml.kernel.org/r/3d09db0171a0e92ff3eb0ee74de74558bc9b56c4.1676063693.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/stackdepot.c~lib-stackdepot-use-pr_fmt-to-define-message-format
+++ a/lib/stackdepot.c
@@ -19,6 +19,8 @@
  * Based on code by Dmitry Chernenkov.
  */
 
+#define pr_fmt(fmt) "stackdepot: " fmt
+
 #include <linux/gfp.h>
 #include <linux/jhash.h>
 #include <linux/kernel.h>
@@ -98,7 +100,7 @@ static int __init is_stack_depot_disable
 
 	ret = kstrtobool(str, &stack_depot_disable);
 	if (!ret && stack_depot_disable) {
-		pr_info("Stack Depot is disabled\n");
+		pr_info("disabled\n");
 		stack_table = NULL;
 	}
 	return 0;
@@ -142,7 +144,7 @@ int __init stack_depot_early_init(void)
 						1UL << STACK_HASH_ORDER_MAX);
 
 	if (!stack_table) {
-		pr_err("Stack Depot hash table allocation failed, disabling\n");
+		pr_err("hash table allocation failed, disabling\n");
 		stack_depot_disable = true;
 		return -ENOMEM;
 	}
@@ -177,11 +179,11 @@ int stack_depot_init(void)
 		if (entries > 1UL << STACK_HASH_ORDER_MAX)
 			entries = 1UL << STACK_HASH_ORDER_MAX;
 
-		pr_info("Stack Depot allocating hash table of %lu entries with kvcalloc\n",
+		pr_info("allocating hash table of %lu entries with kvcalloc\n",
 				entries);
 		stack_table = kvcalloc(entries, sizeof(struct stack_record *), GFP_KERNEL);
 		if (!stack_table) {
-			pr_err("Stack Depot hash table allocation failed, disabling\n");
+			pr_err("hash table allocation failed, disabling\n");
 			stack_depot_disable = true;
 			ret = -ENOMEM;
 		}
_

Patches currently in -mm which might be from andreyknvl@google.com are


