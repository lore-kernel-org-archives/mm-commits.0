From: akpm@linux-foundation.org
Subject: + drivers-isdn-capi-kcapic-adjust-error-handling-code-involving-capi_ctr_put.patch added to -mm tree
Date: Mon, 11 Aug 2008 13:46:21 -0700
Message-ID: <200808112046.m7BKkMrD020515@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56665 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754634AbYHKUqc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 16:46:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, davem@davemloft.net, kkeil@suse.de


The patch titled
     drivers/isdn/capi/kcapi.c: Adjust error handling code involving capi_ctr_put
has been added to the -mm tree.  Its filename is
     drivers-isdn-capi-kcapic-adjust-error-handling-code-involving-capi_ctr_put.patch

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
Subject: drivers/isdn/capi/kcapi.c: Adjust error handling code involving capi_ctr_put
From: Julia Lawall <julia@diku.dk>

After calling capi_ctr_get, error handling code should call capi_ctr_put.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r@
expression x,E;
statement S;
position p1,p2,p3;
@@

(
if ((x = capi_ctr_get@p1(...)) == NULL || ...) S
|
x = capi_ctr_get@p1(...)
... when != x
if (x == NULL || ...) S
)
<...
if@p3 (...) { ... when != capi_ctr_put(x)
                  when != if (x) { ... capi_ctr_put(x); ...}
    return@p2 ...;
}
...>
(
return x;
|
return 0;
|
x = E
|
E = x
|
capi_ctr_put(x)
)

@exists@
position r.p1,r.p2,r.p3;
expression x;
int ret != 0;
statement S;
@@

* x = capi_ctr_get@p1(...)
  <...
* if@p3 (...)
  S
  ...>
* return@p2 \(NULL\|ret\);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Karsten Keil <kkeil@suse.de>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/capi/kcapi.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/isdn/capi/kcapi.c~drivers-isdn-capi-kcapic-adjust-error-handling-code-involving-capi_ctr_put drivers/isdn/capi/kcapi.c
--- a/drivers/isdn/capi/kcapi.c~drivers-isdn-capi-kcapic-adjust-error-handling-code-involving-capi_ctr_put
+++ a/drivers/isdn/capi/kcapi.c
@@ -828,15 +828,18 @@ static int old_capi_manufacturer(unsigne
 			return -ESRCH;
 		if (card->load_firmware == NULL) {
 			printk(KERN_DEBUG "kcapi: load: no load function\n");
+			capi_ctr_put(card);
 			return -ESRCH;
 		}
 
 		if (ldef.t4file.len <= 0) {
 			printk(KERN_DEBUG "kcapi: load: invalid parameter: length of t4file is %d ?\n", ldef.t4file.len);
+			capi_ctr_put(card);
 			return -EINVAL;
 		}
 		if (ldef.t4file.data == NULL) {
 			printk(KERN_DEBUG "kcapi: load: invalid parameter: dataptr is 0\n");
+			capi_ctr_put(card);
 			return -EINVAL;
 		}
 
@@ -849,6 +852,7 @@ static int old_capi_manufacturer(unsigne
 
 		if (card->cardstate != CARD_DETECTED) {
 			printk(KERN_INFO "kcapi: load: contr=%d not in detect state\n", ldef.contr);
+			capi_ctr_put(card);
 			return -EBUSY;
 		}
 		card->cardstate = CARD_LOADING;
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
drivers-isdn-capi-kcapic-adjust-error-handling-code-involving-capi_ctr_put.patch
net-ieee80211-adjust-error-handling.patch

