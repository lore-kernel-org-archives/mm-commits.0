Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EE8FC433ED
	for <mm-commits@archiver.kernel.org>; Tue,  6 Apr 2021 01:52:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E51FD613C4
	for <mm-commits@archiver.kernel.org>; Tue,  6 Apr 2021 01:52:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239384AbhDFBwh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Apr 2021 21:52:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:44386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238146AbhDFBwh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 5 Apr 2021 21:52:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6602613C6;
        Tue,  6 Apr 2021 01:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617673949;
        bh=N7n8NNuOtdKA7gO7VEYOC0Csc7ptpuK3DFGuvomX9SY=;
        h=Date:From:To:Subject:From;
        b=sSauD8Uzk1LuPv+GHn1WGqe/mUODfLiQWybnxmzPxNtPyMAV0QtQqRvNMRpzYf2u2
         qseKNgfVRQ1B3bHDZwIlBxfbNEufZRI5klDVncVN5x3GLOfHQbKoca0ZOsKZvuEVz1
         CcfQ3VfabSn9zqspjOaViwDxvvWdk58AQbQvw5i0=
Date:   Mon, 05 Apr 2021 18:52:28 -0700
From:   akpm@linux-foundation.org
To:     dave@stgolabs.net, dbueso@suse.de, jbaron@akamai.com,
        mm-commits@vger.kernel.org, rpenyaev@suse.de,
        viro@zeniv.linux.org.uk
Subject:  + fs-epoll-restore-waking-from-ep_done_scan.patch added
 to -mm tree
Message-ID: <20210406015228.KkyAqFIqR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/epoll: restore waking from ep_done_scan()
has been added to the -mm tree.  Its filename is
     fs-epoll-restore-waking-from-ep_done_scan.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-epoll-restore-waking-from-ep_done_scan.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-epoll-restore-waking-from-ep_done_scan.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: fs/epoll: restore waking from ep_done_scan()

339ddb53d373 (fs/epoll: remove unnecessary wakeups of nested epoll)
changed the userspace visible behavior of exclusive waiters blocked on a
common epoll descriptor upon a single event becoming ready.  Previously,
all tasks doing epoll_wait would awake, and now only one is awoken,
potentially causing missed wakeups on applications that rely on this
behavior, such as Apache Qpid.

While the aforementioned commit aims at having only a wakeup single path
in ep_poll_callback (with the exceptions of epoll_ctl cases), we need to
restore the wakeup in what was the old ep_scan_ready_list() such that the
next thread can be awoken, in a cascading style, after the waker's
corresponding ep_send_events().

Link: https://lkml.kernel.org/r/20210405231025.33829-3-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Roman Penyaev <rpenyaev@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/eventpoll.c~fs-epoll-restore-waking-from-ep_done_scan
+++ a/fs/eventpoll.c
@@ -657,6 +657,12 @@ static void ep_done_scan(struct eventpol
 	 */
 	list_splice(txlist, &ep->rdllist);
 	__pm_relax(ep->ws);
+
+	if (!list_empty(&ep->rdllist)) {
+		if (waitqueue_active(&ep->wq))
+			wake_up(&ep->wq);
+	}
+
 	write_unlock_irq(&ep->lock);
 }
 
_

Patches currently in -mm which might be from dave@stgolabs.net are

kselftest-introduce-new-epoll-test-case.patch
fs-epoll-restore-waking-from-ep_done_scan.patch

