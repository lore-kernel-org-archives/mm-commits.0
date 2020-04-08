From: akpm@linux-foundation.org
Subject: [merged] ubsan-include-bug-type-in-report-header.patch
 removed from -mm tree
Date: Tue, 07 Apr 2020 19:02:35 -0700
Message-ID: <20200408020235.DYBjK5suN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgDHCCg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 22:02:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, ard.biesheuvel@linaro.org, arnd@arndb.de, aryabinin@virtuozzo.com, dan.carpenter@oracle.com, dvyukov@google.com, glider@google.com, gustavo@embeddedor.com, keescook@chromium.org, lenaptr@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ubsan: include bug type in report header
has been removed from the -mm tree.  Its filename was
     ubsan-include-bug-type-in-report-header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: ubsan: include bug type in report header

When syzbot tries to figure out how to deduplicate bug reports, it prefers
seeing a hint about a specific bug type (we can do better than just
"UBSAN").  This lifts the handler reason into the UBSAN report line that
includes the file path that tripped a check.  Unfortunately, UBSAN does
not provide function names.

Link: http://lkml.kernel.org/r/20200227193516.32566-7-keescook@chromium.org
Suggested-by: Dmitry Vyukov <dvyukov@google.com>
Link: https://lore.kernel.org/lkml/CACT4Y+bsLJ-wFx_TaXqax3JByUOWB3uk787LsyMVcfW6JzzGvg@mail.gmail.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Elena Petrova <lenaptr@google.com>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ubsan.c |   36 +++++++++++++++---------------------
 1 file changed, 15 insertions(+), 21 deletions(-)

--- a/lib/ubsan.c~ubsan-include-bug-type-in-report-header
+++ a/lib/ubsan.c
@@ -45,13 +45,6 @@ static bool was_reported(struct source_l
 	return test_and_set_bit(REPORTED_BIT, &location->reported);
 }
 
-static void print_source_location(const char *prefix,
-				struct source_location *loc)
-{
-	pr_err("%s %s:%d:%d\n", prefix, loc->file_name,
-		loc->line & LINE_MASK, loc->column & COLUMN_MASK);
-}
-
 static bool suppress_report(struct source_location *loc)
 {
 	return current->in_ubsan || was_reported(loc);
@@ -140,13 +133,14 @@ static void val_to_string(char *str, siz
 	}
 }
 
-static void ubsan_prologue(struct source_location *location)
+static void ubsan_prologue(struct source_location *loc, const char *reason)
 {
 	current->in_ubsan++;
 
 	pr_err("========================================"
 		"========================================\n");
-	print_source_location("UBSAN: Undefined behaviour in", location);
+	pr_err("UBSAN: %s in %s:%d:%d\n", reason, loc->file_name,
+		loc->line & LINE_MASK, loc->column & COLUMN_MASK);
 }
 
 static void ubsan_epilogue(void)
@@ -180,12 +174,12 @@ static void handle_overflow(struct overf
 	if (suppress_report(&data->location))
 		return;
 
-	ubsan_prologue(&data->location);
+	ubsan_prologue(&data->location, type_is_signed(type) ?
+			"signed-integer-overflow" :
+			"unsigned-integer-overflow");
 
 	val_to_string(lhs_val_str, sizeof(lhs_val_str), type, lhs);
 	val_to_string(rhs_val_str, sizeof(rhs_val_str), type, rhs);
-	pr_err("%s integer overflow:\n",
-		type_is_signed(type) ? "signed" : "unsigned");
 	pr_err("%s %c %s cannot be represented in type %s\n",
 		lhs_val_str,
 		op,
@@ -225,7 +219,7 @@ void __ubsan_handle_negate_overflow(stru
 	if (suppress_report(&data->location))
 		return;
 
-	ubsan_prologue(&data->location);
+	ubsan_prologue(&data->location, "negation-overflow");
 
 	val_to_string(old_val_str, sizeof(old_val_str), data->type, old_val);
 
@@ -245,7 +239,7 @@ void __ubsan_handle_divrem_overflow(stru
 	if (suppress_report(&data->location))
 		return;
 
-	ubsan_prologue(&data->location);
+	ubsan_prologue(&data->location, "division-overflow");
 
 	val_to_string(rhs_val_str, sizeof(rhs_val_str), data->type, rhs);
 
@@ -264,7 +258,7 @@ static void handle_null_ptr_deref(struct
 	if (suppress_report(data->location))
 		return;
 
-	ubsan_prologue(data->location);
+	ubsan_prologue(data->location, "null-ptr-deref");
 
 	pr_err("%s null pointer of type %s\n",
 		type_check_kinds[data->type_check_kind],
@@ -279,7 +273,7 @@ static void handle_misaligned_access(str
 	if (suppress_report(data->location))
 		return;
 
-	ubsan_prologue(data->location);
+	ubsan_prologue(data->location, "misaligned-access");
 
 	pr_err("%s misaligned address %p for type %s\n",
 		type_check_kinds[data->type_check_kind],
@@ -295,7 +289,7 @@ static void handle_object_size_mismatch(
 	if (suppress_report(data->location))
 		return;
 
-	ubsan_prologue(data->location);
+	ubsan_prologue(data->location, "object-size-mismatch");
 	pr_err("%s address %p with insufficient space\n",
 		type_check_kinds[data->type_check_kind],
 		(void *) ptr);
@@ -354,7 +348,7 @@ void __ubsan_handle_out_of_bounds(struct
 	if (suppress_report(&data->location))
 		return;
 
-	ubsan_prologue(&data->location);
+	ubsan_prologue(&data->location, "array-index-out-of-bounds");
 
 	val_to_string(index_str, sizeof(index_str), data->index_type, index);
 	pr_err("index %s is out of range for type %s\n", index_str,
@@ -375,7 +369,7 @@ void __ubsan_handle_shift_out_of_bounds(
 	if (suppress_report(&data->location))
 		goto out;
 
-	ubsan_prologue(&data->location);
+	ubsan_prologue(&data->location, "shift-out-of-bounds");
 
 	val_to_string(rhs_str, sizeof(rhs_str), rhs_type, rhs);
 	val_to_string(lhs_str, sizeof(lhs_str), lhs_type, lhs);
@@ -407,7 +401,7 @@ EXPORT_SYMBOL(__ubsan_handle_shift_out_o
 
 void __ubsan_handle_builtin_unreachable(struct unreachable_data *data)
 {
-	ubsan_prologue(&data->location);
+	ubsan_prologue(&data->location, "unreachable");
 	pr_err("calling __builtin_unreachable()\n");
 	ubsan_epilogue();
 	panic("can't return from __builtin_unreachable()");
@@ -422,7 +416,7 @@ void __ubsan_handle_load_invalid_value(s
 	if (suppress_report(&data->location))
 		return;
 
-	ubsan_prologue(&data->location);
+	ubsan_prologue(&data->location, "invalid-load");
 
 	val_to_string(val_str, sizeof(val_str), data->type, val);
 
_

Patches currently in -mm which might be from keescook@chromium.org are
