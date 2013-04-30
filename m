From: akpm@linux-foundation.org
Subject: [merged] checkpatch-add-check-for-reuse-of-krealloc-arg.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:53:23 -0700
Message-ID: <20130430185323.855545A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:64623 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933133Ab3D3SxY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:53:24 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so86455ggm.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:53:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, dwmw2@infradead.org, khali@linux-fr.org, linux@roeck-us.net, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add check for reuse of krealloc arg
has been removed from the -mm tree.  Its filename was
     checkpatch-add-check-for-reuse-of-krealloc-arg.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

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
@@ -3477,6 +3477,13 @@ sub process {
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
drivers-usb-storage-realtek_crc-fix-build.patch
hfs-hfsplus-convert-dprint-to-hfs_dbg.patch
hfs-hfsplus-convert-printks-to-pr_level.patch
kexec-fix-wrong-types-of-some-local-variables.patch
kexec-use-min_t-to-simplify-logic.patch
kexec-use-min_t-to-simplify-logic-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
