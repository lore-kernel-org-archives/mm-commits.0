From: akpm@linux-foundation.org
Subject: + pnpacpi-remove-unnecessary-casts-of-void.patch added to -mm tree
Date: Fri, 17 Aug 2007 11:39:14 -0700
Message-ID: <200708171839.l7HIdEtf023930@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56013 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752460AbXHQSkh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 14:40:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, ambx1@neo.rr.com, lenb@kernel.org, perex@suse.cz


The patch titled
     PNPACPI: remove unnecessary casts of "void *"
has been added to the -mm tree.  Its filename is
     pnpacpi-remove-unnecessary-casts-of-void.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
move-free-pages-between-lists-on-steal.patch
convert-ill-defined-log2-to-ilog2.patch
tpm_tis-fix-interrupt-probing.patch
pnp-fix-up-after-lindent.patch
pnpacpi-simplify-irq_flags.patch
pnpacpi-remove-unnecessary-casts-of-void.patch
isapnp-removed-unused-isapnp_detected-and-isapnp_debug.patch
pnp-remove-module-infrastructure.patch
pnp-remove-null-pointer-checks.patch
