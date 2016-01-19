From: akpm@linux-foundation.org
Subject: + mm-remove-duplicate-definitions-of-madv_free.patch added to -mm tree
Date: Tue, 19 Jan 2016 15:19:14 -0800
Message-ID: <569ec472.zkw1V/kXgcUPQj45%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54756 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933156AbcASXTP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 18:19:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@roeck-us.net, gang.chen.5i5j@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: arch: remove duplicate definitions of MADV_FREE
has been added to the -mm tree.  Its filename is
     mm-remove-duplicate-definitions-of-madv_free.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-duplicate-definitions-of-madv_free.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-duplicate-definitions-of-madv_free.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Guenter Roeck <linux@roeck-us.net>
Subject: mm: arch: remove duplicate definitions of MADV_FREE

Commits 21f55b018ba5 ("arch/*/include/uapi/asm/mman.h: : let MADV_FREE
have same value for all architectures") and ef58978f1eaa ("mm: define
MADV_FREE for some arches") both defined MADV_FREE, but did not use the
same values.  This results in build errors such as

./arch/alpha/include/uapi/asm/mman.h:53:0: error: "MADV_FREE" redefined
./arch/alpha/include/uapi/asm/mman.h:50:0: note:
	this is the location of the previous definition

for the affected architectures.

Fixes: 21f55b018ba5 ("arch/*/include/uapi/asm/mman.h: : let MADV_FREE have same value for all architectures")
Fixes: ef58978f1eaa ("mm: define MADV_FREE for some arches")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Cc: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/uapi/asm/mman.h  |    1 -
 arch/mips/include/uapi/asm/mman.h   |    1 -
 arch/parisc/include/uapi/asm/mman.h |    1 -
 arch/xtensa/include/uapi/asm/mman.h |    1 -
 4 files changed, 4 deletions(-)

diff -puN arch/alpha/include/uapi/asm/mman.h~mm-remove-duplicate-definitions-of-madv_free arch/alpha/include/uapi/asm/mman.h
--- a/arch/alpha/include/uapi/asm/mman.h~mm-remove-duplicate-definitions-of-madv_free
+++ a/arch/alpha/include/uapi/asm/mman.h
@@ -47,7 +47,6 @@
 #define MADV_WILLNEED	3		/* will need these pages */
 #define	MADV_SPACEAVAIL	5		/* ensure resources are available */
 #define MADV_DONTNEED	6		/* don't need these pages */
-#define MADV_FREE	7		/* free pages only if memory pressure */
 
 /* common/generic parameters */
 #define MADV_FREE	8		/* free pages only if memory pressure */
diff -puN arch/mips/include/uapi/asm/mman.h~mm-remove-duplicate-definitions-of-madv_free arch/mips/include/uapi/asm/mman.h
--- a/arch/mips/include/uapi/asm/mman.h~mm-remove-duplicate-definitions-of-madv_free
+++ a/arch/mips/include/uapi/asm/mman.h
@@ -73,7 +73,6 @@
 #define MADV_SEQUENTIAL 2		/* expect sequential page references */
 #define MADV_WILLNEED	3		/* will need these pages */
 #define MADV_DONTNEED	4		/* don't need these pages */
-#define MADV_FREE	5		/* free pages only if memory pressure */
 
 /* common parameters: try to keep these consistent across architectures */
 #define MADV_FREE	8		/* free pages only if memory pressure */
diff -puN arch/parisc/include/uapi/asm/mman.h~mm-remove-duplicate-definitions-of-madv_free arch/parisc/include/uapi/asm/mman.h
--- a/arch/parisc/include/uapi/asm/mman.h~mm-remove-duplicate-definitions-of-madv_free
+++ a/arch/parisc/include/uapi/asm/mman.h
@@ -43,7 +43,6 @@
 #define MADV_SPACEAVAIL 5               /* insure that resources are reserved */
 #define MADV_VPS_PURGE  6               /* Purge pages from VM page cache */
 #define MADV_VPS_INHERIT 7              /* Inherit parents page size */
-#define MADV_FREE	8		/* free pages only if memory pressure */
 
 /* common/generic parameters */
 #define MADV_FREE	8		/* free pages only if memory pressure */
diff -puN arch/xtensa/include/uapi/asm/mman.h~mm-remove-duplicate-definitions-of-madv_free arch/xtensa/include/uapi/asm/mman.h
--- a/arch/xtensa/include/uapi/asm/mman.h~mm-remove-duplicate-definitions-of-madv_free
+++ a/arch/xtensa/include/uapi/asm/mman.h
@@ -86,7 +86,6 @@
 #define MADV_SEQUENTIAL	2		/* expect sequential page references */
 #define MADV_WILLNEED	3		/* will need these pages */
 #define MADV_DONTNEED	4		/* don't need these pages */
-#define MADV_FREE	5		/* free pages only if memory pressure */
 
 /* common parameters: try to keep these consistent across architectures */
 #define MADV_FREE	8		/* free pages only if memory pressure */
_

Patches currently in -mm which might be from linux@roeck-us.net are

mm-remove-duplicate-definitions-of-madv_free.patch

