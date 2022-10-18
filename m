Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22717C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 23:14:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiJRXOc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Oct 2022 19:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiJRXOb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2022 19:14:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EB21004C
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 16:14:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DA3FB8218E
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 23:14:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526CEC433C1;
        Tue, 18 Oct 2022 23:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666134867;
        bh=it/XwiKa/HgY7E43MxGfG1iOA62gzVwOHzG9ZAAjHxI=;
        h=Date:To:From:Subject:From;
        b=THJf9yrJsV+3TUpbiUCkRrZi1ibZr4ggxgy80RQvfhGaA+lBCCvyStqPniTqO9xOy
         9Brr3l1gI3rsA2A7BZtcyjRhQ75zK399vy8ti9JzTUm798o9+smzlZP9gWhtSYYTSd
         ubb1RoBPZp+SfevxKbzAmV2Yz45QTa+QUiFmQ9fE=
Date:   Tue, 18 Oct 2022 16:14:26 -0700
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com,
        ivan@cloudflare.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3.patch added to mm-nonmm-unstable branch
Message-Id: <20221018231427.526CEC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Ivan Babrou <ivan@cloudflare.com>
Subject: proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3
Date: Mon, 17 Oct 2022 21:58:44 -0700

use bitmap_weight() to count the bits

Link: https://lkml.kernel.org/r/20221018045844.37697-1-ivan@cloudflare.com
Signed-off-by: Ivan Babrou <ivan@cloudflare.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/fd.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/fs/proc/fd.c~proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3
+++ a/fs/proc/fd.c
@@ -283,7 +283,7 @@ static int proc_readfd_count(struct inod
 {
 	struct task_struct *p = get_proc_task(inode);
 	struct fdtable *fdt;
-	unsigned int i, size, open_fds = 0;
+	unsigned int open_fds = 0;
 
 	if (!p)
 		return -ENOENT;
@@ -293,10 +293,7 @@ static int proc_readfd_count(struct inod
 		rcu_read_lock();
 
 		fdt = files_fdtable(p->files);
-		size = fdt->max_fds;
-
-		for (i = size / BITS_PER_LONG; i > 0;)
-			open_fds += hweight64(fdt->open_fds[--i]);
+		open_fds = bitmap_weight(fdt->open_fds, fdt->max_fds);
 
 		rcu_read_unlock();
 	}
_

Patches currently in -mm which might be from ivan@cloudflare.com are

proc-report-open-files-as-size-in-stat-for-proc-pid-fd.patch
proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3.patch

