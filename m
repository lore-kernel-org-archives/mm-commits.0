From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_lockupc-make-symbol-test_works-static.patch
 added to -mm tree
Date: Tue, 07 Jul 2020 12:37:29 -0700
Message-ID: <20200707193729.NTw_4uNAb%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726763AbgGGTha (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Jul 2020 15:37:30 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hulkci@huawei.com, mm-commits@vger.kernel.org, weiyongjun1@huawei.com


The patch titled
     Subject: lib/test_lockup.c: make symbol 'test_works' static
has been added to the -mm tree.  Its filename is
     lib-test_lockupc-make-symbol-test_works-static.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-test_lockupc-make-symbol-test_works-static.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-test_lockupc-make-symbol-test_works-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: lib/test_lockup.c: make symbol 'test_works' static

Fix sparse build warning:

lib/test_lockup.c:403:1: warning:
 symbol '__pcpu_scope_test_works' was not declared. Should it be static?

Link: http://lkml.kernel.org/r/20200707112252.9047-1-weiyongjun1@huawei.com
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_lockup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_lockup.c~lib-test_lockupc-make-symbol-test_works-static
+++ a/lib/test_lockup.c
@@ -400,7 +400,7 @@ static void test_lockup(bool master)
 	test_unlock(master, true);
 }
 
-DEFINE_PER_CPU(struct work_struct, test_works);
+static DEFINE_PER_CPU(struct work_struct, test_works);
 
 static void test_work_fn(struct work_struct *work)
 {
_

Patches currently in -mm which might be from weiyongjun1@huawei.com are

mm-slub-extend-slub_debug-syntax-for-multiple-blocks-fix.patch
lib-test_lockupc-make-symbol-test_works-static.patch
bits-add-tests-of-genmask-fix-2.patch
kcov-make-some-symbols-static.patch
