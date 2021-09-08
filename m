Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59C32C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:57:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4509E61165
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:57:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347371AbhIHC6y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:58:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:56266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347302AbhIHC6t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:58:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09FD061102;
        Wed,  8 Sep 2021 02:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069862;
        bh=jCDtCO6Ppb8JUOdqTcBsTgsMgpi+VBgdbCMUuaQALzE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Wue81EApdtzSLu/1adGYWzYN1VMgNWafEIX52/5JPwORft5Mn3BiG6mHe4hwYLbYu
         WmVH7OfZeMtSdA6pppE0e3GulGunejyE1jqQKbn2HXxRlYPnmPbElRfX6k7hNvLYX+
         rD5UkYfygkV4c2bo/0dUmLXuCFcPuBfRymFblTkA=
Date:   Tue, 07 Sep 2021 19:57:41 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 083/147] include/linux/once.h: fix trivia typo Not
 -> Note
Message-ID: <20210908025741.dtFv8dPer%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: include/linux/once.h: fix trivia typo Not -> Note

Fix trivia typo Not -> Note in the comment to DO_ONCE().

Link: https://lkml.kernel.org/r/20210722184349.76290-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/once.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/once.h~once-fix-trivia-typo-not-note
+++ a/include/linux/once.h
@@ -16,7 +16,7 @@ void __do_once_done(bool *done, struct s
  * out the condition into a nop. DO_ONCE() guarantees type safety of
  * arguments!
  *
- * Not that the following is not equivalent ...
+ * Note that the following is not equivalent ...
  *
  *   DO_ONCE(func, arg);
  *   DO_ONCE(func, arg);
_
