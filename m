From: akpm@linux-foundation.org
Subject: + fixed-use-of-rounddown_pow_of_two-in-ramoops.patch added to -mm tree
Date: Mon, 21 Nov 2011 16:06:40 -0800
Message-ID: <201111220006.pAM06etc021302@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:56627 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab1KVAGo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Nov 2011 19:06:44 -0500
Received: by ggnk3 with SMTP id k3so154794ggn.1
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2011 16:06:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marco.stornelli@gmail.com, akpm@linux-foundation.org, xiyou.wangcong@gmail.com


The patch titled
     Subject: ramoops: fix use of rounddown_pow_of_two()
has been added to the -mm tree.  Its filename is
     fixed-use-of-rounddown_pow_of_two-in-ramoops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -126,8 +126,8 @@ static int __init ramoops_probe(struct p
 		goto fail3;
 	}
 
-	rounddown_pow_of_two(pdata->mem_size);
-	rounddown_pow_of_two(pdata->record_size);
+       pdata->mem_size = rounddown_pow_of_two(pdata->mem_size);
+       pdata->record_size = rounddown_pow_of_two(pdata->record_size);
 
 	/* Check for the minimum memory size */
 	if (pdata->mem_size < MIN_MEM_SIZE &&
_
Subject: Subject: ramoops: fix use of rounddown_pow_of_two()

Patches currently in -mm which might be from marco.stornelli@gmail.com are

fixed-use-of-rounddown_pow_of_two-in-ramoops.patch
ramoops-update-parameters-only-after-successful-init.patch

