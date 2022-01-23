Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED01EC433FE
	for <mm-commits@archiver.kernel.org>; Sun, 23 Jan 2022 23:57:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235053AbiAWX5p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 23 Jan 2022 18:57:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234999AbiAWX5o (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 23 Jan 2022 18:57:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5CAEC06173B
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 15:57:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56A7960C34
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 23:57:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FDCAC340E3;
        Sun, 23 Jan 2022 23:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642982263;
        bh=XKXXqOc+XLDkjd4YSsOW+wy76J/snf0ShS6A3dlGiIQ=;
        h=Date:From:To:Subject:From;
        b=fA6KgBHsn01s6MNFTphqGNkctZWXOvToE4Ws5yp8V234rs3EdK7uE7+TfNItObnZE
         vamDkKdX0+/jiCdRrYiVFh+ihHYZ2uU6Xf97dl+Vi4ucSgoLFQcKttovswHnApqMrI
         R8i/MgYr0X8ehRaLGyWik3W+2J64cigaaqWUV0qQ=
Date:   Sun, 23 Jan 2022 15:57:43 -0800
From:   akpm@linux-foundation.org
To:     hulkci@huawei.com, libaokun1@huawei.com, mcgrof@kernel.org,
        mm-commits@vger.kernel.org
Subject:  [merged]
 =?US-ASCII?Q?sysctl-returns-einval-when-a-negative-value-is-passed-to-?=
 =?US-ASCII?Q?proc=5Fdoulongvec=5Fminmax.patch?= removed from -mm tree
Message-ID: <20220123235743.cXvb4lKqc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: returns -EINVAL when a negative value is passed to proc_doulongvec_minmax
has been removed from the -mm tree.  Its filename was
     sysctl-returns-einval-when-a-negative-value-is-passed-to-proc_doulongvec_minmax.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from libaokun1@huawei.com are


