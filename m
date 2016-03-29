From: akpm@linux-foundation.org
Subject: +
 compilerh-provide-__always_inline-to-userspace-headers-too.patch added to
 -mm tree
Date: Tue, 29 Mar 2016 11:31:13 -0700
Message-ID: <56fac9f1.91KycV6hHYULSPZK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49840 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760AbcC2SbO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Mar 2016 14:31:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvlasenk@redhat.com, jwboyer@fedoraproject.org, mm-commits@vger.kernel.org


The patch titled
     Subject: compiler.h: provide __always_inline to userspace headers too
has been added to the -mm tree.  Its filename is
     compilerh-provide-__always_inline-to-userspace-headers-too.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/compilerh-provide-__always_inline-to-userspace-headers-too.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/compilerh-provide-__always_inline-to-userspace-headers-too.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Denys Vlasenko <dvlasenk@redhat.com>
Subject: compiler.h: provide __always_inline to userspace headers too

Recent change to uapi/linux/swab.h needs this.

In file included from test.c:2:0:
/usr/include/linux/swab.h:154:8: error: unknown type name `__always_inline'
 static __always_inline __u16 __swab16p(const __u16 *p)
        ^~~~~~~~~~~~~~~

Fixes: bc27fb68aaad4 ("include/uapi/linux/byteorder, swab: force inlining of some byteswap operations")
Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
Reported-by: Josh Boyer <jwboyer@fedoraproject.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/compiler.h~compilerh-provide-__always_inline-to-userspace-headers-too include/linux/compiler.h
--- a/include/linux/compiler.h~compilerh-provide-__always_inline-to-userspace-headers-too
+++ a/include/linux/compiler.h
@@ -397,12 +397,12 @@ static __always_inline void __write_once
  */
 #define noinline_for_stack noinline
 
+#endif /* __KERNEL__ */
+
 #ifndef __always_inline
 #define __always_inline inline
 #endif
 
-#endif /* __KERNEL__ */
