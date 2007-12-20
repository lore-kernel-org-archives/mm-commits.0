From: akpm@linux-foundation.org
Subject: - drivers-macintosh-via-pmuc-added-a-missing-iounmap.patch removed from -mm tree
Date: Thu, 20 Dec 2007 15:36:17 -0800
Message-ID: <200712202336.lBKNaHTu018795@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50785 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753976AbXLTXhO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 18:37:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, benh@kernel.crashing.org, johannes@sipsolutions.net, olaf@aepfle.de, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     drivers/macintosh/via-pmu.c: Added a missing iounmap
has been removed from the -mm tree.  Its filename was
     drivers-macintosh-via-pmuc-added-a-missing-iounmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/macintosh/via-pmu.c: Added a missing iounmap
From: Julia Lawall <julia@diku.dk>

The error handling code should undo the ioremap as well.

The problem was detected using the following semantic match
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T,T1,T2;
identifier E;
statement S;
expression x1,x2;
constant C;
int ret;
@@

  T E;
  ...
* E = ioremap(...);
  if (E == NULL) S
  ... when != iounmap(E)
      when != if (E != NULL) { ... iounmap(E); ...}
      when != x1 = (T1)E
  if (...) {
    ... when != iounmap(E)
        when != if (E != NULL) { ... iounmap(E); ...}
        when != x2 = (T2)E
(
*   return;
|
*   return C;
|
*   return ret;
)
  }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Olaf Hering <olaf@aepfle.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/macintosh/via-pmu.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/macintosh/via-pmu.c~drivers-macintosh-via-pmuc-added-a-missing-iounmap drivers/macintosh/via-pmu.c
--- a/drivers/macintosh/via-pmu.c~drivers-macintosh-via-pmuc-added-a-missing-iounmap
+++ a/drivers/macintosh/via-pmu.c
@@ -2336,6 +2336,7 @@ powerbook_sleep_3400(void)
 	ret = pmac_suspend_devices();
 	if (ret) {
 		pbook_free_pci_save();
+		iounmap(mem_ctrl);
 		printk(KERN_ERR "Sleep rejected by devices\n");
 		return ret;
 	}
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
git-alsa.patch
git-agpgart.patch
git-powerpc.patch
git-input.patch
arch-cris-added-a-missing-iounmap.patch
drivers-video-remove-unnecessary-pci_dev_put.patch
