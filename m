Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF13BC43217
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:13:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347954AbiCYBOs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354593AbiCYBOk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:14:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59745F21
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:13:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EAA2161857
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:13:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5196CC340EE;
        Fri, 25 Mar 2022 01:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170784;
        bh=sBga4iICZt57zQq9x4WZawmwLtWQKl78sRfaOI+sIYI=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=wJcc2VQ5MeS2QdDxJu0jRgQhntVPnzXIhQ3A3GUy0bQQ+nNrrzYz+mHQSWV7s2FWu
         z0qNpGGqFAB95OM7MEaOCyf1E7xh6GEHIGIjt3Zd7I7DaCSY1K6Och6l9jpfTRIKGE
         VJgKZOZXM4uBjId59OVNQV5lDnIlZrHJ0CO7RY6U=
Date:   Thu, 24 Mar 2022 18:13:03 -0700
To:     ryabinin.a.a@gmail.com, glider@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 090/114] kasan: add comment about UACCESS regions to kasan_report
Message-Id: <20220325011304.5196CC340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: add comment about UACCESS regions to kasan_report

Add a comment explaining why kasan_report() is the only reporting function
that uses user_access_save/restore().

Link: https://lkml.kernel.org/r/1201ca3c2be42c7bd077c53d2e46f4a51dd1476a.1646237226.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/kasan/report.c~kasan-add-comment-about-uaccess-regions-to-kasan_report
+++ a/mm/kasan/report.c
@@ -430,6 +430,11 @@ void kasan_report_invalid_free(void *ptr
 	end_report(&flags, ptr);
 }
 
+/*
+ * kasan_report() is the only reporting function that uses
+ * user_access_save/restore(): kasan_report_invalid_free() cannot be called
+ * from a UACCESS region, and kasan_report_async() is not used on x86.
+ */
 bool kasan_report(unsigned long addr, size_t size, bool is_write,
 			unsigned long ip)
 {
_
