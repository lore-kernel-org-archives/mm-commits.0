From: akpm@linux-foundation.org
Subject: + include-linux-errh-add-a-function-to-cast-error-pointers-to-a-return-value.patch added to -mm tree
Date: Thu, 27 Jan 2011 14:26:15 -0800
Message-ID: <201101272226.p0RMQFwQ003451@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57441 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752195Ab1A0W0o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Jan 2011 17:26:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de, akpm@linux-foundation.org


The patch titled
     include/linux/err.h: add a function to cast error-pointers to a re=
turn value
has been added to the -mm tree.  Its filename is
     include-linux-errh-add-a-function-to-cast-error-pointers-to-a-retu=
rn-value.patch

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
Subject: include/linux/err.h: add a function to cast error-pointers to =
a return value
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

PTR_RET() can be used if you have an error-pointer and are only interes=
ted
in the eventual error value, but not the pointer.  Yields the usual 0 f=
or
no error, -ESOMETHING otherwise.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/err.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN include/linux/err.h~include-linux-errh-add-a-function-to-cast=
-error-pointers-to-a-return-value include/linux/err.h
--- a/include/linux/err.h~include-linux-errh-add-a-function-to-cast-err=
or-pointers-to-a-return-value
+++ a/include/linux/err.h
@@ -52,6 +52,14 @@ static inline void * __must_check ERR_CA
 	return (void *) ptr;
 }
=20
+static inline int __must_check PTR_RET(const void *ptr)
+{
+	if (IS_ERR(ptr))
+		return PTR_ERR(ptr);
+	else
+		return 0;
+}
+
 #endif
=20
 #endif /* _LINUX_ERR_H */
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

origin.patch
linux-next.patch
include-linux-errh-add-a-function-to-cast-error-pointers-to-a-return-va=
lue.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
