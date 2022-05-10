Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D97A0C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:19:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236249AbiEJEXk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236272AbiEJEVw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:21:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 587751AEC69
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:17:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C277B81AF1
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:17:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA4BC385A6;
        Tue, 10 May 2022 04:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156240;
        bh=IEeQe/XxEPQDXhv+zxMfzyC2y1IanMEfe7xQMULJJIY=;
        h=Date:To:From:Subject:From;
        b=MOKCJGwOGfyVhI7rl7hm0+6vC6rzwudSeuJ4KmYq7XxhmyQb2BYyjxlBU8/TBuHAo
         b4drwp6BQ5fVKcgP8Jjdbcj/5FLE+TXsD9GNrB4GGHjxjZ3GwzF1x1C4sS86R2G98H
         dkEiu3viTDX46RRGhGK6ysBv9RabCZoiKtHm3bQ8=
Date:   Mon, 09 May 2022 21:17:20 -0700
To:     mm-commits@vger.kernel.org, Julia.Lawall@inria.fr,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ia64-fix-typos-in-comments.patch removed from -mm tree
Message-Id: <20220510041720.CDA4BC385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ia64: fix typos in comments
has been removed from the -mm tree.  Its filename was
     ia64-fix-typos-in-comments.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


