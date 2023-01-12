Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 612A8C678D7
	for <mm-commits@archiver.kernel.org>; Thu, 12 Jan 2023 00:15:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235329AbjALAPe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Jan 2023 19:15:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235480AbjALAPU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2023 19:15:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A6931C416
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 16:15:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2540561781
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 00:15:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB03C433EF;
        Thu, 12 Jan 2023 00:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673482518;
        bh=CXMj8j02A4J1+nbU7NYFrJ7JWg6nI+/63kQxu+/ZKE8=;
        h=Date:To:From:Subject:From;
        b=WeSnNRJoBBYV94bBYk3mymsHmvZ4kc2EwEgelpUwRk0Y6fRu3SNabz06L7dg3v3sQ
         /73AjWN+apfdPbOCpZ7T0o27iPmk9v/B7odXyrvidyfoRxQjUoNQWtUgjHR0HZJnp4
         yLjLzd/iI2iZ10li3oTfFzbI2tmIdeGiOvQwS09g=
Date:   Wed, 11 Jan 2023 16:15:17 -0800
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, lkp@intel.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kasan-mark-kasan_kunit_executing-as-static.patch removed from -mm tree
Message-Id: <20230112001518.7AB03C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: mark kasan_kunit_executing as static
has been removed from the -mm tree.  Its filename was
     kasan-mark-kasan_kunit_executing-as-static.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: mark kasan_kunit_executing as static
Date: Wed, 4 Jan 2023 02:09:33 +0100

Mark kasan_kunit_executing as static, as it is only used within
mm/kasan/report.c.

Link: https://lkml.kernel.org/r/f64778a4683b16a73bba72576f73bf4a2b45a82f.1672794398.git.andreyknvl@google.com
Fixes: c8c7016f50c8 ("kasan: fail non-kasan KUnit tests on KASAN reports")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kasan/report.c~kasan-mark-kasan_kunit_executing-as-static
+++ a/mm/kasan/report.c
@@ -119,7 +119,7 @@ EXPORT_SYMBOL_GPL(kasan_restore_multi_sh
  * Whether the KASAN KUnit test suite is currently being executed.
  * Updated in kasan_test.c.
  */
-bool kasan_kunit_executing;
+static bool kasan_kunit_executing;
 
 void kasan_kunit_test_suite_start(void)
 {
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-allow-sampling-page_alloc-allocations-for-hw_tags.patch

