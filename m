From: akpm@linux-foundation.org
Subject: + lib-ubsan-remove-returns-nonnull-attribute-checks.patch added
 to -mm tree
Date: Fri, 19 Jan 2018 12:45:16 -0800
Message-ID: <5a6258dc.IQba/vU8QXvFEa8L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55362 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756322AbeASUpS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 Jan 2018 15:45:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, psodagud@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/ubsan: remove returns-nonnull-attribute checks
has been added to the -mm tree.  Its filename is
     lib-ubsan-remove-returns-nonnull-attribute-checks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-ubsan-remove-returns-nonnull-attribute-checks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-ubsan-remove-returns-nonnull-attribute-checks.patch

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

Link: http://lkml.kernel.org/r/20180119152853.16806-2-aryabinin@virtuozzo.com
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Sodagudi Prasad <psodagud@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ubsan.c            |   19 -------------------
 lib/ubsan.h            |    5 -----
 scripts/Makefile.ubsan |    1 -
 3 files changed, 25 deletions(-)

diff -puN lib/ubsan.c~lib-ubsan-remove-returns-nonnull-attribute-checks lib/ubsan.c
--- a/lib/ubsan.c~lib-ubsan-remove-returns-nonnull-attribute-checks
+++ a/lib/ubsan.c
@@ -356,25 +356,6 @@ void __ubsan_handle_type_mismatch_v1(str
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
