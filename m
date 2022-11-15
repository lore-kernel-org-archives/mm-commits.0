Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A3FCC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:26:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbiKOW0I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:26:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231591AbiKOW0G (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:26:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C1A82A941
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:26:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C265461A04
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:26:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC55C433C1;
        Tue, 15 Nov 2022 22:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551165;
        bh=Qh0bsqY4ipa+NKB1xVLVNeqd/jgh0cZlCvPED7pCWLE=;
        h=Date:To:From:Subject:From;
        b=nk22/WJZ006h+Vh6p2eLCggos3NB2/xlSQe/fLbbHq31vdeAdV0fzxkrLKJaJCwSg
         xEdnuYgabu1HkZbwrKfD1/rqPDuFaKEhVFPuSDaGcEHy+tuaHvk8zTHMRnD7hk84ZP
         nvVchFrDdrRYYeqx9cs3COywL0ksCBG/OTkRzZBw=
Date:   Tue, 15 Nov 2022 14:26:04 -0800
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu,
        rppt@kernel.org, paul.gortmaker@windriver.com,
        mail@christoph.anton.mitterer.name, kaleshsingh@google.com,
        hannes@cmpxchg.org, david@redhat.com, David.Laight@ACULAB.COM,
        corbet@lwn.net, adobriyan@gmail.com, ivan@cloudflare.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3.patch removed from -mm tree
Message-Id: <20221115222605.1CC55C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3
has been removed from the -mm tree.  Its filename was
     proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3.patch

This patch was dropped because it was folded into proc-report-open-files-as-size-in-stat-for-proc-pid-fd.patch

------------------------------------------------------
From: Ivan Babrou <ivan@cloudflare.com>
Subject: proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3
Date: Mon, 17 Oct 2022 21:58:44 -0700

use bitmap_weight() to count the bits

Link: https://lkml.kernel.org/r/20221018045844.37697-1-ivan@cloudflare.com
Signed-off-by: Ivan Babrou <ivan@cloudflare.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Theodore Ts'o <tytso@mit.edu>
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
proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v4.patch

