From: akpm@linux-foundation.org
Subject: + tomoyo-remove-tomoyo_gc_thread-daemonize.patch added to -mm tree
Date: Tue, 16 Aug 2011 12:55:09 -0700
Message-ID: <201108161955.p7GJtAF5021562@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46254 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751416Ab1HPUG3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 16:06:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, jmorris@namei.org, penguin-kernel@I-love.SAKURA.ne.jp, takedakn@nttdata.co.jp


The patch titled
     tomoyo: remove tomoyo_gc_thread()->daemonize()
has been added to the -mm tree.  Its filename is
     tomoyo-remove-tomoyo_gc_thread-daemonize.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tomoyo: remove tomoyo_gc_thread()->daemonize()
From: Oleg Nesterov <oleg@redhat.com>

daemonize() is only needed when a user-space task does kernel_thread().

tomoyo_gc_thread() is kthread_create()'ed and thus it doesn't need
the soon-to-be-deprecated daemonize().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/tomoyo/gc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN security/tomoyo/gc.c~tomoyo-remove-tomoyo_gc_thread-daemonize security/tomoyo/gc.c
--- a/security/tomoyo/gc.c~tomoyo-remove-tomoyo_gc_thread-daemonize
+++ a/security/tomoyo/gc.c
@@ -660,7 +660,7 @@ static int tomoyo_gc_thread(void *unused
 	static DEFINE_MUTEX(tomoyo_gc_mutex);
 	if (!mutex_trylock(&tomoyo_gc_mutex))
 		goto out;
-	daemonize("GC for TOMOYO");
+
 	do {
 		tomoyo_collect_entry();
 		if (list_empty(&tomoyo_gc_list))
_

Patches currently in -mm which might be from oleg@redhat.com are

tomoyo-remove-tomoyo_gc_thread-daemonize.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch

