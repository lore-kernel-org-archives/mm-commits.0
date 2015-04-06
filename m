From: akpm@linux-foundation.org
Subject: + zram-fix-error-return-code.patch added to -mm tree
Date: Mon, 06 Apr 2015 12:43:03 -0700
Message-ID: <5522e1c7.85EYdVI5AOC58VOT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40991 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbbDFTnE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2015 15:43:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Julia.Lawall@lip6.fr, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: fix error return code
has been added to the -mm tree.  Its filename is
     zram-fix-error-return-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-fix-error-return-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-fix-error-return-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: zram: fix error return code

Return a negative error code on failure.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier ret; expression e1,e2;
@@
(
if (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/block/zram/zram_drv.c~zram-fix-error-return-code drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-fix-error-return-code
+++ a/drivers/block/zram/zram_drv.c
@@ -1188,6 +1188,7 @@ static int zram_add(int device_id)
 	if (!queue) {
 		pr_err("Error allocating disk queue for device %d\n",
 			device_id);
+		ret = -ENOMEM;
 		goto out_free_idr;
 	}
 
@@ -1198,6 +1199,7 @@ static int zram_add(int device_id)
 	if (!zram->disk) {
 		pr_warn("Error allocating disk structure for device %d\n",
 			device_id);
+		ret = -ENOMEM;
 		goto out_free_queue;
 	}
 
_

Patches currently in -mm which might be from Julia.Lawall@lip6.fr are

zram-fix-error-return-code.patch
linux-next.patch

