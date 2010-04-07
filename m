From: akpm@linux-foundation.org
Subject: [merged] include-linux-kfifoh-fix-init_kfifo.patch removed from -mm tree
Date: Wed, 07 Apr 2010 11:49:26 -0400
Message-ID: <201004071850.o37IoqWd001239@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44066 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755678Ab0DGSvO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Apr 2010 14:51:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@hardeman.nu, stable@kernel.org, stefani@seibold.net, mm-commits@vger.kernel.org


The patch titled
     include/linux/kfifo.h: fix INIT_KFIFO()
has been removed from the -mm tree.  Its filename was
     include-linux-kfifoh-fix-init_kfifo.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: include/linux/kfifo.h: fix INIT_KFIFO()
=46rom: David H=E4rdeman <david@hardeman.nu>

DECLARE_KFIFO creates a union with a struct kfifo and a buffer array wi=
th
size [size + sizeof(struct kfifo)].

INIT_KFIFO then sets the buffer pointer in struct kfifo to point to the
beginning of the buffer array which means that the first call to kfifo_=
in
will overwrite members of the struct kfifo.

Signed-off-by: David H=E4rdeman <david@hardeman.nu>
Acked-by: Stefani Seibold <stefani@seibold.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kfifo.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/kfifo.h~include-linux-kfifoh-fix-init_kfifo inc=
lude/linux/kfifo.h
--- a/include/linux/kfifo.h~include-linux-kfifoh-fix-init_kfifo
+++ a/include/linux/kfifo.h
@@ -86,7 +86,8 @@ union { \
  */
 #define INIT_KFIFO(name) \
 	name =3D __kfifo_initializer(sizeof(name##kfifo_buffer) - \
-				sizeof(struct kfifo), name##kfifo_buffer)
+				sizeof(struct kfifo), \
+				name##kfifo_buffer + sizeof(struct kfifo))
=20
 /**
  * DEFINE_KFIFO - macro to define and initialize a kfifo
_

Patches currently in -mm which might be from david@hardeman.nu are

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
