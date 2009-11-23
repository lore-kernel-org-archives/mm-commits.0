From: akpm@linux-foundation.org
Subject: + drivers-usb-host-ehci-omapc-introduce-missing-kfree.patch added to -mm tree
Date: Mon, 23 Nov 2009 15:39:45 -0800
Message-ID: <200911232339.nANNdj1P020864@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36963 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932130AbZKWXjm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Nov 2009 18:39:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, greg@kroah.com


The patch titled
     drivers/usb/host/ehci-omap.c: introduce missing kfree
has been added to the -mm tree.  Its filename is
     drivers-usb-host-ehci-omapc-introduce-missing-kfree.patch

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
Subject: drivers/usb/host/ehci-omap.c: introduce missing kfree
From: Julia Lawall <julia@diku.dk>

Error handling code following a kzalloc should free the allocated data.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,f1,l;
position p1,p2;
expression *ptr != NULL;
@@

x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
<... when != x
     when != if (...) { <+...x...+> }
(
x->f1 = E
|
 (x->f1 == NULL || ...)
|
 f(...,x->f1,...)
)
...>
(
 return \(0\|<+...x...+>\|ptr\);
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/ehci-omap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/usb/host/ehci-omap.c~drivers-usb-host-ehci-omapc-introduce-missing-kfree drivers/usb/host/ehci-omap.c
--- a/drivers/usb/host/ehci-omap.c~drivers-usb-host-ehci-omapc-introduce-missing-kfree
+++ a/drivers/usb/host/ehci-omap.c
@@ -558,7 +558,7 @@ static int ehci_hcd_omap_probe(struct pl
 	omap = kzalloc(sizeof(*omap), GFP_KERNEL);
 	if (!omap) {
 		ret = -ENOMEM;
-		goto err_create_hcd;
+		goto err_disabled;
 	}
 
 	hcd = usb_create_hcd(&ehci_omap_hc_driver, &pdev->dev,
@@ -653,6 +653,7 @@ err_ioremap:
 	usb_put_hcd(hcd);
 
 err_create_hcd:
+	kfree(omap);
 err_disabled:
 err_pdata:
 	return ret;
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-media-video-move-dereference-after-null-test.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-block-dac960c-use-dac960_v2_controller.patch
drivers-cpuidle-move-dereference-after-null-test.patch
drivers-mmc-move-dereference-after-null-test.patch
drivers-video-move-dereference-after-null-test.patch
drivers-char-ipmi-use-kcs_idle_state.patch
drivers-media-video-introduce-missing-kfree.patch
drivers-edac-introduce-missing-kfree.patch
drivers-usb-host-xhci-memc-introduce-missing-kfree.patch
drivers-usb-host-ehci-omapc-introduce-missing-kfree.patch

