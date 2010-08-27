From: akpm@linux-foundation.org
Subject: + mmc-atmel-mcic-use-resource-size.patch added to -mm tree
Date: Fri, 27 Aug 2010 12:30:04 -0700
Message-ID: <201008271930.o7RJU4v4011402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60818 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753474Ab0H0TaH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Aug 2010 15:30:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hsweeten@visionengravers.com, cjb@laptop.org, linux-mmc@vger.kernel.org


The patch titled
     mmc: atmel-mci.c: use resource size()
has been added to the -mm tree.  Its filename is
     mmc-atmel-mcic-use-resource-size.patch

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
Subject: mmc: atmel-mci.c: use resource size()
From: H Hartley Sweeten <hsweeten@visionengravers.com>

Use resource_size().

[cjb: rebased patch against Linus]
Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/atmel-mci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/host/atmel-mci.c~mmc-atmel-mcic-use-resource-size drivers/mmc/host/atmel-mci.c
--- a/drivers/mmc/host/atmel-mci.c~mmc-atmel-mcic-use-resource-size
+++ a/drivers/mmc/host/atmel-mci.c
@@ -1777,7 +1777,7 @@ static int __init atmci_probe(struct pla
 	}
 
 	ret = -ENOMEM;
-	host->regs = ioremap(regs->start, regs->end - regs->start + 1);
+	host->regs = ioremap(regs->start, resource_size(regs));
 	if (!host->regs)
 		goto err_ioremap;
 
_

Patches currently in -mm which might be from hsweeten@visionengravers.com are

kernelh-add-minmax3-macros.patch
replace-nested-max-min-macros-with-maxmin3-macro.patch
mmc-at91_mcic-use-resource_size.patch
mmc-atmel-mcic-use-resource-size.patch
mmc-au1xmmcc-use-resource_size.patch

