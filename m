Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DB1FC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:13:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354853AbiCYBOp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354887AbiCYBOc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:14:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C821BD7CA
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:12:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22763618D1
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:12:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 799DFC340EC;
        Fri, 25 Mar 2022 01:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170778;
        bh=oIsCqJDOwHRaVf5t0y7qVpsRbZz8JwK1EhBbykk6h5o=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=gu0XeFILDGATspvXYINVqzxgzkTQhb8F5p5nLUsU0e6+rVaYxni1RdeRUJZ8UIgJT
         vuwFKPs5tu0XejQ3acYK2mn22Yoxr3+/VExlSHG/kDm8XHcW02YPVw06lDdue2tfoC
         T08S+wW+zuc61/kjbPIoJEjNa+ADlX7YViq+xr74=
Date:   Thu, 24 Mar 2022 18:12:57 -0700
To:     ryabinin.a.a@gmail.com, glider@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 088/114] kasan: move and simplify kasan_report_async
Message-Id: <20220325011258.799DFC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: move and simplify kasan_report_async

Place kasan_report_async() next to the other main reporting routines. 
Also simplify printed information.

Link: https://lkml.kernel.org/r/52d942ef3ffd29bdfa225bbe8e327bc5bda7ab09.1646237226.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/mm/kasan/report.c~kasan-move-and-simplify-kasan_report_async
+++ a/mm/kasan/report.c
@@ -392,20 +392,6 @@ static bool report_enabled(void)
 	return !test_and_set_bit(KASAN_BIT_REPORTED, &kasan_flags);
 }
 
-#ifdef CONFIG_KASAN_HW_TAGS
-void kasan_report_async(void)
-{
-	unsigned long flags;
-
-	start_report(&flags, false);
-	pr_err("BUG: KASAN: invalid-access\n");
-	pr_err("Asynchronous mode enabled: no access details available\n");
-	pr_err("\n");
-	dump_stack_lvl(KERN_ERR);
-	end_report(&flags, NULL);
-}
-#endif /* CONFIG_KASAN_HW_TAGS */
-
 static void print_report(struct kasan_access_info *info)
 {
 	void *tagged_addr = info->access_addr;
@@ -477,6 +463,20 @@ out:
 	return ret;
 }
 
+#ifdef CONFIG_KASAN_HW_TAGS
+void kasan_report_async(void)
+{
+	unsigned long flags;
+
+	start_report(&flags, false);
+	pr_err("BUG: KASAN: invalid-access\n");
+	pr_err("Asynchronous fault: no details available\n");
+	pr_err("\n");
+	dump_stack_lvl(KERN_ERR);
+	end_report(&flags, NULL);
+}
+#endif /* CONFIG_KASAN_HW_TAGS */
+
 #ifdef CONFIG_KASAN_INLINE
 /*
  * With CONFIG_KASAN_INLINE, accesses to bogus pointers (outside the high
_
