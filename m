From: akpm@linux-foundation.org
Subject: [merged] tomoyo-remove-tomoyo_gc_thread-daemonize.patch removed from -mm tree
Date: Wed, 17 Aug 2011 12:14:32 -0700
Message-ID: <201108171911.p7HJBdrx022346@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752793Ab1HQTMT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Aug 2011 15:12:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, jmorris@namei.org, matt.fleming@intel.com, penguin-kernel@I-love.SAKURA.ne.jp, takedakn@nttdata.co.jp, mm-commits@vger.kernel.org


The patch titled
     tomoyo: remove tomoyo_gc_thread()->daemonize()
has been removed from the -mm tree.  Its filename was
     tomoyo-remove-tomoyo_gc_thread-daemonize.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch

