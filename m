From: akpm@linux-foundation.org
Subject: + checkpatch-add-check-for-reuse-of-krealloc-arg.patch added to -mm tree
Date: Thu, 14 Mar 2013 13:18:57 -0700
Message-ID: <20130314201857.7E48831C15E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:34259 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab3CNUS6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Mar 2013 16:18:58 -0400
Received: by mail-ye0-f202.google.com with SMTP id q5so267679yen.3
        for <mm-commits@vger.kernel.org>; Thu, 14 Mar 2013 13:18:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, apw@canonical.com, dwmw2@infradead.org, khali@linux-fr.org, linux@roeck-us.net


The patch titled
     Subject: checkpatch: add check for reuse of krealloc arg
has been added to the -mm tree.  Its filename is
     checkpatch-add-check-for-reuse-of-krealloc-arg.patch

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
=46rom: Joe Perches <joe@perches.com>
Subject: checkpatch: add check for reuse of krealloc arg

On Thu, 2013-03-14 at 13:30 +0000, David Woodhouse wrote:
> If krealloc() returns NULL, it *doesn't* free the original. So any co=
de
> of the form 'foo =3D krealloc(foo, =E2=80=A6);' is almost certainly a=
 bug.

So add a check for it to checkpatch.

Signed-off-by: Joe Perches <joe@perches.com>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Guenter Roeck <linux@roeck-us.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-check-for-reuse-of-kreal=
loc-arg scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-check-for-reuse-of-krealloc-=
arg
+++ a/scripts/checkpatch.pl
@@ -3476,6 +3476,13 @@ sub process {
 			     "unnecessary cast may hide bugs, see http://c-faq.com/malloc/m=
allocnocast.html\n" . $herecurr);
 		}
=20
+# check for krealloc arg reuse
+		if ($^V && $^V ge 5.10.0 &&
+		    $line =3D~ /\b($Lval)\s*\=3D\s*(?:$balanced_parens)?\s*krealloc\=
s*\(\s*\1\s*,/) {
+			WARN("KREALLOC_ARG_REUSE",
+			     "Reusing the krealloc arg is almost always a bug\n" . $herecur=
r);
+		}
+
 # check for alloc argument mismatch
 		if ($line =3D~ /\b(kcalloc|kmalloc_array)\s*\(\s*sizeof\b/) {
 			WARN("ALLOC_ARRAY_ARGS",
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
get_maintainer-use-filename-only-regex-match-for-tegra.patch
get_maintainer-use-filename-only-regex-match-for-tegra-fix.patch
checkpatch-add-check-for-reuse-of-krealloc-arg.patch
kexec-fix-wrong-types-of-some-local-variables.patch
kexec-use-min_t-to-simplify-logic.patch
kexec-use-min_t-to-simplify-logic-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
