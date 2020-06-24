From: akpm@linux-foundation.org
Subject: + mm-cma-fix-the-name-of-cma-areas-fix.patch added to -mm
 tree
Date: Wed, 24 Jun 2020 15:18:51 -0700
Message-ID: <20200624221851.Vso1a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728798AbgFXWSw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 18:18:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, song.bao.hua@hisilicon.com, sfr@canb.auug.org.au, natechancellor@gmail.com


The patch titled
     Subject: mm: cma: return cma->name directly in cma_get_name
has been added to the -mm tree.  Its filename is
     mm-cma-fix-the-name-of-cma-areas-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-fix-the-name-of-cma-areas-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-fix-the-name-of-cma-areas-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nathan Chancellor <natechancellor@gmail.com>
Subject: mm: cma: return cma->name directly in cma_get_name

clang warns:

mm/cma.c:55:14: warning: address of array 'cma->name' will always
evaluate to 'true' [-Wpointer-bool-conversion]
        return cma->name ? cma->name : "(undefined)";
               ~~~~~^~~~ ~
1 warning generated.

After commit e7f0557d7de9 ("mm: cma: fix the name of CMA areas"),
cma->name will be an array with some value worth printing so we do not
need to check for NULL.

Link: https://github.com/ClangBuiltLinux/linux/issues/1063
Link: http://lkml.kernel.org/r/20200623015840.621964-1-natechancellor@gmail.com
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Barry Song <song.bao.hua@hisilicon.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/cma.c~mm-cma-fix-the-name-of-cma-areas-fix
+++ a/mm/cma.c
@@ -52,7 +52,7 @@ unsigned long cma_get_size(const struct
 
 const char *cma_get_name(const struct cma *cma)
 {
-	return cma->name ? cma->name : "(undefined)";
+	return cma->name;
 }
 
 static unsigned long cma_bitmap_aligned_mask(const struct cma *cma,
_

Patches currently in -mm which might be from natechancellor@gmail.com are

mm-cma-fix-the-name-of-cma-areas-fix.patch
