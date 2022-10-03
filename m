Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6107EC43219
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:10:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiJCVKb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiJCVI3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:08:29 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F594F645
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:06:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 32D2CCE0E7A
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:06:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EDF7C43470;
        Mon,  3 Oct 2022 21:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831189;
        bh=EZLnZuBsZvgBTbiH9vRP6djX7b5q+1TJ+Kkfs16cYXY=;
        h=Date:To:From:Subject:From;
        b=2AnP5r/ibe0/qhzd3uP2RBmAKZ7q6Gz7WCDuXbX62yOWN19peuAQu53YQrMSQnjap
         L6oaC6VsUY53tqv9C4VrgDbDBliPeOjdQkctVrnQgkH10BUdagBecgcsqt1oaNTsRR
         cKdk/iTuE9mz7uw/tB4plGzZm+qqFDYLmmr23L84=
Date:   Mon, 03 Oct 2022 14:06:28 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-better-invalid-double-free-report-header.patch removed from -mm tree
Message-Id: <20221003210629.7EDF7C43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: better invalid/double-free report header
has been removed from the -mm tree.  Its filename was
     kasan-better-invalid-double-free-report-header.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: better invalid/double-free report header
Date: Sun, 11 Sep 2022 01:25:30 +0200

Update the report header for invalid- and double-free bugs to contain the
address being freed:

BUG: KASAN: invalid-free in kfree+0x280/0x2a8
Free of addr ffff00000beac001 by task kunit_try_catch/99

Link: https://lkml.kernel.org/r/fce40f8dbd160972fe01a1ff39d0c426c310e4b7.1662852281.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c         |   23 ++++++++++++++++-------
 mm/kasan/report_generic.c |    3 ++-
 mm/kasan/report_tags.c    |    2 +-
 3 files changed, 19 insertions(+), 9 deletions(-)

--- a/mm/kasan/report.c~kasan-better-invalid-double-free-report-header
+++ a/mm/kasan/report.c
@@ -175,17 +175,14 @@ static void end_report(unsigned long *fl
 
 static void print_error_description(struct kasan_report_info *info)
 {
-	if (info->type == KASAN_REPORT_INVALID_FREE) {
-		pr_err("BUG: KASAN: invalid-free in %pS\n", (void *)info->ip);
-		return;
-	}
+	pr_err("BUG: KASAN: %s in %pS\n", info->bug_type, (void *)info->ip);
 
-	if (info->type == KASAN_REPORT_DOUBLE_FREE) {
-		pr_err("BUG: KASAN: double-free in %pS\n", (void *)info->ip);
+	if (info->type != KASAN_REPORT_ACCESS) {
+		pr_err("Free of addr %px by task %s/%d\n",
+			info->access_addr, current->comm, task_pid_nr(current));
 		return;
 	}
 
-	pr_err("BUG: KASAN: %s in %pS\n", info->bug_type, (void *)info->ip);
 	if (info->access_size)
 		pr_err("%s of size %zu at addr %px by task %s/%d\n",
 			info->is_write ? "Write" : "Read", info->access_size,
@@ -420,6 +417,18 @@ static void complete_report_info(struct
 	} else
 		info->cache = info->object = NULL;
 
+	switch (info->type) {
+	case KASAN_REPORT_INVALID_FREE:
+		info->bug_type = "invalid-free";
+		break;
+	case KASAN_REPORT_DOUBLE_FREE:
+		info->bug_type = "double-free";
+		break;
+	default:
+		/* bug_type filled in by kasan_complete_mode_report_info. */
+		break;
+	}
+
 	/* Fill in mode-specific report info fields. */
 	kasan_complete_mode_report_info(info);
 }
--- a/mm/kasan/report_generic.c~kasan-better-invalid-double-free-report-header
+++ a/mm/kasan/report_generic.c
@@ -132,7 +132,8 @@ void kasan_complete_mode_report_info(str
 	struct kasan_alloc_meta *alloc_meta;
 	struct kasan_free_meta *free_meta;
 
-	info->bug_type = get_bug_type(info);
+	if (!info->bug_type)
+		info->bug_type = get_bug_type(info);
 
 	if (!info->cache || !info->object)
 		return;
--- a/mm/kasan/report_tags.c~kasan-better-invalid-double-free-report-header
+++ a/mm/kasan/report_tags.c
@@ -37,7 +37,7 @@ void kasan_complete_mode_report_info(str
 	bool is_free;
 	bool alloc_found = false, free_found = false;
 
-	if (!info->cache || !info->object) {
+	if ((!info->cache || !info->object) && !info->bug_type) {
 		info->bug_type = get_common_bug_type(info);
 		return;
 	}
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-fix-array-bounds-warnings-in-tests.patch

