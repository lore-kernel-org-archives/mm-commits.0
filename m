Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 454A6C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  7 Dec 2021 23:49:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233993AbhLGXw6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Dec 2021 18:52:58 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51974 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbhLGXw6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Dec 2021 18:52:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E138B81EBA
        for <mm-commits@vger.kernel.org>; Tue,  7 Dec 2021 23:49:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09EEDC341C3;
        Tue,  7 Dec 2021 23:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638920965;
        bh=mZjjkoTnQAUGtuuoUUMm7UFFWOctupvFQ+RVwPi7xQ0=;
        h=Date:From:To:Subject:From;
        b=b//dadZrzwaQrZ8+PldjVM5JGp98+bYwW+Z0psrvyh0NY+GR3fnWzwWGrEtGCr5d+
         ERVqhQqe60giKtItOfamMltv7IpHlr5bgY1mlxCLALBgafCjx0f86vZN/jbZLC6pUP
         0AXc+ruiQQGy4gBwLi88CjMy/CjDS9bE6PK/1qYE=
Date:   Tue, 07 Dec 2021 15:49:24 -0800
From:   akpm@linux-foundation.org
To:     jsavitz@redhat.com, longman@redhat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, npache@redhat.com, peterz@infradead.org
Subject:  +
 =?US-ASCII?Q?mm-oom=5Fkill-wake-futex-waiters-before-annihilating-victi?=
 =?US-ASCII?Q?m-shared-mutex.patch?= added to -mm tree
Message-ID: <20211207234924.gtknfVfZB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/oom_kill: wake futex waiters before annihilating victim shared mutex
has been added to the -mm tree.  Its filename is
     mm-oom_kill-wake-futex-waiters-before-annihilating-victim-shared-mutex.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-oom_kill-wake-futex-waiters-before-annihilating-victim-shared-mutex.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-oom_kill-wake-futex-waiters-before-annihilating-victim-shared-mutex.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joel Savitz <jsavitz@redhat.com>
Subject: mm/oom_kill: wake futex waiters before annihilating victim shared mutex

In the case that two or more processes share a futex located within a
shared mmaped region, such as a process that shares a lock between itself
and a number of child processes, we have observed that when a process
holding the lock is oom killed, at least one waiter is never alerted to
this new development and simply continues to wait.

This is visible via pthreads by checking the __owner field of the
pthread_mutex_t structure within a waiting process, perhaps with gdb.

We identify reproduction of this issue by checking a waiting process of a
test program and viewing the contents of the pthread_mutex_t, taking note
of the value in the owner field, and then checking dmesg to see if the
owner has already been killed.

This issue can be tricky to reproduce, but with the modifications of this
small patch, I have found it to be impossible to reproduce.  There may be
additional considerations that I have not taken into account in this patch
and I welcome any comments and criticism.

Link: https://lkml.kernel.org/r/20211207214902.772614-1-jsavitz@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Co-developed-by: Nico Pache <npache@redhat.com>
Signed-off-by: Joel Savitz <jsavitz@redhat.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/oom_kill.c~mm-oom_kill-wake-futex-waiters-before-annihilating-victim-shared-mutex
+++ a/mm/oom_kill.c
@@ -44,6 +44,7 @@
 #include <linux/kthread.h>
 #include <linux/init.h>
 #include <linux/mmu_notifier.h>
+#include <linux/futex.h>
 
 #include <asm/tlb.h>
 #include "internal.h"
@@ -890,6 +891,7 @@ static void __oom_kill_process(struct ta
 	 * in order to prevent the OOM victim from depleting the memory
 	 * reserves from the user space under its control.
 	 */
+	futex_exit_release(victim);
 	do_send_sig_info(SIGKILL, SEND_SIG_PRIV, victim, PIDTYPE_TGID);
 	mark_oom_victim(victim);
 	pr_err("%s: Killed process %d (%s) total-vm:%lukB, anon-rss:%lukB, file-rss:%lukB, shmem-rss:%lukB, UID:%u pgtables:%lukB oom_score_adj:%hd\n",
@@ -930,6 +932,7 @@ static void __oom_kill_process(struct ta
 		 */
 		if (unlikely(p->flags & PF_KTHREAD))
 			continue;
+		futex_exit_release(p);
 		do_send_sig_info(SIGKILL, SEND_SIG_PRIV, p, PIDTYPE_TGID);
 	}
 	rcu_read_unlock();
_

Patches currently in -mm which might be from jsavitz@redhat.com are

mm-oom_kill-wake-futex-waiters-before-annihilating-victim-shared-mutex.patch

