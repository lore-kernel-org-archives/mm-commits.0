From: akpm@linux-foundation.org
Subject: + byteswap-try-to-avoid-__builtin_constant_p-gcc-bug-v2-fix.patch added to -mm tree
Date: Tue, 03 May 2016 15:45:39 -0700
Message-ID: <57292a13.dR2KkRnH6UlLd/Bz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33397 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756436AbcECWpk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 May 2016 18:45:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, jpoimboe@redhat.com, quinn.tran@qlogic.com, mm-commits@vger.kernel.org


The patch titled
     Subject: byteswap-try-to-avoid-__builtin_constant_p-gcc-bug-v2-fix
has been added to the -mm tree.  Its filename is
     byteswap-try-to-avoid-__builtin_constant_p-gcc-bug-v2-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/byteswap-try-to-avoid-__builtin_constant_p-gcc-bug-v2-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/byteswap-try-to-avoid-__builtin_constant_p-gcc-bug-v2-fix.patch

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
Subject: byteswap-try-to-avoid-__builtin_constant_p-gcc-bug-v2-fix

> > > net/tipc/name_distr.c: In function 'tipc_named_process_backlog':
> > > net/tipc/name_distr.c:330: warning: format '%u' expects type 'unsigned int', but argument 3 has type 'unsigned int'
> > > net/tipc/name_distr.c:330: warning: format '%u' expects type 'unsigned int', but argument 4 has type 'unsigned int'
> > > net/tipc/name_distr.c:330: warning: format '%u' expects type 'unsigned int', but argument 5 has type 'unsigned int'
> > > net/tipc/name_distr.c:330: warning: format '%u' expects type 'unsigned int', but argument 7 has type 'unsigned int'
> >
> > I've built a few thousand kernels (arm32 with gcc-6.1) with the patch applied,
> > but didn't see this one. What target architecture and compiler version produced
> > this? Does it go away if you add a (__u32) cast? I don't even know what the
> > warning is trying to tell me.
>
> heh, I didn't actually read it.
>
> Hopefully we can write this off as a gcc-4.4.4 glitch. 4.8.4 is OK.

Ah, old compiler. I've tried gcc-4.3 now on ARM, and I don't get this warning
(just a lot "may be used uninitialized"), but unlike gcc-4.4, my version doesn't
actually get into the code path I have changed because __builtin_bswap32 was only
introduced with 4.4.

I don't have gcc-4.4 and 4.5 here, but the warning does show up with 4.6, 4.7
and 4.8:

drivers/soc/sunxi/sunxi_sram.c: In function `sunxi_sram_show':
drivers/soc/sunxi/sunxi_sram.c:103:7: warning: format `%x' expects argument of type `unsigned int', but argument 3 has type `unsigned int' [-Wformat=]

4.8 is probably still common enough that we should try to address this.
This change addresses the problem for me with ARM gcc-4.8, but adding
two more type casts. This also makes the 16/32/64 bit swaps all
look the same. I would expect this to also have the same effect on 4.4.

Link: http://lkml.kernel.org/r/12243652.bxSxEgjgfk@wuerfel
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com> # on gcc-5.3
Cc: Quinn Tran <quinn.tran@qlogic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/swab.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/uapi/linux/swab.h~byteswap-try-to-avoid-__builtin_constant_p-gcc-bug-v2-fix include/uapi/linux/swab.h
--- a/include/uapi/linux/swab.h~byteswap-try-to-avoid-__builtin_constant_p-gcc-bug-v2-fix
+++ a/include/uapi/linux/swab.h
@@ -97,7 +97,7 @@ static inline __attribute_const__ __u32
  * @x: value to byteswap
  */
 #ifdef __HAVE_BUILTIN_BSWAP16__
-#define __swab16(x) __builtin_bswap16((__u16)(x))
+#define __swab16(x) (__u16)__builtin_bswap16((__u16)(x))
 #else
 #define __swab16(x)				\
 	(__builtin_constant_p((__u16)(x)) ?	\
@@ -110,7 +110,7 @@ static inline __attribute_const__ __u32
  * @x: value to byteswap
  */
 #ifdef __HAVE_BUILTIN_BSWAP32__
-#define __swab32(x) __builtin_bswap32((__u32)(x))
+#define __swab32(x) (__u32)__builtin_bswap32((__u32)(x))
 #else
 #define __swab32(x)				\
 	(__builtin_constant_p((__u32)(x)) ?	\
_

Patches currently in -mm which might be from arnd@arndb.de are

byteswap-try-to-avoid-__builtin_constant_p-gcc-bug-v2.patch
byteswap-try-to-avoid-__builtin_constant_p-gcc-bug-v2-fix.patch
kernel-padata-hide-unused-functions.patch
drm-amdgpu-make-amdgpu_mn_get-wait-for-mmap_sem-killable-fix.patch

