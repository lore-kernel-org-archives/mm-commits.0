Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28B6CC6FA83
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 20:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiILUbl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Sep 2022 16:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiILUbk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2022 16:31:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4B8491D7
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 13:31:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBA60B80DD7
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 20:31:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813C6C433D6;
        Mon, 12 Sep 2022 20:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663014696;
        bh=g1KZHpiHrANE6JzjEOKd6tb1G46T4uN0Ag2Raub58mE=;
        h=Date:To:From:Subject:From;
        b=u/2f5gtaNcLkCuy2mCpjzpDU+C5N74UgVhhxnPlDdxe7/HJ3h5Ac5QkbLlgCxOm0X
         8qTaAReTFFERE3rZif4+ZKF5ZRJQmHK6X+oz2T1wlgkqtXb+FfhY60t4bQFeuzD6Gb
         kYLffFBNyAwgTYJKDORTy1bj2mmlxjxgeyHAG8ow=
Date:   Mon, 12 Sep 2022 13:31:35 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-better-invalid-double-free-report-header.patch added to mm-unstable branch
Message-Id: <20220912203136.813C6C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: better invalid/double-free report header
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-better-invalid-double-free-report-header.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-better-invalid-double-free-report-header.patch

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

kasan-check-kasan_no_free_meta-in-__kasan_metadata_size.patch
kasan-rename-kasan_set__info-to-kasan_save__info.patch
kasan-move-is_kmalloc-check-out-of-save_alloc_info.patch
kasan-split-save_alloc_info-implementations.patch
kasan-drop-config_kasan_tags_identify.patch
kasan-introduce-kasan_print_aux_stacks.patch
kasan-introduce-kasan_get_alloc_track.patch
kasan-introduce-kasan_init_object_meta.patch
kasan-clear-metadata-functions-for-tag-based-modes.patch
kasan-move-kasan_get__meta-to-genericc.patch
kasan-introduce-kasan_requires_meta.patch
kasan-introduce-kasan_init_cache_meta.patch
kasan-drop-config_kasan_generic-check-from-kasan_init_cache_meta.patch
kasan-only-define-kasan_metadata_size-for-generic-mode.patch
kasan-only-define-kasan_never_merge-for-generic-mode.patch
kasan-only-define-metadata-offsets-for-generic-mode.patch
kasan-only-define-metadata-structs-for-generic-mode.patch
kasan-only-define-kasan_cache_create-for-generic-mode.patch
kasan-pass-tagged-pointers-to-kasan_save_alloc-free_info.patch
kasan-move-kasan_get_alloc-free_track-definitions.patch
kasan-cosmetic-changes-in-reportc.patch
kasan-use-virt_addr_valid-in-kasan_addr_to_page-slab.patch
kasan-use-kasan_addr_to_slab-in-print_address_description.patch
kasan-make-kasan_addr_to_page-static.patch
kasan-simplify-print_report.patch
kasan-introduce-complete_report_info.patch
kasan-fill-in-cache-and-object-in-complete_report_info.patch
kasan-rework-function-arguments-in-reportc.patch
kasan-introduce-kasan_complete_mode_report_info.patch
kasan-implement-stack-ring-for-tag-based-modes.patch
kasan-support-kasanstacktrace-for-sw_tags.patch
kasan-dynamically-allocate-stack-ring-entries.patch
kasan-better-identify-bug-types-for-tag-based-modes.patch
kasan-add-another-use-after-free-test.patch
kasan-move-tests-to-mm-kasan.patch
kasan-better-invalid-double-free-report-header.patch

