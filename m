From: akpm@linux-foundation.org
Subject: + small-acpica-extension-to-be-able-to-store-the-name-of.patch added to -mm tree
Date: Wed, 24 Oct 2007 20:50:25 -0700
Message-ID: <200710250350.l9P3oP90030362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35284 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754743AbXJYDvD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 23:51:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: trenn@suse.de, khali@linux-fr.org, lenb@kernel.org, mhoffman@lightlink.com


The patch titled
     Small ACPICA extension to be able to store the name of operation regions in osl.c later
has been added to the -mm tree.  Its filename is
     small-acpica-extension-to-be-able-to-store-the-name-of.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Small ACPICA extension to be able to store the name of operation regions in osl.c later
From: Thomas Renninger <trenn@suse.de>

In ACPI, AML can define accesses to IO ports and System Memory by Operation
Regions.  Those are not registered as done by PNPACPI using resource templates
(and _CRS/_SRS methods).

The IO ports and System Memory regions may get accessed by arbitrary AML code.
 When native drivers are accessing the same resources bad things can happen
(e.g.  a critical shutdown temperature of 3000 C every 2 months or so).

It is not really possible to register the operation regions via
request_resource, as they often overlap with pnp or other resources (e.g. 
statically setup IO resources below 0x100).

This approach stores all Operation Region declarations (IO and System Memory
only) at ACPI table parse time.  It offers a similar functionality like
request_region and let drivers which are known to possibly use the same IO
ports and Memory which are also often used by ACPI (hwmon and i2c) check for
ACPI interference.

A boot parameter acpi_enforce_resources=strict/lax/no is provided, which
is default set to lax:
  - strict: let conflicting drivers fail to load with an error message
  - lax:    let conflicting driver work normal with a warning message
  - no:     no functional change at all
Depending on the feedback and the kind of interferences we see, this
should be set to strict at later time.

Goal of this patch set is:
  - Identify ACPI interferences in bug reports (very hard to reproduce
    and to identify)
  - Find BIOSes for that an ACPI driver should exist for specific HW
    instead of a native one.
  - stability in general

Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/dispatcher/dsopcode.c |    4 +++-
 include/acpi/acpiosxf.h            |    4 ++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/acpi/dispatcher/dsopcode.c~small-acpica-extension-to-be-able-to-store-the-name-of drivers/acpi/dispatcher/dsopcode.c
--- a/drivers/acpi/dispatcher/dsopcode.c~small-acpica-extension-to-be-able-to-store-the-name-of
+++ a/drivers/acpi/dispatcher/dsopcode.c
@@ -359,7 +359,9 @@ acpi_status acpi_ds_get_region_arguments
 
 	status = acpi_os_validate_address(obj_desc->region.space_id,
 					  obj_desc->region.address,
-					  (acpi_size) obj_desc->region.length);
+					  (acpi_size) obj_desc->region.length,
+					  acpi_ut_get_node_name(node));
+
 	if (ACPI_FAILURE(status)) {
 		/*
 		 * Invalid address/length. We will emit an error message and mark
diff -puN include/acpi/acpiosxf.h~small-acpica-extension-to-be-able-to-store-the-name-of include/acpi/acpiosxf.h
--- a/include/acpi/acpiosxf.h~small-acpica-extension-to-be-able-to-store-the-name-of
+++ a/include/acpi/acpiosxf.h
@@ -239,8 +239,8 @@ acpi_status acpi_os_validate_interface(c
 acpi_status acpi_osi_invalidate(char* interface);
 
 acpi_status
-acpi_os_validate_address(u8 space_id,
-			 acpi_physical_address address, acpi_size length);
+acpi_os_validate_address(u8 space_id, acpi_physical_address address,
+			 acpi_size length, char *name);
 
 u64 acpi_os_get_timer(void);
 
_

Patches currently in -mm which might be from trenn@suse.de are

small-acpica-extension-to-be-able-to-store-the-name-of.patch
provide-acpi_check_mem_region.patch
export-acpi_check_resource_conflict.patch
check-for-acpi-resource-conflicts-in-hwmon-drivers.patch
check-for-acpi-resource-conflicts-in-i2c-bus-drivers.patch
