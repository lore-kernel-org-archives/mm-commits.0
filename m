From: akpm@linux-foundation.org
Subject: [merged] kstrtox-mark-const-init-data-with-__initconst-instead-of-__initdata.patch removed from -mm tree
Date: Thu, 31 May 2012 12:19:59 -0700
Message-ID: <20120531191959.62E49A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:41454 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933082Ab2EaTUA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:20:00 -0400
Received: by qabg24 with SMTP id g24so154855qab.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:19:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test-kstrtox.c: mark const init data with __initconst=
 instead of __initdata
has been removed from the -mm tree.  Its filename was
     kstrtox-mark-const-init-data-with-__initconst-instead-of-__initdat=
a.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

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

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

origin.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
