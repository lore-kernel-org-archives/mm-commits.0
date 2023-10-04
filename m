Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D743E936E4
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:24:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245065AbjJDUYx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245084AbjJDUXm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:23:42 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A44C31B2
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:23:37 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003F7C433CA;
        Wed,  4 Oct 2023 20:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696451017;
        bh=h8oku1TlPs7RO0uui7Dy+/RL2wgGVWLUo6uJm0YM9U8=;
        h=Date:To:From:Subject:From;
        b=OSz7rzMGinTZWs1daPCqntYWNBLElSnMijEWVW5nu8RcO2wDIKUYXrSsy4AWumUSJ
         zT9T/4a9PP13LyXiOa7VEx1k3ovV0NoG48/NGTc7Lv8TXDBY0f/Q9Tuvim+kPUyuD7
         osdNSEirWG1gus6ESvMAnENF+LiKD3TIabQujkF0=
Date:   Wed, 04 Oct 2023 13:23:35 -0700
To:     mm-commits@vger.kernel.org, ebiederm@xmission.com, oleg@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fs-proc-do_task_stat-use-__for_each_thread.patch removed from -mm tree
Message-Id: <20231004202337.003F7C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs/proc: do_task_stat: use __for_each_thread()
has been removed from the -mm tree.  Its filename was
     fs-proc-do_task_stat-use-__for_each_thread.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: fs/proc: do_task_stat: use __for_each_thread()
Date: Sat, 9 Sep 2023 18:45:01 +0200

do/while_each_thread should be avoided when possible.

Link: https://lkml.kernel.org/r/20230909164501.GA11581@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/proc/array.c~fs-proc-do_task_stat-use-__for_each_thread
+++ a/fs/proc/array.c
@@ -536,12 +536,13 @@ static int do_task_stat(struct seq_file
 
 		/* add up live thread stats at the group level */
 		if (whole) {
-			struct task_struct *t = task;
-			do {
+			struct task_struct *t;
+
+			__for_each_thread(sig, t) {
 				min_flt += t->min_flt;
 				maj_flt += t->maj_flt;
 				gtime += task_gtime(t);
-			} while_each_thread(task, t);
+			}
 
 			min_flt += sig->min_flt;
 			maj_flt += sig->maj_flt;
_

Patches currently in -mm which might be from oleg@redhat.com are


