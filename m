Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3464AC3DA7A
	for <mm-commits@archiver.kernel.org>; Fri,  6 Jan 2023 02:09:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjAFCJW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Jan 2023 21:09:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjAFCJV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2023 21:09:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E65061471
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 18:09:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E13EE61CCB
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 02:09:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C54DC433D2;
        Fri,  6 Jan 2023 02:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672970959;
        bh=L0bcperUpZYiWpoQmfy3ICEs98jXf8GkYVWzcI+y/1U=;
        h=Date:To:From:Subject:From;
        b=vlIq7PgDF9TqEn42z4xNqWf6ACA4iWjKlGW9wtWxAI+iln+g68YhtAPoqRoXs9CK+
         0YVXle8j32OJY+B3FuayENRbRrXEJzTSsv8AFLxAdsFrZ+n5fZyyC/Rt4y91DuKQK5
         h/TNLJ7zMmnFTzj9q/4nR9H0hKg7wIjrpFdw4m5I=
Date:   Thu, 05 Jan 2023 18:09:18 -0800
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, lkp@intel.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-mark-kasan_kunit_executing-as-static.patch added to mm-hotfixes-unstable branch
Message-Id: <20230106020919.3C54DC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: mark kasan_kunit_executing as static
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kasan-mark-kasan_kunit_executing-as-static.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-mark-kasan_kunit_executing-as-static.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

kasan-mark-kasan_kunit_executing-as-static.patch
kasan-allow-sampling-page_alloc-allocations-for-hw_tags.patch

