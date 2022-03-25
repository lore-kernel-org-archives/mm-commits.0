Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCAFAC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:43:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234019AbiCYWol (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234021AbiCYWoa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:44:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B2EF20D510
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:42:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1969614D8
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:42:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56C36C340ED;
        Fri, 25 Mar 2022 22:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248174;
        bh=kBIFlCReCjYTkombzzoTwmdLryQ3GUUWHdvTdrbb6u4=;
        h=Date:To:From:Subject:From;
        b=MiyfZVnPDVAseeN3s9Wh37fF5LfFHTA7tNQV8z3E3YJXPgTGXP5hyaoiNOsiG+bYp
         Nncp2aLCVaPztfwEL/qKp8u1OmWn1ZeTCw+WbxPvEgivXtnvf8kpvJbzDa9htGCh7B
         jNAQwTg9llfjVKkd+AmRcfXu5NbZsx4+JzW1BMmk=
Date:   Fri, 25 Mar 2022 15:42:53 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kasan-merge-__kasan_report-into-kasan_report.patch removed from -mm tree
Message-Id: <20220325224254.56C36C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: merge __kasan_report into kasan_report
has been removed from the -mm tree.  Its filename was
     kasan-merge-__kasan_report-into-kasan_report.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: merge __kasan_report into kasan_report

Merge __kasan_report() into kasan_report().  The code is simple enough to
be readable without the __kasan_report() helper.

Link: https://lkml.kernel.org/r/c8a125497ef82f7042b3795918dffb81a85a878e.1646237226.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |   36 +++++++++++++++---------------------
 1 file changed, 15 insertions(+), 21 deletions(-)

--- a/mm/kasan/report.c~kasan-merge-__kasan_report-into-kasan_report
+++ a/mm/kasan/report.c
@@ -435,37 +435,31 @@ static void print_report(struct kasan_ac
 	}
 }
 
-static void __kasan_report(void *addr, size_t size, bool is_write,
-				unsigned long ip)
-{
-	struct kasan_access_info info;
-	unsigned long flags;
-
-	start_report(&flags, true);
-
-	info.access_addr = addr;
-	info.first_bad_addr = kasan_find_first_bad_addr(addr, size);
-	info.access_size = size;
-	info.is_write = is_write;
-	info.ip = ip;
-
-	print_report(&info);
-
-	end_report(&flags, addr);
-}
-
 bool kasan_report(unsigned long addr, size_t size, bool is_write,
 			unsigned long ip)
 {
-	unsigned long ua_flags = user_access_save();
 	bool ret = true;
+	void *ptr = (void *)addr;
+	unsigned long ua_flags = user_access_save();
+	unsigned long irq_flags;
+	struct kasan_access_info info;
 
 	if (unlikely(!report_enabled())) {
 		ret = false;
 		goto out;
 	}
 
-	__kasan_report((void *)addr, size, is_write, ip);
+	start_report(&irq_flags, true);
+
+	info.access_addr = ptr;
+	info.first_bad_addr = kasan_find_first_bad_addr(ptr, size);
+	info.access_size = size;
+	info.is_write = is_write;
+	info.ip = ip;
+
+	print_report(&info);
+
+	end_report(&irq_flags, ptr);
 
 out:
 	user_access_restore(ua_flags);
_

Patches currently in -mm which might be from andreyknvl@google.com are

stacktrace-add-interface-based-on-shadow-call-stack.patch
arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch

