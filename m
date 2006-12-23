From: akpm@osdl.org
Subject: + fix-ipmi-watchdog-set_param_str-using-kstrdup.patch added to -mm tree
Date: Sat, 23 Dec 2006 14:02:26 -0800
Message-ID: <200612232202.kBNM2QfU022857@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:41422 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753801AbWLWWCe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Dec 2006 17:02:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sebastien.dugue@bull.net, minyard@acm.org


The patch titled
     Fix IPMI watchdog set_param_str() using kstrdup
has been added to the -mm tree.  Its filename is
     fix-ipmi-watchdog-set_param_str-using-kstrdup.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: Fix IPMI watchdog set_param_str() using kstrdup
=46rom: Sebastien Dugu=E9 <sebastien.dugue@bull.net>

set_param_str() cannot use kstrdup() to duplicate the parameter.  That'=
s
fine when the driver is compiled as a module but it sure is not when bu=
ilt
into the kernel as the kernel parameters are parsed before the kmalloc
slabs are setup.

Signed-off-by: Sebastien Dugu=E9 <sebastien.dugue@bull.net>
Cc: Corey Minyard <minyard@acm.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/ipmi/ipmi_watchdog.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN drivers/char/ipmi/ipmi_watchdog.c~fix-ipmi-watchdog-set_param=
_str-using-kstrdup drivers/char/ipmi/ipmi_watchdog.c
--- a/drivers/char/ipmi/ipmi_watchdog.c~fix-ipmi-watchdog-set_param_str=
-using-kstrdup
+++ a/drivers/char/ipmi/ipmi_watchdog.c
@@ -216,13 +216,13 @@ static int set_param_str(const char *val
 {
 	action_fn  fn =3D (action_fn) kp->arg;
 	int        rv =3D 0;
-	char       *dup, *s;
+	char       valcp[16];
+	char       *s;
=20
-	dup =3D kstrdup(val, GFP_KERNEL);
-	if (!dup)
-		return -ENOMEM;
+	strncpy(valcp, val, 16);
+	valcp[15] =3D '\0';
=20
-	s =3D strstrip(dup);
+	s =3D strstrip(valcp);
=20
 	down_read(&register_sem);
 	rv =3D fn(s, NULL);
@@ -235,7 +235,6 @@ static int set_param_str(const char *val
=20
  out_unlock:
 	up_read(&register_sem);
-	kfree(dup);
 	return rv;
 }
=20
_

Patches currently in -mm which might be from sebastien.dugue@bull.net a=
re

fix-ipmi-watchdog-set_param_str-using-kstrdup.patch

-
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
