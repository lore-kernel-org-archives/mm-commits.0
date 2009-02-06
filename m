From: akpm@linux-foundation.org
Subject: + mpt-fix-enable-lsi-sas-to-use-msi-as-default.patch added to -mm tree
Date: Fri, 06 Feb 2009 13:45:03 -0800
Message-ID: <200902062145.n16Lj3Pg021606@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42385 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754380AbZBFVpP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Feb 2009 16:45:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghai@kernel.org, James.Bottomley@HansenPartnership.com, kadesai@lsi.com


The patch titled
     mpt: fix enable lsi sas to use msi as default
has been added to the -mm tree.  Its filename is
     mpt-fix-enable-lsi-sas-to-use-msi-as-default.patch

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

origin.patch
linux-next.patch
fix-sparseirq-use-kstat_irqs_cpu-on-non-x86-architectures-too.patch
mpt-fix-enable-lsi-sas-to-use-msi-as-default.patch

