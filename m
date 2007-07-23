From: akpm@linux-foundation.org
Subject: - fix-empty-macros-in-acpi.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:35:19 -0700
Message-ID: <200707230935.l6N9ZJ0f016475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36427 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759067AbXGWJpY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:45:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@redhat.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi: fix empty macros
has been removed from the -mm tree.  Its filename was
     fix-empty-macros-in-acpi.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
