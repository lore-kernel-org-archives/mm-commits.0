From: akpm@linux-foundation.org
Subject: [merged] zcrypt-use-seq_hex_dump-to-dump-buffers.patch removed
 from -mm tree
Date: Fri, 11 Sep 2015 11:13:10 -0700
Message-ID: <55f319b6.h26gd0Qs5biq3ADT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53984 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622AbbIKSNL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:13:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, catalin.marinas@arm.com, deller@gmx.de, ingo.tuchscherer@de.ibm.com, joe@perches.com, qca_vkondrat@qca.qualcomm.com, tadeusz.struk@intel.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/s390/crypto/zcrypt_api.c: use seq_hex_dump() to dump buffers
has been removed from the -mm tree.  Its filename was
     zcrypt-use-seq_hex_dump-to-dump-buffers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1206,16 +1206,8 @@ static void sprinthx(unsigned char *titl
 static void sprinthx4(unsigned char *title, struct seq_file *m,
 		      unsigned int *array, unsigned int len)
 {
-	int r;
