Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56EEDC43219
	for <mm-commits@archiver.kernel.org>; Fri, 22 Apr 2022 18:26:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbiDVS3F (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 22 Apr 2022 14:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234314AbiDVS2e (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2022 14:28:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B540D8166E
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 11:25:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB4BAB81F56
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 18:24:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CAB0C385A9;
        Fri, 22 Apr 2022 18:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650651897;
        bh=b3qVteJNgT83kl77ceWiBLp+SRfTo2C0lX6uByAqUbE=;
        h=Date:To:From:Subject:From;
        b=IR7U7Bx8iaH7otVs9Mim5WLVr+0WgjWQ303DSO03wY/yMWpkW0h9KqWjasvnqrOLJ
         mKBmVnYskCVd1GyBau0TMc+qO7LzvpBPnpRE4m4zwz4Lqi3pbwQTYTDVq1X8RcNpp3
         69ceHgXlKNNGEGMNRY0Ugomph8980OVBtlNjolck=
Date:   Fri, 22 Apr 2022 11:24:56 -0700
To:     mm-commits@vger.kernel.org, tarasmadan@google.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        bigeasy@linutronix.de, andreyknvl@gmail.com, nogikh@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kcov-dont-generate-a-warning-on-vm_insert_pages-failure.patch removed from -mm tree
Message-Id: <20220422182457.4CAB0C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kcov: don't generate a warning on vm_insert_page()'s failure
has been removed from the -mm tree.  Its filename was
     kcov-dont-generate-a-warning-on-vm_insert_pages-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from nogikh@google.com are


