From: akpm@linux-foundation.org
Subject: + acpi_evaluate_integer-avoid-using-kmalloc.patch added to -mm tree
Date: Wed, 26 Nov 2008 13:21:05 -0800
Message-ID: <200811262121.mAQLL50M029329@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33155 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755159AbYKZVVh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Nov 2008 16:21:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@suse.cz, len.brown@intel.com, robert.moore@intel.com


The patch titled
     acpi_evaluate_integer: avoid using kmalloc()
has been added to the -mm tree.  Its filename is
     acpi_evaluate_integer-avoid-using-kmalloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi_evaluate_integer: avoid using kmalloc()
From: Pavel Machek <pavel@suse.cz>

Now I know why I had strange "scheduling in atomic" problems:
acpi_evaluate_integer() does malloc(..., irqs_disabled() ? GFP_ATOMIC
: GFP_KERNEL)... which is (of course) broken.

There's no way to reliably tell if we need GFP_ATOMIC or not from code,
this one for example fails to detect spinlocks held.

Fortunately, allocation seems small enough to be done on stack.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Cc: "Moore, Robert" <robert.moore@intel.com>
Cc: "Brown, Len" <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/utils.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff -puN drivers/acpi/utils.c~acpi_evaluate_integer-avoid-using-kmalloc drivers/acpi/utils.c
--- a/drivers/acpi/utils.c~acpi_evaluate_integer-avoid-using-kmalloc
+++ a/drivers/acpi/utils.c
@@ -259,34 +259,26 @@ acpi_evaluate_integer(acpi_handle handle
 		      struct acpi_object_list *arguments, unsigned long long *data)
 {
 	acpi_status status = AE_OK;
-	union acpi_object *element;
+	union acpi_object element;
 	struct acpi_buffer buffer = { 0, NULL };
 
-
 	if (!data)
 		return AE_BAD_PARAMETER;
 
-	element = kzalloc(sizeof(union acpi_object), irqs_disabled() ? GFP_ATOMIC: GFP_KERNEL);
-	if (!element)
-		return AE_NO_MEMORY;
-
 	buffer.length = sizeof(union acpi_object);
-	buffer.pointer = element;
+	buffer.pointer = &element;
 	status = acpi_evaluate_object(handle, pathname, arguments, &buffer);
 	if (ACPI_FAILURE(status)) {
 		acpi_util_eval_error(handle, pathname, status);
-		kfree(element);
 		return status;
 	}
 
-	if (element->type != ACPI_TYPE_INTEGER) {
+	if (element.type != ACPI_TYPE_INTEGER) {
 		acpi_util_eval_error(handle, pathname, AE_BAD_DATA);
-		kfree(element);
 		return AE_BAD_DATA;
 	}
 
-	*data = element->integer.value;
-	kfree(element);
+	*data = element.integer.value;
 
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Return value [%llu]\n", *data));
 
_

Patches currently in -mm which might be from pavel@suse.cz are

linux-next.patch
backlight-catch-invalid-input.patch
backlight-catch-invalid-input-checkpatch-fixes.patch
acpi_evaluate_integer-avoid-using-kmalloc.patch
strict_strto-is-not-strict-enough.patch
lis3lv02d-separate-the-core-from-hp-acpi-api.patch
lis3lv02d-merge-with-leds-hp-disk.patch

