From: akpm@linux-foundation.org
Subject: + blackfin-define-dummy-pgprot_writecombine-for-mmu.patch added
 to -mm tree
Date: Wed, 10 Feb 2016 11:28:09 -0800
Message-ID: <56bb8f49.vVJg7GYrQIFHY67p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41978 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbcBJT2K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Feb 2016 14:28:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, realmz6@gmail.com, sudip@vectorindia.org, mm-commits@vger.kernel.org


The patch titled
     Subject: blackfin: define dummy pgprot_writecombine for !MMU
has been added to the -mm tree.  Its filename is
     blackfin-define-dummy-pgprot_writecombine-for-mmu.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/blackfin-define-dummy-pgprot_writecombine-for-mmu.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/blackfin-define-dummy-pgprot_writecombine-for-mmu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: blackfin: define dummy pgprot_writecombine for !MMU

blackfin allmodconfig build fails with the error:

../sound/core/pcm_native.c: In function 'snd_pcm_lib_default_mmap':
../sound/core/pcm_native.c:3386:24: error: implicit declaration of function 'pgprot_writecombine' [-Werror=implicit-function-declaration]
   area->vm_page_prot = pgprot_writecombine(area->vm_page_prot);
                        ^
../sound/core/pcm_native.c:3386:22: error: incompatible types when assigning to type 'pgprot_t {aka struct <anonymous>}' from type 'int'
   area->vm_page_prot = pgprot_writecombine(area->vm_page_prot);
                      ^

When !MMU, asm-generic will not define default pgprot_writecombine, so
blackfin needs to define it by itself.

The patch idea is from:
65b9ab888cd7 ("arch/c6x/include/asm/pgtable.h: define dummy pgprot_writecombine for !MMU")

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
Cc: Steven Miao <realmz6@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/include/asm/pgtable.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/blackfin/include/asm/pgtable.h~blackfin-define-dummy-pgprot_writecombine-for-mmu arch/blackfin/include/asm/pgtable.h
--- a/arch/blackfin/include/asm/pgtable.h~blackfin-define-dummy-pgprot_writecombine-for-mmu
+++ a/arch/blackfin/include/asm/pgtable.h
@@ -97,6 +97,8 @@ extern unsigned long get_fb_unmapped_are
 					  unsigned long);
 #define HAVE_ARCH_FB_UNMAPPED_AREA
 
+#define pgprot_writecombine pgprot_noncached
+
 #include <asm-generic/pgtable.h>
 
 #endif				/* _BLACKFIN_PGTABLE_H */
_

Patches currently in -mm which might be from sudipm.mukherjee@gmail.com are

m32r-mm-fix-build-warning.patch
blackfin-define-dummy-pgprot_writecombine-for-mmu.patch

