From: akpm@linux-foundation.org
Subject: [merged]
 lib-ubsan-add-type-mismatch-handler-for-new-gcc-clang.patch removed from
 -mm tree
Date: Wed, 07 Feb 2018 11:59:10 -0800
Message-ID: <20180207195910.7AVJnWojq%akpm__44738.2668419324$1518033474$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60220 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754411AbeBGT7M (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:59:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, mm-commits@vger.kernel.org, psodagud@codeaurora.org, stable@vger.kernel.org


The patch titled
     Subject: lib/ubsan: add type mismatch handler for new GCC/Clang
has been removed from the -mm tree.  Its filename was
     lib-ubsan-add-type-mismatch-handler-for-new-gcc-clang.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: lib/ubsan: add type mismatch handler for new GCC/Clang

UBSAN=y fails to build with new GCC/clang:

    arch/x86/kernel/head64.o: In function `sanitize_boot_params':
    arch/x86/include/asm/bootparam_utils.h:37: undefined reference to `__ubsan_handle_type_mismatch_v1'

because Clang and GCC 8 slightly changed ABI for 'type mismatch' errors. 
Compiler now uses new __ubsan_handle_type_mismatch_v1() function with
slightly modified 'struct type_mismatch_data'.

Let's add new 'struct type_mismatch_data_common' which is independent from
compiler's layout of 'struct type_mismatch_data'.  And make
__ubsan_handle_type_mismatch[_v1]() functions transform compiler-dependent
type mismatch data to our internal representation.  This way, we can
support both old and new compilers with minimal amount of change.

Link: http://lkml.kernel.org/r/20180119152853.16806-1-aryabinin@virtuozzo.com
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Reported-by: Sodagudi Prasad <psodagud@codeaurora.org>
Cc: <stable@vger.kernel.org>	[4.5+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ubsan.c |   48 ++++++++++++++++++++++++++++++++++++++----------
 lib/ubsan.h |   14 ++++++++++++++
 2 files changed, 52 insertions(+), 10 deletions(-)

diff -puN lib/ubsan.c~lib-ubsan-add-type-mismatch-handler-for-new-gcc-clang lib/ubsan.c
--- a/lib/ubsan.c~lib-ubsan-add-type-mismatch-handler-for-new-gcc-clang
+++ a/lib/ubsan.c
@@ -265,14 +265,14 @@ void __ubsan_handle_divrem_overflow(stru
 }
 EXPORT_SYMBOL(__ubsan_handle_divrem_overflow);
 
-static void handle_null_ptr_deref(struct type_mismatch_data *data)
+static void handle_null_ptr_deref(struct type_mismatch_data_common *data)
 {
 	unsigned long flags;
 
-	if (suppress_report(&data->location))
+	if (suppress_report(data->location))
 		return;
 
-	ubsan_prologue(&data->location, &flags);
+	ubsan_prologue(data->location, &flags);
 
 	pr_err("%s null pointer of type %s\n",
 		type_check_kinds[data->type_check_kind],
@@ -281,15 +281,15 @@ static void handle_null_ptr_deref(struct
 	ubsan_epilogue(&flags);
 }
 
-static void handle_misaligned_access(struct type_mismatch_data *data,
+static void handle_misaligned_access(struct type_mismatch_data_common *data,
 				unsigned long ptr)
 {
 	unsigned long flags;
 
-	if (suppress_report(&data->location))
+	if (suppress_report(data->location))
 		return;
 
-	ubsan_prologue(&data->location, &flags);
+	ubsan_prologue(data->location, &flags);
 
 	pr_err("%s misaligned address %p for type %s\n",
 		type_check_kinds[data->type_check_kind],
@@ -299,15 +299,15 @@ static void handle_misaligned_access(str
 	ubsan_epilogue(&flags);
 }
 
-static void handle_object_size_mismatch(struct type_mismatch_data *data,
+static void handle_object_size_mismatch(struct type_mismatch_data_common *data,
 					unsigned long ptr)
 {
 	unsigned long flags;
 
-	if (suppress_report(&data->location))
+	if (suppress_report(data->location))
 		return;
 
-	ubsan_prologue(&data->location, &flags);
+	ubsan_prologue(data->location, &flags);
 	pr_err("%s address %p with insufficient space\n",
 		type_check_kinds[data->type_check_kind],
 		(void *) ptr);
@@ -315,7 +315,7 @@ static void handle_object_size_mismatch(
 	ubsan_epilogue(&flags);
 }
 
-void __ubsan_handle_type_mismatch(struct type_mismatch_data *data,
+static void ubsan_type_mismatch_common(struct type_mismatch_data_common *data,
 				unsigned long ptr)
 {
 
@@ -326,8 +326,36 @@ void __ubsan_handle_type_mismatch(struct
 	else
 		handle_object_size_mismatch(data, ptr);
 }
+
+void __ubsan_handle_type_mismatch(struct type_mismatch_data *data,
+				unsigned long ptr)
+{
+	struct type_mismatch_data_common common_data = {
+		.location = &data->location,
+		.type = data->type,
+		.alignment = data->alignment,
+		.type_check_kind = data->type_check_kind
+	};
+
+	ubsan_type_mismatch_common(&common_data, ptr);
+}
 EXPORT_SYMBOL(__ubsan_handle_type_mismatch);
 
+void __ubsan_handle_type_mismatch_v1(struct type_mismatch_data_v1 *data,
+				unsigned long ptr)
+{
+
+	struct type_mismatch_data_common common_data = {
+		.location = &data->location,
+		.type = data->type,
+		.alignment = 1UL << data->log_alignment,
+		.type_check_kind = data->type_check_kind
+	};
+
+	ubsan_type_mismatch_common(&common_data, ptr);
+}
+EXPORT_SYMBOL(__ubsan_handle_type_mismatch_v1);
+
 void __ubsan_handle_nonnull_return(struct nonnull_return_data *data)
 {
 	unsigned long flags;
diff -puN lib/ubsan.h~lib-ubsan-add-type-mismatch-handler-for-new-gcc-clang lib/ubsan.h
--- a/lib/ubsan.h~lib-ubsan-add-type-mismatch-handler-for-new-gcc-clang
+++ a/lib/ubsan.h
@@ -37,6 +37,20 @@ struct type_mismatch_data {
 	unsigned char type_check_kind;
 };
 
+struct type_mismatch_data_v1 {
+	struct source_location location;
+	struct type_descriptor *type;
+	unsigned char log_alignment;
+	unsigned char type_check_kind;
+};
+
+struct type_mismatch_data_common {
+	struct source_location *location;
+	struct type_descriptor *type;
+	unsigned long alignment;
+	unsigned char type_check_kind;
+};
+
 struct nonnull_arg_data {
 	struct source_location location;
 	struct source_location attr_location;
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are

mm-kasan-dont-vfree-nonexistent-vm_area.patch

