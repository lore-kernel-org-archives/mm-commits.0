Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBC68C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 03:57:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4FDC61245
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 03:57:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236283AbhIOD6k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Sep 2021 23:58:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:43740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236277AbhIOD6k (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Sep 2021 23:58:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE1C761164;
        Wed, 15 Sep 2021 03:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631678242;
        bh=x38iWoKVKzx0ytR5ZyuBO3yAPMHHWayHgOKEfI/yLEA=;
        h=Date:From:To:Subject:From;
        b=yUScjSC8vakaO5HDz1d0RqkgO6ENHAlE57oYjvCc2BgW/xO3vvfZ3ght9RgXTrWbG
         c6UOd5Esjb/jK++ehpgx1QdTgHlEAeEh4GdsL6bYnIFUdCyVyhjVymZbpTuELPwePy
         F2YiboLogaH52Lp350id+fn0QEJ2KVuoCQDsU/Zg=
Date:   Tue, 14 Sep 2021 20:57:21 -0700
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, jaharkes@cs.cmu.edu,
        jing.yangyang@zte.com.cn, mm-commits@vger.kernel.org,
        tanxin.ctf@gmail.com, xiyuyang19@fudan.edu.cn, zealci@zte.com.cn
Subject:  + coda-use-vmemdup_user-to-replace-the-open-code.patch
 added to -mm tree
Message-ID: <20210915035721.jCYt5DGHt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: coda: use vmemdup_user to replace the open code
has been added to the -mm tree.  Its filename is
     coda-use-vmemdup_user-to-replace-the-open-code.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/coda-use-vmemdup_user-to-replace-the-open-code.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/coda-use-vmemdup_user-to-replace-the-open-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jing Yangyang <jing.yangyang@zte.com.cn>
Subject: coda: use vmemdup_user to replace the open code

vmemdup_user is better than duplicating its implementation, So just
replace the open code.

./fs/coda/psdev.c:125:10-18:WARNING:opportunity for vmemdup_user

The issue is detected with the help of Coccinelle.

Link: https://lkml.kernel.org/r/20210908140308.18491-9-jaharkes@cs.cmu.edu
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Jing Yangyang <jing.yangyang@zte.com.cn>
Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Xin Tan <tanxin.ctf@gmail.com>
Cc: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/psdev.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/fs/coda/psdev.c~coda-use-vmemdup_user-to-replace-the-open-code
+++ a/fs/coda/psdev.c
@@ -122,14 +122,10 @@ static ssize_t coda_psdev_write(struct f
 				hdr.opcode, hdr.unique);
 		        nbytes = size;
 		}
-		dcbuf = kvmalloc(nbytes, GFP_KERNEL);
-		if (!dcbuf) {
-			retval = -ENOMEM;
-			goto out;
-		}
-		if (copy_from_user(dcbuf, buf, nbytes)) {
-			kvfree(dcbuf);
-			retval = -EFAULT;
+
+		dcbuf = vmemdup_user(buf, nbytes);
+		if (IS_ERR(dcbuf)) {
+			retval = PTR_ERR(dcbuf);
 			goto out;
 		}
 
_

Patches currently in -mm which might be from jing.yangyang@zte.com.cn are

coda-use-vmemdup_user-to-replace-the-open-code.patch

