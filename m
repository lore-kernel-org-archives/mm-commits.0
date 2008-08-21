From: akpm@linux-foundation.org
Subject: + scsi-tmscsimc-fix-mangled-printk-output.patch added to -mm tree
Date: Thu, 21 Aug 2008 12:23:32 -0700
Message-ID: <200808211923.m7LJNW6K021726@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59190 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755836AbYHUTXm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Aug 2008 15:23:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nick@ukfsn.org, James.Bottomley@HansenPartnership.com, g.liakhovetski@gmx.de


The patch titled
     scsi: tmscsim.c: fix mangled printk output
has been added to the -mm tree.  Its filename is
     scsi-tmscsimc-fix-mangled-printk-output.patch

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
Subject: scsi: tmscsim.c: fix mangled printk output
From: Nick Warne <nick@ukfsn.org>

Signed-off-by: Nick Warne <nick@ukfsn.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/tmscsim.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/tmscsim.c~scsi-tmscsimc-fix-mangled-printk-output drivers/scsi/tmscsim.c
--- a/drivers/scsi/tmscsim.c~scsi-tmscsimc-fix-mangled-printk-output
+++ a/drivers/scsi/tmscsim.c
@@ -2573,8 +2573,8 @@ static struct pci_driver dc390_driver = 
 static int __init dc390_module_init(void)
 {
 	if (!disable_clustering)
-		printk(KERN_INFO "DC390: clustering now enabled by default. If you get problems load\n"
-		       "\twith \"disable_clustering=1\" and report to maintainers\n");
+		printk(KERN_INFO "DC390: clustering now enabled by default. If you get problems load\n");
+		printk(KERN_INFO "	with \"disable_clustering=1\" and report to maintainers\n");
 
 	if (tmscsim[0] == -1 || tmscsim[0] > 15) {
 		tmscsim[0] = 7;
_

Patches currently in -mm which might be from nick@ukfsn.org are

scsi-tmscsimc-fix-mangled-printk-output.patch

