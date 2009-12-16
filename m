From: akpm@linux-foundation.org
Subject: + lib-vsprintfc-document-more-vsnprintf-extensions.patch added to -mm tree
Date: Wed, 16 Dec 2009 14:23:18 -0800
Message-ID: <200912162223.nBGMNI9F018368@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53628 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932466AbZLPWXz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 17:23:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de, bjorn.helgaas@hp.com, davem@davemloft.net, harvey.harrison@gmail.com, jbarnes@virtuousgeek.org, jens@mcbone.net, joe@perches.com


The patch titled
     lib/vsprintf.c: document more vsnprintf extensions
has been added to the -mm tree.  Its filename is
     lib-vsprintfc-document-more-vsnprintf-extensions.patch

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
Subject: lib/vsprintf.c: document more vsnprintf extensions
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

These were added in

9ac6e44 (lib/vsprintf.c: add %pU to print UUID/GUIDs)
c7dabef (vsprintf: use %pR, %pr instead of %pRt, %pRf)
8a27f7c (lib/vsprintf.c: Add "%pI6c" - print pointer as compressed ipv6=
 address)
4aa9960 (printk: add %I4, %I6, %i4, %i6 format specifiers)
dd45c9c (printk: add %pM format specifier for MAC addresses)

but only added comments to pointer() not vsnprintf() that is refered to=
 by
printk's comments.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: Harvey Harrison <harvey.harrison@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Joe Perches <joe@perches.com>
Cc: Jens Rosenboom <jens@mcbone.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN lib/vsprintf.c~lib-vsprintfc-document-more-vsnprintf-extensio=
ns lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-document-more-vsnprintf-extensions
+++ a/lib/vsprintf.c
@@ -1179,7 +1179,18 @@ qualifier:
  * %ps output the name of a text symbol without offset
  * %pF output the name of a function pointer with its offset
  * %pf output the name of a function pointer without its offset
- * %pR output the address range in a struct resource
+ * %pR output the address range in a struct resource with decoded flag=
s
+ * %pr output the address range in a struct resource with raw flags
+ * %pM output a 6-byte MAC address with colons
+ * %pm output a 6-byte MAC address without colons
+ * %pI4 print an IPv4 address without leading zeros
+ * %pi4 print an IPv4 address with leading zeros
+ * %pI6 print an IPv6 address with colons
+ * %pi6 print an IPv6 address without colons
+ * %pI6c print an IPv6 address as specified by
+ *   http://www.ietf.org/id/draft-kawamura-ipv6-text-representation-03=
=2Etxt
+ * %pU[bBlL] print a UUID/GUID in big or little endian using lower or =
upper
+ *   case.
  * %n is ignored
  *
  * The return value is the number of characters which would
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

origin.patch
lib-vsprintfc-document-more-vsnprintf-extensions.patch
linux-next.patch
hrtimer-correct-a-few-numbers-in-comments.patch
clockevents-ensure-taht-min_delta_ns-is-increased-in-error-path.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
