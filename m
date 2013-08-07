From: akpm@linux-foundation.org
Subject: + kexec-remove-unnecessary-return.patch added to -mm tree
Date: Wed, 07 Aug 2013 14:14:34 -0700
Message-ID: <5202b8ba.E8zKqhzkKDY+XVNU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40019 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933327Ab3HGVOf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Aug 2013 17:14:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, horms@verge.net.au, qiuxishi@huawei.com

Subject: + kexec-remove-unnecessary-return.patch added to -mm tree
To: qiuxishi@huawei.com,horms@verge.net.au,zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Wed, 07 Aug 2013 14:14:34 -0700


The patch titled
     Subject: kexec: remove unnecessary return
has been added to the -mm tree.  Its filename is
     kexec-remove-unnecessary-return.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-remove-unnecessary-return.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-remove-unnecessary-return.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: kexec: remove unnecessary return

Code can not run here forever, so remove the unnecessary return.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Suggested-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Reviewed-by: Simon Horman <horms@verge.net.au>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN kernel/kexec.c~kexec-remove-unnecessary-return kernel/kexec.c
--- a/kernel/kexec.c~kexec-remove-unnecessary-return
+++ a/kernel/kexec.c
@@ -1474,11 +1474,8 @@ static int __init __parse_crashkernel(ch
 	if (first_colon && (!first_space || first_colon < first_space))
 		return parse_crashkernel_mem(ck_cmdline, system_ram,
 				crash_size, crash_base);
-	else
-		return parse_crashkernel_simple(ck_cmdline, crash_size,
-				crash_base);
 
-	return 0;
+	return parse_crashkernel_simple(ck_cmdline, crash_size, crash_base);
 }
 
 /*
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

kexec-remove-unnecessary-return.patch

