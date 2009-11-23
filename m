From: akpm@linux-foundation.org
Subject: + drivers-edac-introduce-missing-kfree.patch added to -mm tree
Date: Mon, 23 Nov 2009 15:39:40 -0800
Message-ID: <200911232339.nANNdfcN020683@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48527 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932102AbZKWXji (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Nov 2009 18:39:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, norsk5@yahoo.com


The patch titled
     drivers/edac: introduce missing kfree
has been added to the -mm tree.  Its filename is
     drivers-edac-introduce-missing-kfree.patch

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
Subject: drivers/edac: introduce missing kfree
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
Cc: Doug Thompson <norsk5@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i7core_edac.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/edac/i7core_edac.c~drivers-edac-introduce-missing-kfree drivers/edac/i7core_edac.c
--- a/drivers/edac/i7core_edac.c~drivers-edac-introduce-missing-kfree
+++ a/drivers/edac/i7core_edac.c
@@ -1215,8 +1215,10 @@ int i7core_get_onedevice(struct pci_dev 
 			return -ENOMEM;
 		i7core_dev->pdev = kzalloc(sizeof(*i7core_dev->pdev) * n_devs,
 					   GFP_KERNEL);
-		if (!i7core_dev->pdev)
+		if (!i7core_dev->pdev) {
+			kfree(i7core_dev);
 			return -ENOMEM;
+		}
 		i7core_dev->socket = socket;
 		i7core_dev->n_devs = n_devs;
 		list_add_tail(&i7core_dev->list, &i7core_edac_list);
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

