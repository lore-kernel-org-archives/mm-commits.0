From: akpm@linux-foundation.org
Subject: + kasan-make-function-get_wild_bug_type-static.patch added to -mm tree
Date: Thu, 22 Jun 2017 14:16:32 -0700
Message-ID: <594c33b0.RGaVVUbZ6ONW5ywo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47838 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752071AbdFVVQd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 22 Jun 2017 17:16:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: make get_wild_bug_type() static
has been added to the -mm tree.  Its filename is
     kasan-make-function-get_wild_bug_type-static.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-make-function-get_wild_bug_type-static.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-make-function-get_wild_bug_type-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kasan-make-function-get_wild_bug_type-static.patch

