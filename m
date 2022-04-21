Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F225C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 21 Apr 2022 23:36:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442598AbiDUXjH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Apr 2022 19:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442135AbiDUXjB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2022 19:39:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6FE71260A
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 16:36:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 557B6B829A7
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 23:36:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E09C385A7;
        Thu, 21 Apr 2022 23:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650584168;
        bh=IeHWkgVqOFZYBcD3UCEb6fsykXZrS6zVdkxAwURYZ8o=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=hWKhkPcddd81NiKFF2uKb+B8tduVIelemb/cNJk9mwRYCh7JZ81wSHbwyjP6Jjtq6
         ER+TqT30mv4XUjKpRX4TjCGQtqxFkeC1cxQjeFp3uC1Afo4sLzBysb42faNHyq6G0f
         dKj6KhalQPdGZpNs/3c2hmkDTsCh9HbKpZgkbvdA=
Date:   Thu, 21 Apr 2022 16:36:07 -0700
To:     tarasmadan@google.com, glider@google.com, elver@google.com,
        dvyukov@google.com, bigeasy@linutronix.de, andreyknvl@gmail.com,
        nogikh@google.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220421163508.66028a9ac2d9fb6ea05b1342@linux-foundation.org>
Subject: [patch 12/13] kcov: don't generate a warning on vm_insert_page()'s failure
Message-Id: <20220421233607.E7E09C385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Aleksandr Nogikh <nogikh@google.com>
Subject: kcov: don't generate a warning on vm_insert_page()'s failure

vm_insert_page()'s failure is not an unexpected condition, so don't do
WARN_ONCE() in such a case.

Instead, print a kernel message and just return an error code.

This flaw has been reported under an OOM condition by sysbot
(https://lkml.kernel.org/r/Ylkr2xrVbhQYwNLf@elver.google.com).

The message is mainly for the benefit of the test log, in this case the
fuzzer's log so that humans inspecting the log can figure out what was
going on. KCOV is a testing tool, so I think being a little more chatty
when KCOV unexpectedly is about to fail will save someone debugging
time.

We don't want the WARN, because it's not a kernel bug that syzbot should
report, and failure can happen if the fuzzer tries hard enough (as
above).

Link: https://lkml.kernel.org/r/20220401182512.249282-1-nogikh@google.com
Fixes: b3d7fe86fbd0 ("kcov: properly handle subsequent mmap calls"),
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Taras Madan <tarasmadan@google.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcov.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/kernel/kcov.c~kcov-dont-generate-a-warning-on-vm_insert_pages-failure
+++ a/kernel/kcov.c
@@ -475,8 +475,11 @@ static int kcov_mmap(struct file *filep,
 	vma->vm_flags |= VM_DONTEXPAND;
 	for (off = 0; off < size; off += PAGE_SIZE) {
 		page = vmalloc_to_page(kcov->area + off);
-		if (vm_insert_page(vma, vma->vm_start + off, page))
-			WARN_ONCE(1, "vm_insert_page() failed");
+		res = vm_insert_page(vma, vma->vm_start + off, page);
+		if (res) {
+			pr_warn_once("kcov: vm_insert_page() failed\n");
+			return res;
+		}
 	}
 	return 0;
 exit:
_
