Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 059C5CDB465
	for <mm-commits@archiver.kernel.org>; Mon, 16 Oct 2023 22:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbjJPWaI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Oct 2023 18:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbjJPWaI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Oct 2023 18:30:08 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18F9A1
        for <mm-commits@vger.kernel.org>; Mon, 16 Oct 2023 15:30:06 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51676C433C7;
        Mon, 16 Oct 2023 22:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697495406;
        bh=nBHOYjOT8E+Sua1srtR/AnS0330bJhF2CKq4PXBzigA=;
        h=Date:To:From:Subject:From;
        b=nnpPlm5AynG/7WHApLkwtKdV4cgTjpWvWnssdwa20nwrdJ7Ixc8VC4parNoS5HO9X
         4gwjetJZxTcESI1Gj7awT4wqxQFQ0v/CuOK/hEj5g2+zsNY6NDtuoRQ6erUavoxUgE
         ZNl03347ppTBcGqjtcYgHxur8Hr/Bcx03RRdDaXQ=
Date:   Mon, 16 Oct 2023 15:30:05 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com, mhocko@suse.com,
        brauner@kernel.org, kasong@tencent.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-oom_killer-simplify-oom-killer-info-dump-helper.patch added to mm-unstable branch
Message-Id: <20231016223006.51676C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/oom_killer: simplify OOM killer info dump helper
has been added to the -mm mm-unstable branch.  Its filename is
     mm-oom_killer-simplify-oom-killer-info-dump-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-oom_killer-simplify-oom-killer-info-dump-helper.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/oom_killer: simplify OOM killer info dump helper
Date: Mon, 16 Oct 2023 19:31:03 +0800

There is only one caller wants to dump the kill victim info, so just let
it call the standalone helper, no need to make the generic info dump
helper take an extra argument for that.

Result of bloat-o-meter:
./scripts/bloat-o-meter ./mm/oom_kill.old.o ./mm/oom_kill.o
add/remove: 0/0 grow/shrink: 1/2 up/down: 131/-142 (-11)
Function                                     old     new   delta
oom_kill_process                             412     543    +131
out_of_memory                               1422    1418      -4
dump_header                                  562     424    -138
Total: Before=21514, After=21503, chg -0.05%

Link: https://lkml.kernel.org/r/20231016113103.86477-1-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/oom_kill.c~mm-oom_killer-simplify-oom-killer-info-dump-helper
+++ a/mm/oom_kill.c
@@ -437,7 +437,7 @@ static void dump_tasks(struct oom_contro
 	}
 }
 
-static void dump_oom_summary(struct oom_control *oc, struct task_struct *victim)
+static void dump_oom_victim(struct oom_control *oc, struct task_struct *victim)
 {
 	/* one line summary of the oom killer context. */
 	pr_info("oom-kill:constraint=%s,nodemask=%*pbl",
@@ -449,7 +449,7 @@ static void dump_oom_summary(struct oom_
 		from_kuid(&init_user_ns, task_uid(victim)));
 }
 
-static void dump_header(struct oom_control *oc, struct task_struct *p)
+static void dump_header(struct oom_control *oc)
 {
 	pr_warn("%s invoked oom-killer: gfp_mask=%#x(%pGg), order=%d, oom_score_adj=%hd\n",
 		current->comm, oc->gfp_mask, &oc->gfp_mask, oc->order,
@@ -467,8 +467,6 @@ static void dump_header(struct oom_contr
 	}
 	if (sysctl_oom_dump_tasks)
 		dump_tasks(oc);
-	if (p)
-		dump_oom_summary(oc, p);
 }
 
 /*
@@ -1029,8 +1027,10 @@ static void oom_kill_process(struct oom_
 	}
 	task_unlock(victim);
 
-	if (__ratelimit(&oom_rs))
-		dump_header(oc, victim);
+	if (__ratelimit(&oom_rs)) {
+		dump_header(oc);
+		dump_oom_victim(oc, victim);
+	}
 
 	/*
 	 * Do we need to kill the entire memory cgroup?
@@ -1072,7 +1072,7 @@ static void check_panic_on_oom(struct oo
 	/* Do not panic for oom kills triggered by sysrq */
 	if (is_sysrq_oom(oc))
 		return;
-	dump_header(oc, NULL);
+	dump_header(oc);
 	panic("Out of memory: %s panic_on_oom is enabled\n",
 		sysctl_panic_on_oom == 2 ? "compulsory" : "system-wide");
 }
@@ -1155,7 +1155,7 @@ bool out_of_memory(struct oom_control *o
 	select_bad_process(oc);
 	/* Found nothing?!?! */
 	if (!oc->chosen) {
-		dump_header(oc, NULL);
+		dump_header(oc);
 		pr_warn("Out of memory and no killable processes...\n");
 		/*
 		 * If we got here due to an actual allocation at the
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-oom_killer-simplify-oom-killer-info-dump-helper.patch

