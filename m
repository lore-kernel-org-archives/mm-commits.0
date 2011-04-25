From: akpm@linux-foundation.org
Subject: + drivers-char-ppdevc-put-gotten-port-value.patch added to -mm tree
Date: Mon, 25 Apr 2011 13:47:14 -0700
Message-ID: <201104252047.p3PKlEkp008330@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932836Ab1DYUrS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Apr 2011 16:47:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk


The patch titled
     drivers/char/ppdev.c: put gotten port value
has been added to the -mm tree.  Its filename is
     drivers-char-ppdevc-put-gotten-port-value.patch

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
Subject: drivers/char/ppdev.c: put gotten port value
From: Julia Lawall <julia@diku.dk>

parport_find_number() calls parport_get_port() on its result, so there
should be a corresponding call to parport_put_port() before dropping the
reference.  Similar code is found in the function register_device() in the
same file.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@exists@
local idexpression struct parport * x;
expression ra,rr;
statement S1,S2;
@@

x = parport_find_number(...)
... when != x = rr
    when any
    when != parport_put_port(x,...)
    when != if (...) { ... parport_put_port(x,...) ...}
(
if(<+...x...+>) S1 else S2
|
if(...) { ... when != x = ra
     when forall
     when != parport_put_port(x,...)
*return...;
}
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ppdev.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/char/ppdev.c~drivers-char-ppdevc-put-gotten-port-value drivers/char/ppdev.c
--- a/drivers/char/ppdev.c~drivers-char-ppdevc-put-gotten-port-value
+++ a/drivers/char/ppdev.c
@@ -457,6 +457,7 @@ static int pp_do_ioctl(struct file *file
 			return -ENODEV;
 
 		modes = port->modes;
+		parport_put_port(port);
 		if (copy_to_user (argp, &modes, sizeof (modes))) {
 			return -EFAULT;
 		}
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region-fix.patch
drivers-char-ppdevc-put-gotten-port-value.patch

