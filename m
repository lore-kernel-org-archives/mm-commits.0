Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6131C3526E
	for <mm-commits@archiver.kernel.org>; Sun, 20 Dec 2020 02:59:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4C2923ACA
	for <mm-commits@archiver.kernel.org>; Sun, 20 Dec 2020 02:59:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgLTC6w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 19 Dec 2020 21:58:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:54452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727002AbgLTC6w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 19 Dec 2020 21:58:52 -0500
Date:   Sat, 19 Dec 2020 18:57:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608433067;
        bh=Xk7LMo/HOkreMm24r2gFprzl/J/icddoFJK5ZyC0jag=;
        h=From:To:Subject:From;
        b=rBztshLbVzdcBHX4IRJGYpIYDpHw1I3jil+Oya8sOvbxl5L+BDCz7D+fZ4Cg+S67O
         gJEXjAP9q+CPuLewEpQwCDRNduO7t9x1j9ILEQdpnSLQuDJkD8f+mKDkrpIBbrRzrC
         FhJnprImu2h/AIosI95VSMo6n5UKphc6KdmKVuGk=
From:   akpm@linux-foundation.org
To:     edumazet@google.com, guantaol@google.com, khazhy@google.com,
        mm-commits@vger.kernel.org, soheil@google.com,
        torvalds@linux-foundation.org, willemb@google.com
Subject:  [merged]
 epoll-move-eavail-next-to-the-list_empty_careful-check.patch removed from
 -mm tree
Message-ID: <20201220025747.dd4Ni4USz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: move eavail next to the list_empty_careful check
has been removed from the -mm tree.  Its filename was
     epoll-move-eavail-next-to-the-list_empty_careful-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Soheil Hassas Yeganeh <soheil@google.com>
Subject: epoll: move eavail next to the list_empty_careful check

This is a no-op change and simply to make the code more coherent.

Link: https://lkml.kernel.org/r/20201106231635.3528496-5-soheil.kdev@gmail.com
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Khazhismel Kumykov <khazhy@google.com>
Cc: Guantao Liu <guantaol@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/eventpoll.c~epoll-move-eavail-next-to-the-list_empty_careful-check
+++ a/fs/eventpoll.c
@@ -1828,6 +1828,7 @@ fetch_events:
 		if (!eavail)
 			timed_out = !schedule_hrtimeout_range(to, slack,
 							      HRTIMER_MODE_ABS);
+		__set_current_state(TASK_RUNNING);
 
 		/*
 		 * We were woken up, thus go and try to harvest some events.
@@ -1837,8 +1838,6 @@ fetch_events:
 		eavail = 1;
 	} while (0);
 
-	__set_current_state(TASK_RUNNING);
-
 	if (!list_empty_careful(&wait.entry)) {
 		write_lock_irq(&ep->lock);
 		/*
_

Patches currently in -mm which might be from soheil@google.com are


