Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA9FBC433EF
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:34:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3B766134F
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:34:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237070AbhKIChi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:37:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:53090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236920AbhKIChh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:37:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77B0E61350;
        Tue,  9 Nov 2021 02:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425292;
        bh=E9ydoCXB6E9Dtid88YpLrQxXDdLhZ3e1DdrS0n7ZPsM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=uQSE+TN8EpA+hJHKgC+7CUJT+EfVYAQjyD+R/RbueY3IBsjh+q3s0JrCSt7YPYSpA
         tQPW0qiUULcjij8RtdbjhMJApyhzgynUgGqYozqQF+e778FrdFq3GMswBJkzceLh5t
         IX/1sneQAgTfk25fat0i7CzKkiFPZY1+F2IXYcGA=
Date:   Mon, 08 Nov 2021 18:34:52 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        jaharkes@cs.cmu.edu, jing.yangyang@zte.com.cn, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, tanxin.ctf@gmail.com,
        torvalds@linux-foundation.org, xiyuyang19@fudan.edu.cn,
        zealci@zte.com.cn
Subject:  [patch 64/87] coda: use vmemdup_user to replace the open
 code
Message-ID: <20211109023452.gTP4CgY5y%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
