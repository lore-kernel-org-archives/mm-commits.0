Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5760DC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 21 Dec 2021 23:40:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238081AbhLUXkw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Dec 2021 18:40:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238086AbhLUXku (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Dec 2021 18:40:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923A3C061574
        for <mm-commits@vger.kernel.org>; Tue, 21 Dec 2021 15:40:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D6EDB81A1A
        for <mm-commits@vger.kernel.org>; Tue, 21 Dec 2021 23:40:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3114C36AE8;
        Tue, 21 Dec 2021 23:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640130047;
        bh=qSS+xPZGyJxbeiKnvU7pYeYcNoqm3bK5bvnvKvZmf5A=;
        h=Date:From:To:Subject:From;
        b=UauZCfUyJI0/jT0QgUKmopH8CgFseikQmtlttPWLWiTbY85T+lM08gGu5U8eX7aTf
         K6RhmtGlFTXl5bdac7HYXYY2DpymAlySutwtCM3WonWVItS9R5QZGnOVDWEVfpet/S
         y/3ujqwjgx/YSiCbUq+vYuXQzoXw8uiB2QnmxHm8=
Date:   Tue, 21 Dec 2021 15:40:46 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mcgrof@kernel.org, hulkci@huawei.com,
        libaokun1@huawei.com
Subject:  +
 =?us-ascii?Q?sysctl-returns-einval-when-a-negative-value-is-passed-to-?=
 =?us-ascii?Q?proc=5Fdoulongvec=5Fminmax.patch?= added to -mm tree
Message-ID: <20211221234046.phZ4r%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: returns -EINVAL when a negative value is passed to proc_doulongvec_minmax
has been added to the -mm tree.  Its filename is
     sysctl-returns-einval-when-a-negative-value-is-passed-to-proc_doulongvec_minmax.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/sysctl-returns-einval-when-a-negative-value-is-passed-to-proc_doulongvec_minmax.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/sysctl-returns-einval-when-a-negative-value-is-passed-to-proc_doulongvec_minmax.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Baokun Li <libaokun1@huawei.com>
Subject: sysctl: returns -EINVAL when a negative value is passed to proc_doulongvec_minmax

When we pass a negative value to the proc_doulongvec_minmax() function,
the function returns 0, but the corresponding interface value does not
change.

we can easily reproduce this problem with the following commands:
    cd /proc/sys/fs/epoll
    echo -1 > max_user_watches; echo $?; cat max_user_watches

This function requires a non-negative number to be passed in, so when
a negative number is passed in, -EINVAL is returned.

Link: https://lkml.kernel.org/r/20211220092627.3744624-1-libaokun1@huawei.com
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/kernel/sysctl.c~sysctl-returns-einval-when-a-negative-value-is-passed-to-proc_doulongvec_minmax
+++ a/kernel/sysctl.c
@@ -1144,10 +1144,11 @@ static int __do_proc_doulongvec_minmax(v
 			err = proc_get_long(&p, &left, &val, &neg,
 					     proc_wspace_sep,
 					     sizeof(proc_wspace_sep), NULL);
-			if (err)
+			if (err || neg) {
+				err = -EINVAL;
 				break;
-			if (neg)
-				continue;
+			}
+
 			val = convmul * val / convdiv;
 			if ((min && val < *min) || (max && val > *max)) {
 				err = -EINVAL;
_

Patches currently in -mm which might be from libaokun1@huawei.com are

kfence-fix-memory-leak-when-cat-kfence-objects.patch
sysctl-returns-einval-when-a-negative-value-is-passed-to-proc_doulongvec_minmax.patch

