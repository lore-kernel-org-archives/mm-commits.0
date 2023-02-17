Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D93ADC64EC4
	for <mm-commits@archiver.kernel.org>; Fri, 17 Feb 2023 04:44:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbjBQEof (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Feb 2023 23:44:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjBQEo1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Feb 2023 23:44:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5040C4346A
        for <mm-commits@vger.kernel.org>; Thu, 16 Feb 2023 20:44:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E02766112C
        for <mm-commits@vger.kernel.org>; Fri, 17 Feb 2023 04:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412CAC4339B;
        Fri, 17 Feb 2023 04:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676609065;
        bh=dLdU+WUiUs5L30TI1wdR4dzGoPnwhP1DmsLzt2vA0NY=;
        h=Date:To:From:Subject:From;
        b=vRtpq6RtL/BjuIvq2R9/WGdRFxoyRwlrb65PPBj8p7JnTH0buh6R+WID9xBQ1LuiZ
         WEbS3QCoBfbV+f+s3BgrczhxztqOQ7EWveWAIw+/VFPogX/ba/SCoB9ap7iGTNrA42
         VVKeTiKKMTbR+HcrBmhjSaVlS3Ir0ckdG6tExFy0=
Date:   Thu, 16 Feb 2023 20:44:24 -0800
To:     mm-commits@vger.kernel.org, glider@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-stackdepot-lower-the-indentation-in-stack_depot_init.patch removed from -mm tree
Message-Id: <20230217044425.412CAC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/stackdepot: lower the indentation in stack_depot_init
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-lower-the-indentation-in-stack_depot_init.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: lib/stackdepot: lower the indentation in stack_depot_init
Date: Fri, 10 Feb 2023 22:15:54 +0100

stack_depot_init does most things inside an if check. Move them out and
use a goto statement instead.

No functional changes.

Link: https://lkml.kernel.org/r/8e382f1f0c352e4b2ad47326fec7782af961fe8e.1676063693.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/stackdepot.c~lib-stackdepot-lower-the-indentation-in-stack_depot_init
+++ a/lib/stackdepot.c
@@ -165,46 +165,50 @@ int __init stack_depot_early_init(void)
 int stack_depot_init(void)
 {
 	static DEFINE_MUTEX(stack_depot_init_mutex);
+	unsigned long entries;
 	int ret = 0;
 
 	mutex_lock(&stack_depot_init_mutex);
-	if (!stack_depot_disabled && !stack_table) {
-		unsigned long entries;
 
-		/*
-		 * Similarly to stack_depot_early_init, use stack_hash_order
-		 * if assigned, and rely on automatic scaling otherwise.
-		 */
-		if (stack_hash_order) {
-			entries = 1UL << stack_hash_order;
-		} else {
-			int scale = STACK_HASH_SCALE;
-
-			entries = nr_free_buffer_pages();
-			entries = roundup_pow_of_two(entries);
-
-			if (scale > PAGE_SHIFT)
-				entries >>= (scale - PAGE_SHIFT);
-			else
-				entries <<= (PAGE_SHIFT - scale);
-		}
-
-		if (entries < 1UL << STACK_HASH_ORDER_MIN)
-			entries = 1UL << STACK_HASH_ORDER_MIN;
-		if (entries > 1UL << STACK_HASH_ORDER_MAX)
-			entries = 1UL << STACK_HASH_ORDER_MAX;
-
-		pr_info("allocating hash table of %lu entries via kvcalloc\n",
-				entries);
-		stack_table = kvcalloc(entries, sizeof(struct stack_record *), GFP_KERNEL);
-		if (!stack_table) {
-			pr_err("hash table allocation failed, disabling\n");
-			stack_depot_disabled = true;
-			ret = -ENOMEM;
-		}
-		stack_hash_mask = entries - 1;
+	if (stack_depot_disabled || stack_table)
+		goto out_unlock;
+
+	/*
+	 * Similarly to stack_depot_early_init, use stack_hash_order
+	 * if assigned, and rely on automatic scaling otherwise.
+	 */
+	if (stack_hash_order) {
+		entries = 1UL << stack_hash_order;
+	} else {
+		int scale = STACK_HASH_SCALE;
+
+		entries = nr_free_buffer_pages();
+		entries = roundup_pow_of_two(entries);
+
+		if (scale > PAGE_SHIFT)
+			entries >>= (scale - PAGE_SHIFT);
+		else
+			entries <<= (PAGE_SHIFT - scale);
+	}
+
+	if (entries < 1UL << STACK_HASH_ORDER_MIN)
+		entries = 1UL << STACK_HASH_ORDER_MIN;
+	if (entries > 1UL << STACK_HASH_ORDER_MAX)
+		entries = 1UL << STACK_HASH_ORDER_MAX;
+
+	pr_info("allocating hash table of %lu entries via kvcalloc\n", entries);
+	stack_table = kvcalloc(entries, sizeof(struct stack_record *), GFP_KERNEL);
+	if (!stack_table) {
+		pr_err("hash table allocation failed, disabling\n");
+		stack_depot_disabled = true;
+		ret = -ENOMEM;
+		goto out_unlock;
 	}
+	stack_hash_mask = entries - 1;
+
+out_unlock:
 	mutex_unlock(&stack_depot_init_mutex);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(stack_depot_init);
_

Patches currently in -mm which might be from andreyknvl@google.com are


