From: akpm@linux-foundation.org
Subject: +
 kprobes-makes-kprobes-enabled-works-correctly-for-optimized-kprobes.patch
 added to -mm tree
Date: Thu, 05 Feb 2015 14:50:23 -0800
Message-ID: <54d3f3af.2X+SZpR7dVGbfhD+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37405 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbbBEWuY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2015 17:50:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangnan0@huawei.com, masami.hiramatsu.pt@hitachi.com, mingo@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kprobes: makes kprobes/enabled works correctly for optimized kprobes.
has been added to the -mm tree.  Its filename is
     kprobes-makes-kprobes-enabled-works-correctly-for-optimized-kprobes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kprobes-makes-kprobes-enabled-works-correctly-for-optimized-kprobes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kprobes-makes-kprobes-enabled-works-correctly-for-optimized-kprobes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wang Nan <wangnan0@huawei.com>
Subject: kprobes: makes kprobes/enabled works correctly for optimized kprobes.

debugfs/kprobes/enabled doesn't work correctly on optimized kprobes. 
Masami Hiramatsu has a test report on x86_64 platform:

https://lkml.org/lkml/2015/1/19/274

This patch forces it to unoptimize kprobe if kprobes_all_disarmed is set. 
It also checks the flag in unregistering path for skipping unneeded
disarming process when kprobes globally disarmed.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN kernel/kprobes.c~kprobes-makes-kprobes-enabled-works-correctly-for-optimized-kprobes kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-makes-kprobes-enabled-works-correctly-for-optimized-kprobes
+++ a/kernel/kprobes.c
@@ -869,7 +869,8 @@ static void __disarm_kprobe(struct kprob
 {
 	struct kprobe *_p;
 
-	unoptimize_kprobe(p, false);	/* Try to unoptimize */
+	/* Try to unoptimize */
+	unoptimize_kprobe(p, kprobes_all_disarmed);
 
 	if (!kprobe_queued(p)) {
 		arch_disarm_kprobe(p);
@@ -1571,7 +1572,13 @@ static struct kprobe *__disable_kprobe(s
 
 		/* Try to disarm and disable this/parent probe */
 		if (p == orig_p || aggr_kprobe_disabled(orig_p)) {
-			disarm_kprobe(orig_p, true);
+			/*
+			 * If kprobes_all_disarmed is set, orig_p
+			 * should have already been disarmed, so
+			 * skip unneed disarming process.
+			 */
+			if (!kprobes_all_disarmed)
+				disarm_kprobe(orig_p, true);
 			orig_p->flags |= KPROBE_FLAG_DISABLED;
 		}
 	}
_

Patches currently in -mm which might be from wangnan0@huawei.com are

kprobes-set-kprobes_all_disarmed-earlier-to-enable-re-optimization.patch
kprobes-makes-kprobes-enabled-works-correctly-for-optimized-kprobes.patch
linux-next.patch

