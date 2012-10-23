From: akpm@linux-foundation.org
Subject: + scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch added to -mm tree
Date: Tue, 23 Oct 2012 11:57:10 -0700
Message-ID: <20121023185711.9A352200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:46313 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756836Ab2JWS5O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 14:57:14 -0400
Received: by mail-lb0-f202.google.com with SMTP id l12so62115lbo.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 11:57:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, andreas@biessmann.de, geert@linux-m68k.org


The patch titled
     Subject: scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch

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
=46rom: Andrew Morton <akpm@linux-foundation.org>
Subject: scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes

ERROR: do not initialise statics to 0 or NULL
#24: FILE: scripts/pnmtologo.c:77:
+static int is_plain_pbm =3D 0;

WARNING: line over 80 characters
#33: FILE: scripts/pnmtologo.c:108:
+	 * between the digits. This is Ok cause we know a PBM can only have a=
 '1'

total: 1 errors, 1 warnings, 25 lines checked

=2E/patches/scripts-pnmtologo-fix-for-plain-pbm.patch has style problem=
s, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andreas Bie=DFmann <andreas@biessmann.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/pnmtologo.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN scripts/pnmtologo.c~scripts-pnmtologo-fix-for-plain-pbm-check=
patch-fixes scripts/pnmtologo.c
--- a/scripts/pnmtologo.c~scripts-pnmtologo-fix-for-plain-pbm-checkpatc=
h-fixes
+++ a/scripts/pnmtologo.c
@@ -104,9 +104,11 @@ static unsigned int get_number(FILE *fp)
     val =3D 0;
     while (isdigit(c)) {
 	val =3D 10*val+c-'0';
-	/* some PBM are 'broken'; GiMP for example exports a PBM without spac=
e
-	 * between the digits. This is Ok cause we know a PBM can only have a=
 '1'
-	 * or a '0' for the digit. */
+	/*
+	 * Some PBM are 'broken'; GiMP for example exports a PBM without spac=
e
+	 * between the digits. This is OK because we know a PBM can only have=
 a
+	 * '1' or a '0' for the digit.
+	 */
 	if (is_plain_pbm)
 		break;
 	c =3D fgetc(fp);
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

revert-epoll-support-for-disabling-items-and-a-self-test-app.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-=
driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
mm.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
init-use-the-stringify-operator-for-the-__define_initcall-macro-checkpa=
tch-fixes.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.p=
atch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-c=
heckpatch-fixes.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes=
=2Epatch
fat-exportfs-rebuild-inode-if-ilookup-fails-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
