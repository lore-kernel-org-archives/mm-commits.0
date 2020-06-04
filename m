From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 127/127] lib/ubsan.c: fix gcc-10 warnings
Date: Thu, 04 Jun 2020 16:53:00 -0700
Message-ID: <20200604235300.ATAPlWMFM%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgFDXxC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:53:02 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, aryabinin@virtuozzo.com, herbert@gondor.apana.org.au, julien.grall@arm.com, keescook@chromium.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Arnd Bergmann <arnd@arndb.de>
Subject: lib/ubsan.c: fix gcc-10 warnings

The latest compiler expects slightly different function prototypes
for the ubsan helpers:

lib/ubsan.c:192:6: error: conflicting types for built-in function '__ubsan_handle_add_overflow'; expected 'void(void *, void *, void *)' [-Werror=builtin-declaration-mismatch]
  192 | void __ubsan_handle_add_overflow(struct overflow_data *data,
      |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~
lib/ubsan.c:200:6: error: conflicting types for built-in function '__ubsan_handle_sub_overflow'; expected 'void(void *, void *, void *)' [-Werror=builtin-declaration-mismatch]
  200 | void __ubsan_handle_sub_overflow(struct overflow_data *data,
      |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~
lib/ubsan.c:207:6: error: conflicting types for built-in function '__ubsan_handle_mul_overflow'; expected 'void(void *, void *, void *)' [-Werror=builtin-declaration-mismatch]
  207 | void __ubsan_handle_mul_overflow(struct overflow_data *data,
      |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~
lib/ubsan.c:214:6: error: conflicting types for built-in function '__ubsan_handle_negate_overflow'; expected 'void(void *, void *)' [-Werror=builtin-declaration-mismatch]
  214 | void __ubsan_handle_negate_overflow(struct overflow_data *data,
      |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
lib/ubsan.c:234:6: error: conflicting types for built-in function '__ubsan_handle_divrem_overflow'; expected 'void(void *, void *, void *)' [-Werror=builtin-declaration-mismatch]
  234 | void __ubsan_handle_divrem_overflow(struct overflow_data *data,
      |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Change the Linux implementation to match these, using a local typed
pointer.

Link: http://lkml.kernel.org/r/20200429185948.4189600-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Julien Grall <julien.grall@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ubsan.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

--- a/lib/ubsan.c~ubsan-fix-gcc-10-warnings
+++ a/lib/ubsan.c
@@ -189,7 +189,7 @@ static void handle_overflow(struct overf
 	ubsan_epilogue();
 }
 
-void __ubsan_handle_add_overflow(struct overflow_data *data,
+void __ubsan_handle_add_overflow(void *data,
 				void *lhs, void *rhs)
 {
 
@@ -197,23 +197,23 @@ void __ubsan_handle_add_overflow(struct
 }
 EXPORT_SYMBOL(__ubsan_handle_add_overflow);
 
-void __ubsan_handle_sub_overflow(struct overflow_data *data,
+void __ubsan_handle_sub_overflow(void *data,
 				void *lhs, void *rhs)
 {
 	handle_overflow(data, lhs, rhs, '-');
 }
 EXPORT_SYMBOL(__ubsan_handle_sub_overflow);
 
-void __ubsan_handle_mul_overflow(struct overflow_data *data,
+void __ubsan_handle_mul_overflow(void *data,
 				void *lhs, void *rhs)
 {
 	handle_overflow(data, lhs, rhs, '*');
 }
 EXPORT_SYMBOL(__ubsan_handle_mul_overflow);
 
-void __ubsan_handle_negate_overflow(struct overflow_data *data,
-				void *old_val)
+void __ubsan_handle_negate_overflow(void *_data, void *old_val)
 {
+	struct overflow_data *data = _data;
 	char old_val_str[VALUE_LENGTH];
 
 	if (suppress_report(&data->location))
@@ -231,9 +231,9 @@ void __ubsan_handle_negate_overflow(stru
 EXPORT_SYMBOL(__ubsan_handle_negate_overflow);
 
 
-void __ubsan_handle_divrem_overflow(struct overflow_data *data,
-				void *lhs, void *rhs)
+void __ubsan_handle_divrem_overflow(void *_data, void *lhs, void *rhs)
 {
+	struct overflow_data *data = _data;
 	char rhs_val_str[VALUE_LENGTH];
 
 	if (suppress_report(&data->location))
@@ -326,10 +326,9 @@ void __ubsan_handle_type_mismatch(struct
 }
 EXPORT_SYMBOL(__ubsan_handle_type_mismatch);
 
-void __ubsan_handle_type_mismatch_v1(struct type_mismatch_data_v1 *data,
-				void *ptr)
+void __ubsan_handle_type_mismatch_v1(void *_data, void *ptr)
 {
-
+	struct type_mismatch_data_v1 *data = _data;
 	struct type_mismatch_data_common common_data = {
 		.location = &data->location,
 		.type = data->type,
@@ -341,8 +340,9 @@ void __ubsan_handle_type_mismatch_v1(str
 }
 EXPORT_SYMBOL(__ubsan_handle_type_mismatch_v1);
 
-void __ubsan_handle_out_of_bounds(struct out_of_bounds_data *data, void *index)
+void __ubsan_handle_out_of_bounds(void *_data, void *index)
 {
+	struct out_of_bounds_data *data = _data;
 	char index_str[VALUE_LENGTH];
 
 	if (suppress_report(&data->location))
@@ -357,9 +357,9 @@ void __ubsan_handle_out_of_bounds(struct
 }
 EXPORT_SYMBOL(__ubsan_handle_out_of_bounds);
 
-void __ubsan_handle_shift_out_of_bounds(struct shift_out_of_bounds_data *data,
-					void *lhs, void *rhs)
+void __ubsan_handle_shift_out_of_bounds(void *_data, void *lhs, void *rhs)
 {
+	struct shift_out_of_bounds_data *data = _data;
 	struct type_descriptor *rhs_type = data->rhs_type;
 	struct type_descriptor *lhs_type = data->lhs_type;
 	char rhs_str[VALUE_LENGTH];
@@ -399,8 +399,9 @@ out:
 EXPORT_SYMBOL(__ubsan_handle_shift_out_of_bounds);
 
 
-void __ubsan_handle_builtin_unreachable(struct unreachable_data *data)
+void __ubsan_handle_builtin_unreachable(void *_data)
 {
+	struct unreachable_data *data = _data;
 	ubsan_prologue(&data->location, "unreachable");
 	pr_err("calling __builtin_unreachable()\n");
 	ubsan_epilogue();
@@ -408,9 +409,9 @@ void __ubsan_handle_builtin_unreachable(
 }
 EXPORT_SYMBOL(__ubsan_handle_builtin_unreachable);
 
-void __ubsan_handle_load_invalid_value(struct invalid_value_data *data,
-				void *val)
+void __ubsan_handle_load_invalid_value(void *_data, void *val)
 {
+	struct invalid_value_data *data = _data;
 	char val_str[VALUE_LENGTH];
 
 	if (suppress_report(&data->location))
_
