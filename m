Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00296C433ED
	for <mm-commits@archiver.kernel.org>; Thu, 20 May 2021 21:38:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7C80613AA
	for <mm-commits@archiver.kernel.org>; Thu, 20 May 2021 21:38:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbhETVkJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 May 2021 17:40:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:44790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230255AbhETVkI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 May 2021 17:40:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C9AA6135C;
        Thu, 20 May 2021 21:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621546726;
        bh=A2MnvdTHkOBD0BeNNL9wgtXpnTzXy+h9X4sGZWwtkAE=;
        h=Date:From:To:Subject:From;
        b=fsx7sYUwZaUDq3vGNQjhs7Q0PyAMfJGMOCz2vZbmTDuNFKsND7CFr6HcfhVovLgLT
         pesNO+BH000htiKTDgtDPLx3FyoXmcHqVWRTHVPFSudfHH1XljeKyTRc05/T2dFZKL
         S4jwBkLy0V3HDYZw0u9yv8knSiH/JJZS1oFywFI8=
Date:   Thu, 20 May 2021 14:38:46 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, arnd@arndb.de, bcrl@kvack.org,
        David.Laight@ACULAB.COM, deepa.kernel@gmail.com, e@80x24.org,
        ebiederm@xmission.com, mm-commits@vger.kernel.org, oleg@redhat.com,
        peterz@infradead.org, viro@zeniv.linux.org.uk
Subject:  [withdrawn] aio-simplify-read_events.patch removed from
 -mm tree
Message-ID: <20210520213846.J3vz4eK7k%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: aio: simplify read_events()
has been removed from the -mm tree.  Its filename was
     aio-simplify-read_events.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: aio: simplify read_events()

Change wait_event_hrtimeout() to not call __wait_event_hrtimeout() if
timeout == 0, this matches other _timeout() helpers in wait.h.

This allows to simplify its only user, read_events(), it no longer needs
to optimize the "until == 0" case by hand.

Note: this patch doesn't use ___wait_cond_timeout because _hrtimeout()
also differs in that it returns 0 if succeeds and -ETIME on timeout. 
Perhaps we should change this to make it fully compatible with other
helpers.

Link: http://lkml.kernel.org/r/20190607175413.GA29187@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Eric Wong <e@80x24.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c             |    9 +++------
 include/linux/wait.h |    4 ++--
 2 files changed, 5 insertions(+), 8 deletions(-)

--- a/fs/aio.c~aio-simplify-read_events
+++ a/fs/aio.c
@@ -1286,12 +1286,9 @@ static long read_events(struct kioctx *c
 	 * the ringbuffer empty. So in practice we should be ok, but it's
 	 * something to be aware of when touching this code.
 	 */
-	if (until == 0)
-		aio_read_events(ctx, min_nr, nr, event, &ret);
-	else
-		wait_event_interruptible_hrtimeout(ctx->wait,
-				aio_read_events(ctx, min_nr, nr, event, &ret),
-				until);
+	wait_event_interruptible_hrtimeout(ctx->wait,
+			aio_read_events(ctx, min_nr, nr, event, &ret),
+			until);
 	return ret;
 }
 
--- a/include/linux/wait.h~aio-simplify-read_events
+++ a/include/linux/wait.h
@@ -555,7 +555,7 @@ do {										\
 ({										\
 	int __ret = 0;								\
 	might_sleep();								\
-	if (!(condition))							\
+	if (!(condition) && (timeout))						\
 		__ret = __wait_event_hrtimeout(wq_head, condition, timeout,	\
 					       TASK_UNINTERRUPTIBLE);		\
 	__ret;									\
@@ -581,7 +581,7 @@ do {										\
 ({										\
 	long __ret = 0;								\
 	might_sleep();								\
-	if (!(condition))							\
+	if (!(condition) && (timeout))						\
 		__ret = __wait_event_hrtimeout(wq, condition, timeout,		\
 					       TASK_INTERRUPTIBLE);		\
 	__ret;									\
_

Patches currently in -mm which might be from oleg@redhat.com are


