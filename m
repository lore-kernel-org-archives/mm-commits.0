From: akpm@linux-foundation.org
Subject: + fix-empty-macros-in-acpi.patch added to -mm tree
Date: Mon, 25 Jun 2007 11:38:19 -0700
Message-ID: <200706251838.l5PIcJ0w008064@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37033 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752053AbXFYSil (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 14:38:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davej@redhat.com, lenb@kernel.org


The patch titled
     acpi: fix empty macros
has been added to the -mm tree.  Its filename is
     fix-empty-macros-in-acpi.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: acpi: fix empty macros
From: Dave Jones <davej@redhat.com>

ACPI has a ton of macros which make a bunch of empty if's when configured
in non-debug mode.

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/glue.c     |    2 -
 include/acpi/acmacros.h |   40 +++++++++++++++++++-------------------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff -puN drivers/acpi/glue.c~fix-empty-macros-in-acpi drivers/acpi/glue.c
--- a/drivers/acpi/glue.c~fix-empty-macros-in-acpi
+++ a/drivers/acpi/glue.c
@@ -16,7 +16,7 @@
 #if ACPI_GLUE_DEBUG
 #define DBG(x...) printk(PREFIX x)
 #else
-#define DBG(x...)
+#define DBG(x...) do { } while(0)
 #endif
 static LIST_HEAD(bus_type_list);
 static DECLARE_RWSEM(bus_type_sem);
diff -puN include/acpi/acmacros.h~fix-empty-macros-in-acpi include/acpi/acmacros.h
--- a/include/acpi/acmacros.h~fix-empty-macros-in-acpi
+++ a/include/acpi/acmacros.h
@@ -622,26 +622,26 @@
 #define ACPI_DEBUG_EXEC(a)
 #define ACPI_NORMAL_EXEC(a)             a;
 
-#define ACPI_DEBUG_DEFINE(a)
-#define ACPI_DEBUG_ONLY_MEMBERS(a)
-#define ACPI_FUNCTION_NAME(a)
-#define ACPI_FUNCTION_TRACE(a)
-#define ACPI_FUNCTION_TRACE_PTR(a,b)
-#define ACPI_FUNCTION_TRACE_U32(a,b)
-#define ACPI_FUNCTION_TRACE_STR(a,b)
-#define ACPI_FUNCTION_EXIT
-#define ACPI_FUNCTION_STATUS_EXIT(s)
-#define ACPI_FUNCTION_VALUE_EXIT(s)
-#define ACPI_FUNCTION_ENTRY()
-#define ACPI_DUMP_STACK_ENTRY(a)
-#define ACPI_DUMP_OPERANDS(a,b,c,d,e)
-#define ACPI_DUMP_ENTRY(a,b)
-#define ACPI_DUMP_TABLES(a,b)
-#define ACPI_DUMP_PATHNAME(a,b,c,d)
-#define ACPI_DUMP_RESOURCE_LIST(a)
-#define ACPI_DUMP_BUFFER(a,b)
-#define ACPI_DEBUG_PRINT(pl)
-#define ACPI_DEBUG_PRINT_RAW(pl)
+#define ACPI_DEBUG_DEFINE(a)		do { } while(0)
+#define ACPI_DEBUG_ONLY_MEMBERS(a)	do { } while(0)
+#define ACPI_FUNCTION_NAME(a)		do { } while(0)
+#define ACPI_FUNCTION_TRACE(a)		do { } while(0)
+#define ACPI_FUNCTION_TRACE_PTR(a,b)	do { } while(0)
+#define ACPI_FUNCTION_TRACE_U32(a,b)	do { } while(0)
+#define ACPI_FUNCTION_TRACE_STR(a,b)	do { } while(0)
+#define ACPI_FUNCTION_EXIT		do { } while(0)
+#define ACPI_FUNCTION_STATUS_EXIT(s)	do { } while(0)
+#define ACPI_FUNCTION_VALUE_EXIT(s)	do { } while(0)
+#define ACPI_FUNCTION_ENTRY()		do { } while(0)
+#define ACPI_DUMP_STACK_ENTRY(a)	do { } while(0)
+#define ACPI_DUMP_OPERANDS(a,b,c,d,e)	do { } while(0)
+#define ACPI_DUMP_ENTRY(a,b)		do { } while(0)
+#define ACPI_DUMP_TABLES(a,b)		do { } while(0)
+#define ACPI_DUMP_PATHNAME(a,b,c,d)	do { } while(0)
+#define ACPI_DUMP_RESOURCE_LIST(a)	do { } while(0)
+#define ACPI_DUMP_BUFFER(a,b)		do { } while(0)
+#define ACPI_DEBUG_PRINT(pl)		do { } while(0)
+#define ACPI_DEBUG_PRINT_RAW(pl)	do { } while(0)
 
 #define return_VOID                     return
 #define return_ACPI_STATUS(s)           return(s)
_

Patches currently in -mm which might be from davej@redhat.com are

fix-empty-macros-in-acpi.patch
git-alsa.patch
git-cpufreq.patch
i386-remove-support-for-the-rise-cpu.patch
fix-up-codingstyle-in-isofs.patch
undeprecate-raw-driver.patch
fix-typo-in-prefetchh.patch
allow-softlockup-to-be-runtime-disabled.patch
add-werror-implicit-function-declaration.patch
