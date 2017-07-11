From: akpm@linux-foundation.org
Subject: [merged]
 kasan-make-function-get_wild_bug_type-static.patch removed from -mm tree
Date: Tue, 11 Jul 2017 12:25:39 -0700
Message-ID: <20170711192539.NanO4awr5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48244 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932722AbdGKTZk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:25:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, colin.king@canonical.com, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: make get_wild_bug_type() static
has been removed from the -mm tree.  Its filename was
     kasan-make-function-get_wild_bug_type-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: kasan: make get_wild_bug_type() static

The helper function get_wild_bug_type() does not need to be in global
scope, so make it static.

Cleans up sparse warning:
"symbol 'get_wild_bug_type' was not declared. Should it be static?"

Link: http://lkml.kernel.org/r/20170622090049.10658-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/kasan/report.c~kasan-make-function-get_wild_bug_type-static mm/kasan/report.c
--- a/mm/kasan/report.c~kasan-make-function-get_wild_bug_type-static
+++ a/mm/kasan/report.c
@@ -107,7 +107,7 @@ static const char *get_shadow_bug_type(s
 	return bug_type;
 }
 
-const char *get_wild_bug_type(struct kasan_access_info *info)
+static const char *get_wild_bug_type(struct kasan_access_info *info)
 {
 	const char *bug_type = "unknown-crash";
 
_

Patches currently in -mm which might be from colin.king@canonical.com are


