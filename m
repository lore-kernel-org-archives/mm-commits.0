From: akpm@linux-foundation.org
Subject: + scsi-arcmsr-update-changelog.patch added to -mm tree
Date: Fri, 14 Mar 2008 13:01:16 -0700
Message-ID: <200803142001.m2EK1Gsg016871@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41096 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754391AbYCNUL0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Mar 2008 16:11:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nick.cheng@areca.com.tw, James.Bottomley@HansenPartnership.com


The patch titled
     scsi: arcmsr: update changelog
has been added to the -mm tree.  Its filename is
     scsi-arcmsr-update-changelog.patch

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
Subject: scsi: arcmsr: update changelog
From: "nickcheng" <nick.cheng@areca.com.tw>

Add the description for the change of the arithmetic of iomem of the Type_B
Adapter in ChangeLog.arcmsr

Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/scsi/ChangeLog.arcmsr |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN Documentation/scsi/ChangeLog.arcmsr~scsi-arcmsr-update-changelog Documentation/scsi/ChangeLog.arcmsr
--- a/Documentation/scsi/ChangeLog.arcmsr~scsi-arcmsr-update-changelog
+++ a/Documentation/scsi/ChangeLog.arcmsr
@@ -115,4 +115,8 @@
 **						that the current GFP_KERNEL|GFP_DMA flags are wrong: firstly we are in
 **						atomic context, secondly this memory is not used for DMA.
 **						Also removed some unneeded casts. Thanks to Daniel Drake <dsd@gentoo.org>
+**						2.The Type B Adapter teardown does iounmap on pointers subtracted by a
+**						constant offset.  Since the offset is in bytes, we need the pointers to
+**						be of type void * not uint32_t * so the subtraction is done in the
+**						correct units and we iounmap the correct area.
 **************************************************************************
_

Patches currently in -mm which might be from nick.cheng@areca.com.tw are

arcmsr-modify-the-type-of-element-of-messageunit_b.patch
scsi-arcmsr-update-changelog.patch

