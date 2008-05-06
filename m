From: akpm@linux-foundation.org
Subject: + pnp-add-pnp_build_option-to-the-api.patch added to -mm tree
Date: Tue, 06 May 2008 12:08:34 -0700
Message-ID: <200805061908.m46J8YaA022508@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41472 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755023AbYEFTIv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 15:08:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rene.herman@keyaccess.nl, bjorn.helgaas@hp.com, len.brown@intel.com, rene.herman@gmail.com, tiwai@suse.de, uwe.bugla@gmx.de


The patch titled
     : add pnp_build_option() to the API
has been added to the -mm tree.  Its filename is
     pnp-add-pnp_build_option-to-the-api.patch

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
Subject: : add pnp_build_option() to the API
From: Rene Herman <rene.herman@keyaccess.nl>

The subsequent AD181x quirk patch would like this as part of the API. 
pnp_register_dependent_option() adds to the same dependent chain the quirk is
walking which is fairly unclean.  This enables a private option chain build
which it can then just add onto the end when done.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Uwe Bugla <uwe.bugla@gmx.de>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/base.h     |    1 +
 drivers/pnp/resource.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/pnp/base.h~pnp-add-pnp_build_option-to-the-api drivers/pnp/base.h
--- a/drivers/pnp/base.h~pnp-add-pnp_build_option-to-the-api
+++ a/drivers/pnp/base.h
@@ -19,6 +19,7 @@ void pnp_remove_card(struct pnp_card *ca
 int pnp_add_card_device(struct pnp_card *card, struct pnp_dev *dev);
 void pnp_remove_card_device(struct pnp_dev *dev);
 
+struct pnp_option *pnp_build_option(int priority);
 struct pnp_option *pnp_register_independent_option(struct pnp_dev *dev);
 struct pnp_option *pnp_register_dependent_option(struct pnp_dev *dev,
 						 int priority);
diff -puN drivers/pnp/resource.c~pnp-add-pnp_build_option-to-the-api drivers/pnp/resource.c
--- a/drivers/pnp/resource.c~pnp-add-pnp_build_option-to-the-api
+++ a/drivers/pnp/resource.c
@@ -28,7 +28,7 @@ static int pnp_reserve_mem[16] = {[0 ...
  * option registration
  */
 
-static struct pnp_option *pnp_build_option(int priority)
+struct pnp_option *pnp_build_option(int priority)
 {
 	struct pnp_option *option = pnp_alloc(sizeof(struct pnp_option));
 
_

Patches currently in -mm which might be from rene.herman@keyaccess.nl are

pnp-add-pnp_build_option-to-the-api.patch
pnp-add-ad1815-and-ad1816-quirks.patch
pnp-add-detail-to-debug-resource-dump.patch
pnp-remove-pnp_resourceindex.patch
pnp-add-pnp_resource_type-internal-interface.patch
pnp-add-pnp_resource_type_name-helper-function.patch
pnp-replace-pnp_resource_table-with-dynamically-allocated-resources.patch
pnp-remove-ratelimit-on-add-resource-failures.patch
pnp-dont-sort-by-type-in-sys-resources.patch

