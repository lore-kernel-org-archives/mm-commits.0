Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4814BC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:36:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 253AC20658
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196208;
	bh=CeUj3+m4ojAqxFjQuq5+9lhBHW+bVAEpwKjaxQ0wQ8M=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Yzz/uIpoKaXid6hFfwjG+6QLk+bH/RL731MlWRBVXL36HuHW/nVgfFoy3uHfsBnUd
	 DFEd2tn0wEJ1HQ7HLKuryCMguPSn755RYpKnlC6KNTRyfIHViZr0WLqYIEkvJ/QHdC
	 yNSNkUwqc36FoCnWtVN9qYSeRQnh4vwAki9XJEKc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgHLBgr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:36:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:38246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726430AbgHLBgr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:36:47 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F35CD207DA;
        Wed, 12 Aug 2020 01:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196207;
        bh=CeUj3+m4ojAqxFjQuq5+9lhBHW+bVAEpwKjaxQ0wQ8M=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=JzB9LAo2ypAbRDxkgzRzarDKi2z5K61bL+eKSw222kkmucMYRvPXi9TLcg/vGDTrl
         EW/cHQRJ93oz8C6a44trXo2QHk269c7REHmDY2cPCkG/WTJSaXs7AwLkcdF7uKCNis
         DonkIYSpNDWIhq8hXvlyaz+hYspKTGHuFW/XB+oM=
Date:   Tue, 11 Aug 2020 18:36:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, keescook@chromium.org,
        linux-mm@kvack.org, lixuefeng@loongson.cn,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        yangtiezhu@loongson.cn
Subject:  [patch 123/165] kernel/panic.c: make oops_may_print()
 return bool
Message-ID: <20200812013646.AC2GVce6S%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: kernel/panic.c: make oops_may_print() return bool

The return value of oops_may_print() is true or false, so change its type
to reflect that.

Link: http://lkml.kernel.org/r/1591103358-32087-1-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Xuefeng Li <lixuefeng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    2 +-
 kernel/panic.c         |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/kernel.h~kernel-panicc-make-oops_may_print-return-bool
+++ a/include/linux/kernel.h
@@ -322,7 +322,7 @@ void nmi_panic(struct pt_regs *regs, con
 extern void oops_enter(void);
 extern void oops_exit(void);
 void print_oops_end_marker(void);
-extern int oops_may_print(void);
+extern bool oops_may_print(void);
 void do_exit(long error_code) __noreturn;
 void complete_and_exit(struct completion *, long) __noreturn;
 
--- a/kernel/panic.c~kernel-panicc-make-oops_may_print-return-bool
+++ a/kernel/panic.c
@@ -505,7 +505,7 @@ static void do_oops_enter_exit(void)
  * Return true if the calling CPU is allowed to print oops-related info.
  * This is a bit racy..
  */
-int oops_may_print(void)
+bool oops_may_print(void)
 {
 	return pause_on_oops_flag == 0;
 }
_
