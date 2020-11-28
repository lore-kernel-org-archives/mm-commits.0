Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53FF7C64E7C
	for <mm-commits@archiver.kernel.org>; Sat, 28 Nov 2020 17:56:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04A5E246E2
	for <mm-commits@archiver.kernel.org>; Sat, 28 Nov 2020 17:56:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NkSXe9mt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731830AbgK1Rz4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 28 Nov 2020 12:55:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:53834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732231AbgK1EUr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 27 Nov 2020 23:20:47 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1A3321973;
        Sat, 28 Nov 2020 04:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606537246;
        bh=fRtphAePVQdrNObhctcaG7jErgwK1zuYLWo0rwirOH4=;
        h=Date:From:To:Subject:From;
        b=NkSXe9mtEwx/i5U0TJyhGnXuIQhRjy4qTLkJRm22FenP7ycVoeCrKuh7Fo4Cd5gmw
         mLCRuCrkulHD6mMlkCfQUSRe/KRhV3DN7o+bI7rM4VDUpqxa11rjL0l4qVC/jE70uY
         32g7pg/3Gjd/IC5IBwfR7yhnBsdFw9yQRH0XIDIU=
Date:   Fri, 27 Nov 2020 20:20:45 -0800
From:   akpm@linux-foundation.org
To:     broonie@kernel.org, dan.j.williams@intel.com, glider@google.com,
        mhiramat@kernel.org, minchan@kernel.org,
        mm-commits@vger.kernel.org, vinmenon@codeaurora.org,
        vjitta@codeaurora.org, ylal@codeaurora.org, zhenhuah@codeaurora.org
Subject:  +
 lib-stackdepot-add-support-to-configure-stack_hash_size.patch added to -mm
 tree
Message-ID: <20201128042045._tVB28VY1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: stackdepot: add support to configure STACK_HASH_SIZE
has been added to the -mm tree.  Its filename is
     lib-stackdepot-add-support-to-configure-stack_hash_size.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-stackdepot-add-support-to-configure-stack_hash_size.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-stackdepot-add-support-to-configure-stack_hash_size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 lib/stackdepot.c |   27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

--- a/lib/stackdepot.c~lib-stackdepot-add-support-to-configure-stack_hash_size
+++ a/lib/stackdepot.c
@@ -141,14 +141,31 @@ static struct stack_record *depot_alloc_
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
+	kstrtouint(str, 0, &stack_hash_order);
+	return 0;
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

lib-stackdepot-add-support-to-configure-stack_hash_size.patch

