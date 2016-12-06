From: akpm@linux-foundation.org
Subject: + tpm-use-idr_find-not-idr_find_slowpath.patch added to -mm tree
Date: Tue, 06 Dec 2016 12:51:13 -0800
Message-ID: <584724c1.ZeHebSvZqm3W9UN3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37060 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751726AbcLFUuo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Dec 2016 15:50:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mawilcox@microsoft.com, jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, peterhuewe@gmx.de, ross.zwisler@linux.intel.com, tpmdd@selhorst.net, mm-commits@vger.kernel.org


The patch titled
     Subject: tpm: use idr_find(), not idr_find_slowpath()
has been added to the -mm tree.  Its filename is
     tpm-use-idr_find-not-idr_find_slowpath.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tpm-use-idr_find-not-idr_find_slowpath.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tpm-use-idr_find-not-idr_find_slowpath.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
radix-tree-test-suite-iteration-test-misuses-rcu.patch
radix-tree-test-suite-use-rcu_barrier.patch
radix-tree-test-suite-handle-exceptional-entries.patch
radix-tree-test-suite-record-order-in-each-item.patch
btrfs-fix-race-in-btrfs_free_dummy_fs_info.patch
radix-tree-improve-multiorder-iterators.patch
radix-tree-delete-radix_tree_locate_item.patch
radix-tree-delete-radix_tree_range_tag_if_tagged.patch
radix-tree-fix-replacement-for-multiorder-entries.patch
radix-tree-test-suite-check-multiorder-iteration.patch
tpm-use-idr_find-not-idr_find_slowpath.patch
rxrpc-abstract-away-knowledge-of-idr-internals.patch

