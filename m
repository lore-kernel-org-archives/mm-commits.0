Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2806CC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 22:40:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345678AbhKXWnu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:43:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:44904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230098AbhKXWnu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Nov 2021 17:43:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B881C61059;
        Wed, 24 Nov 2021 22:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637793640;
        bh=TB6hoosx1svaSMmpmFqd9nOViFvHqQy/WOOAyKe/wAE=;
        h=Date:From:To:Subject:From;
        b=pzNwTZ1rLqwWp5W1ncI44qUGq6Fv+NjNPG8AXBUQLS/T59dGYbICcb+hSmRjh5wsh
         iOpUR/XcfJguYhNDeRTUxQFa/a/sz0zZprFUawJCCKHbwYgIpWfOmHU6x9xaySa3bJ
         Ny581ubGl4ryvGqTrgtTscANPWIVVkK/Dkx5OtnE=
Date:   Wed, 24 Nov 2021 14:40:39 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, dvyukov@google.com, elver@google.com,
        glider@google.com, jirislaby@kernel.org, jkosina@suse.cz,
        mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com
Subject:  [to-be-updated]
 kasan-distinguish-kasan-report-from-generic-bug.patch removed from -mm tree
Message-ID: <20211124224039.JU7wcYf8C%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: distinguish kasan report from generic BUG()
has been removed from the -mm tree.  Its filename was
     kasan-distinguish-kasan-report-from-generic-bug.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Jiri Kosina <jkosina@suse.cz>
Subject: kasan: distinguish kasan report from generic BUG()

The typical KASAN report always begins with

	BUG: KASAN: ....

in kernel log.  That 'BUG:' prefix creates a false impression that it's an
actual BUG() codepath being executed, and as such things like
'panic_on_oops' etc.  would work on it as expected; but that's obviously
not the case.

Switch the order of prefixes to make this distinction clear and avoid
confusion.

Link: https://lkml.kernel.org/r/nycvar.YFH.7.76.2111241839590.16505@cbobk.fhfr.pm
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/kasan/report.c~kasan-distinguish-kasan-report-from-generic-bug
+++ a/mm/kasan/report.c
@@ -86,7 +86,7 @@ __setup("kasan_multi_shot", kasan_set_mu
 
 static void print_error_description(struct kasan_access_info *info)
 {
-	pr_err("BUG: KASAN: %s in %pS\n",
+	pr_err("KASAN: BUG: %s in %pS\n",
 		kasan_get_bug_type(info), (void *)info->ip);
 	if (info->access_size)
 		pr_err("%s of size %zu at addr %px by task %s/%d\n",
@@ -366,7 +366,7 @@ void kasan_report_invalid_free(void *obj
 #endif /* IS_ENABLED(CONFIG_KUNIT) */
 
 	start_report(&flags);
-	pr_err("BUG: KASAN: double-free or invalid-free in %pS\n", (void *)ip);
+	pr_err("KASAN: BUG: double-free or invalid-free in %pS\n", (void *)ip);
 	kasan_print_tags(tag, object);
 	pr_err("\n");
 	print_address_description(object, tag);
@@ -386,7 +386,7 @@ void kasan_report_async(void)
 #endif /* IS_ENABLED(CONFIG_KUNIT) */
 
 	start_report(&flags);
-	pr_err("BUG: KASAN: invalid-access\n");
+	pr_err("KASAN: BUG: invalid-access\n");
 	pr_err("Asynchronous mode enabled: no access details available\n");
 	pr_err("\n");
 	dump_stack_lvl(KERN_ERR);
_

Patches currently in -mm which might be from jkosina@suse.cz are


