From: akpm@linux-foundation.org
Subject: + zcrypt-use-seq_hex_dump-to-dump-buffers.patch added to -mm tree
Date: Tue, 07 Jul 2015 13:59:44 -0700
Message-ID: <559c3dc0.ws5fsJdCiqzkWByI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57600 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932930AbbGGU7p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jul 2015 16:59:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, catalin.marinas@arm.com, deller@gmx.de, ingo.tuchscherer@de.ibm.com, joe@perches.com, qca_vkondrat@qca.qualcomm.com, tadeusz.struk@intel.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/s390/crypto/zcrypt_api.c: use seq_hex_dump() to dump buffers
has been added to the -mm tree.  Its filename is
     zcrypt-use-seq_hex_dump-to-dump-buffers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zcrypt-use-seq_hex_dump-to-dump-buffers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zcrypt-use-seq_hex_dump-to-dump-buffers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: drivers/s390/crypto/zcrypt_api.c: use seq_hex_dump() to dump buffers

Instead of custom approach let's use recently introduced seq_hex_dump()
helper.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Joe Perches <joe@perches.com>
Cc: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/crypto/zcrypt_api.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff -puN drivers/s390/crypto/zcrypt_api.c~zcrypt-use-seq_hex_dump-to-dump-buffers drivers/s390/crypto/zcrypt_api.c
--- a/drivers/s390/crypto/zcrypt_api.c~zcrypt-use-seq_hex_dump-to-dump-buffers
+++ a/drivers/s390/crypto/zcrypt_api.c
@@ -1202,16 +1202,8 @@ static void sprinthx(unsigned char *titl
 static void sprinthx4(unsigned char *title, struct seq_file *m,
 		      unsigned int *array, unsigned int len)
 {
-	int r;
