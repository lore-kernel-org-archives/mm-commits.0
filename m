From: akpm@linux-foundation.org
Subject: + bitops-remove-for_each_set_bit_cont-fix.patch added to -mm tree
Date: Tue, 28 Feb 2012 14:08:30 -0800
Message-ID: <20120228220830.A9954A02DD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:49190 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965660Ab2B1WId (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Feb 2012 17:08:33 -0500
Received: by laai8 with SMTP id i8so97849laa.1
        for <mm-commits@vger.kernel.org>; Tue, 28 Feb 2012 14:08:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au, akinobu.mita@gmail.com, broonie@opensource.wolfsonmicro.com


The patch titled
     Subject: regmap: cope with bitops API change (for_each_set_bit_cont)
has been added to the -mm tree.  Its filename is
     bitops-remove-for_each_set_bit_cont-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: regmap: cope with bitops API change (for_each_set_bit_cont)

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/regmap/regcache-lzo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/base/regmap/regcache-lzo.c~bitops-remove-for_each_set_bit_cont-fix drivers/base/regmap/regcache-lzo.c
--- a/drivers/base/regmap/regcache-lzo.c~bitops-remove-for_each_set_bit_cont-fix
+++ a/drivers/base/regmap/regcache-lzo.c
@@ -341,7 +341,7 @@ static int regcache_lzo_sync(struct regm
 
 	lzo_blocks = map->cache;
 	i = min;
-	for_each_set_bit_cont(i, lzo_blocks[0]->sync_bmp,
+	for_each_set_bit_from(i, lzo_blocks[0]->sync_bmp,
 			      lzo_blocks[0]->sync_bmp_nbits) {
 		if (i > max)
 			continue;
_
Subject: Subject: regmap: cope with bitops API change (for_each_set_bit_cont)

Patches currently in -mm which might be from sfr@canb.auug.org.au are

linux-next.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
bitops-remove-for_each_set_bit_cont-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch

