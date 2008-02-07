From: akpm@linux-foundation.org
Subject: - declare-pnp-option-parsing-functions-as-__init.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:30:17 -0800
Message-ID: <200802070029.m170TwXN007340@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33289 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935056AbYBGAoi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: trenn@suse.de, bjorn.helgaas@hp.com, rene.herman@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pnp: declare PNP option parsing functions as __init
has been removed from the -mm tree.  Its filename was
     declare-pnp-option-parsing-functions-as-__init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnp: declare PNP option parsing functions as __init
From: Thomas Renninger <trenn@suse.de>

There are three kind of parse functions provided by PNP acpi/bios:
 - get current resources
 - set resources
 - get possible resources
The first two may be needed later at runtime.
The possible resource settings should never change dynamically.
And even if this would make any sense (I doubt it), the current implementation
only parses possible resource settings at early init time:
  -> declare all the option parsing __init

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Thomas Renninger <trenn@suse.de>
Acked-By: Rene Herman <rene.herman@gmail.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/pnpacpi/rsparser.c |   44 +++++++++++++++----------------
 drivers/pnp/pnpbios/core.c     |    2 -
 drivers/pnp/pnpbios/rsparser.c |   33 +++++++++++------------
 3 files changed, 40 insertions(+), 39 deletions(-)

diff -puN drivers/pnp/pnpacpi/rsparser.c~declare-pnp-option-parsing-functions-as-__init drivers/pnp/pnpacpi/rsparser.c
--- a/drivers/pnp/pnpacpi/rsparser.c~declare-pnp-option-parsing-functions-as-__init
+++ a/drivers/pnp/pnpacpi/rsparser.c
@@ -391,8 +391,8 @@ acpi_status pnpacpi_parse_allocated_reso
 				   pnpacpi_allocated_resource, res);
 }
 
-static void pnpacpi_parse_dma_option(struct pnp_option *option,
-				     struct acpi_resource_dma *p)
+static __init void pnpacpi_parse_dma_option(struct pnp_option *option,
+					    struct acpi_resource_dma *p)
 {
 	int i;
 	struct pnp_dma *dma;
@@ -411,8 +411,8 @@ static void pnpacpi_parse_dma_option(str
 	pnp_register_dma_resource(option, dma);
 }
 
-static void pnpacpi_parse_irq_option(struct pnp_option *option,
-				     struct acpi_resource_irq *p)
+static __init void pnpacpi_parse_irq_option(struct pnp_option *option,
+					    struct acpi_resource_irq *p)
 {
 	int i;
 	struct pnp_irq *irq;
@@ -431,8 +431,8 @@ static void pnpacpi_parse_irq_option(str
 	pnp_register_irq_resource(option, irq);
 }
 
-static void pnpacpi_parse_ext_irq_option(struct pnp_option *option,
-					 struct acpi_resource_extended_irq *p)
+static __init void pnpacpi_parse_ext_irq_option(struct pnp_option *option,
+					struct acpi_resource_extended_irq *p)
 {
 	int i;
 	struct pnp_irq *irq;
@@ -451,8 +451,8 @@ static void pnpacpi_parse_ext_irq_option
 	pnp_register_irq_resource(option, irq);
 }
 
-static void pnpacpi_parse_port_option(struct pnp_option *option,
-				      struct acpi_resource_io *io)
+static __init void pnpacpi_parse_port_option(struct pnp_option *option,
+					     struct acpi_resource_io *io)
 {
 	struct pnp_port *port;
 
@@ -470,8 +470,8 @@ static void pnpacpi_parse_port_option(st
 	pnp_register_port_resource(option, port);
 }
 
-static void pnpacpi_parse_fixed_port_option(struct pnp_option *option,
-					    struct acpi_resource_fixed_io *io)
+static __init void pnpacpi_parse_fixed_port_option(struct pnp_option *option,
+					struct acpi_resource_fixed_io *io)
 {
 	struct pnp_port *port;
 
@@ -487,8 +487,8 @@ static void pnpacpi_parse_fixed_port_opt
 	pnp_register_port_resource(option, port);
 }
 
-static void pnpacpi_parse_mem24_option(struct pnp_option *option,
-				       struct acpi_resource_memory24 *p)
+static __init void pnpacpi_parse_mem24_option(struct pnp_option *option,
+					      struct acpi_resource_memory24 *p)
 {
 	struct pnp_mem *mem;
 
@@ -508,8 +508,8 @@ static void pnpacpi_parse_mem24_option(s
 	pnp_register_mem_resource(option, mem);
 }
 
-static void pnpacpi_parse_mem32_option(struct pnp_option *option,
-				       struct acpi_resource_memory32 *p)
+static __init void pnpacpi_parse_mem32_option(struct pnp_option *option,
+					      struct acpi_resource_memory32 *p)
 {
 	struct pnp_mem *mem;
 
@@ -529,8 +529,8 @@ static void pnpacpi_parse_mem32_option(s
 	pnp_register_mem_resource(option, mem);
 }
 
-static void pnpacpi_parse_fixed_mem32_option(struct pnp_option *option,
-					 struct acpi_resource_fixed_memory32 *p)
+static __init void pnpacpi_parse_fixed_mem32_option(struct pnp_option *option,
+					struct acpi_resource_fixed_memory32 *p)
 {
 	struct pnp_mem *mem;
 
@@ -549,8 +549,8 @@ static void pnpacpi_parse_fixed_mem32_op
 	pnp_register_mem_resource(option, mem);
 }
 
-static void pnpacpi_parse_address_option(struct pnp_option *option,
-					 struct acpi_resource *r)
+static __init void pnpacpi_parse_address_option(struct pnp_option *option,
+						struct acpi_resource *r)
 {
 	struct acpi_resource_address64 addr, *p = &addr;
 	acpi_status status;
@@ -596,8 +596,8 @@ struct acpipnp_parse_option_s {
 	struct pnp_dev *dev;
 };
 
-static acpi_status pnpacpi_option_resource(struct acpi_resource *res,
-					   void *data)
+static __init acpi_status pnpacpi_option_resource(struct acpi_resource *res,
+						  void *data)
 {
 	int priority = 0;
 	struct acpipnp_parse_option_s *parse_data = data;
@@ -696,8 +696,8 @@ static acpi_status pnpacpi_option_resour
 	return AE_OK;
 }
 
-acpi_status pnpacpi_parse_resource_option_data(acpi_handle handle,
-					       struct pnp_dev * dev)
+acpi_status __init pnpacpi_parse_resource_option_data(acpi_handle handle,
+						      struct pnp_dev *dev)
 {
 	acpi_status status;
 	struct acpipnp_parse_option_s parse_data;
diff -puN drivers/pnp/pnpbios/core.c~declare-pnp-option-parsing-functions-as-__init drivers/pnp/pnpbios/core.c
--- a/drivers/pnp/pnpbios/core.c~declare-pnp-option-parsing-functions-as-__init
+++ a/drivers/pnp/pnpbios/core.c
@@ -315,7 +315,7 @@ struct pnp_protocol pnpbios_protocol = {
 	.disable = pnpbios_disable_resources,
 };
 
-static int insert_device(struct pnp_bios_node *node)
+static int __init insert_device(struct pnp_bios_node *node)
 {
 	struct list_head *pos;
 	struct pnp_dev *dev;
diff -puN drivers/pnp/pnpbios/rsparser.c~declare-pnp-option-parsing-functions-as-__init drivers/pnp/pnpbios/rsparser.c
--- a/drivers/pnp/pnpbios/rsparser.c~declare-pnp-option-parsing-functions-as-__init
+++ a/drivers/pnp/pnpbios/rsparser.c
@@ -262,8 +262,8 @@ len_err:
  * Resource Configuration Options
  */
 
-static void pnpbios_parse_mem_option(unsigned char *p, int size,
-				     struct pnp_option *option)
+static __init void pnpbios_parse_mem_option(unsigned char *p, int size,
+					    struct pnp_option *option)
 {
 	struct pnp_mem *mem;
 
@@ -278,8 +278,8 @@ static void pnpbios_parse_mem_option(uns
 	pnp_register_mem_resource(option, mem);
 }
 
-static void pnpbios_parse_mem32_option(unsigned char *p, int size,
-				       struct pnp_option *option)
+static __init void pnpbios_parse_mem32_option(unsigned char *p, int size,
+					      struct pnp_option *option)
 {
 	struct pnp_mem *mem;
 
@@ -294,8 +294,8 @@ static void pnpbios_parse_mem32_option(u
 	pnp_register_mem_resource(option, mem);
 }
 
-static void pnpbios_parse_fixed_mem32_option(unsigned char *p, int size,
-					     struct pnp_option *option)
+static __init void pnpbios_parse_fixed_mem32_option(unsigned char *p, int size,
+						    struct pnp_option *option)
 {
 	struct pnp_mem *mem;
 
@@ -309,7 +309,7 @@ static void pnpbios_parse_fixed_mem32_op
 	pnp_register_mem_resource(option, mem);
 }
 
-static void pnpbios_parse_irq_option(unsigned char *p, int size,
+static __init void pnpbios_parse_irq_option(unsigned char *p, int size,
 				     struct pnp_option *option)
 {
 	struct pnp_irq *irq;
@@ -327,7 +327,7 @@ static void pnpbios_parse_irq_option(uns
 	pnp_register_irq_resource(option, irq);
 }
 
-static void pnpbios_parse_dma_option(unsigned char *p, int size,
+static __init void pnpbios_parse_dma_option(unsigned char *p, int size,
 				     struct pnp_option *option)
 {
 	struct pnp_dma *dma;
@@ -340,8 +340,8 @@ static void pnpbios_parse_dma_option(uns
 	pnp_register_dma_resource(option, dma);
 }
 
-static void pnpbios_parse_port_option(unsigned char *p, int size,
-				      struct pnp_option *option)
+static __init void pnpbios_parse_port_option(unsigned char *p, int size,
+					     struct pnp_option *option)
 {
 	struct pnp_port *port;
 
@@ -356,8 +356,8 @@ static void pnpbios_parse_port_option(un
 	pnp_register_port_resource(option, port);
 }
 
-static void pnpbios_parse_fixed_port_option(unsigned char *p, int size,
-					    struct pnp_option *option)
+static __init void pnpbios_parse_fixed_port_option(unsigned char *p, int size,
+						   struct pnp_option *option)
 {
 	struct pnp_port *port;
 
@@ -371,9 +371,9 @@ static void pnpbios_parse_fixed_port_opt
 	pnp_register_port_resource(option, port);
 }
 
-static unsigned char *pnpbios_parse_resource_option_data(unsigned char *p,
-							 unsigned char *end,
-							 struct pnp_dev *dev)
+static __init unsigned char *
+pnpbios_parse_resource_option_data(unsigned char *p, unsigned char *end,
+					struct pnp_dev *dev)
 {
 	unsigned int len, tag;
 	int priority = 0;
@@ -781,7 +781,8 @@ len_err:
  * Core Parsing Functions
  */
 
-int pnpbios_parse_data_stream(struct pnp_dev *dev, struct pnp_bios_node *node)
+int __init pnpbios_parse_data_stream(struct pnp_dev *dev,
+					struct pnp_bios_node *node)
 {
 	unsigned char *p = (char *)node->data;
 	unsigned char *end = (char *)(node->data + node->size);
_

Patches currently in -mm which might be from trenn@suse.de are

origin.patch
git-acpi.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
export-acpi_check_resource_conflict.patch
check-for-acpi-resource-conflicts-in-i2c-bus-drivers.patch
check-for-acpi-resource-conflicts-in-hwmon-drivers.patch
