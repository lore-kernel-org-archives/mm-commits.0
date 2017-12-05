From: akpm@linux-foundation.org
Subject: + stringh-work-around-for-increased-stack-usage.patch added to
 -mm tree
Date: Tue, 05 Dec 2017 14:02:26 -0800
Message-ID: <5a271772.qssuZMSh01x9AsNZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35440 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752126AbdLEWC2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Dec 2017 17:02:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, aryabinin@virtuozzo.com, danielmicay@gmail.com, dan.j.williams@intel.com, dvyukov@google.com, glider@google.com, gregkh@linuxfoundation.org, keescook@chromium.org, mchehab@kernel.org, mwilck@suse.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: string.h: workaround for increased stack usage
has been added to the -mm tree.  Its filename is
     stringh-work-around-for-increased-stack-usage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/stringh-work-around-for-increased-stack-usage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/stringh-work-around-for-increased-stack-usage.patch

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
Subject: string.h: workaround for increased stack usage

The hardened strlen() function causes rather large stack usage in at least
one file in the kernel, in particular when CONFIG_KASAN is enabled:

drivers/media/usb/em28xx/em28xx-dvb.c: In function 'em28xx_dvb_init':
drivers/media/usb/em28xx/em28xx-dvb.c:2062:1: error: the frame size of 3256 bytes is larger than 204 bytes [-Werror=frame-larger-than=]

Analyzing this problem led to the discovery that gcc fails to merge the
stack slots for the i2c_board_info[] structures after we strlcpy() into
them, due to the 'noreturn' attribute on the source string length check.

I reported this as a gcc bug, but it is unlikely to get fixed for gcc-8,
since it is relatively easy to work around, and it gets triggered rarely. 
An earlier workaround I did added an empty inline assembly statement
before the call to fortify_panic(), which works surprisingly well, but is
really ugly and unintuitive.

This is a new approach to the same problem, this time addressing it by not
calling the 'extern __real_strnlen()' function for string constants where
__builtin_strlen() is a compile-time constant and therefore known to be
safe.  We do this by checking if the last character in the string is a
compile-time constant '\0'.  If it is, we can assume that strlen() of the
string is also constant.  As a side-effect, this should also improve the
object code output for any other call of strlen() on a string constant.

Link: http://lkml.kernel.org/r/20171205215143.3085755-1-arnd@arndb.de
Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=82365
Link: https://patchwork.kernel.org/patch/9980413/
Link: https://patchwork.kernel.org/patch/9974047/
Fixes: 6974f0c4555 ("include/linux/string.h: add the option of fortified string.h functions")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/string.h~stringh-work-around-for-increased-stack-usage include/linux/string.h
--- a/include/linux/string.h~stringh-work-around-for-increased-stack-usage
+++ a/include/linux/string.h
@@ -259,7 +259,8 @@ __FORTIFY_INLINE __kernel_size_t strlen(
 {
 	__kernel_size_t ret;
 	size_t p_size = __builtin_object_size(p, 0);
-	if (p_size == (size_t)-1)
+	if (p_size == (size_t)-1 ||
+	    (__builtin_constant_p(p[p_size - 1]) && p[p_size - 1] == '\0'))
 		return __builtin_strlen(p);
 	ret = strnlen(p, p_size);
 	if (p_size <= ret)
_

Patches currently in -mm which might be from arnd@arndb.de are

stringh-work-around-for-increased-stack-usage.patch

