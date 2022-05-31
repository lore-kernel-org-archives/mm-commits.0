Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D94BC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 31 May 2022 17:52:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345064AbiEaRwa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 May 2022 13:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346693AbiEaRwY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2022 13:52:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC83259335
        for <mm-commits@vger.kernel.org>; Tue, 31 May 2022 10:52:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80654B8121B
        for <mm-commits@vger.kernel.org>; Tue, 31 May 2022 17:52:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FC2C385A9;
        Tue, 31 May 2022 17:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654019540;
        bh=LLnHF2YJvPGWecIF3y9h35mrZtkJJJQFYNQMx22XRG8=;
        h=Date:To:From:Subject:From;
        b=qXhKNnFoS/eO3JJslyOViW1XA+2BVOmoUxf12hSSeUBBNxKNEQV905qs2Hmy/q0Vf
         tuI9xANqQ/lDBkkDGkLpo/qjA70OG//xcMmq6f+X4+VhS+GuMlLnFZvam/AGTz9ebi
         zs19sqP5PpqWYYy9EZvc6Hy0znRkEsnQNdytGcqU=
Date:   Tue, 31 May 2022 10:52:19 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-fix-zeroing-vmalloc-memory-with-hw_tags-fix.patch added to mm-unstable branch
Message-Id: <20220531175220.28FC2C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-fix-zeroing-vmalloc-memory-with-hw_tags-fix
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-fix-zeroing-vmalloc-memory-with-hw_tags-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-fix-zeroing-vmalloc-memory-with-hw_tags-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kasan-fix-zeroing-vmalloc-memory-with-hw_tags-fix
Date: Tue May 31 10:50:55 AM PDT 2022

s/clear_highpage_tagged/clear_highpage_kasan_tagged/

Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/hw_tags.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kasan/hw_tags.c~kasan-fix-zeroing-vmalloc-memory-with-hw_tags-fix
+++ a/mm/kasan/hw_tags.c
@@ -274,7 +274,7 @@ void *__kasan_unpoison_vmalloc(const voi
 
 		for (addr = start; addr < start + size; addr += PAGE_SIZE) {
 			page = virt_to_page(addr);
-			clear_highpage_tagged(page);
+			clear_highpage_kasan_tagged(page);
 		}
 
 		return (void *)start;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
mm-handling-non-lru-pages-returned-by-vm_normal_pages-fix.patch
mm-introduce-clear_highpage_tagged-fix.patch
kasan-fix-zeroing-vmalloc-memory-with-hw_tags-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

