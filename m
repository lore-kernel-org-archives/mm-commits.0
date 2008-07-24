From: akpm@linux-foundation.org
Subject: - pm-remove-definition-of-struct-pm_dev.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:25:17 -0700
Message-ID: <200807242325.m6ONPHWp010865@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755548AbYGXXZX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:25:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, pavel@suse.cz, mm-commits@vger.kernel.org


The patch titled
     pm: remove definition of struct pm_dev
has been removed from the -mm tree.  Its filename was
     pm-remove-definition-of-struct-pm_dev.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm: remove definition of struct pm_dev
From: Rafael J. Wysocki <rjw@sisk.pl>

Remove the definition of 'struct pm_dev', which is not used any more,
along with some related stuff from include/linux/pm.h .

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@suse.cz>
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
