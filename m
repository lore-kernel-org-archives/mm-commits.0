Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5242ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 04:58:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbiILE6o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Sep 2022 00:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiILE5L (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2022 00:57:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A67F128E1C
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 21:57:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5739260AF4
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 04:57:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEFC9C433C1;
        Mon, 12 Sep 2022 04:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662958627;
        bh=RZv86LhReflCHSKHnSNwesaoksYCexGEEqKzHg5fGp4=;
        h=Date:To:From:Subject:From;
        b=CkAsUt0NqxjS4Y4l33o9sVvGaWTWq3HBuFeADrGO5eF5ZWC6nLzzyr1vJCrjkEeXh
         dBkvQ2vYHCZLbMDx6bnOFxbHgVYXvcHI7EUQfnTHmM7UAWiD6MqgiNKIhBFztLdZCY
         KDa3QEfJEPkjk5aBEdBOD0SUxfCZUvwfdFmjIzCg=
Date:   Sun, 11 Sep 2022 21:57:07 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        mcgrof@kernel.org, akpm@linux-foudation.org, wuchi.zero@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] latencytop-use-the-last-element-of-latency_record-of-system.patch removed from -mm tree
Message-Id: <20220912045707.AEFC9C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: latencytop: use the last element of latency_record of system
has been removed from the -mm tree.  Its filename was
     latencytop-use-the-last-element-of-latency_record-of-system.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: wuchi <wuchi.zero@gmail.com>
Subject: latencytop: use the last element of latency_record of system
Date: Sat, 3 Sep 2022 21:52:33 +0800

In account_global_scheduler_latency(), when we don't find the matching
latency_record we try to select one which is unused in
latency_record[MAXLR], but the condition will skip the last one.

if (i >= MAXLR-1)

Fix that.

Link: https://lkml.kernel.org/r/20220903135233.5225-1-wuchi.zero@gmail.com
Signed-off-by: wuchi <wuchi.zero@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foudation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/latencytop.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/latencytop.c~latencytop-use-the-last-element-of-latency_record-of-system
+++ a/kernel/latencytop.c
@@ -112,7 +112,7 @@ static void __sched
 account_global_scheduler_latency(struct task_struct *tsk,
 				 struct latency_record *lat)
 {
-	int firstnonnull = MAXLR + 1;
+	int firstnonnull = MAXLR;
 	int i;
 
 	/* skip kernel threads for now */
@@ -150,7 +150,7 @@ account_global_scheduler_latency(struct
 	}
 
 	i = firstnonnull;
-	if (i >= MAXLR - 1)
+	if (i >= MAXLR)
 		return;
 
 	/* Allocted a new one: */
_

Patches currently in -mm which might be from wuchi.zero@gmail.com are

lib-debugobjects-fix-stat-count-and-optimize-debug_objects_mem_init.patch
relay-use-kvcalloc-to-alloc-page-array-in-relay_alloc_page_array.patch

