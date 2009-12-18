From: akpm@linux-foundation.org
Subject: [merged] lib-vsprintfc-document-more-vsnprintf-extensions.patch removed from -mm tree
Date: Fri, 18 Dec 2009 12:26:24 -0800
Message-ID: <200912182026.nBIKQOf6016457@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38194 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932732AbZLRU1E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Dec 2009 15:27:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, bjorn.helgaas@hp.com, davem@davemloft.net, harvey.harrison@gmail.com, jbarnes@virtuousgeek.org, jens@mcbone.net, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     lib/vsprintf.c: document more vsnprintf extensions
has been removed from the -mm tree.  Its filename was
     lib-vsprintfc-document-more-vsnprintf-extensions.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

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

linux-next.patch
hrtimer-correct-a-few-numbers-in-comments.patch
clockevents-ensure-taht-min_delta_ns-is-increased-in-error-path.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
