Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6CAAC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 14 Apr 2022 21:26:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235875AbiDNV23 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Apr 2022 17:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiDNV23 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Apr 2022 17:28:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B11E6C50
        for <mm-commits@vger.kernel.org>; Thu, 14 Apr 2022 14:26:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7ABA7B82B9B
        for <mm-commits@vger.kernel.org>; Thu, 14 Apr 2022 21:26:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B1FC385A5;
        Thu, 14 Apr 2022 21:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649971560;
        bh=iwykIH0veXIwKzw95kvAkHacqqKUl73G4Jc4Sv2piEs=;
        h=Date:To:From:Subject:From;
        b=nCxL9FIYYXgIW6iFtgygAnykPhT9avoVagIk3CW2SfB7HPvFcGkvEW12gVn6Tzc3U
         sucW1V5EtWrtwDnUl8GNCpI/8lkXG6W6Lk5rVhFzZsPLTl3AwECH/4riGlPIoQA2KC
         altz+tPCp0jzVYVbHCyEdyb/b2ny5dATqJ7tl2pU=
Date:   Thu, 14 Apr 2022 14:25:59 -0700
To:     mm-commits@vger.kernel.org, tarasmadan@google.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        bigeasy@linutronix.de, andreyknvl@gmail.com, nogikh@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kcov-dont-generate-a-warning-on-vm_insert_pages-failure.patch added to -mm tree
Message-Id: <20220414212600.13B1FC385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kcov: don't generate a warning on vm_insert_page()'s failure
has been added to the -mm tree.  Its filename is
     kcov-dont-generate-a-warning-on-vm_insert_pages-failure.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kcov-dont-generate-a-warning-on-vm_insert_pages-failure.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kcov-dont-generate-a-warning-on-vm_insert_pages-failure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Aleksandr Nogikh <nogikh@google.com>
Subject: kcov: don't generate a warning on vm_insert_page()'s failure

vm_insert_page()'s failure is not an unexpected condition, so don't do
WARN_ONCE() in such a case.

Instead, print a kernel message and just return an error code.

Link: https://lkml.kernel.org/r/20220401182512.249282-1-nogikh@google.com
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Taras Madan <tarasmadan@google.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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

kcov-dont-generate-a-warning-on-vm_insert_pages-failure.patch

