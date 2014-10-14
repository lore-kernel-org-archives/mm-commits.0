From: akpm@linux-foundation.org
Subject: [merged] binfmt_misc-work-around-gcc-49-warning.patch removed
 from -mm tree
Date: Tue, 14 Oct 2014 11:19:59 -0700
Message-ID: <543d694f.DHUJ0B6QlSwMFn9W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44186 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbaJNST5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:19:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: binfmt_misc: work around gcc-4.9 warning
has been removed from the -mm tree.  Its filename was
     binfmt_misc-work-around-gcc-49-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

