From: akpm@linux-foundation.org
Subject: + efi-redefine-type-constant-macro-from-generic-code.patch added
 to -mm tree
Date: Mon, 04 Apr 2016 16:40:58 -0700
Message-ID: <5702fb8a.8DqWpkJMCXOap5XH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39132 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756821AbcDDXk7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Apr 2016 19:40:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, arnd@arndb.de, linux@rasmusvillemoes.dk, matt@codeblueprint.co.uk, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: efi: redefine type, constant, macro from generic code
has been added to the -mm tree.  Its filename is
     efi-redefine-type-constant-macro-from-generic-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/efi-redefine-type-constant-macro-from-generic-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/efi-redefine-type-constant-macro-from-generic-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: efi: redefine type, constant, macro from generic code

Generic UUID library defines structure type, macro to define UUID, and the
length of the UUID string. This patch removes duplicate data structure
definition, UUID string length constant  as well as macro for UUID handling.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
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
 
 #include <asm/page.h>
 
@@ -43,17 +44,10 @@ typedef u16 efi_char16_t;		/* UNICODE ch
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
@@ -1050,7 +1044,7 @@ efi_reboot(enum reboot_mode reboot_mode,
  * Length of a GUID string (strlen("aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"))
  * not including trailing NUL
  */
-#define EFI_VARIABLE_GUID_LEN 36
+#define EFI_VARIABLE_GUID_LEN	UUID_STRING_LEN
 
 /*
  * The type of search to perform when calling boottime->locate_handle
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

lib-vsprintf-simplify-uuid-printing.patch
lib-uuid-move-generate_random_uuid-to-uuidc.patch
lib-uuid-introduce-few-more-generic-helpers-for-uuid.patch
lib-uuid-remove-fsf-address.patch
sysctl-drop-away-useless-label.patch
sysctl-use-generic-uuid-library.patch
efi-redefine-type-constant-macro-from-generic-code.patch
efivars-use-generic-uuid-library.patch

