Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 815E5C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:43:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233970AbiCYWoh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233956AbiCYWoU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:44:20 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95EC120C19A
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:42:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 124E3CE2A9E
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:42:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C74C340ED;
        Fri, 25 Mar 2022 22:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248161;
        bh=e/dRp5cY96Jz4zuOtBxxS8ImTBa/pt6EOLziWMV0bc8=;
        h=Date:To:From:Subject:From;
        b=T8grtO67OvYE6a+EjlED6gNZfSOTuJtg/kSW5ZTtRe7qFJZ36j/ypIJOZtE/Po4TP
         x70Lr78aqqrm+DIRi65Mf7oSC4ewiDu2A9IebFea9ex1qEt7pHtZRUOVKxMzfkzBED
         S9RxGRmoWoZu5NdSXqBA6ihXH/hQVd1pmpnoQhVQ=
Date:   Fri, 25 Mar 2022 15:42:40 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kasan-drop-addr-check-from-describe_object_addr.patch removed from -mm tree
Message-Id: <20220325224241.68C74C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: drop addr check from describe_object_addr
has been removed from the -mm tree.  Its filename was
     kasan-drop-addr-check-from-describe_object_addr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: drop addr check from describe_object_addr

Patch series "kasan: report clean-ups and improvements".

A number of clean-up patches for KASAN reporting code.  Most are
non-functional and only improve readability.


This patch (of 22):

describe_object_addr() used to be called with NULL addr in the early days
of KASAN.  This no longer happens, so drop the check.

Link: https://lkml.kernel.org/r/cover.1646237226.git.andreyknvl@google.com
Link: https://lkml.kernel.org/r/761f8e5a6ee040d665934d916a90afe9f322f745.1646237226.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/kasan/report.c~kasan-drop-addr-check-from-describe_object_addr
+++ a/mm/kasan/report.c
@@ -162,9 +162,6 @@ static void describe_object_addr(struct
 	       " which belongs to the cache %s of size %d\n",
 		object, cache->name, cache->object_size);
 
-	if (!addr)
-		return;
-
 	if (access_addr < object_addr) {
 		rel_type = "to the left";
 		rel_bytes = object_addr - access_addr;
_

Patches currently in -mm which might be from andreyknvl@google.com are

stacktrace-add-interface-based-on-shadow-call-stack.patch
arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch

