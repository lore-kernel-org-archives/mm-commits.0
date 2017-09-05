From: akpm@linux-foundation.org
Subject: + dax-initialize-variable-pfn-before-using-it.patch added to -mm
 tree
Date: Tue, 05 Sep 2017 15:55:42 -0700
Message-ID: <59af2b6e.RfmvEMvGPlLnuLzd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37454 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752459AbdIEWzn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Sep 2017 18:55:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.iooss_linux@m4x.org, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: initialize variable pfn before using it
has been added to the -mm tree.  Its filename is
     dax-initialize-variable-pfn-before-using-it.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-initialize-variable-pfn-before-using-it.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-initialize-variable-pfn-before-using-it.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Subject: dax: initialize variable pfn before using it

dax_pmd_insert_mapping() contains the following code:

        pfn_t pfn;
        if (bdev_dax_pgoff(bdev, sector, size, &pgoff) != 0)
            goto fallback;
        /* ... */
    fallback:
      trace_dax_pmd_insert_mapping_fallback(inode, vmf, length, pfn, ret);

When the condition in the if statement fails, the function calls
trace_dax_pmd_insert_mapping_fallback() with an uninitialized pfn value.

This issue has been found while building the kernel with clang. The
compiler reported:

    fs/dax.c:1280:6: error: variable 'pfn' is used uninitialized
    whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
        if (bdev_dax_pgoff(bdev, sector, size, &pgoff) != 0)
            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    fs/dax.c:1310:60: note: uninitialized use occurs here
      trace_dax_pmd_insert_mapping_fallback(inode, vmf, length, pfn, ret);
                                                                     ^~~

Link: http://lkml.kernel.org/r/20170903083000.587-1-nicolas.iooss_linux@m4x.org
Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/dax.c~dax-initialize-variable-pfn-before-using-it fs/dax.c
--- a/fs/dax.c~dax-initialize-variable-pfn-before-using-it
+++ a/fs/dax.c
@@ -1230,7 +1230,7 @@ static int dax_pmd_insert_mapping(struct
 	void *ret = NULL, *kaddr;
 	long length = 0;
 	pgoff_t pgoff;
-	pfn_t pfn;
+	pfn_t pfn = {};
 	int id;
 
 	if (bdev_dax_pgoff(bdev, sector, size, &pgoff) != 0)
_

Patches currently in -mm which might be from nicolas.iooss_linux@m4x.org are

dax-initialize-variable-pfn-before-using-it.patch

