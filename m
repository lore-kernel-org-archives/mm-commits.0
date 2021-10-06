Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3216C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  6 Oct 2021 00:22:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA8B86117A
	for <mm-commits@archiver.kernel.org>; Wed,  6 Oct 2021 00:22:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237019AbhJFAYS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Oct 2021 20:24:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:34582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234027AbhJFAYR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 Oct 2021 20:24:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACE6261130;
        Wed,  6 Oct 2021 00:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633479746;
        bh=lQfblsJP1CEwNJ3rUUK5tZk3o/QEmNIZZmSOxv0BYKs=;
        h=Date:From:To:Subject:From;
        b=O7vJqs9gbGSHZdObbULedfzpM3vKL7amjd4EXdmsMgk+kNj4nay8HT6Y/Sru1hZxs
         NUVBgDdUgjmsko4wTdIdISeYR32UibjYk22oR949nyogN7eX8yqZKNeV2CldDGwnaJ
         D5yeQaiXaKr1Cz9Raj5jFsIc8jJQN2Pahd5tZJg0=
Date:   Tue, 05 Oct 2021 17:22:26 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, mm-commits@vger.kernel.org
Subject:  + elf-simplify-stack_alloc-macro.patch added to -mm tree
Message-ID: <20211006002226.gwdekrNbX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ELF: simplify STACK_ALLOC macro
has been added to the -mm tree.  Its filename is
     elf-simplify-stack_alloc-macro.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/elf-simplify-stack_alloc-macro.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/elf-simplify-stack_alloc-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: ELF: simplify STACK_ALLOC macro

"A -= B; A" is equivalent to "A -= B".

Link: https://lkml.kernel.org/r/YVmcP256fRMqCwgK@localhost.localdomain
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/binfmt_elf.c~elf-simplify-stack_alloc-macro
+++ a/fs/binfmt_elf.c
@@ -156,7 +156,7 @@ static int padzero(unsigned long elf_bss
 #define STACK_ADD(sp, items) ((elf_addr_t __user *)(sp) - (items))
 #define STACK_ROUND(sp, items) \
 	(((unsigned long) (sp - items)) &~ 15UL)
-#define STACK_ALLOC(sp, len) ({ sp -= len ; sp; })
+#define STACK_ALLOC(sp, len) (sp -= len)
 #endif
 
 #ifndef ELF_BASE_PLATFORM
_

Patches currently in -mm which might be from adobriyan@gmail.com are

lib-uninline-simple_strntoull-as-well.patch
elf-fix-overflow-in-total-mapping-size-calculation.patch
elf-simplify-stack_alloc-macro.patch

