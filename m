Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AD62C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 06:13:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbiAVGNv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Jan 2022 01:13:51 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54882 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiAVGNv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 22 Jan 2022 01:13:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CA50B820FE
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 06:13:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDFAC004E1;
        Sat, 22 Jan 2022 06:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642832029;
        bh=1x4JN5S0n9RZ0qlKxGN3jfVL3NgvlQumpjqKP1bFW9Q=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=j20TdlmqPVf3y8HCrTBkYyWWuwSQUQAhBQpF+/5KB/ywT1v7HhEQgrtRYiiPGU/KV
         nINPPSxZezq8nZri2zdnLTc7r27n82XhsXaiQaS5ZxS7DM3ip3QyttanYQ6QKqhUOt
         PzvdueyQTnaiVDaWH4+TuIUNx35Ryr40q9RfYjQU=
Date:   Fri, 21 Jan 2022 22:13:48 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hulkci@huawei.com, libaokun1@huawei.com,
        linux-mm@kvack.org, mcgrof@kernel.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 43/69] sysctl: returns -EINVAL when a negative
 value is passed to proc_doulongvec_minmax
Message-ID: <20220122061348.oKWIG8D09%akpm@linux-foundation.org>
In-Reply-To: <20220121221021.60533b009c357d660791476e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -1145,10 +1145,11 @@ static int __do_proc_doulongvec_minmax(v
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
