From: akpm@linux-foundation.org
Subject: - pnpacpi-remove-unnecessary-casts-of-void.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:58:59 -0700
Message-ID: <200708242058.l7OKwx94014350@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47100 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763877AbXHXVJK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:09:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, ambx1@neo.rr.com, lenb@kernel.org, perex@suse.cz, mm-commits@vger.kernel.org


The patch titled
     PNPACPI: remove unnecessary casts of "void *"
has been removed from the -mm tree.  Its filename was
     pnpacpi-remove-unnecessary-casts-of-void.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PNPACPI: remove unnecessary casts of "void *"
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Remove unnecessary casts of void pointers.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/pnpacpi/rsparser.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff -puN drivers/pnp/pnpacpi/rsparser.c~pnpacpi-remove-unnecessary-casts-of-void drivers/pnp/pnpacpi/rsparser.c
--- a/drivers/pnp/pnpacpi/rsparser.c~pnpacpi-remove-unnecessary-casts-of-void
+++ a/drivers/pnp/pnpacpi/rsparser.c
@@ -240,8 +240,7 @@ static void pnpacpi_parse_allocated_addr
 static acpi_status pnpacpi_allocated_resource(struct acpi_resource *res,
 					      void *data)
 {
-	struct pnp_resource_table *res_table =
-	    (struct pnp_resource_table *)data;
+	struct pnp_resource_table *res_table = data;
 	int i;
 
 	switch (res->type) {
@@ -564,8 +563,7 @@ static acpi_status pnpacpi_option_resour
 					   void *data)
 {
 	int priority = 0;
-	struct acpipnp_parse_option_s *parse_data =
-	    (struct acpipnp_parse_option_s *)data;
+	struct acpipnp_parse_option_s *parse_data = data;
 	struct pnp_dev *dev = parse_data->dev;
 	struct pnp_option *option = parse_data->option;
 
@@ -703,7 +701,7 @@ static int pnpacpi_supported_resource(st
 static acpi_status pnpacpi_count_resources(struct acpi_resource *res,
 					   void *data)
 {
-	int *res_cnt = (int *)data;
+	int *res_cnt = data;
 
 	if (pnpacpi_supported_resource(res))
 		(*res_cnt)++;
@@ -712,7 +710,7 @@ static acpi_status pnpacpi_count_resourc
 
 static acpi_status pnpacpi_type_resources(struct acpi_resource *res, void *data)
 {
-	struct acpi_resource **resource = (struct acpi_resource **)data;
+	struct acpi_resource **resource = data;
 
 	if (pnpacpi_supported_resource(res)) {
 		(*resource)->type = res->type;
@@ -884,8 +882,7 @@ int pnpacpi_encode_resources(struct pnp_
 	int i = 0;
 	/* pnpacpi_build_resource_template allocates extra mem */
 	int res_cnt = (buffer->length - 1) / sizeof(struct acpi_resource) - 1;
-	struct acpi_resource *resource =
-	    (struct acpi_resource *)buffer->pointer;
+	struct acpi_resource *resource = buffer->pointer;
 	int port = 0, irq = 0, dma = 0, mem = 0;
 
 	pnp_dbg("res cnt %d", res_cnt);
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
git-acpi.patch
serial-keep-the-dtr-setting-for-serial-console.patch
move-free-pages-between-lists-on-steal.patch
convert-ill-defined-log2-to-ilog2.patch
tpm_tis-fix-interrupt-probing.patch
pnp-make-pnpacpi_suspend-handle-errors.patch
