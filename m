From: akpm@linux-foundation.org
Subject: - mpt-fusion-dont-oops-if-numphys==0.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:22:41 -0800
Message-ID: <200803062222.m26MMf2t020827@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764080AbYCFWXf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:23:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olel@ans.pl, Eric.Moore@lsi.com, James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp, ole@ans.pl, sathya.prakash@lsi.com, mm-commits@vger.kernel.org


The patch titled
     mpt fusion: don't oops if NumPhys==0
has been removed from the -mm tree.  Its filename was
     mpt-fusion-dont-oops-if-numphys==0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

