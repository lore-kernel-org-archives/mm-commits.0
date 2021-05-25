Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02BE9C47086
	for <mm-commits@archiver.kernel.org>; Tue, 25 May 2021 21:50:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8FCC610CE
	for <mm-commits@archiver.kernel.org>; Tue, 25 May 2021 21:50:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233540AbhEYVvb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 May 2021 17:51:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:50786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232114AbhEYVvb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 25 May 2021 17:51:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE71A613C1;
        Tue, 25 May 2021 21:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621979400;
        bh=hQi9LNIGjD7gAvO8HuNIfhWdQx5eWjrIZ5bE4bVUE2Y=;
        h=Date:From:To:Subject:From;
        b=YIuMFeiPbg9wDVxe3jwKBT/GY9w6l154wMqOTgej740J35BuTgYgHpu97zNn7nOFh
         16ZWN4pX31erRpBxjUkdseOpsSsYQ6rskQYeahTxYGhPSlnZmnB3IIEcWU5DoK0uyd
         Nx1aatX6nVnFlrzyypdiKEl855Ibl8wlJSyHcwCk=
Date:   Tue, 25 May 2021 14:49:59 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        dlatypov@google.com, mm-commits@vger.kernel.org, oskar@scara.com,
        tpiepho@gmail.com, yguoaz@gmail.com
Subject:  + lib-math-rational-add-kunit-test-cases-fix.patch added
 to -mm tree
Message-ID: <20210525214959.MSFDtIJYi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib-math-rational-add-kunit-test-cases-fix
has been added to the -mm tree.  Its filename is
     lib-math-rational-add-kunit-test-cases-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-math-rational-add-kunit-t=
est-cases-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-math-rational-add-kunit-t=
est-cases-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-math-rational-add-kunit-test-cases-fix

remove non-ascii characters, fix whitespace

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Daniel Latypov <dlatypov@google.com>
Cc: Oskar Schirmer <oskar@scara.com>
Cc: Trent Piepho <tpiepho@gmail.com>
Cc: Yiyuan Guo <yguoaz@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/math/rational-test.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/lib/math/rational-test.c~lib-math-rational-add-kunit-test-cases-fix
+++ a/lib/math/rational-test.c
@@ -13,8 +13,8 @@ struct rational_test_param {
 };
=20
 static const struct rational_test_param test_parameters[] =3D {
-	{ 1230,	10,	100, 20,	100, 1,    "Exceeds bounds, semi-convergent term > =
=C2=BD last term" },
-	{ 34567,100, 	120, 20,	120, 1,    "Exceeds bounds, semi-convergent term <=
 =C2=BD last term" },
+	{ 1230,	10,	100, 20,	100, 1,    "Exceeds bounds, semi-convergent term > 1=
/2 last term" },
+	{ 34567,100, 	120, 20,	120, 1,    "Exceeds bounds, semi-convergent term <=
 1/2 last term" },
 	{ 1, 30,	100, 10,	0, 1,	   "Closest to zero" },
 	{ 1, 19,	100, 10,	1, 10,     "Closest to smallest non-zero" },
 	{ 27,32,	16, 16,		11, 13,    "Use convergent" },
@@ -42,13 +42,13 @@ static void rational_test(struct kunit *
 }
=20
 static struct kunit_case rational_test_cases[] =3D {
-       KUNIT_CASE_PARAM(rational_test, rational_gen_params),
-       {}
+	KUNIT_CASE_PARAM(rational_test, rational_gen_params),
+	{}
 };
=20
 static struct kunit_suite rational_test_suite =3D {
-       .name =3D "rational",
-       .test_cases =3D rational_test_cases,
+	.name =3D "rational",
+	.test_cases =3D rational_test_cases,
 };
=20
 kunit_test_suites(&rational_test_suite);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5-fix.patch
binfmt-remove-in-tree-usage-of-map_executable-fix.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
powerpc-mm-book3s64-update-tlb-flush-routines-to-take-a-page-walk-cache-flu=
sh-argument-fix.patch
mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush-fix.patch
mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races-fix.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enable=
d-fix.patch
mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkp=
atch-fixes.patch
kernelh-split-out-panic-and-oops-helpers-fix.patch
lib-math-rational-add-kunit-test-cases-fix.patch
lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch
linux-next-pre.patch
linux-next-post.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.pat=
ch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.pat=
ch
kernel-forkc-export-kernel_thread-to-modules.patch

