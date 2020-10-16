Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F02C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A34A02145D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881590;
	bh=ZOMzeQ+7csI3PWnMouCF/XnI0YOukBZFHaye2aSPwvk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=bse8m/1M8Wrt4I1QGnvBY7wo4kbz8h+5/0eKU4dVIevzMABZCRyFiWiYZLVBm9dvv
	 GqHHapxnYtcx8BV2rSaXhL44yNXysIoPPx6bEmJK9Gs+1dGwfeYjaI6DgEqLVDCVEj
	 BVtKE5PYpqSZ3z+1/hPFsy2578DeqU8yDxpumOy4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409114AbgJPUxK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:53:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:41432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409109AbgJPUxK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:53:10 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C81A205CB;
        Fri, 16 Oct 2020 20:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881589;
        bh=ZOMzeQ+7csI3PWnMouCF/XnI0YOukBZFHaye2aSPwvk=;
        h=Date:From:To:Subject:From;
        b=WrKrPakFOQfst9eXFa4GCEDEMvpuM1RtAJfMFZnHzT6vtlvaose/UwK+FFUtEydNW
         derkvt4aYoENFQgte9LqUd404bawKjc1aXckgRkTroeI99BfW7x1FJjYN5CYG6dHRG
         eo6/1VoXo7s6kS15tCWWE8YhYbRrahdQTRUbM+sk=
Date:   Fri, 16 Oct 2020 13:53:09 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  [merged] lib-syscall-delete-duplicated-words.patch
 removed from -mm tree
Message-ID: <20201016205309.sMdnyvCNP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: syscall: delete duplicated words
has been removed from the -mm tree.  Its filename was
     lib-syscall-delete-duplicated-words.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: lib: syscall: delete duplicated words

Drop the repeated word "the".

Link: https://lkml.kernel.org/r/20200823040514.26136-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/syscall.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/syscall.c~lib-syscall-delete-duplicated-words
+++ a/lib/syscall.c
@@ -44,7 +44,7 @@ static int collect_syscall(struct task_s
  *			 .data.instruction_pointer - filled with user PC
  *
  * If @target is blocked in a system call, returns zero with @info.data.nr
- * set to the the call's number and @info.data.args filled in with its
+ * set to the call's number and @info.data.args filled in with its
  * arguments. Registers not used for system call arguments may not be available
  * and it is not kosher to use &struct user_regset calls while the system
  * call is still in progress.  Note we may get this result if @target
_

Patches currently in -mm which might be from rdunlap@infradead.org are


