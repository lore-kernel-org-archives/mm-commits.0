Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 914AAC4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:09:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiJCVJn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiJCVIK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:08:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73944F19C
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:06:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F187B81123
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:06:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E043C433D6;
        Mon,  3 Oct 2022 21:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831176;
        bh=r0UIcOrkqq2cdnwxDJCu+VLyiQULJFyBuggvsFDNdOw=;
        h=Date:To:From:Subject:From;
        b=0WO7uHXpLZWqB/oteqMxGdexyU24rtWtVaMtIS79nGJ6GTEv7B9KDZ0uCfWX2UGyp
         AGcpBE6V53054jiNEgB25efcZoOM0cOw3gTzJnxwXuxlVEeQp+KYKY4pHwJfqvJxSw
         4Fs5YKnm/iX/Q34r74L2pW4J3I/ef0Oqc5RVA1Xs=
Date:   Mon, 03 Oct 2022 14:06:15 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-simplify-print_report.patch removed from -mm tree
Message-Id: <20221003210616.0E043C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: simplify print_report
has been removed from the -mm tree.  Its filename was
     kasan-simplify-print_report.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: simplify print_report
Date: Mon, 5 Sep 2022 23:05:40 +0200

To simplify reading the implementation of print_report(), remove the
tagged_addr variable and rename untagged_addr to addr.

Link: https://lkml.kernel.org/r/f64f5f1093b3c06896bf0f850c5d9e661313fcb2.1662411799.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/mm/kasan/report.c~kasan-simplify-print_report
+++ a/mm/kasan/report.c
@@ -397,17 +397,16 @@ static void print_memory_metadata(const
 
 static void print_report(struct kasan_report_info *info)
 {
-	void *tagged_addr = info->access_addr;
-	void *untagged_addr = kasan_reset_tag(tagged_addr);
-	u8 tag = get_tag(tagged_addr);
+	void *addr = kasan_reset_tag(info->access_addr);
+	u8 tag = get_tag(info->access_addr);
 
 	print_error_description(info);
-	if (addr_has_metadata(untagged_addr))
+	if (addr_has_metadata(addr))
 		kasan_print_tags(tag, info->first_bad_addr);
 	pr_err("\n");
 
-	if (addr_has_metadata(untagged_addr)) {
-		print_address_description(untagged_addr, tag);
+	if (addr_has_metadata(addr)) {
+		print_address_description(addr, tag);
 		print_memory_metadata(info->first_bad_addr);
 	} else {
 		dump_stack_lvl(KERN_ERR);
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-fix-array-bounds-warnings-in-tests.patch

