Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBE98C19F2D
	for <mm-commits@archiver.kernel.org>; Sat, 13 Aug 2022 23:14:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiHMXO0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 13 Aug 2022 19:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiHMXOZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 13 Aug 2022 19:14:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D640689822
        for <mm-commits@vger.kernel.org>; Sat, 13 Aug 2022 16:14:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B95160F13
        for <mm-commits@vger.kernel.org>; Sat, 13 Aug 2022 23:14:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD965C433C1;
        Sat, 13 Aug 2022 23:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660432463;
        bh=7sv8iKAvYhNtXScIFayXZLeijANegg6M6jGudubJm4E=;
        h=Date:To:From:Subject:From;
        b=Fz7QN9K2/X/PmUV6SHidOIBijOHtnNOYtzlxf/UZOkpKOBOzRdVupNEiU7USYlJG8
         APEyuh6CH5AG5uvMYLN89Z65ibJbB/iOV+8L1FZN4HWuIgtvBVDtoNwRwtWPiPtkrK
         kIzhZlcRvbKXNZsYBBSBGoKEJhK+89kdApWa9FBU=
Date:   Sat, 13 Aug 2022 16:14:23 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de, joe@perches.com,
        fmdefrancesco@gmail.com, ira.weiny@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-add-kmap-and-kmap_atomic-to-the-deprecated-list.patch added to mm-nonmm-unstable branch
Message-Id: <20220813231423.BD965C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: Add kmap and kmap_atomic to the deprecated list
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-add-kmap-and-kmap_atomic-to-the-deprecated-list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-add-kmap-and-kmap_atomic-to-the-deprecated-list.patch

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
From: Ira Weiny <ira.weiny@intel.com>
Subject: checkpatch: Add kmap and kmap_atomic to the deprecated list
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

checkpatch-add-kmap-and-kmap_atomic-to-the-deprecated-list.patch

