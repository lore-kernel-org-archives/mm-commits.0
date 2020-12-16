Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BC93C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:47:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4319C2313B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725998AbgLPErv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:47:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:52882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725996AbgLPErv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:47:51 -0500
Date:   Tue, 15 Dec 2020 20:47:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608094031;
        bh=0CzIDQbttkvUzQacBW22o1hParG88p5cpnfk4C+LD1s=;
        h=From:To:Subject:In-Reply-To:From;
        b=n64TzqJLgJ7CimJXekb5KISQ2lsEMEsU8Jxti62mwPDB3OT6VzoaLIiu6IwDNc5rd
         M3XhgsKgfIhVGdQHOjIKRoBHz+vGzMxIr9WbC2LSdaLI4RzXMNI2DabJvC2ys5cHyG
         q7e+r8njXudWIO6cYnaSJ4VNROs4x1swKinKDUH0=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akinobu.mita@gmail.com, akpm@linux-foundation.org,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        linux-mm@kvack.org, mhiramat@kernel.org,
        mm-commits@vger.kernel.org, naveen.n.rao@linux.ibm.com,
        pobrn@protonmail.com, torvalds@linux-foundation.org
Subject:  [patch 88/95] fault-injection: handle EI_ETYPE_TRUE
Message-ID: <20201216044710.q4ti6ayM8%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: Barnab=C3=A1s P=C5=91cze <pobrn@protonmail.com>
Subject: fault-injection: handle EI_ETYPE_TRUE

Commit af3b854492f351d1 ("mm/page_alloc.c: allow error injection")
introduced EI_ETYPE_TRUE, but did not extend

 * lib/error-inject.c:error_type_string(), and
 * kernel/fail_function.c:adjust_error_retval()

to accommodate for this change.

Handle EI_ETYPE_TRUE in both functions appropriately by
 * returning "TRUE" in error_type_string(),
 * adjusting the return value to true (1) in adjust_error_retval().

Furthermore, simplify the logic of handling EI_ETYPE_NULL in
adjust_error_retval().

Link: https://lkml.kernel.org/r/njB1czX0ZgWPR9h61euHIBb5bEyePw9D4D2m3i5lc9C=
l96P8Q1308dTcmsEZW7Vtz3Ifz4do-rOtSfuFTyGoEDYokkK2aUqBePVptzZEWfU=3D@protonm=
ail.com
Signed-off-by: Barnab=C3=A1s P=C5=91cze <pobrn@protonmail.com>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Reviewed-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fail_function.c |    6 +++---
 lib/error-inject.c     |    2 ++
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/kernel/fail_function.c~fault-injection-handle-ei_etype_true
+++ a/kernel/fail_function.c
@@ -37,9 +37,7 @@ static unsigned long adjust_error_retval
 {
 	switch (get_injectable_error_type(addr)) {
 	case EI_ETYPE_NULL:
-		if (retv !=3D 0)
-			return 0;
-		break;
+		return 0;
 	case EI_ETYPE_ERRNO:
 		if (retv < (unsigned long)-MAX_ERRNO)
 			return (unsigned long)-EINVAL;
@@ -48,6 +46,8 @@ static unsigned long adjust_error_retval
 		if (retv !=3D 0 && retv < (unsigned long)-MAX_ERRNO)
 			return (unsigned long)-EINVAL;
 		break;
+	case EI_ETYPE_TRUE:
+		return 1;
 	}
=20
 	return retv;
--- a/lib/error-inject.c~fault-injection-handle-ei_etype_true
+++ a/lib/error-inject.c
@@ -180,6 +180,8 @@ static const char *error_type_string(int
 		return "ERRNO";
 	case EI_ETYPE_ERRNO_NULL:
 		return "ERRNO_NULL";
+	case EI_ETYPE_TRUE:
+		return "TRUE";
 	default:
 		return "(unknown)";
 	}
_
