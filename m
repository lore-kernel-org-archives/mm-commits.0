From: akpm@linux-foundation.org
Subject: - make-pnp_add_card_id-static.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:18:08 -0700
Message-ID: <200807262118.m6QLI8B9020063@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59820 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758065AbYGZVSu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:18:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, bjorn.helgaas@hp.com, rene.herman@gmail.com, mm-commits@vger.kernel.org


The patch titled
     make pnp_add_card_id() static
has been removed from the -mm tree.  Its filename was
     make-pnp_add_card_id-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: make pnp_add_card_id() static
From: Adrian Bunk <bunk@kernel.org>

pnp_add_card_id() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Rene Herman <rene.herman@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/base.h |    1 -
 drivers/pnp/card.c |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/pnp/base.h~make-pnp_add_card_id-static drivers/pnp/base.h
--- a/drivers/pnp/base.h~make-pnp_add_card_id-static
+++ a/drivers/pnp/base.h
@@ -19,7 +19,6 @@ struct pnp_id *pnp_add_id(struct pnp_dev
 int pnp_interface_attach_device(struct pnp_dev *dev);
 
 int pnp_add_card(struct pnp_card *card);
-struct pnp_id *pnp_add_card_id(struct pnp_card *card, char *id);
 void pnp_remove_card(struct pnp_card *card);
 int pnp_add_card_device(struct pnp_card *card, struct pnp_dev *dev);
 void pnp_remove_card_device(struct pnp_dev *dev);
diff -puN drivers/pnp/card.c~make-pnp_add_card_id-static drivers/pnp/card.c
--- a/drivers/pnp/card.c~make-pnp_add_card_id-static
+++ a/drivers/pnp/card.c
@@ -102,7 +102,7 @@ static int card_probe(struct pnp_card *c
  * @id: pointer to a pnp_id structure
  * @card: pointer to the desired card
  */
-struct pnp_id *pnp_add_card_id(struct pnp_card *card, char *id)
+static struct pnp_id *pnp_add_card_id(struct pnp_card *card, char *id)
 {
 	struct pnp_id *dev_id, *ptr;
 
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
if-0-ses_match_host.patch
git-xtensa.patch
include-linux-kernelh-userspace-header-cleanup.patch
make-mm-rmapc-anon_vma_cachep-static.patch
reiser4.patch

