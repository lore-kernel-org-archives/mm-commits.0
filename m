Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84233E936E3
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:24:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245069AbjJDUYy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245091AbjJDUXp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:23:45 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84EEA1B6
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:23:41 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5A2C433C7;
        Wed,  4 Oct 2023 20:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696451021;
        bh=KB3sDfYpxKJ1iUCK7BXz9ShFqfS1rm1Gmc7VRQ3usU4=;
        h=Date:To:From:Subject:From;
        b=tOLwdVtyayBrqmfiQuMXIN0SRuL/iHM9wcbNicPzCuCUQ4BYlu7jAQvgspZZtIisr
         quo2L8o7+OwCLR/nUtZLbuQciQmiCHpcf1i+/7ub/DnzPW5G/8e73P8t8Qvu9/y1Z6
         6kR4VjZ6hL8GMCn0/iYw8rw775dRyDdVEPR2Ta6Q=
Date:   Wed, 04 Oct 2023 13:23:39 -0700
To:     mm-commits@vger.kernel.org, ebiederm@xmission.com, oleg@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] getrusage-add-the-signal_struct-sig-local-variable.patch removed from -mm tree
Message-Id: <20231004202340.EE5A2C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: getrusage: add the "signal_struct *sig" local variable
has been removed from the -mm tree.  Its filename was
     getrusage-add-the-signal_struct-sig-local-variable.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: getrusage: add the "signal_struct *sig" local variable
Date: Sat, 9 Sep 2023 19:25:54 +0200

No functional changes, cleanup/preparation.

Link: https://lkml.kernel.org/r/20230909172554.GA20441@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

--- a/kernel/sys.c~getrusage-add-the-signal_struct-sig-local-variable
+++ a/kernel/sys.c
@@ -1786,6 +1786,7 @@ void getrusage(struct task_struct *p, in
 	unsigned long flags;
 	u64 tgutime, tgstime, utime, stime;
 	unsigned long maxrss = 0;
+	struct signal_struct *sig = p->signal;
 
 	memset((char *)r, 0, sizeof (*r));
 	utime = stime = 0;
@@ -1793,7 +1794,7 @@ void getrusage(struct task_struct *p, in
 	if (who == RUSAGE_THREAD) {
 		task_cputime_adjusted(current, &utime, &stime);
 		accumulate_thread_rusage(p, r);
-		maxrss = p->signal->maxrss;
+		maxrss = sig->maxrss;
 		goto out;
 	}
 
@@ -1803,15 +1804,15 @@ void getrusage(struct task_struct *p, in
 	switch (who) {
 	case RUSAGE_BOTH:
 	case RUSAGE_CHILDREN:
-		utime = p->signal->cutime;
-		stime = p->signal->cstime;
-		r->ru_nvcsw = p->signal->cnvcsw;
-		r->ru_nivcsw = p->signal->cnivcsw;
-		r->ru_minflt = p->signal->cmin_flt;
-		r->ru_majflt = p->signal->cmaj_flt;
-		r->ru_inblock = p->signal->cinblock;
-		r->ru_oublock = p->signal->coublock;
-		maxrss = p->signal->cmaxrss;
+		utime = sig->cutime;
+		stime = sig->cstime;
+		r->ru_nvcsw = sig->cnvcsw;
+		r->ru_nivcsw = sig->cnivcsw;
+		r->ru_minflt = sig->cmin_flt;
+		r->ru_majflt = sig->cmaj_flt;
+		r->ru_inblock = sig->cinblock;
+		r->ru_oublock = sig->coublock;
+		maxrss = sig->cmaxrss;
 
 		if (who == RUSAGE_CHILDREN)
 			break;
@@ -1821,14 +1822,14 @@ void getrusage(struct task_struct *p, in
 		thread_group_cputime_adjusted(p, &tgutime, &tgstime);
 		utime += tgutime;
 		stime += tgstime;
-		r->ru_nvcsw += p->signal->nvcsw;
-		r->ru_nivcsw += p->signal->nivcsw;
-		r->ru_minflt += p->signal->min_flt;
-		r->ru_majflt += p->signal->maj_flt;
-		r->ru_inblock += p->signal->inblock;
-		r->ru_oublock += p->signal->oublock;
-		if (maxrss < p->signal->maxrss)
-			maxrss = p->signal->maxrss;
+		r->ru_nvcsw += sig->nvcsw;
+		r->ru_nivcsw += sig->nivcsw;
+		r->ru_minflt += sig->min_flt;
+		r->ru_majflt += sig->maj_flt;
+		r->ru_inblock += sig->inblock;
+		r->ru_oublock += sig->oublock;
+		if (maxrss < sig->maxrss)
+			maxrss = sig->maxrss;
 		t = p;
 		do {
 			accumulate_thread_rusage(t, r);
_

Patches currently in -mm which might be from oleg@redhat.com are


