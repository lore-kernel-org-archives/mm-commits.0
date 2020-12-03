Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D701C4361A
	for <mm-commits@archiver.kernel.org>; Thu,  3 Dec 2020 20:33:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 329A6221F2
	for <mm-commits@archiver.kernel.org>; Thu,  3 Dec 2020 20:33:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728324AbgLCUdq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Dec 2020 15:33:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:46192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726915AbgLCUdq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Dec 2020 15:33:46 -0500
Date:   Thu, 03 Dec 2020 12:33:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607027586;
        bh=VhLNH66xuZu7tvdjMFERbHL8lQmH0oB9Ej64+P8CRuU=;
        h=From:To:Subject:From;
        b=C+Fp4DvBFSAZq/BonIVWMQLiN9hPCXhaL3Ve6otvpYeulvWihAAGz67RyLJrviWzA
         OGguhinzEs1rNBzlcmUVqhNYkfx7yip/EKnFIK3WvI1XvGDrSFSRZZiEYtXQyoxCKc
         32HSxx1GZ2GJpa79tW5t4Jg5IGCpfdg70A3+RSTE=
From:   akpm@linux-foundation.org
To:     broonie@kernel.org, dan.j.williams@intel.com, glider@google.com,
        mhiramat@kernel.org, minchan@kernel.org,
        mm-commits@vger.kernel.org, vinmenon@codeaurora.org,
        vjitta@codeaurora.org, ylal@codeaurora.org, zhenhuah@codeaurora.org
Subject:  [failures]
 lib-stackdepot-add-support-to-configure-stack_hash_size.patch removed from
 -mm tree
Message-ID: <20201203203304.mg6ClYQU4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: stackdepot: add support to configure STACK_HASH_SIZE
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-add-support-to-configure-stack_hash_size.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Yogesh Lal <ylal@codeaurora.org>
Subject: lib: stackdepot: add support to configure STACK_HASH_SIZE

Add a kernel parameter stack_hash_order to configure STACK_HASH_SIZE.

Aim is to have configurable value for STACK_HASH_SIZE, so that one can
configure it depending on usecase there by reducing the static memory
overhead.

One example is of Page Owner, default value of STACK_HASH_SIZE lead stack
depot to consume 8MB of static memory.  Making it configurable and use
lower value helps to enable features like CONFIG_PAGE_OWNER without any
significant overhead.

[akpm@linux-foundation.org: fix warning]
Link: https://lkml.kernel.org/r/1606365835-3242-1-git-send-email-vjitta@codeaurora.org
Suggested-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Yogesh Lal <ylal@codeaurora.org>
Signed-off-by: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: Zhenhua Huang <zhenhuah@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

--- a/lib/stackdepot.c~lib-stackdepot-add-support-to-configure-stack_hash_size
+++ a/lib/stackdepot.c
@@ -141,14 +141,30 @@ static struct stack_record *depot_alloc_
 	return stack;
 }
 
-#define STACK_HASH_ORDER 20
-#define STACK_HASH_SIZE (1L << STACK_HASH_ORDER)
+static unsigned int stack_hash_order = 20;
+#define STACK_HASH_SIZE (1L << stack_hash_order)
 #define STACK_HASH_MASK (STACK_HASH_SIZE - 1)
 #define STACK_HASH_SEED 0x9747b28c
 
-static struct stack_record *stack_table[STACK_HASH_SIZE] = {
-	[0 ...	STACK_HASH_SIZE - 1] = NULL
-};
+static struct stack_record **stack_table;
+
+static int __init setup_stack_hash_order(char *str)
+{
+	return kstrtouint(str, 0, &stack_hash_order);
+}
+early_param("stack_hash_order", setup_stack_hash_order);
+
+static int __init init_stackdepot(void)
+{
+	int i;
+
+	stack_table = kvmalloc(sizeof(struct stack_record *) * STACK_HASH_SIZE, GFP_KERNEL);
+	for (i = 0; i < STACK_HASH_SIZE; i++)
+		stack_table[i] = NULL;
+	return 0;
+}
+
+early_initcall(init_stackdepot);
 
 /* Calculate hash for a stack */
 static inline u32 hash_stack(unsigned long *entries, unsigned int size)
_

Patches currently in -mm which might be from ylal@codeaurora.org are


