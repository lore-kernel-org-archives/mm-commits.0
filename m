Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C60AC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:12:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354486AbiCYBOM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357214AbiCYBOG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:14:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C1DEBD2E3
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:12:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F191161857
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:12:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525A8C340ED;
        Fri, 25 Mar 2022 01:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170752;
        bh=BvySnWZa+bNjUg/rrHE485qNGZVu5dsTywZhyhuER0M=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=LdU0Uz9Zf4aksZhhSlkvLU+npiFGLNU/E0J8Npv0+c6XEI5ru1+/NjQo9sSvnOHut
         bnhgYhX8fv9rcobDYwZWKkxFwvl8cEIpunnYj+meW8akszURVFDxd0cihZBRBLZTXy
         wydKu7XhyS/DKNEKgJW79Qhvju7XliH4hNTCJTVg=
Date:   Thu, 24 Mar 2022 18:12:31 -0700
To:     ryabinin.a.a@gmail.com, glider@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 079/114] kasan: simplify kasan_update_kunit_status() and call sites
Message-Id: <20220325011232.525A8C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: simplify kasan_update_kunit_status() and call sites

- Rename kasan_update_kunit_status() to update_kunit_status()
  (the function is static).

- Move the IS_ENABLED(CONFIG_KUNIT) to the function's
  definition instead of duplicating it at call sites.

- Obtain and check current->kunit_test within the function.

Link: https://lkml.kernel.org/r/dac26d811ae31856c3d7666de0b108a3735d962d.1646237226.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |   30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

--- a/mm/kasan/report.c~kasan-simplify-kasan_update_kunit_status-and-call-sites
+++ a/mm/kasan/report.c
@@ -357,24 +357,31 @@ static bool report_enabled(void)
 }
 
 #if IS_ENABLED(CONFIG_KUNIT)
-static void kasan_update_kunit_status(struct kunit *cur_test, bool sync)
+static void update_kunit_status(bool sync)
 {
+	struct kunit *test;
 	struct kunit_resource *resource;
 	struct kunit_kasan_status *status;
 
-	resource = kunit_find_named_resource(cur_test, "kasan_status");
+	test = current->kunit_test;
+	if (!test)
+		return;
 
+	resource = kunit_find_named_resource(test, "kasan_status");
 	if (!resource) {
-		kunit_set_failure(cur_test);
+		kunit_set_failure(test);
 		return;
 	}
 
 	status = (struct kunit_kasan_status *)resource->data;
 	WRITE_ONCE(status->report_found, true);
 	WRITE_ONCE(status->sync_fault, sync);
+
 	kunit_put_resource(resource);
 }
-#endif /* IS_ENABLED(CONFIG_KUNIT) */
+#else
+static void update_kunit_status(bool sync) { }
+#endif
 
 void kasan_report_invalid_free(void *object, unsigned long ip)
 {
@@ -383,10 +390,7 @@ void kasan_report_invalid_free(void *obj
 
 	object = kasan_reset_tag(object);
 
-#if IS_ENABLED(CONFIG_KUNIT)
-	if (current->kunit_test)
-		kasan_update_kunit_status(current->kunit_test, true);
-#endif /* IS_ENABLED(CONFIG_KUNIT) */
+	update_kunit_status(true);
 
 	start_report(&flags);
 	pr_err("BUG: KASAN: double-free or invalid-free in %pS\n", (void *)ip);
@@ -402,10 +406,7 @@ void kasan_report_async(void)
 {
 	unsigned long flags;
 
-#if IS_ENABLED(CONFIG_KUNIT)
-	if (current->kunit_test)
-		kasan_update_kunit_status(current->kunit_test, false);
-#endif /* IS_ENABLED(CONFIG_KUNIT) */
+	update_kunit_status(false);
 
 	start_report(&flags);
 	pr_err("BUG: KASAN: invalid-access\n");
@@ -424,10 +425,7 @@ static void __kasan_report(unsigned long
 	void *untagged_addr;
 	unsigned long flags;
 
-#if IS_ENABLED(CONFIG_KUNIT)
-	if (current->kunit_test)
-		kasan_update_kunit_status(current->kunit_test, true);
-#endif /* IS_ENABLED(CONFIG_KUNIT) */
+	update_kunit_status(true);
 
 	disable_trace_on_warning();
 
_
