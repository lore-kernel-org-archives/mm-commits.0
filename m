From: akpm@linux-foundation.org
Subject: [folded-merged]
 mmoom-reverse-the-order-of-setting-tif_memdie-and-sending-sigkill-v2.patch
 removed from -mm tree
Date: Thu, 05 Nov 2015 18:23:51 -0800
Message-ID: <563c0f37.DyfH+Tz+K6kxhbFP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52375 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031154AbbKFCXw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Nov 2015 21:23:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@i-love.sakura.ne.jp, mhocko@suse.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mmoom-reverse-the-order-of-setting-tif_memdie-and-sending-sigkill-v2
has been removed from the -mm tree.  Its filename was
     mmoom-reverse-the-order-of-setting-tif_memdie-and-sending-sigkill-v2.patch

This patch was dropped because it was folded into mmoom-reverse-the-order-of-setting-tif_memdie-and-sending-sigkill.patch

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: mmoom-reverse-the-order-of-setting-tif_memdie-and-sending-sigkill-v2

Cc: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/oom_kill.c~mmoom-reverse-the-order-of-setting-tif_memdie-and-sending-sigkill-v2 mm/oom_kill.c
--- a/mm/oom_kill.c~mmoom-reverse-the-order-of-setting-tif_memdie-and-sending-sigkill-v2
+++ a/mm/oom_kill.c
@@ -563,7 +563,11 @@ void oom_kill_process(struct oom_control
 
 	/* mm cannot safely be dereferenced after task_unlock(victim) */
 	mm = victim->mm;
-	/* Send SIGKILL before setting TIF_MEMDIE. */
+	/*
+	 * We should send SIGKILL before setting TIF_MEMDIE in order to prevent
+	 * the OOM victim from depleting the memory reserves from the user
+	 * space under its control.
+	 */
 	do_send_sig_info(SIGKILL, SEND_SIG_FORCED, victim, true);
 	mark_oom_victim(victim);
 	pr_err("Killed process %d (%s) total-vm:%lukB, anon-rss:%lukB, file-rss:%lukB\n",
_

Patches currently in -mm which might be from penguin-kernel@i-love.sakura.ne.jp are

mmoom-reverse-the-order-of-setting-tif_memdie-and-sending-sigkill.patch
mmoom-fix-potentially-killing-unrelated-process.patch
mmoom-suppress-unnecessary-sharing-same-memory-message.patch

