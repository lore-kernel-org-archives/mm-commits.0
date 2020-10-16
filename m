Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37AD8C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:48:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD75B2087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816482;
	bh=+p9lnZQkfrMJu7ufTwIg2uUjFMb+uNWXcVqipAf0rXM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Cdx7LU5Iv5TE2MoAqNAykttZSAFlZI7svdBahQTCtP93VUBAHqh74nCQl+u7bdvo5
	 pF8fHt61Xnf7gNYCb7HmQ4jfg7Fws4qpOhdWwFicWqwebHG3vzRUnRhemq3eimjMKR
	 WqschsyFc5FBgXMNNXvH0SzjuMXzcJFsgkVSicj0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404357AbgJPCsC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:48:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404351AbgJPCsC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:48:02 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62FED20897;
        Fri, 16 Oct 2020 02:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816480;
        bh=+p9lnZQkfrMJu7ufTwIg2uUjFMb+uNWXcVqipAf0rXM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Qf3zI6AyjRwLFsljdQvTqf0x+mT2Abpw27svtNntZ3H+AY7oz+PsJeYGgrKj2bCFu
         4mBwd04VVSeobsDOjn1g1VXTwKApu2O/7pRmfVGSwNQqZudiytQ0zHLXU+eCdwIb0v
         yHdJAkd7UgLf3+NGybaeZU6OKc6+LbtZDTfpDp/c=
Date:   Thu, 15 Oct 2020 19:47:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org
Subject:  [patch 109/156] lib: syscall: delete duplicated words
Message-ID: <20201016024759.kk479UAYy%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
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
