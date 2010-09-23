From: akpm@linux-foundation.org
Subject: + vsprintfc-use-default-pointer-field-size-for-null-strings.patch added to -mm tree
Date: Thu, 23 Sep 2010 16:52:47 -0700
Message-ID: <201009232352.o8NNqlBI026830@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52843 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755945Ab0IWXxU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Sep 2010 19:53:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, mingo@elte.hu


The patch titled
     vsprintf.c: use default pointer field size for "(null)" strings
has been added to the -mm tree.  Its filename is
     vsprintfc-use-default-pointer-field-size-for-null-strings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vsprintf.c: use default pointer field size for "(null)" strings
From: Joe Perches <joe@perches.com>

It might be nicer to align the output.

For instance, ACPI messages sometimes have "(null)" pointers.

$ dmesg | grep "(null)"  -A 1 -B 1
[    0.198733] ACPI: Dynamic OEM Table Load:
[    0.198745] ACPI: SSDT (null) 00239 (v02  PmRef  Cpu0Ist 00003000 INTL 20051117)
[    0.199294] ACPI: SSDT 7f596e10 001C7 (v02  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.200708] ACPI: Dynamic OEM Table Load:
[    0.200721] ACPI: SSDT (null) 001C7 (v02  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.201950] ACPI: SSDT 7f597f10 000D0 (v02  PmRef  Cpu1Ist 00003000 INTL 20051117)
[    0.203386] ACPI: Dynamic OEM Table Load:
[    0.203398] ACPI: SSDT (null) 000D0 (v02  PmRef  Cpu1Ist 00003000 INTL 20051117)
[    0.203871] ACPI: SSDT 7f595f10 00083 (v02  PmRef  Cpu1Cst 00003000 INTL 20051117)
[    0.205301] ACPI: Dynamic OEM Table Load:
[    0.205315] ACPI: SSDT (null) 00083 (v02  PmRef  Cpu1Cst 00003000 INTL 20051117)

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN lib/vsprintf.c~vsprintfc-use-default-pointer-field-size-for-null-strings lib/vsprintf.c
--- a/lib/vsprintf.c~vsprintfc-use-default-pointer-field-size-for-null-strings
+++ a/lib/vsprintf.c
@@ -988,8 +988,11 @@ static noinline_for_stack
 char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 	      struct printf_spec spec)
 {
-	if (!ptr)
+	if (!ptr) {
+		if (spec.field_width == -1)
+			spec.field_width = 2 * sizeof(void *);
 		return string(buf, end, "(null)", spec);
+	}
 
 	switch (*fmt) {
 	case 'F':
@@ -1031,7 +1034,7 @@ char *pointer(const char *fmt, char *buf
 	}
 	spec.flags |= SMALL;
 	if (spec.field_width == -1) {
-		spec.field_width = 2*sizeof(void *);
+		spec.field_width = 2 * sizeof(void *);
 		spec.flags |= ZEROPAD;
 	}
 	spec.base = 16;
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
kernelh-add-minmax3-macros.patch
kernelh-add-minmax3-macros-fix.patch
replace-nested-max-min-macros-with-maxmin3-macro.patch
vsprintfc-use-default-pointer-field-size-for-null-strings.patch
scripts-get_maintainerpl-add-git-blame-rolestats-authored-lines-information.patch
scripts-get_maintainerpl-use-correct-indentation.patch
scripts-get_maintainerpl-dont-search-maintainers-for-keywords-or-emails.patch
scripts-get_maintainerpl-add-default-git-fallback-remove-default-git.patch
scripts-get_maintainerpl-use-get_maintainerconf-from-then-home-then-scripts.patch
maintainers-fix-colibri-pxa270-file-pattern.patch
maintainers-merge-imote2-and-stargate.patch
maintainers-merge-s3c-244x-sections.patch
maintainers-merge-s3c6400-and-6410-to-64xx.patch
maintainers-remove-usb-ov511-driver.patch
maintainers-remove-usb-zc0301-driver.patch
checkpatch-add-check-for-space-after-struct-union-and-enum.patch
checkpatch-add-additional-attribute-defines.patch
scripts-checkpatchpl-add-warnings-for-static-char-that-could-be-static-const-char.patch

