From: akpm@linux-foundation.org
Subject: + add-kstrndup-fix.patch added to -mm tree
Date: Fri, 11 May 2007 14:50:17 -0700
Message-ID: <200705112150.l4BLoHqh027736@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751349AbXEKVuX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 17:50:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, jeremy@xensource.com, rene.scharfe@lsrfire.ath.cx


The patch titled
     add-kstrndup fix
has been added to the -mm tree.  Its filename is
     add-kstrndup-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: add-kstrndup fix
=46rom: Jeremy Fitzhardinge <jeremy@goop.org>

strnlen prevents over-reading the input.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Ren=E9 Scharfe <rene.scharfe@lsrfire.ath.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    4 +---
 1 files changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/util.c~add-kstrndup-fix mm/util.c
--- a/mm/util.c~add-kstrndup-fix
+++ a/mm/util.c
@@ -53,9 +53,7 @@ char *kstrndup(const char *s, size_t max
 	if (!s)
 		return NULL;
=20
-	len =3D strlen(s);
-	if (len > max)
-		len =3D max;
+	len =3D strnlen(s, max);
 	buf =3D kmalloc_track_caller(len+1, gfp);
  	if (buf) {
 		memcpy(buf, s, len);
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
loop_probe-fix-return-value.patch
x86-use-elfnoteh-to-generate-vsyscall-notes.patch
x86-use-elfnoteh-to-generate-vsyscall-notes-fix.patch
i386-move-common-parts-of-smp-into-their-own-file.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
add-kstrndup.patch
add-kstrndup-fix.patch
add-argv_split.patch
split-usermodehelper-setup-from-execution.patch
add-common-orderly_poweroff.patch
tidy-up-usermode-helper-waiting-a-bit.patch
tidy-up-usermode-helper-waiting-a-bit-fix.patch
lguest-the-guest-code.patch
