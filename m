Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EDD1C43219
	for <mm-commits@archiver.kernel.org>; Thu, 24 Nov 2022 21:38:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbiKXViS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Nov 2022 16:38:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiKXViR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Nov 2022 16:38:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C2E1834B
        for <mm-commits@vger.kernel.org>; Thu, 24 Nov 2022 13:38:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 012B56223C
        for <mm-commits@vger.kernel.org>; Thu, 24 Nov 2022 21:38:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49DA1C433C1;
        Thu, 24 Nov 2022 21:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669325894;
        bh=NtbwOKiSmRUk+UYMt5ZwOYkE7zgZKJxYPpo847Bzv4w=;
        h=Date:To:From:Subject:From;
        b=0EhIVqZNv3OyLjr9L/+kD0gOh9PHZlQ2BdcjRAdq4iu0EQNuf9jHR+3XY+IH4ADBS
         hQMn9tEVB5QZVzp4XTzRcSMKseDuOApqg1ZckYTIxDgD6xCbKMftbNAuTW41ZQTnT5
         KzTV0DoEXYR+fBc1rAagQEMBjl2s5Dq5Fct2PNUM=
Date:   Thu, 24 Nov 2022 13:38:13 -0800
To:     mm-commits@vger.kernel.org, handai.szj@taobao.com, dylany@fb.com,
        axboe@kernel.dk, zhangqilong3@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + eventfd-change-int-to-__u64-in-eventfd_signal-ifndef-config_eventfd.patch added to mm-nonmm-unstable branch
Message-Id: <20221124213814.49DA1C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: eventfd: change int to __u64 in eventfd_signal() ifndef CONFIG_EVENTFD
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     eventfd-change-int-to-__u64-in-eventfd_signal-ifndef-config_eventfd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/eventfd-change-int-to-__u64-in-eventfd_signal-ifndef-config_eventfd.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Zhang Qilong <zhangqilong3@huawei.com>
Subject: eventfd: change int to __u64 in eventfd_signal() ifndef CONFIG_EVENTFD
Date: Thu, 24 Nov 2022 22:01:54 +0800

Commit ee62c6b2dc93 ("eventfd: change int to __u64 in eventfd_signal()")
forgot to change int to __u64 in the CONFIG_EVENTFD=n stub function.

Link: https://lkml.kernel.org/r/20221124140154.104680-1-zhangqilong3@huawei.com
Fixes: ee62c6b2dc93 ("eventfd: change int to __u64 in eventfd_signal()")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Cc: Dylan Yudaken <dylany@fb.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Sha Zhengju <handai.szj@taobao.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/eventfd.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/eventfd.h~eventfd-change-int-to-__u64-in-eventfd_signal-ifndef-config_eventfd
+++ a/include/linux/eventfd.h
@@ -61,7 +61,7 @@ static inline struct eventfd_ctx *eventf
 	return ERR_PTR(-ENOSYS);
 }
 
-static inline int eventfd_signal(struct eventfd_ctx *ctx, int n)
+static inline int eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
 {
 	return -ENOSYS;
 }
_

Patches currently in -mm which might be from zhangqilong3@huawei.com are

eventfd-change-int-to-__u64-in-eventfd_signal-ifndef-config_eventfd.patch

