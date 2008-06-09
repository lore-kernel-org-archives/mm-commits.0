From: akpm@linux-foundation.org
Subject: + drivers-isdn-sc-ioctlc-add-missing-kfree.patch added to -mm tree
Date: Mon, 09 Jun 2008 02:52:39 -0700
Message-ID: <200806090952.m599qeHV014109@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38722 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758821AbYFIJwv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2008 05:52:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, kkeil@suse.de


The patch titled
     drivers/isdn/sc/ioctl.c: add missing kfree
has been added to the -mm tree.  Its filename is
     drivers-isdn-sc-ioctlc-add-missing-kfree.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/isdn/sc/ioctl.c: add missing kfree
From: Julia Lawall <julia@diku.dk>

spid has been allocated in this function and so should be freed before
leaving it, as in the other error handling cases.

The semantic match that finds the problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

@r exists@
expression E,E1;
statement S;
position p1,p2,p3;
@@

E =@p1 \(kmalloc\|kcalloc\|kzalloc\)(...)
... when != E = E1
if (E == NULL || ...) S
... when != E = E1
if@p2 (...) {
 ... when != kfree(E)
 }
... when != E = E1
kfree@p3(E);

@forall@
position r.p2;
expression r.E;
int E1 != 0;
@@

* if@p2 (...) {
 ... when != kfree(E)
     when strict
return E1; }

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/sc/ioctl.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/isdn/sc/ioctl.c~drivers-isdn-sc-ioctlc-add-missing-kfree drivers/isdn/sc/ioctl.c
--- a/drivers/isdn/sc/ioctl.c~drivers-isdn-sc-ioctlc-add-missing-kfree
+++ a/drivers/isdn/sc/ioctl.c
@@ -226,6 +226,7 @@ int sc_ioctl(int card, scs_ioctl *data)
 		 */
 		if (copy_from_user(spid, data->dataptr, SCIOC_SPIDSIZE)) {
 			kfree(rcvmsg);
+			kfree(spid);
 			return -EFAULT;
 		}
 
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-isdn-sc-ioctlc-add-missing-kfree.patch

