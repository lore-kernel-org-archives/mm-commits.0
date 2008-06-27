From: akpm@linux-foundation.org
Subject: + edac-mv64x60-fix-get_property.patch added to -mm tree
Date: Fri, 27 Jun 2008 16:09:20 -0700
Message-ID: <200806272309.m5RN9KDH010833@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49735 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932600AbYF0XQu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jun 2008 19:16:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djiang@mvista.com


The patch titled
     edac: mv64x60 fix get_property
has been added to the -mm tree.  Its filename is
     edac-mv64x60-fix-get_property.patch

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
Subject: edac: mv64x60 fix get_property
From: Dave Jiang <djiang@mvista.com>

Update get_property() call to use of_get_property() in order to fix compile

Signed-off-by: Dave Jiang <djiang@mvista.com>
Signed-off-by: Doug Thompson <dougthompson.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/mv64x60_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/edac/mv64x60_edac.c~edac-mv64x60-fix-get_property drivers/edac/mv64x60_edac.c
--- a/drivers/edac/mv64x60_edac.c~edac-mv64x60-fix-get_property
+++ a/drivers/edac/mv64x60_edac.c
@@ -612,7 +612,7 @@ static void get_total_mem(struct mv64x60
 	if (!np)
 		return;
 
-	reg = get_property(np, "reg", NULL);
+	reg = of_get_property(np, "reg", NULL);
 
 	pdata->total_mem = reg[1];
 }
_

Patches currently in -mm which might be from djiang@mvista.com are

edac-mv64x60-fix-get_property.patch
edac-mv64x60-add-pci-fixup.patch

