From: akpm@linux-foundation.org
Subject: + include-linux-kfifoh-fix-init_kfifo.patch added to -mm tree
Date: Wed, 31 Mar 2010 12:15:12 -0700
Message-ID: <201003311915.o2VJFCsn003122@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751853Ab0CaTPf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Mar 2010 15:15:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david@hardeman.nu, stable@kernel.org, stefani@seibold.net


The patch titled
     include/linux/kfifo.h: fix INIT_KFIFO()
has been added to the -mm tree.  Its filename is
     include-linux-kfifoh-fix-init_kfifo.patch

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

include-linux-kfifoh-fix-init_kfifo.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
