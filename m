Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DCA4C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:02:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 311A861424
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:02:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238224AbhGABEw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:04:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:59400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238280AbhGABEw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:04:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1C7A610A1;
        Thu,  1 Jul 2021 01:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625101342;
        bh=Gtc1qTe4omd3Ijdzp2+RfegM0XcnMamuk0QOMAZR7jw=;
        h=Date:From:To:Subject:From;
        b=e+T5T32SHAEWV5Ngm7nZA4QbW2MNtZegdn3wBVv+wh9J2SQyob/N2GpB4+zHYRex/
         oeU7NZeEOFFFpbEu4jHwWOUtLhlJSo5/3fA6heQjaIJEAtT/symoabYSVKSr0HuGMO
         XV0e4Xqspgvb+31au23agKXUHAb37g/dCtf/c0rQ=
Date:   Wed, 30 Jun 2021 18:02:21 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        dlatypov@google.com, mm-commits@vger.kernel.org, oskar@scara.com,
        tpiepho@gmail.com, yguoaz@gmail.com
Subject:  [folded-merged]
 lib-math-rational-add-kunit-test-cases-fix.patch removed from -mm tree
Message-ID: <20210701010221.d8486EFQO%akpm@linux-foundation.org>
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
has been removed from the -mm tree.  Its filename was
     lib-math-rational-add-kunit-test-cases-fix.patch

This patch was dropped because it was folded into lib-math-rational-add-kun=
it-test-cases.patch

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

lib-math-rational-add-kunit-test-cases.patch
lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch
ipc-utilc-use-binary-search-for-max_idx-fix.patch
mm.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
linux-next-pre.patch
linux-next-post.patch
linux-next-rejects.patch
kernel-cgroup-cgroupc-dont-export-cgroup_get_e_css-twice.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.pat=
ch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.pat=
ch
kernel-forkc-export-kernel_thread-to-modules.patch

