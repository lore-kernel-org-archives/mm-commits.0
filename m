Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D8B1C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 04:51:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C10460FBF
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 04:51:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235958AbhKPEyO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 23:54:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:33064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236452AbhKPEw5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 23:52:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98A8460FBF;
        Tue, 16 Nov 2021 04:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637038199;
        bh=sfnvTabit4v7NOnwtHs8B25Ns6ocPgy7Kpss7TeLd9E=;
        h=Date:From:To:Subject:From;
        b=vwkSaBpir0CwDV4NeIG4p3dvQuqqgTnkVPnE/agD8fCJiyftHTKILkHKn/VlCNGC+
         O9lZJ+Uy80ME48cn1e/FZngq750UxCvZfZqTxnbCtpqp7SzzTOp3aOqoP8tc0pCxI1
         +st9CcWF66CoZo4yTxQPf+K7tMtqgu5tIzAdJ5RM=
Date:   Mon, 15 Nov 2021 20:49:59 -0800
From:   akpm@linux-foundation.org
To:     davidcomponentone@gmail.com, mm-commits@vger.kernel.org,
        yang.guang5@zte.com.cn, zealci@zte.com.cn
Subject:  + ia64-use-swap-to-make-code-cleaner.patch added to -mm
 tree
Message-ID: <20211116044959.AxwcZzY5F%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch/ia64/kernel/setup.c: use swap() to make code cleaner
has been added to the -mm tree.  Its filename is
     ia64-use-swap-to-make-code-cleaner.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ia64-use-swap-to-make-code-cleaner.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ia64-use-swap-to-make-code-cleaner.patch

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
Subject: arch/ia64/kernel/setup.c: use swap() to make code cleaner

Use the macro 'swap()' defined in 'include/linux/minmax.h' to avoid
opencoding it.

Link: https://lkml.kernel.org/r/20211104001908.695110-1-yang.guang5@zte.com.cn
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
Cc: David Yang <davidcomponentone@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/setup.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/ia64/kernel/setup.c~ia64-use-swap-to-make-code-cleaner
+++ a/arch/ia64/kernel/setup.c
@@ -208,10 +208,7 @@ sort_regions (struct rsvd_region *rsvd_r
 	while (max--) {
 		for (j = 0; j < max; ++j) {
 			if (rsvd_region[j].start > rsvd_region[j+1].start) {
-				struct rsvd_region tmp;
-				tmp = rsvd_region[j];
-				rsvd_region[j] = rsvd_region[j + 1];
-				rsvd_region[j + 1] = tmp;
+				swap(rsvd_region[j], rsvd_region[j + 1]);
 			}
 		}
 	}
_

Patches currently in -mm which might be from yang.guang5@zte.com.cn are

ia64-module-use-swap-to-make-code-cleaner.patch
ia64-use-swap-to-make-code-cleaner.patch

