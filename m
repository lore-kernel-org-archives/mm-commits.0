Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E503DECAAD5
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 04:56:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiILE4n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Sep 2022 00:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiILE4Z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2022 00:56:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961982654A
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 21:56:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28E61B80C6D
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 04:56:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5895C433B5;
        Mon, 12 Sep 2022 04:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662958581;
        bh=FTj7jy2GGHdDrgs5mAG26Yx3UETtHzMv8TmH+lb24As=;
        h=Date:To:From:Subject:From;
        b=PaFeV3UeEipFl6gVbp84RD7N/tlkLZDb+F/UxCRdqT7lBkHD+W7jZGga5jxTZmHrJ
         OzupVRbpSf4JbEHC75r8F/NjZ1AVE07+P2wjvytOqnOmR8kFWcpVkl6M2FWfLEm/Tp
         /34gTY0IE5ncNePQ+URhsIuFCpcwQ8xThysioXwU=
Date:   Sun, 11 Sep 2022 21:56:21 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de, kch@nvidia.com,
        joe@perches.com, fmdefrancesco@gmail.com, ira.weiny@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-add-kmap-and-kmap_atomic-to-the-deprecated-list.patch removed from -mm tree
Message-Id: <20220912045621.D5895C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: checkpatch: add kmap and kmap_atomic to the deprecated list
has been removed from the -mm tree.  Its filename was
     checkpatch-add-kmap-and-kmap_atomic-to-the-deprecated-list.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ira Weiny <ira.weiny@intel.com>
Subject: checkpatch: add kmap and kmap_atomic to the deprecated list
Date: Sat, 13 Aug 2022 15:00:34 -0700

kmap() and kmap_atomic() are being deprecated in favor of
kmap_local_page().

There are two main problems with kmap(): (1) It comes with an overhead as
mapping space is restricted and protected by a global lock for
synchronization and (2) it also requires global TLB invalidation when the
kmap's pool wraps and it might block when the mapping space is fully
utilized until a slot becomes available.

kmap_local_page() is safe from any context and is therefore redundant with
kmap_atomic() with the exception of any pagefault or preemption disable
requirements.  However, using kmap_atomic() for these side effects makes
the code less clear.  So any requirement for pagefault or preemption
disable should be made explicitly.

With kmap_local_page() the mappings are per thread, CPU local, can take
page faults, and can be called from any context (including interrupts). 
It is faster than kmap() in kernels with HIGHMEM enabled.  Furthermore,
the tasks can be preempted and, when they are scheduled to run again, the
kernel virtual addresses are restored.

Link: https://lkml.kernel.org/r/20220813220034.806698-1-ira.weiny@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Suggested-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 ++
 1 file changed, 2 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-add-kmap-and-kmap_atomic-to-the-deprecated-list
+++ a/scripts/checkpatch.pl
@@ -807,6 +807,8 @@ our %deprecated_apis = (
 	"rcu_barrier_sched"			=> "rcu_barrier",
 	"get_state_synchronize_sched"		=> "get_state_synchronize_rcu",
 	"cond_synchronize_sched"		=> "cond_synchronize_rcu",
+	"kmap"					=> "kmap_local_page",
+	"kmap_atomic"				=> "kmap_local_page",
 );
 
 #Create a search pattern for all these strings to speed up a loop below
_

Patches currently in -mm which might be from ira.weiny@intel.com are


