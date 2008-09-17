From: akpm@linux-foundation.org
Subject: + drivers-net-hp-plusc-fix-build-error.patch added to -mm tree
Date: Wed, 17 Sep 2008 14:28:23 -0700
Message-ID: <200809172128.m8HLSNoE031290@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752513AbYIQV3M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Sep 2008 17:29:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, jeff@garzik.org


The patch titled
     drivers/net/hp-plus.c: fix build error
has been added to the -mm tree.  Its filename is
     drivers-net-hp-plusc-fix-build-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/hp-plus.c: fix build error
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix hp-plus build error (yet again; will it ever end?):

hp-plus.c:(.init.text+0xa2cd): undefined reference to `NS8390p_init'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/hp-plus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/hp-plus.c~drivers-net-hp-plusc-fix-build-error drivers/net/hp-plus.c
--- a/drivers/net/hp-plus.c~drivers-net-hp-plusc-fix-build-error
+++ a/drivers/net/hp-plus.c
@@ -262,7 +262,7 @@ static int __init hpp_probe1(struct net_
 	}
 
 	outw(Perf_Page, ioaddr + HP_PAGING);
-	NS8390p_init(dev, 0);
+	NS8390_init(dev, 0);
 	/* Leave the 8390 and HP chip reset. */
 	outw(inw(ioaddr + HPP_OPTION) & ~EnableIRQ, ioaddr + HPP_OPTION);
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

kernel-doc-allow-structs-whose-members-are-all-private.patch
linux-next.patch
mfd-ucb1400-sound-driver-uses-depends-on-ac97_bus.patch
fb-metronome-printk-format-warning.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
drivers-net-hp-plusc-fix-build-error.patch
dontdiff-more-updates-to-be-closer-to-gitignore.patch
w1-documentation-w1-masters-ds2490-update.patch
profile-likely-unlikely-macros.patch

