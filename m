Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9FEBC433F5
	for <mm-commits@archiver.kernel.org>; Mon, 28 Mar 2022 20:12:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343842AbiC1UOg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 16:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344321AbiC1UOg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 16:14:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B3B5C377
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 13:12:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90E316145F
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 20:12:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A6FC340ED;
        Mon, 28 Mar 2022 20:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648498374;
        bh=+hgmOiGLjZ7eLfnvbxVUA9eI+7wpsba1DbFMg5vygeY=;
        h=Date:To:From:Subject:From;
        b=XFG+8vZJiQMu6hrPfwHe1fO32V3ZhcFt4TKkhpGpq0odQmKXrzoa4Og13qg0Daq+N
         P1aLM2kBQMxQkEJ0tDIk6ocqkRZtxh/+XRexLdCpqsu4sSNU4lM4cUz8XnZE/E0vaR
         l/7x2TMsDr3gI6hfVs2QmcZ/35w5QrsgbTmU7iVo=
Date:   Mon, 28 Mar 2022 13:12:53 -0700
To:     mm-commits@vger.kernel.org, Julia.Lawall@inria.fr,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ia64-fix-typos-in-comments.patch added to -mm tree
Message-Id: <20220328201253.E7A6FC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: fix typos in comments
has been added to the -mm tree.  Its filename is
     ia64-fix-typos-in-comments.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ia64-fix-typos-in-comments.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ia64-fix-typos-in-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Julia Lawall <Julia.Lawall@inria.fr>
Subject: ia64: fix typos in comments

Various spelling mistakes in comments.
Detected with the help of Coccinelle.

Link: https://lkml.kernel.org/r/20220318103729.157574-1-Julia.Lawall@inria.fr
Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/palinfo.c |    2 +-
 arch/ia64/kernel/traps.c   |    2 +-
 arch/ia64/mm/init.c        |    2 +-
 arch/ia64/mm/tlb.c         |    4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

--- a/arch/ia64/kernel/palinfo.c~ia64-fix-typos-in-comments
+++ a/arch/ia64/kernel/palinfo.c
@@ -120,7 +120,7 @@ static const char *mem_attrib[]={
  * Input:
  *	- a pointer to a buffer to hold the string
  *	- a 64-bit vector
- * Ouput:
+ * Output:
  *	- a pointer to the end of the buffer
  *
  */
--- a/arch/ia64/kernel/traps.c~ia64-fix-typos-in-comments
+++ a/arch/ia64/kernel/traps.c
@@ -309,7 +309,7 @@ handle_fpu_swa (int fp_fault, struct pt_
 			/*
 			 * Lower 4 bits are used as a count. Upper bits are a sequence
 			 * number that is updated when count is reset. The cmpxchg will
-			 * fail is seqno has changed. This minimizes mutiple cpus
+			 * fail is seqno has changed. This minimizes multiple cpus
 			 * resetting the count.
 			 */
 			if (current_jiffies > last.time)
--- a/arch/ia64/mm/init.c~ia64-fix-typos-in-comments
+++ a/arch/ia64/mm/init.c
@@ -451,7 +451,7 @@ mem_init (void)
 	memblock_free_all();
 
 	/*
-	 * For fsyscall entrpoints with no light-weight handler, use the ordinary
+	 * For fsyscall entrypoints with no light-weight handler, use the ordinary
 	 * (heavy-weight) handler, but mark it by setting bit 0, so the fsyscall entry
 	 * code can tell them apart.
 	 */
--- a/arch/ia64/mm/tlb.c~ia64-fix-typos-in-comments
+++ a/arch/ia64/mm/tlb.c
@@ -174,7 +174,7 @@ __setup("nptcg=", set_nptcg);
  * override table (in which case we should ignore the value from
  * PAL_VM_SUMMARY).
  *
- * Kernel parameter "nptcg=" overrides maximum number of simultanesous ptc.g
+ * Kernel parameter "nptcg=" overrides maximum number of simultaneous ptc.g
  * purges defined in either PAL_VM_SUMMARY or PAL override table. In this case,
  * we should ignore the value from either PAL_VM_SUMMARY or PAL override table.
  *
@@ -516,7 +516,7 @@ found:
 	if (i >= per_cpu(ia64_tr_num, cpu))
 		return -EBUSY;
 
-	/*Record tr info for mca hander use!*/
+	/*Record tr info for mca handler use!*/
 	if (i > per_cpu(ia64_tr_used, cpu))
 		per_cpu(ia64_tr_used, cpu) = i;
 
_

Patches currently in -mm which might be from Julia.Lawall@inria.fr are

ia64-fix-typos-in-comments.patch
ia64-ptrace-fix-typos-in-comments.patch

