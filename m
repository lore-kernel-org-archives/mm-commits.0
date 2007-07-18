From: akpm@linux-foundation.org
Subject: - add-kstrndup-fix.patch removed from -mm tree
Date: Wed, 18 Jul 2007 11:52:23 -0700
Message-ID: <200707181852.l6IIqNgn023669@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35274 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934461AbXGRSzJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 14:55:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, jeremy@xensource.com, rene.scharfe@lsrfire.ath.cx, mm-commits@vger.kernel.org


The patch titled
     add-kstrndup fix
has been removed from the -mm tree.  Its filename was
     add-kstrndup-fix.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

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
fix-the-softlockup-watchdog-to-actually-work.patch
git-kbuild.patch
fix-x86_64-mm-xen-xen-smp-guest-support.patch
fix-x86_64-mm-xen-xen-event-channels.patch
i386-minor-nx-handling-adjustment.patch
x86-fix-iounmaps-use-of-vm_structs-size-field.patch
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
lguest-the-guest-code.patch
