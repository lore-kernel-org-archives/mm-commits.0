From: akpm@linux-foundation.org
Subject: + i82875p_edac-fix-module-remove.patch added to -mm tree
Date: Fri, 28 Nov 2008 23:56:55 -0800
Message-ID: <200811290756.mAT7utjD003208@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33049 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901AbYK2H5N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 29 Nov 2008 02:57:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlavi@iki.fi, alan@lxorguk.ukuu.org.uk, norsk5@yahoo.com


The patch titled
     i82875p_edac: fix module remove
has been added to the -mm tree.  Its filename is
     i82875p_edac-fix-module-remove.patch

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
Subject: i82875p_edac: fix module remove
From: Jarkko Lavinen <jlavi@iki.fi>

Fix module removal bugs of i82875p_edac.  Also i82975x_edac code seems to
have the same module removal bugs as in i82875p_edac.

The problems were:

1. In module removal i82875p_remove_one() is never called.

   Variable i82875p_registered is newer changed from 1, which
   guarantees i82875p_remove_one() is not called (and even if it were
   called, it would be called in wrong order).

   As a result, the edac_mc workque is not stopped and keeps probing.
   If kernel debugging options are not enabled, user may not notice
   anything going wrong.

   if debugging options are enabled and I do "rmmod i82875p_edac", I
   get:

      edac debug: edac_pci_workq_function() checking
      BUG: unable to handle kernel paging request at f882d16f
      ...
      call trace:
       [<f8834df3>] ? edac_mc_workq_function+0x55/0x7e [edac_core]
       [<c0233974>] ? run_workqueue+0xd7/0x1a5
       [<c023392f>] ? run_workqueue+0x92/0x1a5
       [<f8834d9e>] ? edac_mc_workq_function+0x0/0x7e [edac_core]
       [<c0233af9>] ? worker_thread+0xb7/0xc3
       [<c0236a7b>] ? autoremove_wake_function+0x0/0x33
       [<c0233a42>] ? worker_thread+0x0/0xc3
       [<c0236809>] ? kthread+0x3b/0x61
       [<c02367ce>] ? kthread+0x0/0x61
       [<c0204587>] ? kernel_thread_helper+0x7/0x10


   Fix for this is to get rid of needles variable i82875p_registered
   altogether and run i82875p_remove_one() *before*
   pci_unregister_driver().

2. edac_mc_del_mc() uses mci after freeing mci

   edac_mc_del_mc() calls calls edac_remove_sysfs_mci_device().  The
   kobject refcount of mci drops to 0 and mci is freed.  After this
   mci is accessed via debug print and i82875p_remove_one() still
   uses mci->pvt and tries to free mci again with edac_mc_free().

   The fix for this is add kobject_get(&mci->edac_mci_kobj) after
   edac_mc_alloc(). Then the mci is still available after returning
   from edac_mc_del_mc() with refcount 1, and mci->pvt is still
   available. When i82875p_remove_one() finally calls edac_mc_free(),
   this will cause kobject_put() and mci is released properly.

Signed-off-by: Jarkko Lavinen <jlavi@iki.fi>
Cc: Doug Thompson <norsk5@yahoo.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i82875p_edac.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN drivers/edac/i82875p_edac.c~i82875p_edac-fix-module-remove drivers/edac/i82875p_edac.c
--- a/drivers/edac/i82875p_edac.c~i82875p_edac-fix-module-remove
+++ a/drivers/edac/i82875p_edac.c
@@ -182,8 +182,6 @@ static struct pci_dev *mci_pdev;	/* init
 					 * already registered driver
 					 */
 
-static int i82875p_registered = 1;
-
 static struct edac_pci_ctl_info *i82875p_pci;
 
 static void i82875p_get_error_info(struct mem_ctl_info *mci,
@@ -410,6 +408,9 @@ static int i82875p_probe1(struct pci_dev
 		goto fail0;
 	}
 
+	/* Keeps mci available after edac_mc_del_mc() till edac_mc_free() */
+	kobject_get(&mci->edac_mci_kobj);
+
 	debugf3("%s(): init mci\n", __func__);
 	mci->dev = &pdev->dev;
 	mci->mtype_cap = MEM_FLAG_DDR;
@@ -452,6 +453,7 @@ static int i82875p_probe1(struct pci_dev
 	return 0;
 
 fail1:
+	kobject_put(&mci->edac_mci_kobj);
 	edac_mc_free(mci);
 
 fail0:
@@ -579,12 +581,11 @@ static void __exit i82875p_exit(void)
 {
 	debugf3("%s()\n", __func__);
 
+	i82875p_remove_one(mci_pdev);
+	pci_dev_put(mci_pdev);
+
 	pci_unregister_driver(&i82875p_driver);
 
-	if (!i82875p_registered) {
-		i82875p_remove_one(mci_pdev);
-		pci_dev_put(mci_pdev);
-	}
 }
 
 module_init(i82875p_init);
_

Patches currently in -mm which might be from jlavi@iki.fi are

i82875p_edac-fix-overflow-device-resource-setup.patch
i82875p_edac-fix-module-remove.patch

