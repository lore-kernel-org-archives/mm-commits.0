From: akpm@linux-foundation.org
Subject: [patch 009/119] dax: initialize variable pfn before using
 it
Date: Wed, 06 Sep 2017 16:19:01 -0700
Message-ID: <20170906231901.2VYGHLlS_%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49112 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754578AbdIFXTD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:19:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mawilcox@microsoft.com, mm-commits@vger.kernel.org, nicolas.iooss_linux@m4x.org, ross.zwisler@linux.intel.com, torvalds@linux-foundation.org

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
