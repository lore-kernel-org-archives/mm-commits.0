From: akpm@linux-foundation.org
Subject: - pnp-whitespace-coding-style-fixes.patch removed from -mm tree
Date: Mon, 23 Jun 2008 14:03:17 -0700
Message-ID: <200806232103.m5NL3HAC016148@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758022AbYFWVD4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 17:03:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, abelay@mit.edu, castet.matthieu@free.fr, lenb@kernel.org, perex@perex.cz, rene.herman@gmail.com, shaohua.li@intel.com, tiwai@suse.de, trenn@suse.de, mm-commits@v


The patch titled
     pnp: whitespace/coding style fixes
has been removed from the -mm tree.  Its filename was
     pnp-whitespace-coding-style-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnp: whitespace/coding style fixes
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

No functional change; just make a couple declarations consistent with the
rest of the file.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-by: Rene Herman <rene.herman@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/interface.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN drivers/pnp/interface.c~pnp-whitespace-coding-style-fixes drivers/pnp/interface.c
--- a/drivers/pnp/interface.c~pnp-whitespace-coding-style-fixes
+++ a/drivers/pnp/interface.c
@@ -216,12 +216,12 @@ static ssize_t pnp_show_options(struct d
 				struct device_attribute *attr, char *buf)
 {
 	struct pnp_dev *dev = to_pnp_dev(dmdev);
+	pnp_info_buffer_t *buffer;
 	struct pnp_option *independent = dev->independent;
 	struct pnp_option *dependent = dev->dependent;
 	int ret, dep = 1;
 
-	pnp_info_buffer_t *buffer = (pnp_info_buffer_t *)
-	    pnp_alloc(sizeof(pnp_info_buffer_t));
+	buffer = pnp_alloc(sizeof(pnp_info_buffer_t));
 	if (!buffer)
 		return -ENOMEM;
 
@@ -248,17 +248,18 @@ static ssize_t pnp_show_current_resource
 					  char *buf)
 {
 	struct pnp_dev *dev = to_pnp_dev(dmdev);
+	pnp_info_buffer_t *buffer;
 	struct pnp_resource *pnp_res;
 	struct resource *res;
 	int ret;
-	pnp_info_buffer_t *buffer;
 
 	if (!dev)
 		return -EINVAL;
 
-	buffer = (pnp_info_buffer_t *) pnp_alloc(sizeof(pnp_info_buffer_t));
+	buffer = pnp_alloc(sizeof(pnp_info_buffer_t));
 	if (!buffer)
 		return -ENOMEM;
+
 	buffer->len = PAGE_SIZE;
 	buffer->buffer = buf;
 	buffer->curr = buffer->buffer;
@@ -295,9 +296,9 @@ static ssize_t pnp_show_current_resource
 	return ret;
 }
 
-static ssize_t
-pnp_set_current_resources(struct device *dmdev, struct device_attribute *attr,
-			  const char *ubuf, size_t count)
+static ssize_t pnp_set_current_resources(struct device *dmdev,
+					 struct device_attribute *attr,
+					 const char *ubuf, size_t count)
 {
 	struct pnp_dev *dev = to_pnp_dev(dmdev);
 	char *buf = (void *)ubuf;
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

linux-next.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch
isa-set-24-bit-dma_mask-for-isa-devices.patch
make-pnp_add_card_id-static.patch

