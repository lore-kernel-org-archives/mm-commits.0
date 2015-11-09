From: akpm@linux-foundation.org
Subject: [merged]
 signal-remove-jffs2_garbage_collect_thread-allow_signalsigcont.patch
 removed from -mm tree
Date: Mon, 09 Nov 2015 12:13:30 -0800
Message-ID: <5640fe6a.z9WjW/18fm8SFc/l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57664 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbbKIUNa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 15:13:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, balbi@ti.com, dwmw2@infradead.org, mpa@pengutronix.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: signal: remove jffs2_garbage_collect_thread()->allow_signal(SIGCONT)
has been removed from the -mm tree.  Its filename was
     signal-remove-jffs2_garbage_collect_thread-allow_signalsigcont.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: signal: remove jffs2_garbage_collect_thread()->allow_signal(SIGCONT)

jffs2_garbage_collect_thread() does allow_signal(SIGCONT) for no reason,
SIGCONT will wake a stopped task up even if it is ignored.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Markus Pargmann <mpa@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/background.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/jffs2/background.c~signal-remove-jffs2_garbage_collect_thread-allow_signalsigcont fs/jffs2/background.c
--- a/fs/jffs2/background.c~signal-remove-jffs2_garbage_collect_thread-allow_signalsigcont
+++ a/fs/jffs2/background.c
@@ -80,7 +80,6 @@ static int jffs2_garbage_collect_thread(
 	siginitset(&hupmask, sigmask(SIGHUP));
 	allow_signal(SIGKILL);
 	allow_signal(SIGSTOP);
-	allow_signal(SIGCONT);
 	allow_signal(SIGHUP);
 
 	c->gc_task = current;
_

Patches currently in -mm which might be from oleg@redhat.com are


