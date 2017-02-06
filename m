From: akpm@linux-foundation.org
Subject: +
 mm-place-not-inside-of-unlikely-statement-in-wb_domain_writeout_inc.patch
 added to -mm tree
Date: Mon, 06 Feb 2017 15:25:54 -0800
Message-ID: <58990602.e3RDiUxKWmTfkTlq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34894 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752108AbdBFXZz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2017 18:25:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page-writeback.c: place "not" inside of unlikely() statement in wb_domain_writeout_inc()
has been added to the -mm tree.  Its filename is
     mm-place-not-inside-of-unlikely-statement-in-wb_domain_writeout_inc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-place-not-inside-of-unlikely-statement-in-wb_domain_writeout_inc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-place-not-inside-of-unlikely-statement-in-wb_domain_writeout_inc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-page_alloc-swap-likely-to-unlikely-as-code-logic-is-different-for-next_zones_zonelist.patch
shm-fix-unlikely-test-of-info-seals-to-test-only-for-write-and-grow.patch
mm-place-not-inside-of-unlikely-statement-in-wb_domain_writeout_inc.patch

