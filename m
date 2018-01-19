From: akpm@linux-foundation.org
Subject: + lib-ubsan-add-type-mismatch-handler-for-new-gcc-clang.patch
 added to -mm tree
Date: Fri, 19 Jan 2018 12:45:13 -0800
Message-ID: <5a6258d9.PPzOsbda2GQfjKx9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55354 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756315AbeASUpP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 Jan 2018 15:45:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, psodagud@codeaurora.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/ubsan: add type mismatch handler for new GCC/Clang
has been added to the -mm tree.  Its filename is
     lib-ubsan-add-type-mismatch-handler-for-new-gcc-clang.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-ubsan-add-type-mismatch-handler-for-new-gcc-clang.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-ubsan-add-type-mismatch-handler-for-new-gcc-clang.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-memcg-try-harder-to-decrease-limit_in_bytes.patch
kasan-makefile-support-llvm-style-asan-parameters.patch
lib-strscpy-remove-word-at-a-time-optimization.patch
lib-ubsan-add-type-mismatch-handler-for-new-gcc-clang.patch
lib-ubsan-remove-returns-nonnull-attribute-checks.patch

