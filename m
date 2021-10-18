Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEF68C433FE
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 17:32:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 924486103D
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 17:32:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbhJRRek (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Oct 2021 13:34:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:33630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230057AbhJRRej (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 Oct 2021 13:34:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 531A261002;
        Mon, 18 Oct 2021 17:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634578348;
        bh=TxTjUV4AceN4fUO2aMioTotRpt1aHLnf+6LETuYArGI=;
        h=Date:From:To:Subject:From;
        b=1KZDPjWX1OIiWAjwO+ITOeHZCau3/0CfUsAZPOBDFs81Dm86+Xzbv7Jt5TwLyfTpu
         JsGUB2pag/xSTq39YYqQUBY3/2bN5evUClwYPYM0tw69Tq/esbSjxqabvNIUAd/UOz
         j+x1dkpx5+RYzsIH3sepZon+keO1TOzBPe0BBAfY=
Date:   Mon, 18 Oct 2021 10:32:27 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ran.jianping@zte.com.cn,
        shuah@kernel.org, zealci@zte.com.cn
Subject:  + mm-remove-duplicate-include-in-hugepage-mremapc.patch
 added to -mm tree
Message-ID: <20211018173227.jbfMpTlJn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove duplicate include in hugepage-mremap.c
has been added to the -mm tree.  Its filename is
     mm-remove-duplicate-include-in-hugepage-mremapc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-duplicate-include-in-hugepage-mremapc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-duplicate-include-in-hugepage-mremapc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: cgel.zte@gmail.com
Subject: mm: remove duplicate include in hugepage-mremap.c


Remove duplicate includes 'unistd.h' included in
 '/tools/testing/selftests/vm/hugepage-mremap.c'  is duplicated.It is also
 included on 23 line.

Link: https://lkml.kernel.org/r/20211018102336.869726-1-ran.jianping@zte.com.cn
Signed-off-by: Ran Jianping <ran.jianping@zte.com.cn>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/hugepage-mremap.c |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/testing/selftests/vm/hugepage-mremap.c~mm-remove-duplicate-include-in-hugepage-mremapc
+++ a/tools/testing/selftests/vm/hugepage-mremap.c
@@ -16,7 +16,6 @@
 #include <errno.h>
 #include <fcntl.h> /* Definition of O_* constants */
 #include <sys/syscall.h> /* Definition of SYS_* constants */
-#include <unistd.h>
 #include <linux/userfaultfd.h>
 #include <sys/ioctl.h>
 
_

Patches currently in -mm which might be from ran.jianping@zte.com.cn are

mm-remove-duplicate-include-in-hugepage-mremapc.patch

