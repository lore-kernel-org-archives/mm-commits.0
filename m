From: akpm@linux-foundation.org
Subject: [merged] tpm-use-idr_find-not-idr_find_slowpath.patch removed
 from -mm tree
Date: Thu, 15 Dec 2016 10:49:15 -0800
Message-ID: <5852e5ab.TJNXNyvjYI6vsOmi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50028 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752208AbcLOStQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:49:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mawilcox@microsoft.com, jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, peterhuewe@gmx.de, ross.zwisler@linux.intel.com, tpmdd@selhorst.net, mm-commits@vger.kernel.org


The patch titled
     Subject: tpm: use idr_find(), not idr_find_slowpath()
has been removed from the -mm tree.  Its filename was
     tpm-use-idr_find-not-idr_find_slowpath.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: tpm: use idr_find(), not idr_find_slowpath()

idr_find_slowpath() is not intended to be part of the public API, it's an
implementation detail.  There's no reason to skip straight to the slowpath
here.

Link: http://lkml.kernel.org/r/1480369871-5271-64-git-send-email-mawilcox@linuxonhyperv.com
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Tested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>
Cc: Marcel Selhorst <tpmdd@selhorst.net>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm-chip.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/tpm/tpm-chip.c~tpm-use-idr_find-not-idr_find_slowpath drivers/char/tpm/tpm-chip.c
--- a/drivers/char/tpm/tpm-chip.c~tpm-use-idr_find-not-idr_find_slowpath
+++ a/drivers/char/tpm/tpm-chip.c
@@ -84,7 +84,7 @@ EXPORT_SYMBOL_GPL(tpm_put_ops);
  *
  * The return'd chip has been tpm_try_get_ops'd and must be released via
  * tpm_put_ops
-  */
+ */
 struct tpm_chip *tpm_chip_find_get(int chip_num)
 {
 	struct tpm_chip *chip, *res = NULL;
@@ -103,7 +103,7 @@ struct tpm_chip *tpm_chip_find_get(int c
 			}
 		} while (chip_prev != chip_num);
 	} else {
-		chip = idr_find_slowpath(&dev_nums_idr, chip_num);
+		chip = idr_find(&dev_nums_idr, chip_num);
 		if (chip && !tpm_try_get_ops(chip))
 			res = chip;
 	}
_

Patches currently in -mm which might be from mawilcox@microsoft.com are

radix-tree-test-suite-fix-compilation.patch

