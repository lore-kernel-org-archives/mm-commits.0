Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11CEBC61DA4
	for <mm-commits@archiver.kernel.org>; Mon,  6 Mar 2023 20:59:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbjCFU7i (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Mar 2023 15:59:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjCFU7g (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Mar 2023 15:59:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C08498A1
        for <mm-commits@vger.kernel.org>; Mon,  6 Mar 2023 12:59:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FED7B81128
        for <mm-commits@vger.kernel.org>; Mon,  6 Mar 2023 20:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF0F5C433EF;
        Mon,  6 Mar 2023 20:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678136368;
        bh=gCYELjDaj0q43d2getloFIPcbvY0PeL4/BoqsOAd5iI=;
        h=Date:To:From:Subject:From;
        b=z2i+Ki5Y7XRRd12ovCKhvQo0KbWqb8cbqOoHpZTcAHwIUCp0vz4952ByZuJD6Fufh
         fWtLSYU9TOC5aqWgAuFLDQR3tHi3mcsyLmGjuaBNDZZ4hiJn2HNCC7tx53xbI02J+q
         V/8ghXp89+bw+MoDVniLgimjKS4vK52zBHvBpslo=
Date:   Mon, 06 Mar 2023 12:59:28 -0800
To:     mm-commits@vger.kernel.org, syzkaller@googlegroups.com,
        elver@google.com, dvyukov@google.com, andreyknvl@gmail.com,
        glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-kmsan-mark-api-outputs-as-initialized.patch added to mm-unstable branch
Message-Id: <20230306205928.CF0F5C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: kmsan: mark API outputs as initialized
has been added to the -mm mm-unstable branch.  Its filename is
     lib-stackdepot-kmsan-mark-api-outputs-as-initialized.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-kmsan-mark-api-outputs-as-initialized.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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

x86-kmsan-dont-rename-memintrinsics-in-uninstrumented-files.patch
kmsan-another-take-at-fixing-memcpy-tests.patch
x86-kmsan-use-c-versions-of-memset16-memset32-memset64.patch
kmsan-add-memsetxx-tests.patch
lib-stackdepot-kmsan-mark-api-outputs-as-initialized.patch
kmsan-add-test_stackdepot_roundtrip.patch

