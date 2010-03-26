From: akpm@linux-foundation.org
Subject: [merged] kfifo-fix-kfifo_init-in-include-linux-kfifoh.patch removed from -mm tree
Date: Fri, 26 Mar 2010 12:36:17 -0400
Message-ID: <201003261937.o2QJbGbX016593@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752094Ab0CZThh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 15:37:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@hardeman.nu, stable@kernel.org, stefani@seibold.net, mm-commits@vger.kernel.org


The patch titled
     kfifo: fix KFIFO_INIT in include/linux/kfifo.h
has been removed from the -mm tree.  Its filename was
     kfifo-fix-kfifo_init-in-include-linux-kfifoh.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

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
