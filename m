From: akpm@linux-foundation.org
Subject: - pnp-add-pnp_build_option-to-the-api.patch removed from -mm tree
Date: Fri, 16 May 2008 15:52:39 -0700
Message-ID: <200805162252.m4GMqd7b003061@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39908 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756712AbYEPWw5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 May 2008 18:52:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rene.herman@keyaccess.nl, bjorn.helgaas@hp.com, len.brown@intel.com, rene.herman@gmail.com, tiwai@suse.de, uwe.bugla@gmx.de, mm-commits@vger.kernel.org


The patch titled
     pnp: add pnp_build_option() to the API
has been removed from the -mm tree.  Its filename was
     pnp-add-pnp_build_option-to-the-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnp: add pnp_build_option() to the API
From: Rene Herman <rene.herman@keyaccess.nl>

The subsequent AD181x quirk patch would like this as part of the API. 
pnp_register_dependent_option() adds to the same dependent chain the quirk is
walking which is fairly unclean.  This enables a private option chain build
which it can then just add onto the end when done.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
Tested-by: Uwe Bugla <uwe.bugla@gmx.de>
Acked-by: Uwe Bugla <uwe.bugla@gmx.de>
Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Len Brown <len.brown@intel.com
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

origin.patch
pnp-add-detail-to-debug-resource-dump.patch
pnp-remove-pnp_resourceindex.patch
pnp-add-pnp_resource_type-internal-interface.patch
pnp-add-pnp_resource_type_name-helper-function.patch
pnp-make-pnp_portmemetc_start-et-al-work-for-invalid-resources.patch
pnp-replace-pnp_resource_table-with-dynamically-allocated-resources.patch
pnp-remove-ratelimit-on-add-resource-failures.patch
pnp-dont-sort-by-type-in-sys-resources.patch

