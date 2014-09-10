From: akpm@linux-foundation.org
Subject: + binfmt_misc-work-around-gcc-49-warning.patch added to -mm tree
Date: Wed, 10 Sep 2014 15:33:35 -0700
Message-ID: <5410d1bf.8oy3mCKQw1EBs+w5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58601 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbaIJWdg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Sep 2014 18:33:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: binfmt_misc: work around gcc-4.9 warning
has been added to the -mm tree.  Its filename is
     binfmt_misc-work-around-gcc-49-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/binfmt_misc-work-around-gcc-49-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/binfmt_misc-work-around-gcc-49-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: binfmt_misc: work around gcc-4.9 warning

gcc-4.9 on ARM gives us a mysterious warning about the binfmt_misc
parse_command function:

fs/binfmt_misc.c: In function 'parse_command.part.3':
fs/binfmt_misc.c:405:7: warning: array subscript is above array bounds [-Warray-bounds]

I've managed to trace this back to the ARM implementation of memset,
which is called from copy_from_user in case of a fault and which does

 #define memset(p,v,n)                                                  \
        ({                                                              \
                void *__p = (p); size_t __n = n;                        \
                if ((__n) != 0) {                                       \
                        if (__builtin_constant_p((v)) && (v) == 0)      \
                                __memzero((__p),(__n));                 \
                        else                                            \
                                memset((__p),(v),(__n));                \
                }                                                       \
                (__p);                                                  \
        })

Apparently gcc gets confused by the check for "size != 0" and believes
that the size might be zero when it gets to the line that does "if
(s[count-1] == '\n')", so it would access data outside of the array.

gcc is clearly wrong here, since this condition was already checked
earlier in the function and the 'size' value can not change in the
meantime.

Fortunately, we can work around it and get rid of the warning by
rearranging the function to check for zero size after doing the
copy_from_user.  It is still safe to pass a zero size into copy_from_user,
so it does not cause any side effects.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_misc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/binfmt_misc.c~binfmt_misc-work-around-gcc-49-warning fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~binfmt_misc-work-around-gcc-49-warning
+++ a/fs/binfmt_misc.c
@@ -411,12 +411,12 @@ static int parse_command(const char __us
 {
 	char s[4];
 
-	if (!count)
-		return 0;
 	if (count > 3)
 		return -EINVAL;
 	if (copy_from_user(s, buffer, count))
 		return -EFAULT;
+	if (!count)
+		return 0;
 	if (s[count-1] == '\n')
 		count--;
 	if (count == 1 && s[0] == '0')
_

Patches currently in -mm which might be from arnd@arndb.de are

lib-genallocc-add-power-aligned-algorithm.patch
lib-genallocc-add-genpool-range-check-function.patch
common-dma-mapping-introduce-common-remapping-functions.patch
arm-use-genalloc-for-the-atomic-pool.patch
arm64-add-atomic-pool-for-non-coherent-and-cma-allocations.patch
mm-compaction-fix-warning-of-flags-may-be-used-uninitialized.patch
binfmt_misc-work-around-gcc-49-warning.patch
linux-next.patch
kernel-add-support-for-kernel-restart-handler-call-chain.patch
power-restart-call-machine_restart-instead-of-arm_pm_restart.patch
arm64-support-restart-through-restart-handler-call-chain.patch
arm-support-restart-through-restart-handler-call-chain.patch
watchdog-moxart-register-restart-handler-with-kernel-restart-handler.patch
watchdog-alim7101-register-restart-handler-with-kernel-restart-handler.patch
watchdog-sunxi-register-restart-handler-with-kernel-restart-handler.patch
arm-arm64-unexport-restart-handlers.patch
watchdog-s3c2410-add-restart-handler.patch
clk-samsung-register-restart-handlers-for-s3c2412-and-s3c2443.patch
clk-rockchip-add-restart-handler.patch

