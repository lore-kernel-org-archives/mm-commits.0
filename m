From: akpm@linux-foundation.org
Subject: [merged] checkpatch-fix-stringification-macro-defect.patch removed from -mm tree
Date: Mon, 22 Apr 2013 13:06:40 -0700
Message-ID: <20130422200640.7C8025A4285@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:34222 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513Ab3DVUGl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Apr 2013 16:06:41 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so378632qcs.1
        for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2013 13:06:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, v-stehle@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix stringification macro defect
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-stringification-macro-defect.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

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
get_maintainer-use-filename-only-regex-match-for-tegra.patch
get_maintainer-use-filename-only-regex-match-for-tegra-fix.patch
checkpatch-add-check-for-reuse-of-krealloc-arg.patch
checkpatch-prefer-seq_puts-to-seq_printf.patch
checkpatch-complain-about-executable-files.patch
checkpatch-warn-on-space-before-semicolon.patch
checkpatch-only-warn-for-empty-lines-before-closing-braces-by-themselve=
s.patch
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
