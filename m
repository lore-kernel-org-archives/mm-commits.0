From: akpm@linux-foundation.org
Subject: + kstrtox-mark-const-init-data-with-__initconst-instead-of-__initdata.patch added to -mm tree
Date: Fri, 06 Apr 2012 15:17:11 -0700
Message-ID: <20120406221711.D6F78A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:56656 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487Ab2DFWRM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Apr 2012 18:17:12 -0400
Received: by ghbz15 with SMTP id z15so315607ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 06 Apr 2012 15:17:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de, adobriyan@gmail.com


The patch titled
     Subject: lib/test-kstrtox.c: mark const init data with __initconst=
 instead of __initdata
has been added to the -mm tree.  Its filename is
     kstrtox-mark-const-init-data-with-__initconst-instead-of-__initdat=
a.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Subject: lib/test-kstrtox.c: mark const init data with __initconst inst=
ead of __initdata

As long as there is no other non-const variable marked __initdata in th=
e
same compilation unit it doesn't hurt. If there were one however
compilation would fail with

	error: $variablename causes a section type conflict

because a section containing const variables is marked read only and so
cannot contain non-const variables.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test-kstrtox.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/test-kstrtox.c~kstrtox-mark-const-init-data-with-__initco=
nst-instead-of-__initdata lib/test-kstrtox.c
--- a/lib/test-kstrtox.c~kstrtox-mark-const-init-data-with-__initconst-=
instead-of-__initdata
+++ a/lib/test-kstrtox.c
@@ -11,7 +11,7 @@ struct test_fail {
 };
=20
 #define DEFINE_TEST_FAIL(test)	\
-	const struct test_fail test[] __initdata
+	const struct test_fail test[] __initconst
=20
 #define DECLARE_TEST_OK(type, test_type)	\
 	test_type {				\
@@ -21,7 +21,7 @@ struct test_fail {
 	}
=20
 #define DEFINE_TEST_OK(type, test)	\
-	const type test[] __initdata
+	const type test[] __initconst
=20
 #define TEST_FAIL(fn, type, fmt, test)					\
 {									\
_
Subject: Subject: lib/test-kstrtox.c: mark const init data with __initc=
onst instead of __initdata

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

origin.patch
linux-next.patch
hamradio-scc-orphan-driver-in-maintainers.patch
kstrtox-mark-const-init-data-with-__initconst-instead-of-__initdata.pat=
ch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
