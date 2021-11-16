Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A6CDC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 04:45:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A72260F22
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 04:45:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237296AbhKPEsW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 23:48:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:59286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245076AbhKPErV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 23:47:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CFFB61C14;
        Tue, 16 Nov 2021 04:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637037864;
        bh=xM5UTHI0zUr6KbXL4fe+xnfCfeRjnjyWFrNRC6aJIQ0=;
        h=Date:From:To:Subject:From;
        b=c8SBhiWxS0cUWaYXO4ssRbxQnNa/Dw+K3YLrCyedEBw8qXhKFoAltTAY4HL76RRfU
         c2H0ZHs8Ue6bOORU8nE+FE5+Ri/SxBmmnvrSGysB4P/4zVr8JlaJfls5bZGIuf9U82
         gD0lwRLCxygjxg7iWVCPgzl3/YIakTtkt9dzAKg8=
Date:   Mon, 15 Nov 2021 20:44:24 -0800
From:   akpm@linux-foundation.org
To:     davidcomponentone@gmail.com, mm-commits@vger.kernel.org,
        yang.guang5@zte.com.cn, zealci@zte.com.cn
Subject:  + ia64-module-use-swap-to-make-code-cleaner.patch added
 to -mm tree
Message-ID: <20211116044424.6u_fikDee%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: module: use swap() to make code cleaner
has been added to the -mm tree.  Its filename is
     ia64-module-use-swap-to-make-code-cleaner.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ia64-module-use-swap-to-make-code-cleaner.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ia64-module-use-swap-to-make-code-cleaner.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Guang <yang.guang5@zte.com.cn>
Subject: ia64: module: use swap() to make code cleaner

Use the macro 'swap()' defined in 'include/linux/minmax.h' to avoid
opencoding it.

Link: https://lkml.kernel.org/r/20211104062642.1506539-1-yang.guang5@zte.com.cn
Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Cc: David Yang <davidcomponentone@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/module.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/arch/ia64/kernel/module.c~ia64-module-use-swap-to-make-code-cleaner
+++ a/arch/ia64/kernel/module.c
@@ -848,7 +848,7 @@ register_unwind_table (struct module *mo
 {
 	struct unw_table_entry *start = (void *) mod->arch.unwind->sh_addr;
 	struct unw_table_entry *end = start + mod->arch.unwind->sh_size / sizeof (*start);
-	struct unw_table_entry tmp, *e1, *e2, *core, *init;
+	struct unw_table_entry *e1, *e2, *core, *init;
 	unsigned long num_init = 0, num_core = 0;
 
 	/* First, count how many init and core unwind-table entries there are.  */
@@ -865,9 +865,7 @@ register_unwind_table (struct module *mo
 	for (e1 = start; e1 < end; ++e1) {
 		for (e2 = e1 + 1; e2 < end; ++e2) {
 			if (e2->start_offset < e1->start_offset) {
-				tmp = *e1;
-				*e1 = *e2;
-				*e2 = tmp;
+				swap(*e1, *e2);
 			}
 		}
 	}
_

Patches currently in -mm which might be from yang.guang5@zte.com.cn are

ia64-module-use-swap-to-make-code-cleaner.patch

