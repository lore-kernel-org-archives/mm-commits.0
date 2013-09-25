From: akpm@linux-foundation.org
Subject: [merged] cciss-fix-info-leak-in-cciss_ioctl32_passthru.patch
 removed from -mm tree
Date: Wed, 25 Sep 2013 12:06:18 -0700
Message-ID: <5243342a.Zv9K0NPhq1up2XMA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48660 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab3IYTGS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Sep 2013 15:06:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mike.miller@hp.com, dan.carpenter@oracle.com

Subject: [merged] cciss-fix-info-leak-in-cciss_ioctl32_passthru.patch removed from -mm tree
To: dan.carpenter@oracle.com,mike.miller@hp.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 25 Sep 2013 12:06:18 -0700


The patch titled
     Subject: cciss: fix info leak in cciss_ioctl32_passthru()
has been removed from the -mm tree.  Its filename was
     cciss-fix-info-leak-in-cciss_ioctl32_passthru.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch

