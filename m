From: akpm@linux-foundation.org
Subject: + edac-use-to_delayed_work.patch added to -mm tree
Date: Thu, 09 Apr 2009 12:01:06 -0700
Message-ID: <200904091901.n39J16LJ004815@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759732AbZDITCv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 15:02:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, dougthompson@xmission.com


The patch titled
     edac: use to_delayed_work()
has been added to the -mm tree.  Its filename is
     edac-use-to_delayed_work.patch

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
Subject: edac: use to_delayed_work()
From: Jean Delvare <khali@linux-fr.org>

The edac-core driver includes code which assumes that the work_struct
which is included in every delayed_work is the first member of that
structure.  This is currently the case but might change in the future, so
use to_delayed_work() instead, which doesn't make such an assumption.

linux-2.6.30-rc1 has the to_delayed_work() function that will allow this
patch to work

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_device.c |    2 +-
 drivers/edac/edac_mc.c     |    2 +-
 drivers/edac/edac_pci.c    |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/edac/edac_device.c~edac-use-to_delayed_work drivers/edac/edac_device.c
--- a/drivers/edac/edac_device.c~edac-use-to_delayed_work
+++ a/drivers/edac/edac_device.c
@@ -389,7 +389,7 @@ static void del_edac_device_from_global_
  */
 static void edac_device_workq_function(struct work_struct *work_req)
 {
-	struct delayed_work *d_work = (struct delayed_work *)work_req;
+	struct delayed_work *d_work = to_delayed_work(work_req);
 	struct edac_device_ctl_info *edac_dev = to_edac_device_ctl_work(d_work);
 
 	mutex_lock(&device_ctls_mutex);
diff -puN drivers/edac/edac_mc.c~edac-use-to_delayed_work drivers/edac/edac_mc.c
--- a/drivers/edac/edac_mc.c~edac-use-to_delayed_work
+++ a/drivers/edac/edac_mc.c
@@ -260,7 +260,7 @@ static int edac_mc_assert_error_check_an
  */
 static void edac_mc_workq_function(struct work_struct *work_req)
 {
-	struct delayed_work *d_work = (struct delayed_work *)work_req;
+	struct delayed_work *d_work = to_delayed_work(work_req);
 	struct mem_ctl_info *mci = to_edac_mem_ctl_work(d_work);
 
 	mutex_lock(&mem_ctls_mutex);
diff -puN drivers/edac/edac_pci.c~edac-use-to_delayed_work drivers/edac/edac_pci.c
--- a/drivers/edac/edac_pci.c~edac-use-to_delayed_work
+++ a/drivers/edac/edac_pci.c
@@ -233,7 +233,7 @@ EXPORT_SYMBOL_GPL(edac_pci_find);
  */
 static void edac_pci_workq_function(struct work_struct *work_req)
 {
-	struct delayed_work *d_work = (struct delayed_work *)work_req;
+	struct delayed_work *d_work = to_delayed_work(work_req);
 	struct edac_pci_ctl_info *pci = to_edac_pci_ctl_work(d_work);
 	int msec;
 	unsigned long delay;
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
linux-next.patch
dell-laptop-fix-uninitialized-wrong-return-value.patch
edac-use-to_delayed_work.patch

