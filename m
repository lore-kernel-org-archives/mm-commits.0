From: akpm@linux-foundation.org
Subject: [merged]
 mm-place-not-inside-of-unlikely-statement-in-wb_domain_writeout_inc.patch
 removed from -mm tree
Date: Mon, 27 Feb 2017 12:27:33 -0800
Message-ID: <58b48bb5.baZ1FTyyxc+a991H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60552 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751654AbdB0U2B (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:28:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page-writeback.c: place "not" inside of unlikely() statement in wb_domain_writeout_inc()
has been removed from the -mm tree.  Its filename was
     mm-place-not-inside-of-unlikely-statement-in-wb_domain_writeout_inc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: mm/page-writeback.c: place "not" inside of unlikely() statement in wb_domain_writeout_inc()

The likely/unlikely profiler noticed that the unlikely statement in
wb_domain_writeout_inc() is constantly wrong.  This is due to the "not"
(!) being outside the unlikely statement.  It is likely that
dom->period_time will be set, but unlikely that it wont be.  Move the not
into the unlikely statement.

Link: http://lkml.kernel.org/r/20170206120035.3c2e2b91@gandalf.local.home
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page-writeback.c~mm-place-not-inside-of-unlikely-statement-in-wb_domain_writeout_inc mm/page-writeback.c
--- a/mm/page-writeback.c~mm-place-not-inside-of-unlikely-statement-in-wb_domain_writeout_inc
+++ a/mm/page-writeback.c
@@ -580,7 +580,7 @@ static void wb_domain_writeout_inc(struc
 	__fprop_inc_percpu_max(&dom->completions, completions,
 			       max_prop_frac);
 	/* First event after period switching was turned off? */
-	if (!unlikely(dom->period_time)) {
+	if (unlikely(!dom->period_time)) {
 		/*
 		 * We can race with other __bdi_writeout_inc calls here but
 		 * it does not cause any harm since the resulting time when
_

Patches currently in -mm which might be from rostedt@goodmis.org are


