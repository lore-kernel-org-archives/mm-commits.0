Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD9B6C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:33:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC08B61350
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:33:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235794AbhKICg1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:36:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:51660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236255AbhKICgZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:36:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D86D61288;
        Tue,  9 Nov 2021 02:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425220;
        bh=RjE5RxYsZU9Qh+HrmBiXf3gnXhHo5ONjJcPje1h75CE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=asm+jQl0Var3gGkzYVyiohkhRdFoaRDlZjFqA79ga/uAdpDETUWajFCLTGFC9lgz0
         75eVqEdwJSqgiH3PvpC+RqDqnvpq9V4R2ZwSKpiGaPnn07OIf9lY2Wt5dVZfrHcetn
         oISo6a11o1SD4OrlYDo7c6AC3BZo0ydPEdS6OWMs=
Date:   Mon, 08 Nov 2021 18:33:40 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 43/87] ELF: simplify STACK_ALLOC macro
Message-ID: <20211109023340.BlCjvnGzu%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
