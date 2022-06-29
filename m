Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1779C43334
	for <mm-commits@archiver.kernel.org>; Wed, 29 Jun 2022 23:56:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbiF2X4F (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Jun 2022 19:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbiF2X4E (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Jun 2022 19:56:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E68227159
        for <mm-commits@vger.kernel.org>; Wed, 29 Jun 2022 16:56:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9EC0B827B2
        for <mm-commits@vger.kernel.org>; Wed, 29 Jun 2022 23:56:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A92FC34114;
        Wed, 29 Jun 2022 23:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656546960;
        bh=TJ6tdgmZuekPG5THUvuKAlEW8CfKa7acsDtFqXe/6N4=;
        h=Date:To:From:Subject:From;
        b=Mt+bmOSVcJel0F30qxyIWgD1R9ZVpqVqwUa1IiCj7tljDfAwL9oOjyMiBI+BxI63A
         XqSJJd7t+a8lF1o17P108452uApvF2IIYY5VgQqnKj1B1ZmzlFIz/hy99F6tp9rTCS
         HAO5F7TgLq6N90Ge4volBjw9xcpMzVDAHWVEBip8=
Date:   Wed, 29 Jun 2022 16:55:59 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, shakeelb@google.com,
        rpenyaev@suse.de, r@hev.cc, khazhy@google.com, jbaron@akamai.com,
        edumazet@google.com, bsegall@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + epoll-autoremove-wakers-even-more-aggressively.patch added to mm-nonmm-unstable branch
Message-Id: <20220629235600.5A92FC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: autoremove wakers even more aggressively
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     epoll-autoremove-wakers-even-more-aggressively.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/epoll-autoremove-wakers-even-more-aggressively.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Benjamin Segall <bsegall@google.com>
Subject: epoll: autoremove wakers even more aggressively
Date: Wed, 15 Jun 2022 14:24:23 -0700

If a process is killed or otherwise exits while having active network
connections and many threads waiting on epoll_wait, the threads will all
be woken immediately, but not removed from ep->wq.  Then when network
traffic scans ep->wq in wake_up, every wakeup attempt will fail, and will
not remove the entries from the list.

This means that the cost of the wakeup attempt is far higher than usual,
does not decrease, and this also competes with the dying threads trying to
actually make progress and remove themselves from the wq.

Handle this by removing visited epoll wq entries unconditionally, rather
than only when the wakeup succeeds - the structure of ep_poll means that
the only potential loss is the timed_out->eavail heuristic, which now can
race and result in a redundant ep_send_events attempt.  (But only when
incoming data and a timeout actually race, not on every timeout)

Link: https://lkml.kernel.org/r/xm26fsjotqda.fsf@google.com
Signed-off-by: Ben Segall <bsegall@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Roman Penyaev <rpenyaev@suse.de>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Khazhismel Kumykov <khazhy@google.com>
Cc: Heiher <r@hev.cc>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/fs/eventpoll.c~epoll-autoremove-wakers-even-more-aggressively
+++ a/fs/eventpoll.c
@@ -1747,6 +1747,21 @@ static struct timespec64 *ep_timeout_to_
 	return to;
 }
 
+/*
+ * autoremove_wake_function, but remove even on failure to wake up, because we
+ * know that default_wake_function/ttwu will only fail if the thread is already
+ * woken, and in that case the ep_poll loop will remove the entry anyways, not
+ * try to reuse it.
+ */
+static int ep_autoremove_wake_function(struct wait_queue_entry *wq_entry,
+				       unsigned int mode, int sync, void *key)
+{
+	int ret = default_wake_function(wq_entry, mode, sync, key);
+
+	list_del_init(&wq_entry->entry);
+	return ret;
+}
+
 /**
  * ep_poll - Retrieves ready events, and delivers them to the caller-supplied
  *           event buffer.
@@ -1828,8 +1843,15 @@ static int ep_poll(struct eventpoll *ep,
 		 * normal wakeup path no need to call __remove_wait_queue()
 		 * explicitly, thus ep->lock is not taken, which halts the
 		 * event delivery.
+		 *
+		 * In fact, we now use an even more aggressive function that
+		 * unconditionally removes, because we don't reuse the wait
+		 * entry between loop iterations. This lets us also avoid the
+		 * performance issue if a process is killed, causing all of its
+		 * threads to wake up without being removed normally.
 		 */
 		init_wait(&wait);
+		wait.func = ep_autoremove_wake_function;
 
 		write_lock_irq(&ep->lock);
 		/*
_

Patches currently in -mm which might be from bsegall@google.com are

epoll-autoremove-wakers-even-more-aggressively.patch

