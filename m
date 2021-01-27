Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04A50C433E6
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jan 2021 23:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9CDB60C41
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jan 2021 23:12:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234812AbhA0XMy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Jan 2021 18:12:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:41582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234512AbhA0XKi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 Jan 2021 18:10:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1B2A64DD0;
        Wed, 27 Jan 2021 23:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611788929;
        bh=LMytW73qApcOO9tvX4oDgRFQp6PQQLGPQu0AI5CSKoA=;
        h=Date:From:To:Subject:From;
        b=mlXYCx62peT3iDUXbrUR5ZEO+gX06BZaD8mc3nNM3uAqXWbIifRa58qPo948mogaN
         7Qp2jTnLeZaOlcglPc+KBDIBcvxU7jWwxOfe/VxZ43w7D6Z4sjq0VYdx0SiDXIIzkA
         DbUMK0xwnRAF8QEqCzCMdM1sWqTCnx27te1sQXXc=
Date:   Wed, 27 Jan 2021 15:08:48 -0800
From:   akpm@linux-foundation.org
To:     glider@google.com, minchan@kernel.org, mm-commits@vger.kernel.org,
        vinmenon@codeaurora.org, vjitta@codeaurora.org, ylal@codeaurora.org
Subject:  + lib-stackdepot-add-support-to-disable-stack-depot.patch
 added to -mm tree
Message-ID: <20210127230848.jcU6QReXs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: stackdepot: add support to disable stack depot
has been added to the -mm tree.  Its filename is
     lib-stackdepot-add-support-to-disable-stack-depot.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-stackdepot-add-support-to-disable-stack-depot.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-stackdepot-add-support-to-disable-stack-depot.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vijayanand Jitta <vjitta@codeaurora.org>
Subject: lib: stackdepot: add support to disable stack depot

Add a kernel parameter stack_depot_disable to disable stack depot.  So
that stack hash table doesn't consume any memory when stack depot is
disabled.

The use case is CONFIG_PAGE_OWNER without page_owner=on.  Without this
patch, stackdepot will consume the memory for the hashtable.  By default,
it's 8M which is never trivial.

With this option, in CONFIG_PAGE_OWNER configured system, page_owner=off,
stack_depot_disable in kernel command line, we could save the wasted
memory for the hashtable.

Link: https://lkml.kernel.org/r/1611749198-24316-2-git-send-email-vjitta@codeaurora.org
Signed-off-by: Vinayak Menon <vinmenon@codeaurora.org>
Signed-off-by: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Yogesh Lal <ylal@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    6 ++
 include/linux/stackdepot.h                      |    1 
 init/main.c                                     |    2 
 lib/stackdepot.c                                |   32 ++++++++++++--
 4 files changed, 37 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~lib-stackdepot-add-support-to-disable-stack-depot
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -5132,6 +5132,12 @@
 			growing up) the main stack are reserved for no other
 			mapping. Default value is 256 pages.
 
+	stack_depot_disable= [KNL]
+			Setting this to true through kernel command line will
+			disable the stack depot thereby saving the static memory
+			consumed by the stack hash table. By default this is set
+			to false.
+
 	stacktrace	[FTRACE]
 			Enabled the stack tracer on boot up.
 
--- a/include/linux/stackdepot.h~lib-stackdepot-add-support-to-disable-stack-depot
+++ a/include/linux/stackdepot.h
@@ -21,4 +21,5 @@ unsigned int stack_depot_fetch(depot_sta
 
 unsigned int filter_irq_stacks(unsigned long *entries, unsigned int nr_entries);
 
+int stack_depot_init(void);
 #endif
--- a/init/main.c~lib-stackdepot-add-support-to-disable-stack-depot
+++ a/init/main.c
@@ -98,6 +98,7 @@
 #include <linux/mem_encrypt.h>
 #include <linux/kcsan.h>
 #include <linux/init_syscalls.h>
+#include <linux/stackdepot.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -828,6 +829,7 @@ static void __init mm_init(void)
 	init_mem_debugging_and_hardening();
 	kfence_alloc_pool();
 	report_meminit();
+	stack_depot_init();
 	mem_init();
 	/* page_owner must be initialized after buddy is ready */
 	page_ext_init_flatmem_late();
--- a/lib/stackdepot.c~lib-stackdepot-add-support-to-disable-stack-depot
+++ a/lib/stackdepot.c
@@ -31,6 +31,7 @@
 #include <linux/stackdepot.h>
 #include <linux/string.h>
 #include <linux/types.h>
+#include <linux/memblock.h>
 
 #define DEPOT_STACK_BITS (sizeof(depot_stack_handle_t) * 8)
 
@@ -145,9 +146,32 @@ static struct stack_record *depot_alloc_
 #define STACK_HASH_MASK (STACK_HASH_SIZE - 1)
 #define STACK_HASH_SEED 0x9747b28c
 
-static struct stack_record *stack_table[STACK_HASH_SIZE] = {
-	[0 ...	STACK_HASH_SIZE - 1] = NULL
-};
+static bool stack_depot_disable;
+static struct stack_record **stack_table;
+
+static int __init is_stack_depot_disabled(char *str)
+{
+	kstrtobool(str, &stack_depot_disable);
+	if (stack_depot_disable) {
+		pr_info("Stack Depot is disabled\n");
+		stack_table = NULL;
+	}
+	return 0;
+}
+early_param("stack_depot_disable", is_stack_depot_disabled);
+
+int __init stack_depot_init(void)
+{
+	if (!stack_depot_disable) {
+		size_t size = (STACK_HASH_SIZE * sizeof(struct stack_record *));
+		int i;
+
+		stack_table = memblock_alloc(size, size);
+		for (i = 0; i < STACK_HASH_SIZE;  i++)
+			stack_table[i] = NULL;
+	}
+	return 0;
+}
 
 /* Calculate hash for a stack */
 static inline u32 hash_stack(unsigned long *entries, unsigned int size)
@@ -241,7 +265,7 @@ depot_stack_handle_t stack_depot_save(un
 	unsigned long flags;
 	u32 hash;
 
-	if (unlikely(nr_entries == 0))
+	if (unlikely(nr_entries == 0) || stack_depot_disable)
 		goto fast_exit;
 
 	hash = hash_stack(entries, nr_entries);
_

Patches currently in -mm which might be from vjitta@codeaurora.org are

lib-stackdepot-add-support-to-disable-stack-depot.patch

