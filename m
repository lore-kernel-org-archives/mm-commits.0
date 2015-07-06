From: akpm@linux-foundation.org
Subject: [merged]
 lib-scatterlist-fix-kerneldoc-for-sg_pcopy_tofrom_buffer.patch removed from -mm tree
Date: Mon, 06 Jul 2015 12:47:31 -0700
Message-ID: <559adb53.KTvXaQPoEJAJJnIc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59600 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698AbbGFTrc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:47:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david.s.gordon@intel.com, akinobu.mita@gmail.com, martin.petersen@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/scatterlist.c: fix kerneldoc for sg_pcopy_{to,from}_buffer()
has been removed from the -mm tree.  Its filename was
     lib-scatterlist-fix-kerneldoc-for-sg_pcopy_tofrom_buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Gordon <david.s.gordon@intel.com>
Subject: lib/scatterlist.c: fix kerneldoc for sg_pcopy_{to,from}_buffer()

The kerneldoc for the functions doesn't match the code; the last two
parameters (buflen, skip) have been transposed, which is confusing,
especially as they're both integral types and the compiler won't warn
about swapping them.

These functions and the kerneldoc were introduced in commit:
    df642cea lib/scatterlist: introduce sg_pcopy_from_buffer() ...
    Author: Akinobu Mita <akinobu.mita@gmail.com>
    Date:   Mon Jul 8 16:01:54 2013 -0700

    The only difference between sg_pcopy_{from,to}_buffer() and
    sg_copy_{from,to}_buffer() is an additional argument that
    specifies the number of bytes to skip the SG list before
    copying.

The functions have the extra argument at the end, but the kerneldoc
lists it in penultimate position.

Signed-off-by: Dave Gordon <david.s.gordon@intel.com>
Reviewed-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/scatterlist.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/scatterlist.c~lib-scatterlist-fix-kerneldoc-for-sg_pcopy_tofrom_buffer lib/scatterlist.c
--- a/lib/scatterlist.c~lib-scatterlist-fix-kerneldoc-for-sg_pcopy_tofrom_buffer
+++ a/lib/scatterlist.c
@@ -729,8 +729,8 @@ EXPORT_SYMBOL(sg_copy_to_buffer);
  * @sgl:		 The SG list
  * @nents:		 Number of SG entries
  * @buf:		 Where to copy from
- * @skip:		 Number of bytes to skip before copying
  * @buflen:		 The number of bytes to copy
+ * @skip:		 Number of bytes to skip before copying
  *
  * Returns the number of copied bytes.
  *
@@ -747,8 +747,8 @@ EXPORT_SYMBOL(sg_pcopy_from_buffer);
  * @sgl:		 The SG list
  * @nents:		 Number of SG entries
  * @buf:		 Where to copy to
- * @skip:		 Number of bytes to skip before copying
  * @buflen:		 The number of bytes to copy
+ * @skip:		 Number of bytes to skip before copying
  *
  * Returns the number of copied bytes.
  *
_

Patches currently in -mm which might be from david.s.gordon@intel.com are


