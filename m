From: akpm@linux-foundation.org
Subject: + ips-driver-make-it-less-chatty.patch added to -mm tree
Date: Mon, 02 Aug 2010 15:06:21 -0700
Message-ID: <201008022206.o72M6L8b014052@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37327 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751143Ab0HBWQ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Aug 2010 18:16:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbarnes@virtuousgeek.org, mjg@redhat.com


The patch titled
     ips driver: make it less chatty
has been added to the -mm tree.  Its filename is
     ips-driver-make-it-less-chatty.patch

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
Subject: ips driver: make it less chatty
From: Jesse Barnes <jbarnes@virtuousgeek.org>

We don't need a dev_warn when we exceed a thermal or power limit as we'll
handle it appropriately by clamping down on the CPU, GPU or both as
needed.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/intel_ips.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/platform/x86/intel_ips.c~ips-driver-make-it-less-chatty drivers/platform/x86/intel_ips.c
--- a/drivers/platform/x86/intel_ips.c~ips-driver-make-it-less-chatty
+++ a/drivers/platform/x86/intel_ips.c
@@ -607,7 +607,7 @@ static bool mcp_exceeded(struct ips_driv
 	spin_unlock_irqrestore(&ips->turbo_status_lock, flags);
 
 	if (ret)
-		dev_warn(&ips->dev->dev,
+		dev_info(&ips->dev->dev,
 			 "MCP power or thermal limit exceeded\n");
 
 	return ret;
@@ -635,7 +635,7 @@ static bool cpu_exceeded(struct ips_driv
 	spin_unlock_irqrestore(&ips->turbo_status_lock, flags);
 
 	if (ret)
-		dev_warn(&ips->dev->dev,
+		dev_info(&ips->dev->dev,
 			 "CPU power or thermal limit exceeded\n");
 
 	return ret;
_

Patches currently in -mm which might be from jbarnes@virtuousgeek.org are

linux-next.patch
ips-driver-make-it-less-chatty.patch
pci-add-pci-dma-unamp-state-api-to-feature-removal-scheduletxt.patch

