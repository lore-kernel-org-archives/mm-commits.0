Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1669EC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:53:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0383B610A2
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:53:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234594AbhKKC4T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:56:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:59764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234509AbhKKC4T (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:56:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A26FB60F46;
        Thu, 11 Nov 2021 02:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599210;
        bh=74GY9l4tQSrundfWlEJis4sXf5ayagMirCT8YQfx9sc=;
        h=Date:From:To:Subject:From;
        b=MDFT9JZeXmEVUyuHwcSUMLEHkuIW4BIm3yRKXXubL1P/DG4rllHQI/KzRiR4fsl8d
         FqyOBDq6DvF+O5dKhO+bnJDcsvz1nkdSldZWL5Lyw2h4yw2rA2N2p+ZLu8tm5LqNQz
         6t1pt4z4B5bbMXxq7OGUzXao2vj9HRWFTht2nSsw=
Date:   Wed, 10 Nov 2021 18:53:30 -0800
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, jaharkes@cs.cmu.edu,
        jing.yangyang@zte.com.cn, mm-commits@vger.kernel.org,
        tanxin.ctf@gmail.com, xiyuyang19@fudan.edu.cn, zealci@zte.com.cn
Subject:  [merged]
 coda-use-vmemdup_user-to-replace-the-open-code.patch removed from -mm tree
Message-ID: <20211111025330.eoT76Ij9Z%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: coda: use vmemdup_user to replace the open code
has been removed from the -mm tree.  Its filename was
     coda-use-vmemdup_user-to-replace-the-open-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


