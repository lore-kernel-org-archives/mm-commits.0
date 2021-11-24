Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7E5CC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 21:20:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243836AbhKXVYG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Nov 2021 16:24:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:41800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232874AbhKXVYF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Nov 2021 16:24:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8EB260F41;
        Wed, 24 Nov 2021 21:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637788855;
        bh=AKxHwaFoHYDIZV66odvrDrOiKNb3VLC0owrZVJdhjEU=;
        h=Date:From:To:Subject:From;
        b=f+y+gM1UOvJzRYf5Ilkx2yyCFTzQV8lqZmiqTKwnTU6y2jmHcSUxrFd+1KB6cfMIq
         Q/1oie4l2l9IM1DwsRu84fk+ZiK72x8/qbVx6UsLuUKVI0+8iuj9FuIXiMLEgwu5yp
         BYuiSABIswVrQELKPxgMvvHe5kBJyX6uHHjYQt3s=
Date:   Wed, 24 Nov 2021 13:20:54 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, dvyukov@google.com, elver@google.com,
        glider@google.com, jirislaby@kernel.org, jkosina@suse.cz,
        mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com
Subject:  + kasan-distinguish-kasan-report-from-generic-bug.patch
 added to -mm tree
Message-ID: <20211124212054.GQBSK_Ilb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: distinguish kasan report from generic BUG()
has been added to the -mm tree.  Its filename is
     kasan-distinguish-kasan-report-from-generic-bug.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-distinguish-kasan-report-from-generic-bug.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-distinguish-kasan-report-from-generic-bug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kasan-distinguish-kasan-report-from-generic-bug.patch

