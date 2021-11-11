Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8889BC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:52:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EEDC61381
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:52:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234570AbhKKCzX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:55:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:58856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234548AbhKKCzU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:55:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7580261075;
        Thu, 11 Nov 2021 02:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599152;
        bh=M54OKX7YXsFS+WU0uusUbYKkLCsbHBA+YC4td7fpShQ=;
        h=Date:From:To:Subject:From;
        b=beh9cuxjhxpmMB+q9Va3SwMB+EGzPJKXHncMOgZzY3Ld5hy4dWWFtTms3hC+/0WA9
         qMRvGz/vm4hCKX+5k3HaMHRnlAwQmYTJOVMgVXN6ChT36u+BRznXFjvKCJDMdxhgoD
         CuNVlUhpoWXt6gE7y83/zjre1ukKDGZaFL7zpMAg=
Date:   Wed, 10 Nov 2021 18:52:32 -0800
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, mm-commits@vger.kernel.org
Subject:  [merged] elf-simplify-stack_alloc-macro.patch removed
 from -mm tree
Message-ID: <20211111025232.t6wWOy07o%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ELF: simplify STACK_ALLOC macro
has been removed from the -mm tree.  Its filename was
     elf-simplify-stack_alloc-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

elf-fix-overflow-in-total-mapping-size-calculation.patch

