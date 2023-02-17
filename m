Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D443C636D6
	for <mm-commits@archiver.kernel.org>; Fri, 17 Feb 2023 04:44:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjBQEod (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Feb 2023 23:44:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBQEo0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Feb 2023 23:44:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6D442DFE
        for <mm-commits@vger.kernel.org>; Thu, 16 Feb 2023 20:44:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DD33B82B21
        for <mm-commits@vger.kernel.org>; Fri, 17 Feb 2023 04:44:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076FBC4339B;
        Fri, 17 Feb 2023 04:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676609063;
        bh=64J8Pe0Z+ZIR1lLwFllOyC7VhTE97xjdtp0rTTRaRrU=;
        h=Date:To:From:Subject:From;
        b=WW0cSJawezsYvJViWkZKELe2jhYMthVMifPntSbjhmXdjXNiUuhS41JtVvr5SMAC+
         V31C1iayeXCsKLU3ZIl2q3y9HR5sn/L8fgSojsgQHLayYQQi2jE4tLwr45B6np5JzC
         VDXAtnYNBmhI/Glr4iQKQrlsflQTX4PgQsrldTV8=
Date:   Thu, 16 Feb 2023 20:44:22 -0800
To:     mm-commits@vger.kernel.org, glider@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-stackdepot-rename-stack_depot_disable.patch removed from -mm tree
Message-Id: <20230217044423.076FBC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/stackdepot: rename stack_depot_disable
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-rename-stack_depot_disable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: lib/stackdepot: rename stack_depot_disable
Date: Fri, 10 Feb 2023 22:15:52 +0100

Rename stack_depot_disable to stack_depot_disabled to make its name look
similar to the names of other stack depot flags.

Also put stack_depot_disabled's definition together with the other flags.

Also rename is_stack_depot_disabled to disable_stack_depot: this name
looks more conventional for a function that processes a boot parameter.

No functional changes.

Link: https://lkml.kernel.org/r/d78a07d222e689926e5ead229e4a2e3d87dc9aa7.1676063693.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/stackdepot.c~lib-stackdepot-rename-stack_depot_disable
+++ a/lib/stackdepot.c
@@ -71,6 +71,7 @@ struct stack_record {
 	unsigned long entries[];	/* Variable-sized array of entries. */
 };
 
+static bool stack_depot_disabled;
 static bool __stack_depot_early_init_requested __initdata = IS_ENABLED(CONFIG_STACKDEPOT_ALWAYS_INIT);
 static bool __stack_depot_early_init_passed __initdata;
 
@@ -91,21 +92,20 @@ static DEFINE_RAW_SPINLOCK(depot_lock);
 static unsigned int stack_hash_order;
 static unsigned int stack_hash_mask;
 
-static bool stack_depot_disable;
 static struct stack_record **stack_table;
 
-static int __init is_stack_depot_disabled(char *str)
+static int __init disable_stack_depot(char *str)
 {
 	int ret;
 
-	ret = kstrtobool(str, &stack_depot_disable);
-	if (!ret && stack_depot_disable) {
+	ret = kstrtobool(str, &stack_depot_disabled);
+	if (!ret && stack_depot_disabled) {
 		pr_info("disabled\n");
 		stack_table = NULL;
 	}
 	return 0;
 }
-early_param("stack_depot_disable", is_stack_depot_disabled);
+early_param("stack_depot_disable", disable_stack_depot);
 
 void __init stack_depot_request_early_init(void)
 {
@@ -128,7 +128,7 @@ int __init stack_depot_early_init(void)
 	if (kasan_enabled() && !stack_hash_order)
 		stack_hash_order = STACK_HASH_ORDER_MAX;
 
-	if (!__stack_depot_early_init_requested || stack_depot_disable)
+	if (!__stack_depot_early_init_requested || stack_depot_disabled)
 		return 0;
 
 	if (stack_hash_order)
@@ -145,7 +145,7 @@ int __init stack_depot_early_init(void)
 
 	if (!stack_table) {
 		pr_err("hash table allocation failed, disabling\n");
-		stack_depot_disable = true;
+		stack_depot_disabled = true;
 		return -ENOMEM;
 	}
 
@@ -158,7 +158,7 @@ int stack_depot_init(void)
 	int ret = 0;
 
 	mutex_lock(&stack_depot_init_mutex);
-	if (!stack_depot_disable && !stack_table) {
+	if (!stack_depot_disabled && !stack_table) {
 		unsigned long entries;
 		int scale = STACK_HASH_SCALE;
 
@@ -184,7 +184,7 @@ int stack_depot_init(void)
 		stack_table = kvcalloc(entries, sizeof(struct stack_record *), GFP_KERNEL);
 		if (!stack_table) {
 			pr_err("hash table allocation failed, disabling\n");
-			stack_depot_disable = true;
+			stack_depot_disabled = true;
 			ret = -ENOMEM;
 		}
 		stack_hash_mask = entries - 1;
@@ -353,7 +353,7 @@ depot_stack_handle_t __stack_depot_save(
 	 */
 	nr_entries = filter_irq_stacks(entries, nr_entries);
 
-	if (unlikely(nr_entries == 0) || stack_depot_disable)
+	if (unlikely(nr_entries == 0) || stack_depot_disabled)
 		goto fast_exit;
 
 	hash = hash_stack(entries, nr_entries);
_

Patches currently in -mm which might be from andreyknvl@google.com are


