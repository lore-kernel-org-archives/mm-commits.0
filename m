From: akpm@linux-foundation.org
Subject: [patch 081/114] lib/ubsan: remove
 returns-nonnull-attribute checks
Date: Tue, 06 Feb 2018 15:40:45 -0800
Message-ID: <20180206234045.tzR3ymGXT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55592 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932106AbeBFXkr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:40:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aryabinin@virtuozzo.com, mm-commits@vger.kernel.org, psodagud@codeaurora.org, torvalds@linux-foundation.org

From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: lib/ubsan: remove returns-nonnull-attribute checks

Similarly to type mismatch checks, new GCC 8.x and Clang also changed for
ABI for returns_nonnull checks.  While we can update our code to conform
the new ABI it's more reasonable to just remove it.  Because it's just
dead code, we don't have any single user of returns_nonnull attribute in
the whole kernel.

And AFAIU the advantage that this attribute could bring would be mitigated
by -fno-delete-null-pointer-checks cflag that we use to build the kernel. 
So it's unlikely we will have a lot of returns_nonnull attribute in
future.

So let's just remove the code, it has no use.

[aryabinin@virtuozzo.com: fix warning]
  Link: http://lkml.kernel.org/r/20180122165711.11510-1-aryabinin@virtuozzo.com
Link: http://lkml.kernel.org/r/20180119152853.16806-2-aryabinin@virtuozzo.com
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Sodagudi Prasad <psodagud@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ubsan.c            |   24 ------------------------
 lib/ubsan.h            |    5 -----
 scripts/Makefile.ubsan |    1 -
 3 files changed, 30 deletions(-)

diff -puN lib/ubsan.c~lib-ubsan-remove-returns-nonnull-attribute-checks lib/ubsan.c
--- a/lib/ubsan.c~lib-ubsan-remove-returns-nonnull-attribute-checks
+++ a/lib/ubsan.c
@@ -141,11 +141,6 @@ static void val_to_string(char *str, siz
 	}
 }
 
-static bool location_is_valid(struct source_location *loc)
-{
-	return loc->file_name != NULL;
-}
-
 static DEFINE_SPINLOCK(report_lock);
 
 static void ubsan_prologue(struct source_location *location,
@@ -356,25 +351,6 @@ void __ubsan_handle_type_mismatch_v1(str
 }
 EXPORT_SYMBOL(__ubsan_handle_type_mismatch_v1);
 
-void __ubsan_handle_nonnull_return(struct nonnull_return_data *data)
-{
-	unsigned long flags;
-
-	if (suppress_report(&data->location))
-		return;
-
-	ubsan_prologue(&data->location, &flags);
-
-	pr_err("null pointer returned from function declared to never return null\n");
-
-	if (location_is_valid(&data->attr_location))
-		print_source_location("returns_nonnull attribute specified in",
-				&data->attr_location);
-
-	ubsan_epilogue(&flags);
-}
-EXPORT_SYMBOL(__ubsan_handle_nonnull_return);
-
 void __ubsan_handle_vla_bound_not_positive(struct vla_bound_data *data,
 					unsigned long bound)
 {
diff -puN lib/ubsan.h~lib-ubsan-remove-returns-nonnull-attribute-checks lib/ubsan.h
--- a/lib/ubsan.h~lib-ubsan-remove-returns-nonnull-attribute-checks
+++ a/lib/ubsan.h
@@ -57,11 +57,6 @@ struct nonnull_arg_data {
 	int arg_index;
 };
 
-struct nonnull_return_data {
-	struct source_location location;
-	struct source_location attr_location;
-};
