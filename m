From: akpm@linux-foundation.org
Subject: [folded-merged]
 ubsan-run-time-undefined-behavior-sanity-checker-fix-2.patch removed from
 -mm tree
Date: Wed, 20 Jan 2016 14:36:08 -0800
Message-ID: <56a00bd8.w/DzhEURae6u0ZLm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42031 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbcATWgJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jan 2016 17:36:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ubsan-run-time-undefined-behavior-sanity-checker-fix-2
has been removed from the -mm tree.  Its filename was
     ubsan-run-time-undefined-behavior-sanity-checker-fix-2.patch

This patch was dropped because it was folded into ubsan-run-time-undefined-behavior-sanity-checker.patch

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: ubsan-run-time-undefined-behavior-sanity-checker-fix-2

In GCC internals __ubsan_handle_builtin_unreachable() declared
with "noreturn" attribute. Make it noreturn in-kernel too.
Since we can't return from such function call panic() instead.

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ubsan.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN lib/ubsan.c~ubsan-run-time-undefined-behavior-sanity-checker-fix-2 lib/ubsan.c
--- a/lib/ubsan.c~ubsan-run-time-undefined-behavior-sanity-checker-fix-2
+++ a/lib/ubsan.c
@@ -422,16 +422,16 @@ void __ubsan_handle_shift_out_of_bounds(
 }
 EXPORT_SYMBOL(__ubsan_handle_shift_out_of_bounds);
 
-void __ubsan_handle_builtin_unreachable(struct unreachable_data *data)
+
+void __noreturn
+__ubsan_handle_builtin_unreachable(struct unreachable_data *data)
 {
 	unsigned long flags;
 
-	if (suppress_report(&data->location))
-		return;
