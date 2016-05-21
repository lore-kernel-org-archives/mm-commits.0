From: akpm@linux-foundation.org
Subject: [patch 094/162] include/linux/efi.h: redefine type, constant,
 macro from generic code
Date: Fri, 20 May 2016 17:01:18 -0700
Message-ID: <573fa54e.BGiCTjM2Oa8a+2Z/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52852 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbcEUABT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:01:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, arnd@arndb.de, axboe@kernel.dk, dmitry.kasatkin@gmail.com, linux@rasmusvillemoes.dk, matt@codeblueprint.co.uk, tytso@mit.edu, viro@zeniv.linux.org.uk, zohar@linux.vnet.ibm.com

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: include/linux/efi.h: redefine type, constant, macro from generic code

Generic UUID library defines structure type, macro to define UUID, and the
length of the UUID string.  This patch removes duplicate data structure
definition, UUID string length constant as well as macro for UUID
handling.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/efi.h |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff -puN include/linux/efi.h~efi-redefine-type-constant-macro-from-generic-code include/linux/efi.h
--- a/include/linux/efi.h~efi-redefine-type-constant-macro-from-generic-code
+++ a/include/linux/efi.h
@@ -21,6 +21,7 @@
 #include <linux/pfn.h>
 #include <linux/pstore.h>
 #include <linux/reboot.h>
+#include <linux/uuid.h>
 #include <linux/screen_info.h>
 
 #include <asm/page.h>
@@ -44,17 +45,10 @@ typedef u16 efi_char16_t;		/* UNICODE ch
 typedef u64 efi_physical_addr_t;
 typedef void *efi_handle_t;
 
-
-typedef struct {
-	u8 b[16];
-} efi_guid_t;
+typedef uuid_le efi_guid_t;
 
 #define EFI_GUID(a,b,c,d0,d1,d2,d3,d4,d5,d6,d7) \
-((efi_guid_t) \
-{{ (a) & 0xff, ((a) >> 8) & 0xff, ((a) >> 16) & 0xff, ((a) >> 24) & 0xff, \
-  (b) & 0xff, ((b) >> 8) & 0xff, \
-  (c) & 0xff, ((c) >> 8) & 0xff, \
-  (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }})
+	UUID_LE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)
 
 /*
  * Generic EFI table header
@@ -1117,7 +1111,7 @@ extern int efi_status_to_err(efi_status_
  * Length of a GUID string (strlen("aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"))
  * not including trailing NUL
  */
-#define EFI_VARIABLE_GUID_LEN 36
+#define EFI_VARIABLE_GUID_LEN	UUID_STRING_LEN
 
 /*
  * The type of search to perform when calling boottime->locate_handle
_
