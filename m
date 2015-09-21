From: akpm@linux-foundation.org
Subject: +
 mmoom-reverse-the-order-of-setting-tif_memdie-and-sending-sigkill.patch
 added to -mm tree
Date: Mon, 21 Sep 2015 15:02:45 -0700
Message-ID: <56007e85.IRfyreOHG4SMHbhn%akpm__9964.39378145642$1442872995$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56626 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404AbbIUWCq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Sep 2015 18:02:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@i-love.sakura.ne.jp, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/oom_kill.c: reverse the order of setting TIF_MEMDIE and sending SIGKILL
has been added to the -mm tree.  Its filename is
     mmoom-reverse-the-order-of-setting-tif_memdie-and-sending-sigkill.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmoom-reverse-the-order-of-setting-tif_memdie-and-sending-sigkill.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmoom-reverse-the-order-of-setting-tif_memdie-and-sending-sigkill.patch

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
Subject: mm/oom_kill.c: reverse the order of setting TIF_MEMDIE and sending SIGKILL

It was confirmed that a local unprivileged user can consume all memory
reserves and hang up that system using time lag between the OOM killer
sets TIF_MEMDIE on an OOM victim and sends SIGKILL to that victim, for
printk() inside for_each_process() loop at oom_kill_process() can consume
many seconds when there are many thread groups sharing the same memory.

Before starting oom-depleter process:

    Node 0 DMA: 3*4kB (UM) 6*8kB (U) 4*16kB (UEM) 0*32kB 0*64kB 1*128kB (M) 2*256kB (EM) 2*512kB (UE) 2*1024kB (EM) 1*2048kB (E) 1*4096kB (M) = 9980kB
    Node 0 DMA32: 31*4kB (UEM) 27*8kB (UE) 32*16kB (UE) 13*32kB (UE) 14*64kB (UM) 7*128kB (UM) 8*256kB (UM) 8*512kB (UM) 3*1024kB (U) 4*2048kB (UM) 362*4096kB (UM) = 1503220kB

As of invoking the OOM killer:

    Node 0 DMA: 11*4kB (UE) 8*8kB (UEM) 6*16kB (UE) 2*32kB (EM) 0*64kB 1*128kB (U) 3*256kB (UEM) 2*512kB (UE) 3*1024kB (UEM) 1*2048kB (U) 0*4096kB = 7308kB
    Node 0 DMA32: 1049*4kB (UEM) 507*8kB (UE) 151*16kB (UE) 53*32kB (UEM) 83*64kB (UEM) 52*128kB (EM) 25*256kB (UEM) 11*512kB (M) 6*1024kB (UM) 1*2048kB (M) 0*4096kB = 44556kB

Between the thread group leader got TIF_MEMDIE and receives SIGKILL:

    Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 0kB
    Node 0 DMA32: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 0kB

The oom-depleter's thread group leader which got TIF_MEMDIE started
memset() in user space after the OOM killer set TIF_MEMDIE, and it was
free to abuse ALLOC_NO_WATERMARKS by TIF_MEMDIE for memset() in user space
until SIGKILL is delivered.  If SIGKILL is delivered before TIF_MEMDIE is
set, the oom-depleter can terminate without touching memory reserves.

Although the possibility of hitting this time lag is very small for 3.19
and earlier kernels because TIF_MEMDIE is set immediately before sending
SIGKILL, preemption or long interrupts (an extreme example is SysRq-t) can
step between and allow memory allocations which are not needed for
terminating the OOM victim.

Fixes: 83363b917a29 ("oom: make sure that TIF_MEMDIE is set under task_lock")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>	[4.0+]

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/oom_kill.c~mmoom-reverse-the-order-of-setting-tif_memdie-and-sending-sigkill mm/oom_kill.c
--- a/mm/oom_kill.c~mmoom-reverse-the-order-of-setting-tif_memdie-and-sending-sigkill
+++ a/mm/oom_kill.c
@@ -563,6 +563,8 @@ void oom_kill_process(struct oom_control
 
 	/* mm cannot safely be dereferenced after task_unlock(victim) */
 	mm = victim->mm;
+	/* Send SIGKILL before setting TIF_MEMDIE. */
+	do_send_sig_info(SIGKILL, SEND_SIG_FORCED, victim, true);
 	mark_oom_victim(victim);
 	pr_err("Killed process %d (%s) total-vm:%lukB, anon-rss:%lukB, file-rss:%lukB\n",
 		task_pid_nr(victim), victim->comm, K(victim->mm->total_vm),
@@ -594,7 +596,6 @@ void oom_kill_process(struct oom_control
 		}
 	rcu_read_unlock();
 
-	do_send_sig_info(SIGKILL, SEND_SIG_FORCED, victim, true);
 	put_task_struct(victim);
 }
 #undef K
_

Patches currently in -mm which might be from penguin-kernel@i-love.sakura.ne.jp are

mmoom-reverse-the-order-of-setting-tif_memdie-and-sending-sigkill.patch
mmoom-fix-potentially-killing-unrelated-process.patch
mmoom-suppress-unnecessary-sharing-same-memory-message.patch
lib-vsprintf-add-%pt-format-specifier.patch

