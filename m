From: akpm@linux-foundation.org
Subject: - asm-m32r-uaccessh-must-include-asm-setuph.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:49:07 -0700
Message-ID: <200806081949.m58Jn7Qo017627@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754514AbYFHTtr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:49:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adrian.bunk@movial.fi, Michael.Hennerich@analog.com, takata@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     asm-m32r/uaccess.h must #include <asm/setup.h>
has been removed from the -mm tree.  Its filename was
     asm-m32r-uaccessh-must-include-asm-setuph.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: asm-m32r/uaccess.h must #include <asm/setup.h>
From: Adrian Bunk <adrian.bunk@movial.fi>

This patch fixes the following compile error caused by
commit 4016a1390d07f15b267eecb20e76a48fd5c524ef
(mm/nommu.c: return 0 from kobjsize with invalid objects):

/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/nommu.c: In function 'kobjsize':
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/nommu.c:112: error: 'memory_end' undeclared (first use in this function)
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/nommu.c:112: error: (Each undeclared identifier is reported only once
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/nommu.c:112: error: for each function it appears in.)

The patch also removes now no longer required memory_{start,end}
declarations inside access_ok().

Reported-by: Adrian Bunk <adrian.bunk@movial.fi>
Signed-off-by: Adrian Bunk <adrian.bunk@movial.fi>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Michael Hennerich <Michael.Hennerich@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-m32r/uaccess.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-m32r/uaccess.h~asm-m32r-uaccessh-must-include-asm-setuph include/asm-m32r/uaccess.h
--- a/include/asm-m32r/uaccess.h~asm-m32r-uaccessh-must-include-asm-setuph
+++ a/include/asm-m32r/uaccess.h
@@ -14,6 +14,7 @@
 #include <linux/errno.h>
 #include <linux/thread_info.h>
 #include <asm/page.h>
+#include <asm/setup.h>
 
 #define VERIFY_READ 0
 #define VERIFY_WRITE 1
@@ -106,7 +107,6 @@ static inline void set_fs(mm_segment_t s
 #else
 static inline int access_ok(int type, const void *addr, unsigned long size)
 {
-	extern unsigned long memory_start, memory_end;
 	unsigned long val = (unsigned long)addr;
 
 	return ((val >= memory_start) && ((val + size) < memory_end));
_

Patches currently in -mm which might be from adrian.bunk@movial.fi are

origin.patch

