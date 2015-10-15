From: akpm@linux-foundation.org
Subject: + sh-add-copy_user_page-alias-for-__copy_user.patch added to -mm
 tree
Date: Thu, 15 Oct 2015 13:51:26 -0700
Message-ID: <562011ce.IVJSQivNdm/hfGLD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59069 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbbJOUwI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Oct 2015 16:52:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, andriy.shevchenko@linux.intel.com, geert@linux-m68k.org, matt@codeblueprint.co.uk, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sh: add copy_user_page() alias for __copy_user()
has been added to the -mm tree.  Its filename is
     sh-add-copy_user_page-alias-for-__copy_user.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh-add-copy_user_page-alias-for-__copy_user.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh-add-copy_user_page-alias-for-__copy_user.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: sh: add copy_user_page() alias for __copy_user()

copy_user_page() is needed by DAX.  Without this we get a compile error
for DAX on SH:

fs/dax.c:280:2: error: implicit declaration of function `copy_user_page'
[-Werror=implicit-function-declaration]
  copy_user_page(vto, (void __force *)vfrom, vaddr, to);
    ^
This was done with a random config that happened to include DAX support.

This patch has only been compile tested.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/page.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/sh/include/asm/page.h~sh-add-copy_user_page-alias-for-__copy_user arch/sh/include/asm/page.h
--- a/arch/sh/include/asm/page.h~sh-add-copy_user_page-alias-for-__copy_user
+++ a/arch/sh/include/asm/page.h
@@ -59,6 +59,7 @@ pages_do_alias(unsigned long addr1, unsi
 
 #define clear_page(page)	memset((void *)(page), 0, PAGE_SIZE)
 extern void copy_page(void *to, void *from);
+#define copy_user_page(to, from, vaddr, pg)  __copy_user(to, from, PAGE_SIZE)
 
 struct page;
 struct vm_area_struct;
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

mm-dax-fix-dax-deadlocks.patch
sh-add-copy_user_page-alias-for-__copy_user.patch

