Return-Path: <SRS0=DYKa=DF=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15737C2D0A8
	for <mm-commits@archiver.kernel.org>; Mon, 28 Sep 2020 23:42:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5808207C4
	for <mm-commits@archiver.kernel.org>; Mon, 28 Sep 2020 23:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601336531;
	bh=leEEYuNJMctaK/4n5vmBERsh2XdHP/dcHDbcmhWJrrU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=yZiNJjY+2dM5ZPbBmIQFPlkNz8G5/wiaV9wteW6SLDS4m8mKi9yR+6rpcYlfxYCfh
	 dfx79DRnYAPNWaGoAKFiot/ivjcYN7Mxda7zbPY2NArg9rzNvQAIwsUXd+S+kBKftR
	 W8HTPDZcGTIhD+5ec9rhPi7zhBGTv6b35GUyhNLs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgI1XmL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Sep 2020 19:42:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbgI1XmL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Sep 2020 19:42:11 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA8A820774;
        Mon, 28 Sep 2020 23:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601336530;
        bh=leEEYuNJMctaK/4n5vmBERsh2XdHP/dcHDbcmhWJrrU=;
        h=Date:From:To:Subject:From;
        b=lwpWe9s8LuS7rFVvFDfeAjf/kCuQKQU4nX0mK7ZTy6xwfoHEZQfT3OFmMVw5/8kpA
         o7jFfomiwEDNqdZuL/QH/Zxbrop3iCPPT6RfpQFS+zs3+bp48bPCBJECZv6Qtsp9yY
         p9GZOI2quAYTe+Uii9GeJ3Iyd/k05mGu64jt91eE=
Date:   Mon, 28 Sep 2020 16:42:10 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, minchan@kernel.org, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au
Subject:  +
 =?US-ASCII?Q?mm-madvise-introduce-process=5Fmadvise-syscall-an-external-?=
 =?US-ASCII?Q?memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix-fix.p?=
 =?US-ASCII?Q?atch?= added to -mm tree
Message-ID: <20200928234210.J5gWQYAnZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fix up for "iov_iter: transparently handle compat iovecs in import_iovec"
has been added to the -mm tree.  Its filename is
     mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: fix up for "iov_iter: transparently handle compat iovecs in import_iovec"

Link: https://lkml.kernel.org/r/20200928212542.468e1fef@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/mm/madvise.c~mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix-fix
+++ a/mm/madvise.c
@@ -7,7 +7,6 @@
  */
 
 #include <linux/mman.h>
-#include <linux/compat.h>
 #include <linux/pagemap.h>
 #include <linux/syscalls.h>
 #include <linux/mempolicy.h>
@@ -1189,15 +1188,7 @@ SYSCALL_DEFINE5(process_madvise, int, pi
 		goto out;
 	}
 
-#ifdef CONFIG_COMPAT
-	if (in_compat_syscall())
-		ret = compat_import_iovec(READ,
-				(struct compat_iovec __user *)vec, vlen,
-				ARRAY_SIZE(iovstack), &iov, &iter);
-	else
-#endif
-		ret = import_iovec(READ, vec, vlen, ARRAY_SIZE(iovstack),
-				&iov, &iter);
+	ret = import_iovec(READ, vec, vlen, ARRAY_SIZE(iovstack), &iov, &iter);
 	if (ret < 0)
 		goto out;
 
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix-fix.patch

