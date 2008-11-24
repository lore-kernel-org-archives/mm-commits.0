From: akpm@linux-foundation.org
Subject: + drivers-pci-hotplug-add-missing-pci_dev_get.patch added to -mm tree
Date: Mon, 24 Nov 2008 14:40:13 -0800
Message-ID: <200811242240.mAOMeDUH031991@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50986 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752932AbYKXWkR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Nov 2008 17:40:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, jbarnes@virtuousgeek.org


The patch titled
     drivers/pci/hotplug: Add missing pci_dev_get
has been added to the -mm tree.  Its filename is
     drivers-pci-hotplug-add-missing-pci_dev_get.patch

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
Subject: drivers/pci/hotplug: Add missing pci_dev_get
From: Julia Lawall <julia@diku.dk>

pci_get_slot does a pci_dev_get, so pci_dev_put needs to be called in an
error case.

An alterative would be to move the test_and_set_bit before the call to
pci_get_slot.

The problem was fixed using the following semantic patch.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
local idexpression *n;
statement S1,S2;
expression E,E1;
expression *ptr != NULL;
type T,T1;
@@

(
if (!(n = pci_get_slot(...))) S1
|
n = pci_get_slot(...)
)
<... when != pci_dev_put(n)
    when != if (...) { <+... pci_dev_put(n) ...+> }
    when != true !n  || ...
    when != n = (T)E
    when != E = n
if (!n || ...) S2
...>
(
  return \(0\|<+...n...+>\|ptr\);
|
+ pci_dev_put(n);
return ...;
|
pci_dev_put(n);
|
n = (T1)E1
|
E1 = n
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/fakephp.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/pci/hotplug/fakephp.c~drivers-pci-hotplug-add-missing-pci_dev_get drivers/pci/hotplug/fakephp.c
--- a/drivers/pci/hotplug/fakephp.c~drivers-pci-hotplug-add-missing-pci_dev_get
+++ a/drivers/pci/hotplug/fakephp.c
@@ -324,6 +324,7 @@ static int disable_slot(struct hotplug_s
 
 		if (test_and_set_bit(0, &dslot->removed)) {
 			dbg("Slot already scheduled for removal\n");
+			pci_dev_put(dev);
 			return -ENODEV;
 		}
 
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-char-agp-add-missing-pci_dev_get.patch
drivers-mtd-maps-nettelc-use-array_size.patch
net-tipc-bcasth-use-array_size.patch
drivers-isdn-misdn-use-array_size.patch
drivers-pci-hotplug-add-missing-pci_dev_get.patch
drivers-message-fusion-use-array_size.patch
fs-namespacec-drop-code-after-return.patch

