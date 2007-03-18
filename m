From: akpm@linux-foundation.org
Subject: - fix-read-past-end-of-array-in-md-linearc.patch removed from -mm tree
Date: Sun, 18 Mar 2007 01:08:30 -0800
Message-ID: <200703180908.l2I98UFs019945@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60457 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145AbXCRJKC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 05:10:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adi@hexapodia.org, ego@in.ibm.com, neilb@cse.unsw.edu.au, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     fix read past end of array in md/linear.c
has been removed from the -mm tree.  Its filename was
     fix-read-past-end-of-array-in-md-linearc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix read past end of array in md/linear.c
From: Andy Isaacson <adi@hexapodia.org>

When iterating through an array, one must be careful to test one's index
variable rather than another similarly-named variable.

The loop will read off the end of conf->disks[] in the following
(pathological) case:

% dd bs=1 seek=840716287 if=/dev/zero of=d1 count=1
% for i in 2 3 4; do dd if=/dev/zero of=d$i bs=1k count=$(($i+150)); done
% ./vmlinux ubd0=root ubd1=d1 ubd2=d2 ubd3=d3 ubd4=d4
# mdadm -C /dev/md0 --level=linear --raid-devices=4 /dev/ubd[1234]

adding some printks, I saw this:
[42949374.960000] hash_spacing = 821120
[42949374.960000] cnt          = 4
[42949374.960000] min_spacing  = 801
[42949374.960000] j=0 size=820928 sz=820928
[42949374.960000] i=0 sz=820928 hash_spacing=820928
[42949374.960000] j=1 size=64 sz=64
[42949374.960000] j=2 size=64 sz=128
[42949374.960000] j=3 size=64 sz=192
[42949374.960000] j=4 size=1515870810 sz=1515871002

Cc: Gautham R Shenoy <ego@in.ibm.com>
Acked-by: Neil Brown <neilb@cse.unsw.edu.au>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/linear.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/md/linear.c~fix-read-past-end-of-array-in-md-linearc drivers/md/linear.c
--- a/drivers/md/linear.c~fix-read-past-end-of-array-in-md-linearc
+++ a/drivers/md/linear.c
@@ -188,7 +188,7 @@ static linear_conf_t *linear_conf(mddev_
 	for (i=0; i < cnt-1 ; i++) {
 		sector_t sz = 0;
 		int j;
-		for (j=i; i<cnt-1 && sz < min_spacing ; j++)
+		for (j = i; j < cnt - 1 && sz < min_spacing; j++)
 			sz += conf->disks[j].size;
 		if (sz >= min_spacing && sz < conf->hash_spacing)
 			conf->hash_spacing = sz;
_

Patches currently in -mm which might be from adi@hexapodia.org are

origin.patch
