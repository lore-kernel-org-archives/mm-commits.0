From: akpm@linux-foundation.org
Subject: + drivers-platform-olpc-olpc-ecc-initialise-earlier.patch added
 to -mm tree
Date: Wed, 14 Aug 2013 15:15:58 -0700
Message-ID: <520c019e.lvm7gGdfl+ufIRM4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55866 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933153Ab3HNWP6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Aug 2013 18:15:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dilinger@queued.net, dsd@laptop.org

Subject: + drivers-platform-olpc-olpc-ecc-initialise-earlier.patch added to -mm tree
To: dsd@laptop.org,dilinger@queued.net
From: akpm@linux-foundation.org
Date: Wed, 14 Aug 2013 15:15:58 -0700


The patch titled
     Subject: drivers/platform/olpc/olpc-ec.c: initialise earlier
has been added to the -mm tree.  Its filename is
     drivers-platform-olpc-olpc-ecc-initialise-earlier.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-platform-olpc-olpc-ecc-initialise-earlier.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-platform-olpc-olpc-ecc-initialise-earlier.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Drake <dsd@laptop.org>
Subject: drivers/platform/olpc/olpc-ec.c: initialise earlier

Being a low-level component, various drivers (e.g.  olpc-battery) assume
that it is ok to communicate with the OLPC Embedded Controller during
probe.  Therefore the OLPC EC driver must be initialised before other
drivers try to use it.  This was the case until it was recently moved out
of arch/x86 and restructured.

Use arch_initcall so that olpc-ec is readied earlier, matching the
previous behaviour.  Fixes various drivers such as olpc-battery and
olpc-xo1-sci.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Cc: Andres Salomon <dilinger@queued.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/olpc/olpc-ec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/platform/olpc/olpc-ec.c~drivers-platform-olpc-olpc-ecc-initialise-earlier drivers/platform/olpc/olpc-ec.c
--- a/drivers/platform/olpc/olpc-ec.c~drivers-platform-olpc-olpc-ecc-initialise-earlier
+++ a/drivers/platform/olpc/olpc-ec.c
@@ -330,7 +330,7 @@ static int __init olpc_ec_init_module(vo
 	return platform_driver_register(&olpc_ec_plat_driver);
 }
 
-module_init(olpc_ec_init_module);
+arch_initcall(olpc_ec_init_module);
 
 MODULE_AUTHOR("Andres Salomon <dilinger@queued.net>");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from dsd@laptop.org are

drivers-platform-olpc-olpc-ecc-initialise-earlier.patch
linux-next.patch

