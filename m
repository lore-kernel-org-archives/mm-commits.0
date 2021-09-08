Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3866C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:58:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A08A561152
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:58:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347363AbhIHC77 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:59:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234389AbhIHC77 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:59:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 364AC60E52;
        Wed,  8 Sep 2021 02:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069932;
        bh=q2a53TECowJ/nCej29I44K5ajEbbZzbQeEKJpyolSIM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=N011nfnUWLs6GjfiIXFWyYbdFG8I//KgDs5uepQFROTeGgsrsB2Z49dqx3OR1ipgQ
         IAY93ti266R7zJmDvQO034TV87jMUwdekC4ZaoFvI8PB8NO69q7qk05aHqOXf6myZv
         AC6a5/sJsm1V97n/61sK+1iDwfsJv9h7Ytr0mtfk=
Date:   Tue, 07 Sep 2021 19:58:51 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org
Subject:  [patch 105/147] lib/dump_stack: correct kernel-doc
 notation
Message-ID: <20210908025851.yQjTej88p%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: lib/dump_stack: correct kernel-doc notation

Fix kernel-doc warnings in dump_stack.c:

lib/dump_stack.c:97: warning: Function parameter or member 'log_lvl' not described in 'dump_stack_lvl'
lib/dump_stack.c:97: warning: expecting prototype for dump_stack(). Prototype was for dump_stack_lvl() instead

Link: https://lkml.kernel.org/r/20210809051643.17567-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dump_stack.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/dump_stack.c~lib-dump_stack-correct-kernel-doc-notation
+++ a/lib/dump_stack.c
@@ -89,7 +89,8 @@ static void __dump_stack(const char *log
 }
 
 /**
- * dump_stack - dump the current task information and its stack trace
+ * dump_stack_lvl - dump the current task information and its stack trace
+ * @log_lvl: log level
  *
  * Architectures can override this implementation by implementing its own.
  */
_
