Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C109FC433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:10:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiJCVK1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbiJCVIY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:08:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE7614D01
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:06:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 392CA610A3
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:06:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94780C433C1;
        Mon,  3 Oct 2022 21:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831185;
        bh=7xKC9coFEtjZKEhWi2Z6bzpoKu064Q2KuxU6EYOnqhc=;
        h=Date:To:From:Subject:From;
        b=QWk3C0eUv40vYyl3iuEZS506KAiig0AvDVE3nR8YJ9e/HfVk/8eaUAbd4q3BnnO8I
         ble4fs+0G9X4CcAjqRR1czqbDtTk7owZgOjBs+Jbq+TAqQesLfujGDLfMJRbmtzqo0
         ZYcR3v3nonTGS62jiAace6qoEEsFNoe2vM2cc8Bo=
Date:   Mon, 03 Oct 2022 14:06:24 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-better-identify-bug-types-for-tag-based-modes.patch removed from -mm tree
Message-Id: <20221003210625.94780C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: better identify bug types for tag-based modes
has been removed from the -mm tree.  Its filename was
     kasan-better-identify-bug-types-for-tag-based-modes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: better identify bug types for tag-based modes
Date: Mon, 5 Sep 2022 23:05:48 +0200

Identify the bug type for the tag-based modes based on the stack trace
entries found in the stack ring.

If a free entry is found first (meaning that it was added last), mark the
bug as use-after-free.  If an alloc entry is found first, mark the bug as
slab-out-of-bounds.  Otherwise, assign the common bug type.

This change returns the functionalify of the previously dropped
CONFIG_KASAN_TAGS_IDENTIFY.

Link: https://lkml.kernel.org/r/13ce7fa07d9d995caedd1439dfae4d51401842f2.1662411800.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report_tags.c |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

--- a/mm/kasan/report_tags.c~kasan-better-identify-bug-types-for-tag-based-modes
+++ a/mm/kasan/report_tags.c
@@ -10,7 +10,7 @@
 
 extern struct kasan_stack_ring stack_ring;
 
-static const char *get_bug_type(struct kasan_report_info *info)
+static const char *get_common_bug_type(struct kasan_report_info *info)
 {
 	/*
 	 * If access_size is a negative number, then it has reason to be
@@ -37,9 +37,8 @@ void kasan_complete_mode_report_info(str
 	bool is_free;
 	bool alloc_found = false, free_found = false;
 
-	info->bug_type = get_bug_type(info);
-
-	if (!info->cache || !info->object)
+	if (!info->cache || !info->object) {
+		info->bug_type = get_common_bug_type(info);
 		return;
 	}
 
@@ -84,6 +83,13 @@ void kasan_complete_mode_report_info(str
 			info->free_track.pid = pid;
 			info->free_track.stack = stack;
 			free_found = true;
+
+			/*
+			 * If a free entry is found first, the bug is likely
+			 * a use-after-free.
+			 */
+			if (!info->bug_type)
+				info->bug_type = "use-after-free";
 		} else {
 			/* Second alloc of the same object. Give up. */
 			if (alloc_found)
@@ -92,8 +98,19 @@ void kasan_complete_mode_report_info(str
 			info->alloc_track.pid = pid;
 			info->alloc_track.stack = stack;
 			alloc_found = true;
+
+			/*
+			 * If an alloc entry is found first, the bug is likely
+			 * an out-of-bounds.
+			 */
+			if (!info->bug_type)
+				info->bug_type = "slab-out-of-bounds";
 		}
 	}
 
 	write_unlock_irqrestore(&stack_ring.lock, flags);
+
+	/* Assign the common bug type if no entries were found. */
+	if (!info->bug_type)
+		info->bug_type = get_common_bug_type(info);
 }
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-fix-array-bounds-warnings-in-tests.patch

