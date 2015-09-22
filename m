From: akpm@linux-foundation.org
Subject: +
 mmoom-reverse-the-order-of-setting-tif_memdie-and-sending-sigkill-v2.patch
 added to -mm tree
Date: Tue, 22 Sep 2015 13:02:29 -0700
Message-ID: <5601b3d5.44P1hKYewy6+SMBt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54557 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933446AbbIVUC3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Sep 2015 16:02:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@i-love.sakura.ne.jp, mhocko@suse.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mmoom-reverse-the-order-of-setting-tif_memdie-and-sending-sigkill-v2
has been added to the -mm tree.  Its filename is
     mmoom-reverse-the-order-of-setting-tif_memdie-and-sending-sigkill-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmoom-reverse-the-order-of-setting-tif_memdie-and-sending-sigkill-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmoom-reverse-the-order-of-setting-tif_memdie-and-sending-sigkill-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mmoom-reverse-the-order-of-setting-tif_memdie-and-sending-sigkill-v2.patch
mmoom-fix-potentially-killing-unrelated-process.patch
mmoom-suppress-unnecessary-sharing-same-memory-message.patch
lib-vsprintf-add-%pt-format-specifier.patch

