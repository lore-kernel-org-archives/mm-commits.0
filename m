Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7202C4167B
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 03:31:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbiLLDbN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 22:31:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbiLLDbL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 22:31:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D44DB493
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 19:31:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A7D160ED8
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 03:31:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB0BC433D2;
        Mon, 12 Dec 2022 03:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670815869;
        bh=a7d/b2iDEH7QTEAziT3bGqktDXCele2H9OQasyAN4hQ=;
        h=Date:To:From:Subject:From;
        b=oH8qp5rd+dw2PvLHBmMBoEzJ1fo7XzKm2QXN4V6jX/TIci0Rxg+Hjw7rPx8Mq4OUU
         PhYZVaBt4hUKjb9Y/6oFsAdf+awA9HGRfLCO50YVhfIVq1BNag+pkjs1lkewG6HrUG
         X9aRx02jPn6Jf+4QIZQPU7yLWdQdlWbye8t7uqDQ=
Date:   Sun, 11 Dec 2022 19:31:08 -0800
To:     mm-commits@vger.kernel.org, handai.szj@taobao.com, dylany@fb.com,
        axboe@kernel.dk, zhangqilong3@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] eventfd-change-int-to-__u64-in-eventfd_signal-ifndef-config_eventfd.patch removed from -mm tree
Message-Id: <20221212033109.6CB0BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: eventfd: change int to __u64 in eventfd_signal() ifndef CONFIG_EVENTFD
has been removed from the -mm tree.  Its filename was
     eventfd-change-int-to-__u64-in-eventfd_signal-ifndef-config_eventfd.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


