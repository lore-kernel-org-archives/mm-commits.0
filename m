From: akpm@linux-foundation.org
Subject: + drivers-block-viodasdc-use-field_sizeof.patch added to -mm tree
Date: Thu, 14 Feb 2008 14:09:57 -0800
Message-ID: <200802142209.m1EM9vdT005498@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53789 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753093AbYBNWKd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 17:10:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, benh@kernel.crashing.org, jens.axboe@oracle.com, paulus@samba.org, sfr@canb.auug.org.au


The patch titled
     drivers/block/viodasd.c: Use FIELD_SIZEOF
has been added to the -mm tree.  Its filename is
     drivers-block-viodasdc-use-field_sizeof.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block/viodasd.c: Use FIELD_SIZEOF
From: Julia Lawall <julia@diku.dk>

Robert P.J. Day proposed to use the macro FIELD_SIZEOF in replace of code
that matches its definition.

The modification was made using the following semantic patch
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
type t;
identifier f;
@@

- (sizeof(((t*)0)->f))
+ FIELD_SIZEOF(t, f)

@depends on haskernel@
type t;
identifier f;
@@

- sizeof(((t*)0)->f)
+ FIELD_SIZEOF(t, f)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/viodasd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/viodasd.c~drivers-block-viodasdc-use-field_sizeof drivers/block/viodasd.c
--- a/drivers/block/viodasd.c~drivers-block-viodasdc-use-field_sizeof
+++ a/drivers/block/viodasd.c
@@ -69,7 +69,7 @@ MODULE_LICENSE("GPL");
 enum {
 	PARTITION_SHIFT = 3,
 	MAX_DISKNO = HVMAXARCHITECTEDVIRTUALDISKS,
-	MAX_DISK_NAME = sizeof(((struct gendisk *)0)->disk_name)
+	MAX_DISK_NAME = FIELD_SIZEOF(struct gendisk, disk_name)
 };
 
 static DEFINE_SPINLOCK(viodasd_spinlock);
_

Patches currently in -mm which might be from julia@diku.dk are

drivers-cpufreq-add-calls-to-cpufreq_cpu_put.patch
drivers-net-igb-use-field_sizeof.patch
drivers-net-mv643xx_ethc-use-field_sizeof.patch
drivers-net-ixgb-ixgb_ethtoolc-use-field_sizeof.patch
drivers-net-e1000-use-field_sizeof.patch
drivers-block-viodasdc-use-field_sizeof.patch
