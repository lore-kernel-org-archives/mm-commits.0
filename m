From: akpm@linux-foundation.org
Subject: + cciss-fix-info-leak-in-cciss_ioctl32_passthru.patch added to
 -mm tree
Date: Fri, 20 Sep 2013 13:33:46 -0700
Message-ID: <523cb12a.6GaeLMa2HYblkAt4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36822 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab3ITUdr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Sep 2013 16:33:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mike.miller@hp.com, dan.carpenter@oracle.com

Subject: + cciss-fix-info-leak-in-cciss_ioctl32_passthru.patch added to -mm tree
To: dan.carpenter@oracle.com,mike.miller@hp.com
From: akpm@linux-foundation.org
Date: Fri, 20 Sep 2013 13:33:46 -0700


The patch titled
     Subject: cciss: fix info leak in cciss_ioctl32_passthru()
has been added to the -mm tree.  Its filename is
     cciss-fix-info-leak-in-cciss_ioctl32_passthru.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cciss-fix-info-leak-in-cciss_ioctl32_passthru.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cciss-fix-info-leak-in-cciss_ioctl32_passthru.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: cciss: fix info leak in cciss_ioctl32_passthru()

The arg64 struct has a hole after ->buf_size which isn't cleared.  Or if
any of the calls to copy_from_user() fail then that would cause an
information leak as well.

This was assigned CVE-2013-2147.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/block/cciss.c~cciss-fix-info-leak-in-cciss_ioctl32_passthru drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-fix-info-leak-in-cciss_ioctl32_passthru
+++ a/drivers/block/cciss.c
@@ -1189,6 +1189,7 @@ static int cciss_ioctl32_passthru(struct
 	int err;
 	u32 cp;
 
+	memset(&arg64, 0, sizeof(arg64));
 	err = 0;
 	err |=
 	    copy_from_user(&arg64.LUN_info, &arg32->LUN_info,
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
cpqarray-fix-info-leak-in-ida_locked_ioctl.patch
cciss-fix-info-leak-in-cciss_ioctl32_passthru.patch
linux-next.patch

