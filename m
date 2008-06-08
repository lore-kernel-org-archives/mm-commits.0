From: akpm@linux-foundation.org
Subject: + update-taskstats-struct-document-for-scaled-time-accounting.patch added to -mm tree
Date: Sun, 08 Jun 2008 13:43:16 -0700
Message-ID: <200806082043.m58KhGF1019604@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39356 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754317AbYFHUnT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 16:43:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: h-shimamoto@ct.jp.nec.com


The patch titled
     Update taskstats-struct document for scaled time accounting
has been added to the -mm tree.  Its filename is
     update-taskstats-struct-document-for-scaled-time-accounting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Update taskstats-struct document for scaled time accounting
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Update Documentation/accounting/taskstats-struct.txt for TASKSTATS_VERSION 6,
adding scaled time accounting.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/taskstats-struct.txt |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN Documentation/accounting/taskstats-struct.txt~update-taskstats-struct-document-for-scaled-time-accounting Documentation/accounting/taskstats-struct.txt
--- a/Documentation/accounting/taskstats-struct.txt~update-taskstats-struct-document-for-scaled-time-accounting
+++ a/Documentation/accounting/taskstats-struct.txt
@@ -24,6 +24,8 @@ There are three different groups of fiel
 
 4) Per-task and per-thread context switch count statistics
 
+5) Time accounting for SMT machines
+
 Future extension should add fields to the end of the taskstats struct, and
 should not change the relative position of each field within the struct.
 
@@ -164,4 +166,8 @@ struct taskstats {
 	__u64	nvcsw;			/* Context voluntary switch counter */
 	__u64	nivcsw;			/* Context involuntary switch counter */
 
+5) Time accounting for SMT machines
+	__u64	ac_utimescaled;		/* utime scaled on frequency etc */
+	__u64	ac_stimescaled;		/* stime scaled on frequency etc */
+	__u64	cpu_scaled_run_real_total; /* scaled cpu_run_real_total */
 }
_

Patches currently in -mm which might be from h-shimamoto@ct.jp.nec.com are

linux-next.patch
update-taskstats-struct-document-for-scaled-time-accounting.patch

