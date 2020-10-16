Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA2FDC43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:11:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F0FB20878
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817869;
	bh=+p9lnZQkfrMJu7ufTwIg2uUjFMb+uNWXcVqipAf0rXM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=gmsfcs/PD8JpvVfS79/3tgCWTrcBjNwHlWPEmeTiqkfPbm0dk+i3vef9j0m11qRcE
	 2L9YgVJtygJSGT/A0oB91dPlAHrsrOoDb9h+QADThtRvDg0Nh/MIaijUlcU3kRFlii
	 gswbRwwMpkUCKiOVkiVa+kGMMUr53L4QMd04tn4U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388316AbgJPDLJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:11:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387864AbgJPDLJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:11:09 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5316E2087D;
        Fri, 16 Oct 2020 03:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817868;
        bh=+p9lnZQkfrMJu7ufTwIg2uUjFMb+uNWXcVqipAf0rXM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=hFy/zJzcI1Jxf+/SsqXr1+848h6NSSNaY/9nFSBShzb92maIJr0gAtVwEl362XAku
         Lmb0N6UPcQE4xCS464KbnFB3PZ/WekdNqvMv8QOj4EbRuL4xSAI0Qs1rIC8QB3I8xz
         22DbnYNac4Ei2Zl4EMrdhv3vGw/Zv+wWDCmG+PhU=
Date:   Thu, 15 Oct 2020 20:11:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, torvalds@linux-foundation.org
Subject:  [patch 109/156] lib: syscall: delete duplicated words
Message-ID: <20201016031107.wSBcJ7eBS%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
