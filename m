From: akpm@linux-foundation.org
Subject: + ibft-fix-target-info-parsing-in-ibft-module.patch added to -mm tree
Date: Thu, 21 Aug 2008 13:34:13 -0700
Message-ID: <200808212034.m7LKYDNr024636@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753367AbYHUUe5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Aug 2008 16:34:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, gregkh@suse.de, konrad@virtualiron.com, pjones@redhat.com, shyam_iyer@dell.com


The patch titled
     ibft: fix target info parsing in ibft module
has been added to the -mm tree.  Its filename is
     ibft-fix-target-info-parsing-in-ibft-module.patch

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
Subject: ibft: fix target info parsing in ibft module
From: Mike Christie <michaelc@cs.wisc.edu>

I got this patch through Red Hat's bugzilla from the bug submitter and
patch creator.  I have just fixed it up so it applies without fuzz to
upstream kernels.

Original patch and description from Shyam kumar Iyer:

The issue [ibft module not displaying targets with short names] is because
of an offset calculatation error in the iscsi_ibft.c code.  Due to this
error directory structure for the target in /sys/firmware/ibft does not
get created and so the initiator is unable to connect to the target.

Note that this bug surfaced only with an name that had a short section at
the end.  eg: "iqn.1984-05.com.dell:dell".  It did not surface when the
iqn's had a longer section at the end.  eg:
"iqn.2001-04.com.example:storage.disk2.sys1.xyz"

So, the eot_offset was calculated such that an extra 48 bytes i.e.  the
size of the ibft_header which has already been accounted was subtracted
twice.

This was not evident with longer iqn names because they would overshoot
the total ibft length more than 48 bytes and thus would escape the bug.

Signed-off-by: Shyam Kumar Iyer <shyam_iyer@dell.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Cc: Konrad Rzeszutek <konrad@virtualiron.com>
Cc: Peter Jones <pjones@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/iscsi_ibft.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/firmware/iscsi_ibft.c~ibft-fix-target-info-parsing-in-ibft-module drivers/firmware/iscsi_ibft.c
--- a/drivers/firmware/iscsi_ibft.c~ibft-fix-target-info-parsing-in-ibft-module
+++ a/drivers/firmware/iscsi_ibft.c
@@ -669,8 +669,7 @@ static int __init ibft_register_kobjects
 
 	control = (void *)header + sizeof(*header);
 	end = (void *)control + control->hdr.length;
-	eot_offset = (void *)header + header->length -
-		     (void *)control - sizeof(*header);
+	eot_offset = (void *)header + header->length - (void *)control;
 	rc = ibft_verify_hdr("control", (struct ibft_hdr *)control, id_control,
 			     sizeof(*control));
 
_

Patches currently in -mm which might be from michaelc@cs.wisc.edu are

ibft-fix-target-info-parsing-in-ibft-module.patch

