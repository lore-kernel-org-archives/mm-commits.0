From: akpm@linux-foundation.org
Subject: + mpt-fusion-dont-oops-if-numphys==0.patch added to -mm tree
Date: Tue, 19 Feb 2008 15:34:13 -0800
Message-ID: <200802192335.m1JNZ7MV005426@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44235 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752483AbYBSXgH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Feb 2008 18:36:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olel@ans.pl, Eric.Moore@lsi.com, James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp, ole@ans.pl, sathya.prakash@lsi.com


The patch titled
     mpt fusion: don't oops if NumPhys==0
has been added to the -mm tree.  Its filename is
     mpt-fusion-dont-oops-if-numphys==0.patch

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
Subject: mpt fusion: don't oops if NumPhys==0
From: Krzysztof Oledzki <olel@ans.pl>

Don't oops if NumPhys==0, instead return -ENODEV.
This patch fixes http://bugzilla.kernel.org/show_bug.cgi?id=9909

Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Eric Moore <Eric.Moore@lsi.com>
Cc: Sathya Prakash <sathya.prakash@lsi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptsas.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/message/fusion/mptsas.c~mpt-fusion-dont-oops-if-numphys==0 drivers/message/fusion/mptsas.c
--- a/drivers/message/fusion/mptsas.c~mpt-fusion-dont-oops-if-numphys==0
+++ a/drivers/message/fusion/mptsas.c
@@ -1701,6 +1701,11 @@ mptsas_sas_expander_pg0(MPT_ADAPTER *ioc
 	if (error)
 		goto out_free_consistent;
 
+	if (!buffer->NumPhys) {
+		error = -ENODEV;
+		goto out_free_consistent;
+	}
+
 	/* save config data */
 	port_info->num_phys = buffer->NumPhys;
 	port_info->phy_info = kcalloc(port_info->num_phys,
_

Patches currently in -mm which might be from olel@ans.pl are

mpt-fusion-dont-oops-if-numphys==0.patch
