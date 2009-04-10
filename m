From: akpm@linux-foundation.org
Subject: + mips-cacheflush-system-call-not-returning-einval.patch added to -mm tree
Date: Fri, 10 Apr 2009 15:41:31 -0700
Message-ID: <200904102241.n3AMfWVK029343@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57639 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751431AbZDJWnO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 18:43:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maxin.john@gmail.com, ralf@linux-mips.org


The patch titled
     mips: cacheflush system call not returning -EINVAL
has been added to the -mm tree.  Its filename is
     mips-cacheflush-system-call-not-returning-einval.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mips: cacheflush system call not returning -EINVAL
From: Maxin John <maxin.john@gmail.com>

cacheflush man page states that cacheflush() will set EINVAL if cache
parameter is not one of ICACHE, DCACHE, or BCACHE.  In order to confirm
this behavior, I have executed the below listed program
(cacheflush_check.c) in Toshiba RBTX4937 board (MIPS) with 2.6.29.1
kernel.

=================================================================
 /*
  *  cacheflush_check.c
  *
  *  Description:
  * Tests EINVAL error of cacheflush system call
  *
  *  Expected behaviour:
  * cacheflush() should return -EINVAL when cache parameter is not one of ICACHE, DCACHE, or BCACHE.
  *
  */

#include <sys/syscall.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#if defined __mips__
#include <asm/cachectl.h>

int cacheflush(char *addr, int nbytes, int cache)
{
        return syscall(__NR_cacheflush, addr, nbytes, cache);
}
#endif /* __mips__ */

int main()
{
        /* cacheflush man page states that cacheflush() is only
applicable to MIPS architecture */

        char *addr = NULL;

        /* Create some user address range */
        addr = malloc(getpagesize());
        if (addr == NULL) {
                printf("Malloc error\n");
                exit(-1);
        }

        /* Invokes cacheflush() with proper parameters */
        cacheflush(addr, getpagesize(), ICACHE);
        cacheflush(addr, getpagesize(), DCACHE);
        cacheflush(addr, getpagesize(), BCACHE);

       /* Tests whether cacheflush() returns -EINVAL */
        if (cacheflush(addr, getpagesize(), 0) < 0) {
                if (errno == EINVAL) {
                        printf("cacheflush EINVAL : TEST PASS\n");
                        exit(0);
                } else {
                        printf("cacheflush EINVAL : TEST FAIL\n");
                }
        }
        printf("cacheflush EINVAL : TEST FAIL\n");
        return -1;
}
=======================================================

I have observed that the test failed when executed in target board.

-bash-3.2# ./cacheflush_err_check
cacheflush EINVAL : TEST FAIL

I have checked the 'arch/mips/mm/cache.c' and observed that the
cacheflush() implementation is not setting EINVAL.
So, I have modified this file by including these two lines for EINVAL.

 if ( (cache != ICACHE) && (cache != DCACHE) && (cache != BCACHE) )
            return -EINVAL;

After this modification, I have straced the cacheflush_check program
with the modified kernel:

strace ./cacheflush_check
....
set_thread_area(0x2aacd3e0)             = 0
mprotect(0x2ac1a000, 28672, PROT_READ)  = 0
mprotect(0x2aad4000, 4096, PROT_READ)   = 0
brk(0)                                  = 0x411000
brk(0x432000)                           = 0x432000
syscall(0x1033, 0x411050, 0x1000, 0x1, 0x418e90, 0x2aac5280, 0x418e90,
0x2aad4ef0) = 0
syscall(0x1033, 0x411050, 0x1000, 0x2, 0x418e90, 0x2aac5280, 0x418e90,
0x2aad4ef0) = 0
syscall(0x1033, 0x411050, 0x1000, 0x3, 0x418e90, 0x2aac5280, 0x418e90,
0x2aad4ef0) = 0
syscall(0x1033, 0x411050, 0x1000, 0, 0x418e90, 0x2aac5280, 0x418e90,
0x2aad4ef0) = -1 EINVAL (Invalid argument)
fstat64(1, {st_mode=S_IFCHR|0600, st_rdev=makedev(136, 0), ...}) = 0
old_mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS,
-1, 0) = 0x2ac2a000
....

The test passes when executed in the modified kernel.I have tested this
patch and seen no adverse effects.

Signed-off-by: Maxin B. John <maxinbjohn@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/cache.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN arch/mips/mm/cache.c~mips-cacheflush-system-call-not-returning-einval arch/mips/mm/cache.c
--- a/arch/mips/mm/cache.c~mips-cacheflush-system-call-not-returning-einval
+++ a/arch/mips/mm/cache.c
@@ -64,6 +64,10 @@ SYSCALL_DEFINE3(cacheflush, unsigned lon
 {
 	if (bytes == 0)
 		return 0;
+
+       if ( (cache != ICACHE) && (cache != DCACHE) && (cache != BCACHE) )
+                return -EINVAL;
+
 	if (!access_ok(VERIFY_WRITE, (void __user *) addr, bytes))
 		return -EFAULT;
 
_

Patches currently in -mm which might be from maxin.john@gmail.com are

mips-cacheflush-system-call-not-returning-einval.patch

