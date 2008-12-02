From: akpm@linux-foundation.org
Subject: - drivers-pci-hotplug-add-missing-pci_dev_get.patch removed from -mm tree
Date: Tue, 02 Dec 2008 10:39:18 -0800
Message-ID: <200812021839.mB2IdIih007455@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754158AbYLBSjX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 13:39:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     drivers/pci/hotplug: Add missing pci_dev_get
has been removed from the -mm tree.  Its filename was
     drivers-pci-hotplug-add-missing-pci_dev_get.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
arch-arm-eliminate-null-test-and-memset-after-alloc_bootmem.patch
arch-avr32-eliminate-null-test-and-memset-after-alloc_bootmem.patch
arch-powerpc-eliminate-null-test-and-memset-after-alloc_bootmem.patch
arch-ia64-eliminate-null-test-and-memset-after-alloc_bootmem.patch
drivers-mtd-maps-nettelc-use-array_size.patch
net-tipc-bcasth-use-array_size.patch
drivers-isdn-misdn-use-array_size.patch
fs-namespacec-drop-code-after-return.patch
mm-page_allocc-eliminate-null-test-and-memset-after-alloc_bootmem.patch

