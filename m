From: akpm@linux-foundation.org
Subject: + acpi-fix-a-warning-of-discarding-qualifiers-from-pointer-target-type.patch added to -mm tree
Date: Tue, 21 Aug 2007 13:22:49 -0700
Message-ID: <200708212022.l7LKMn4k009068@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43029 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754207AbXHUUXR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Aug 2007 16:23:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viro@ftp.linux.org.uk, astarikovskiy@suse.de, jarkao2@o2.pl, lenb@kernel.org, viro@zeniv.linux.org.uk, xiyou.wangcong@gmail.com


The patch titled
     acpi: fix warnings of discarding qualifiers from pointer target types
has been added to the -mm tree.  Its filename is
     acpi-fix-a-warning-of-discarding-qualifiers-from-pointer-target-type.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: acpi: fix warnings of discarding qualifiers from pointer target types
From: Al Viro <viro@ftp.linux.org.uk>

drivers/acpi/ec.c: In function `acpi_ec_ecdt_probe':
drivers/acpi/ec.c:873: warning: passing arg 1 of `acpi_get_devices' discards qualifiers from pointer target type

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Jarek Poplawski <jarkao2@o2.pl>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/namespace/nsxfeval.c |    2 +-
 include/acpi/acpixf.h             |    2 +-
 include/acpi/acstruct.h           |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/acpi/namespace/nsxfeval.c~acpi-fix-a-warning-of-discarding-qualifiers-from-pointer-target-type drivers/acpi/namespace/nsxfeval.c
--- a/drivers/acpi/namespace/nsxfeval.c~acpi-fix-a-warning-of-discarding-qualifiers-from-pointer-target-type
+++ a/drivers/acpi/namespace/nsxfeval.c
@@ -540,7 +540,7 @@ acpi_ns_get_device_callback(acpi_handle 
  ******************************************************************************/
 
 acpi_status
-acpi_get_devices(char *HID,
+acpi_get_devices(const char *HID,
 		 acpi_walk_callback user_function,
 		 void *context, void **return_value)
 {
diff -puN include/acpi/acpixf.h~acpi-fix-a-warning-of-discarding-qualifiers-from-pointer-target-type include/acpi/acpixf.h
--- a/include/acpi/acpixf.h~acpi-fix-a-warning-of-discarding-qualifiers-from-pointer-target-type
+++ a/include/acpi/acpixf.h
@@ -130,7 +130,7 @@ acpi_walk_namespace(acpi_object_type typ
 		    void *context, void **return_value);
 
 acpi_status
-acpi_get_devices(char *HID,
+acpi_get_devices(const char *HID,
 		 acpi_walk_callback user_function,
 		 void *context, void **return_value);
 
diff -puN include/acpi/acstruct.h~acpi-fix-a-warning-of-discarding-qualifiers-from-pointer-target-type include/acpi/acstruct.h
--- a/include/acpi/acstruct.h~acpi-fix-a-warning-of-discarding-qualifiers-from-pointer-target-type
+++ a/include/acpi/acstruct.h
@@ -146,7 +146,7 @@ struct acpi_init_walk_info {
 struct acpi_get_devices_info {
 	acpi_walk_callback user_function;
 	void *context;
-	char *hid;
+	const char *hid;
 };
 
 union acpi_aml_operands {
_

Patches currently in -mm which might be from viro@ftp.linux.org.uk are

origin.patch
acpi-fix-a-warning-of-discarding-qualifiers-from-pointer-target-type.patch
fix-f_version-type-should-be-u64-instead-of-unsigned-long.patch
introduce-i_sync.patch
slab-leaks3-default-y.patch
