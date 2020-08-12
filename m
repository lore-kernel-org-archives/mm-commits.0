Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2C85C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9670E20B1F
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266336;
	bh=kERJMQez2ToThsjmrXH5ssN5lM7r7wpcUZWFZuYbYas=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Wdr6W36ZuRIvD41qHVbHLiWiqSTvwSSy3KcterOUWB8C2SoZejbCuI+yAzYGw+ocE
	 QrUFoMzlRbvwZoWC2LGt8yjUWNvDcZdZUHNw+C0eBi8xqs7iW6MYwRVyQH10718S9Y
	 rsgsQIpl5CWvv0nShsijMHfPGyq5vybsP/uDF8Sc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbgHLVFg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:05:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:59368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726564AbgHLVFg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:05:36 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 822612078B;
        Wed, 12 Aug 2020 21:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266334;
        bh=kERJMQez2ToThsjmrXH5ssN5lM7r7wpcUZWFZuYbYas=;
        h=Date:From:To:Subject:From;
        b=p9A3SZAbg2hEKfb+qy312CapwnNO7Y+DGNiZfwGUKWlUtsrljnsW1kbEbJH/UBowQ
         KWnryfIUHrtim8KGUKJCdPn2lbaNSWNu82O5Fbg7EOmPHob+VxMee0mW7SQnKI10CB
         9WVfUM+5s/UF4Se1rW7Tbyf2uylbUahoYfgcT2h8=
Date:   Wed, 12 Aug 2020 14:05:34 -0700
From:   akpm@linux-foundation.org
To:     keescook@chromium.org, lixuefeng@loongson.cn,
        mm-commits@vger.kernel.org, yangtiezhu@loongson.cn
Subject:  [merged]
 kernel-panicc-make-oops_may_print-return-bool.patch removed from -mm tree
Message-ID: <20200812210534.C7aecA2YW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/panic.c: make oops_may_print() return bool
has been removed from the -mm tree.  Its filename was
     kernel-panicc-make-oops_may_print-return-bool.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from yangtiezhu@loongson.cn are


