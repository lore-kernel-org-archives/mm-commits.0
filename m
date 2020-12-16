Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A2AEC4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDB1023407
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:12:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgLPRMM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:12:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:33078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726826AbgLPRMM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:12:12 -0500
Date:   Wed, 16 Dec 2020 09:11:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138717;
        bh=79sd76ThsKXolJeXX26aHKT3TYabt50yW+6Kp+wYFLk=;
        h=From:To:Subject:From;
        b=FElxk+4tamfIb5QQyAHzxIXXlYBViUAY8BCiYLkA8zsVTA72M6PVxilBU1UYMmDK6
         zmEinzh4WMBc0RK08yHGTCcba/Cef8ujZrvfwWVa9GyGD4kJIwcT4n3ubs0QaEuS4/
         v825QvxKuiEKVL5D+AOtV3ug/3IzalP8LxrMBl6Y=
From:   akpm@linux-foundation.org
To:     akinobu.mita@gmail.com, anil.s.keshavamurthy@intel.com,
        davem@davemloft.net, mhiramat@kernel.org,
        mm-commits@vger.kernel.org, naveen.n.rao@linux.ibm.com,
        pobrn@protonmail.com
Subject:  [merged] fault-injection-handle-ei_etype_true.patch
 removed from -mm tree
Message-ID: <20201216171156.pVBavxcHx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fault-injection: handle EI_ETYPE_TRUE
has been removed from the -mm tree.  Its filename was
     fault-injection-handle-ei_etype_true.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
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

Patches currently in -mm which might be from pobrn@protonmail.com are


