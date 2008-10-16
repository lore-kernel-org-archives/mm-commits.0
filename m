From: akpm@linux-foundation.org
Subject: + tpm-dont-export-static-functions.patch added to -mm tree
Date: Thu, 16 Oct 2008 15:59:41 -0700
Message-ID: <200810162259.m9GMxfop002314@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756896AbYJPXAf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 19:00:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au, jmorris@namei.org, srajiv@linux.vnet.ibm.com


The patch titled
     tpm: don't export static functions
has been added to the -mm tree.  Its filename is
     tpm-dont-export-static-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tpm: don't export static functions
From: Stephen Rothwell <sfr@canb.auug.org.au>

Today's linux-next build (powerpc_allyesconfig) failed like this:

drivers/char/tpm/tpm.c:1162: error: __ksymtab_tpm_dev_release causes a section type conflict

Caused by commit 253115b71fa06330bd58afbe01ccaf763a8a0cf1 ("The
tpm_dev_release function is only called for platform devices, not pnp")
which exported a static function.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/tpm/tpm.c~tpm-dont-export-static-functions drivers/char/tpm/tpm.c
--- a/drivers/char/tpm/tpm.c~tpm-dont-export-static-functions
+++ a/drivers/char/tpm/tpm.c
@@ -1157,7 +1157,7 @@ EXPORT_SYMBOL_GPL(tpm_dev_vendor_release
  * Once all references to platform device are down to 0,
  * release all allocated structures.
  */
-static void tpm_dev_release(struct device *dev)
+void tpm_dev_release(struct device *dev)
 {
 	struct tpm_chip *chip = dev_get_drvdata(dev);
 
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
revert-i7300_idle-driver-v155.patch
make-do_mounts_md-use-of-msleep-more-robust.patch
tpm-dont-export-static-functions.patch

