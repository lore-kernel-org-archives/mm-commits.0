From: akpm@linux-foundation.org
Subject: + kfifo-fix-kfifo_init-in-include-linux-kfifoh.patch added to -mm tree
Date: Sat, 20 Mar 2010 11:39:40 -0400
Message-ID: <201003201840.o2KIePlf002529@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751079Ab0CTSkt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 20 Mar 2010 14:40:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david@hardeman.nu, stable@kernel.org, stefani@seibold.net


The patch titled
     kfifo: fix KFIFO_INIT in include/linux/kfifo.h
has been added to the -mm tree.  Its filename is
     kfifo-fix-kfifo_init-in-include-linux-kfifoh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: kfifo: fix KFIFO_INIT in include/linux/kfifo.h
=46rom: David H=E4rdeman <david@hardeman.nu>

include/linux/kfifo.h first defines and then undefines __kfifo_initiali=
zer
which is used by INIT_KFIFO (which is also a macro, so building a modul=
e
which uses INIT_KFIFO will fail).

Signed-off-by: David H=E4rdeman <david@hardeman.nu>
Acked-by: Stefani Seibold <stefani@seibold.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kfifo.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/linux/kfifo.h~kfifo-fix-kfifo_init-in-include-linux-k=
fifoh include/linux/kfifo.h
--- a/include/linux/kfifo.h~kfifo-fix-kfifo_init-in-include-linux-kfifo=
h
+++ a/include/linux/kfifo.h
@@ -102,8 +102,6 @@ union { \
 	unsigned char name##kfifo_buffer[size]; \
 	struct kfifo name =3D __kfifo_initializer(size, name##kfifo_buffer)
=20
-#undef __kfifo_initializer
