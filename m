From: akpm@linux-foundation.org
Subject: + drivers-macintosh-add-missing-of_node_put-in-therm_adt746xc.patch added to -mm tree
Date: Sat, 06 Dec 2008 16:23:42 -0800
Message-ID: <200812070023.mB70Ngi4032307@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752655AbYLGAXz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 6 Dec 2008 19:23:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npalix@diku.dk, julia@diku.dk, sfr@canb.auug.org.au


The patch titled
     drivers/macintosh: Add missing of_node_put in therm_adt746x.c
has been added to the -mm tree.  Its filename is
     drivers-macintosh-add-missing-of_node_put-in-therm_adt746xc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/macintosh: Add missing of_node_put in therm_adt746x.c
From: Nicolas Palix <npalix@diku.dk>

of_node_put is needed before discarding a value received from
of_find_node_by_name, eg in error handling code or when the device node is
no longer used.

The semantic match that catches the bug is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression struct device_node *n;
position p1, p2;
struct device_node *n1;
statement S;
identifier f;
expression E;
expression *ptr != NULL;
@@

n@p1 = of_find_node_by_name(...)
...
if (!n) S
... when != of_node_put(n)
    when != n1 = f(n,...)
    when != E = n
    when any
    when strict
(
  return \(0\|<+...n...+>\|ptr\);
|
return@p2 ...;
|
  of_node_put(n);
|
  n1 = f(n,...)
|
  E = n
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s of_find_node_by_name %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Nicolas Palix <npalix@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/macintosh/therm_adt746x.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/macintosh/therm_adt746x.c~drivers-macintosh-add-missing-of_node_put-in-therm_adt746xc drivers/macintosh/therm_adt746x.c
--- a/drivers/macintosh/therm_adt746x.c~drivers-macintosh-add-missing-of_node_put-in-therm_adt746xc
+++ a/drivers/macintosh/therm_adt746x.c
@@ -554,7 +554,7 @@ thermostat_init(void)
 	const u32 *prop;
 	int i = 0, offset = 0;
 	int err;
-	
+
 	np = of_find_node_by_name(NULL, "fan");
 	if (!np)
 		return -ENODEV;
@@ -613,13 +613,13 @@ thermostat_init(void)
 	}
 
 	of_dev = of_platform_device_create(np, "temperatures", NULL);
-	
+	of_node_put(np);
+
 	if (of_dev == NULL) {
 		printk(KERN_ERR "Can't register temperatures device !\n");
-		of_node_put(np);
 		return -ENODEV;
 	}
-	
+
 	err = device_create_file(&of_dev->dev, &dev_attr_sensor1_temperature);
 	err |= device_create_file(&of_dev->dev, &dev_attr_sensor2_temperature);
 	err |= device_create_file(&of_dev->dev, &dev_attr_sensor1_limit);
_

Patches currently in -mm which might be from npalix@diku.dk are

linux-next.patch
powerpc-chrp-add-missing-of_node_put-in-pcic.patch
drivers-macintosh-add-missing-of_node_put-in-therm_adt746xc.patch

