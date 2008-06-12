From: akpm@linux-foundation.org
Subject: + pm-remove-definition-of-struct-pm_dev.patch added to -mm tree
Date: Thu, 12 Jun 2008 01:47:44 -0700
Message-ID: <200806120847.m5C8liiI010632@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35003 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754541AbYFLIrs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 04:47:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl


The patch titled
     pm: remove definition of struct pm_dev
has been added to the -mm tree.  Its filename is
     pm-remove-definition-of-struct-pm_dev.patch

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
Subject: pm: remove definition of struct pm_dev
From: Rafael J. Wysocki <rjw@sisk.pl>

Remove the definition of 'struct pm_dev', which is not used any more,
along with some related stuff from include/linux/pm.h .

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pm.h |   24 ------------------------
 1 file changed, 24 deletions(-)

diff -puN include/linux/pm.h~pm-remove-definition-of-struct-pm_dev include/linux/pm.h
--- a/include/linux/pm.h~pm-remove-definition-of-struct-pm_dev
+++ a/include/linux/pm.h
@@ -68,30 +68,6 @@ enum
  */
 #define PM_PCI_ID(dev) ((dev)->bus->number << 16 | (dev)->devfn)
 
-/*
- * Request handler callback
- */
-struct pm_dev;
-
-typedef int (*pm_callback)(struct pm_dev *dev, pm_request_t rqst, void *data);
-
-/*
- * Dynamic device information
- */
-struct pm_dev
-{
-	pm_dev_t	 type;
-	unsigned long	 id;
-	pm_callback	 callback;
-	void		*data;
-
-	unsigned long	 flags;
-	unsigned long	 state;
-	unsigned long	 prev_state;
-
-	struct list_head entry;
-};
