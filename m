Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2718C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:39:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C36D1206C3
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027167;
	bh=msQFkIefC80Q5vTSfqZc+2fim41CDrV4cqYbVK/r2m8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=1cMfAlVvEDk/TFjH1ATrPjR3kjTxGJ9UPBXL5rwTBIiqGWiiFkcIz6I2EIfaO6Bou
	 SDUjCVbVxYPxEnFs9nofG4Ne01lJt1hlRNL4qOE/irR4KgPP+thAgjaqQJuerL6D/I
	 w5qNPEh7yvGnElVBZ1GxocQI2hc4kQ+oIdNHzAuw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgHJCj1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:39:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:42634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCj1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:39:27 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71A542065D;
        Mon, 10 Aug 2020 02:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027166;
        bh=msQFkIefC80Q5vTSfqZc+2fim41CDrV4cqYbVK/r2m8=;
        h=Date:From:To:Subject:From;
        b=okjeBe82PCmGnO0yY4eQ4+NZwDii/lw71FR7670Ukr2q2d7Sg02vYAqVrgdYjnK2A
         Q/orH9t6QGh9xGEFn4XIkab+pgVuVU26w7YDDRHxinAgQoRTTQEmYlnAGpIZ/YpJSJ
         JFvyxwBEfc/8kffAOENYRMgU3cPgto9COC5zX+Nw=
Date:   Sun, 09 Aug 2020 19:39:26 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, ardb@kernel.org, aryabinin@virtuozzo.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        glider@google.com, lenaptr@google.com, mm-commits@vger.kernel.org,
        vincenzo.frascino@arm.com, walter-zh.wu@mediatek.com
Subject:  [merged]
 kasan-dont-tag-stacks-allocated-with-pagealloc.patch removed from -mm tree
Message-ID: <20200810023926.mn-PQjILd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: don't tag stacks allocated with pagealloc
has been removed from the -mm tree.  Its filename was
     kasan-dont-tag-stacks-allocated-with-pagealloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: don't tag stacks allocated with pagealloc

Patch series "kasan: support stack instrumentation for tag-based mode", v2.

This patch (of 5):

Prepare Software Tag-Based KASAN for stack tagging support.

With Tag-Based KASAN when kernel stacks are allocated via pagealloc (which
happens when CONFIG_VMAP_STACK is not enabled), they get tagged.  KASAN
instrumentation doesn't expect the sp register to be tagged, and this
leads to false-positive reports.

Fix by resetting the tag of kernel stack pointers after allocation.

Link: http://lkml.kernel.org/r/cover.1596199677.git.andreyknvl@google.com
Link: http://lkml.kernel.org/r/cover.1596544734.git.andreyknvl@google.com
Link: http://lkml.kernel.org/r/12d8c678869268dd0884b01271ab592f30792abf.1596544734.git.andreyknvl@google.com
Link: http://lkml.kernel.org/r/01c678b877755bcf29009176592402cdf6f2cb15.1596199677.git.andreyknvl@google.com
Link: https://bugzilla.kernel.org/show_bug.cgi?id=203497
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Walter Wu <walter-zh.wu@mediatek.com>
Cc: Elena Petrova <lenaptr@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/fork.c~kasan-dont-tag-stacks-allocated-with-pagealloc
+++ a/kernel/fork.c
@@ -261,7 +261,7 @@ static unsigned long *alloc_thread_stack
 					     THREAD_SIZE_ORDER);
 
 	if (likely(page)) {
-		tsk->stack = page_address(page);
+		tsk->stack = kasan_reset_tag(page_address(page));
 		return tsk->stack;
 	}
 	return NULL;
@@ -302,6 +302,7 @@ static unsigned long *alloc_thread_stack
 {
 	unsigned long *stack;
 	stack = kmem_cache_alloc_node(thread_stack_cache, THREADINFO_GFP, node);
+	stack = kasan_reset_tag(stack);
 	tsk->stack = stack;
 	return stack;
 }
_

Patches currently in -mm which might be from andreyknvl@google.com are


