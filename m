Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33F07C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:22:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbjC1XW5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjC1XWD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:22:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DAAC35A0
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:21:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF346619EF
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:21:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33801C4339B;
        Tue, 28 Mar 2023 23:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045711;
        bh=0U7CwfN7mtEc3yu8iyVcEMX3tjIR1eAJgXOZAlEwPL0=;
        h=Date:To:From:Subject:From;
        b=vfx/nJexPtp+yGv15ifEIxZ+cVd33WbbZr4fztuKBECUdkp4SnJilPL5ExL241j8D
         8ayTJELYuMoFvRx5NwOcyeqxxYQ8dFgy1Aj1q5ERtQlCAky0d4ZLqx+Ls3r8TGqG0M
         D5z/5ZJhFYyUFLjMOZ4eYjmjuiB05ngr4XzRpZ/0=
Date:   Tue, 28 Mar 2023 16:21:50 -0700
To:     mm-commits@vger.kernel.org, syzkaller@googlegroups.com,
        elver@google.com, dvyukov@google.com, andreyknvl@gmail.com,
        glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-stackdepot-kmsan-mark-api-outputs-as-initialized.patch removed from -mm tree
Message-Id: <20230328232151.33801C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/stackdepot: kmsan: mark API outputs as initialized
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-kmsan-mark-api-outputs-as-initialized.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: lib/stackdepot: kmsan: mark API outputs as initialized
Date: Mon, 6 Mar 2023 12:13:21 +0100

KMSAN does not instrument stackdepot and may treat memory allocated by it
as uninitialized.  This is not a problem for KMSAN itself, because its
functions calling stackdepot API are also not instrumented.  But other
kernel features (e.g.  netdev tracker) may access stack depot from
instrumented code, which will lead to false positives, unless we
explicitly mark stackdepot outputs as initialized.

Link: https://lkml.kernel.org/r/20230306111322.205724-1-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Suggested-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/lib/stackdepot.c~lib-stackdepot-kmsan-mark-api-outputs-as-initialized
+++ a/lib/stackdepot.c
@@ -17,6 +17,7 @@
 #include <linux/gfp.h>
 #include <linux/jhash.h>
 #include <linux/kernel.h>
+#include <linux/kmsan.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
 #include <linux/percpu.h>
@@ -306,6 +307,11 @@ depot_alloc_stack(unsigned long *entries
 	stack->handle.extra = 0;
 	memcpy(stack->entries, entries, flex_array_size(stack, entries, size));
 	pool_offset += required_size;
+	/*
+	 * Let KMSAN know the stored stack record is initialized. This shall
+	 * prevent false positive reports if instrumented code accesses it.
+	 */
+	kmsan_unpoison_memory(stack, required_size);
 
 	return stack;
 }
@@ -465,6 +471,12 @@ unsigned int stack_depot_fetch(depot_sta
 	struct stack_record *stack;
 
 	*entries = NULL;
+	/*
+	 * Let KMSAN know *entries is initialized. This shall prevent false
+	 * positive reports if instrumented code accesses it.
+	 */
+	kmsan_unpoison_memory(entries, sizeof(*entries));
+
 	if (!handle)
 		return 0;
 
_

Patches currently in -mm which might be from glider@google.com are


