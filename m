From: akpm@linux-foundation.org
Subject: + checkpatch-fix-stringification-macro-defect.patch added to -mm tree
Date: Mon, 08 Apr 2013 13:40:51 -0700
Message-ID: <20130408204051.889455A43E9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:46595 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935919Ab3DHUkw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Apr 2013 16:40:52 -0400
Received: by mail-ob0-f201.google.com with SMTP id uz6so1573677obc.2
        for <mm-commits@vger.kernel.org>; Mon, 08 Apr 2013 13:40:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, v-stehle@ti.com


The patch titled
     Subject: checkpatch: fix stringification macro defect
has been added to the -mm tree.  Its filename is
     checkpatch-fix-stringification-macro-defect.patch

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
Subject: checkpatch: fix stringification macro defect

=46ix checkpatch misreporting defect with stringification macros

ERROR: Macros with complex values should be enclosed in parenthesis
  #27: FILE: arch/arm/include/asm/kgdb.h:41:
  +#define ___to_string(X) #X

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Vincent Stehl=E9 <v-stehle@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/checkpatch.pl~checkpatch-fix-stringification-macro-de=
fect scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-stringification-macro-defect
+++ a/scripts/checkpatch.pl
@@ -3016,6 +3016,7 @@ sub process {
 			    $dstat !~ /^'X'$/ &&					# character constants
 			    $dstat !~ /$exceptions/ &&
 			    $dstat !~ /^\.$Ident\s*=3D/ &&				# .foo =3D
+			    $dstat !~ /^(?:\#\s*$Ident|\#\s*$Constant)\s*$/ &&		# stringifi=
cation #foo
 			    $dstat !~ /^do\s*$Constant\s*while\s*$Constant;?$/ &&	# do {...=
} while (...); // do {...} while (...)
 			    $dstat !~ /^for\s*$Constant$/ &&				# for (...)
 			    $dstat !~ /^for\s*$Constant\s+(?:$Ident|-?$Constant)$/ &&	# for=
 (...) bar()
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
checkpatch-fix-stringification-macro-defect.patch
get_maintainer-use-filename-only-regex-match-for-tegra.patch
get_maintainer-use-filename-only-regex-match-for-tegra-fix.patch
checkpatch-add-check-for-reuse-of-krealloc-arg.patch
checkpatch-prefer-seq_puts-to-seq_printf.patch
checkpatch-complain-about-executable-files.patch
kexec-fix-wrong-types-of-some-local-variables.patch
kexec-use-min_t-to-simplify-logic.patch
kexec-use-min_t-to-simplify-logic-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
