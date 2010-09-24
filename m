From: akpm@linux-foundation.org
Subject: + drivers-char-agp-parisc-agpc-eliminate-memory-leak.patch added to -mm tree
Date: Fri, 24 Sep 2010 15:24:42 -0700
Message-ID: <201009242224.o8OMOgxL028872@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758314Ab0IXWZp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Sep 2010 18:25:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, deller@gmx.de, jejb@parisc-linux.org, kyle@mcmartin.ca


The patch titled
     drivers/char/agp/parisc-agp.c: eliminate memory leak
has been added to the -mm tree.  Its filename is
     drivers-char-agp-parisc-agpc-eliminate-memory-leak.patch

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
Subject: drivers/char/agp/parisc-agp.c: eliminate memory leak
From: Julia Lawall <julia@diku.dk>

alloc_pci_dev allocates some memory, so that memory should be freed before
leaving the function in an error case.

A simplified version of the semantic match that finds this problem is:
(http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
local idexpression x;
expression E;
identifier f1;
iterator I;
@@

x = alloc_pci_dev(...);
<... when != x
     when != true (x == NULL || ...)
     when != if (...) { <+...x...+> }
     when != I (...) { <+...x...+> }
(
 x == NULL
|
 x == E
|
 x->f1
)
...>
* return ...;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Dan Carpenter <error27@gmail.com>
Dave Airlie <airlied@linux.ie>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/parisc-agp.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/char/agp/parisc-agp.c~drivers-char-agp-parisc-agpc-eliminate-memory-leak drivers/char/agp/parisc-agp.c
--- a/drivers/char/agp/parisc-agp.c~drivers-char-agp-parisc-agpc-eliminate-memory-leak
+++ a/drivers/char/agp/parisc-agp.c
@@ -358,8 +358,12 @@ parisc_agp_setup(void __iomem *ioc_hpa, 
 	bridge->dev = fake_bridge_dev;
 
 	error = agp_add_bridge(bridge);
+	if (error)
+		goto fail;
+	return 0;
 
 fail:
+	kfree(fake_bridge_dev);
 	return error;
 }
 
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-char-agp-parisc-agpc-eliminate-memory-leak.patch
fs-btrfs-use-memdup_user.patch
fs-btrfs-use-err_cast.patch
arch-x86-kernel-cpu-cpufreq-fix-unsigned-return-type.patch
drivers-i2c-busses-i2c-pasemic-fix-unsigned-return-type.patch
drivers-video-matrox-matroxfb_mavenc-fix-unsigned-return-type.patch

