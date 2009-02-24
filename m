From: akpm@linux-foundation.org
Subject: [merged] mpt-fix-enable-lsi-sas-to-use-msi-as-default.patch removed from -mm tree
Date: Tue, 24 Feb 2009 11:33:20 -0800
Message-ID: <200902241933.n1OJXKUV004518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44223 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754250AbZBXTeE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 14:34:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghai@kernel.org, James.Bottomley@HansenPartnership.com, kadesai@lsi.com, mm-commits@vger.kernel.org


The patch titled
     mpt: fix enable lsi sas to use msi as default
has been removed from the -mm tree.  Its filename was
     mpt-fix-enable-lsi-sas-to-use-msi-as-default.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mpt: fix enable lsi sas to use msi as default
From: Yinghai Lu <yinghai@kernel.org>

The third arg in module_param(,,) is perm instead of default value.  we
still need to assign default at first.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Kashyap Desai <kadesai@lsi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptbase.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/message/fusion/mptbase.c~mpt-fix-enable-lsi-sas-to-use-msi-as-default drivers/message/fusion/mptbase.c
--- a/drivers/message/fusion/mptbase.c~mpt-fix-enable-lsi-sas-to-use-msi-as-default
+++ a/drivers/message/fusion/mptbase.c
@@ -90,8 +90,8 @@ module_param(mpt_msi_enable_fc, int, 0);
 MODULE_PARM_DESC(mpt_msi_enable_fc, " Enable MSI Support for FC \
 		controllers (default=0)");
 
-static int mpt_msi_enable_sas;
-module_param(mpt_msi_enable_sas, int, 1);
+static int mpt_msi_enable_sas = 1;
+module_param(mpt_msi_enable_sas, int, 0);
 MODULE_PARM_DESC(mpt_msi_enable_sas, " Enable MSI Support for SAS \
 		controllers (default=1)");
 
_

Patches currently in -mm which might be from yinghai@kernel.org are

linux-next.patch

