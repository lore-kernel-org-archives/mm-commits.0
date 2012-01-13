From: akpm@linux-foundation.org
Subject: [merged] fixed-use-of-rounddown_pow_of_two-in-ramoops.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:37:33 -0800
Message-ID: <20120113203734.1977F20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:42927 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932798Ab2AMUhf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:37:35 -0500
Received: by mail-ey0-f202.google.com with SMTP id d12so25473eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:37:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marco.stornelli@gmail.com, akpm@linux-foundation.org, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ramoops: fix use of rounddown_pow_of_two()
has been removed from the -mm tree.  Its filename was
     fixed-use-of-rounddown_pow_of_two-in-ramoops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Marco Stornelli <marco.stornelli@gmail.com>
Subject: ramoops: fix use of rounddown_pow_of_two()

The return value of rounddown_pow_of_two wasn't evaluated, so the
operation was a no-op.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ramoops.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/ramoops.c~fixed-use-of-rounddown_pow_of_two-in-ramoops drivers/char/ramoops.c
--- a/drivers/char/ramoops.c~fixed-use-of-rounddown_pow_of_two-in-ramoops
+++ a/drivers/char/ramoops.c
@@ -125,8 +125,8 @@ static int __init ramoops_probe(struct p
 		goto fail3;
 	}
 
-	rounddown_pow_of_two(pdata->mem_size);
-	rounddown_pow_of_two(pdata->record_size);
+	pdata->mem_size = rounddown_pow_of_two(pdata->mem_size);
+	pdata->record_size = rounddown_pow_of_two(pdata->record_size);
 
 	/* Check for the minimum memory size */
 	if (pdata->mem_size < MIN_MEM_SIZE &&
_

Patches currently in -mm which might be from marco.stornelli@gmail.com are

origin.patch

