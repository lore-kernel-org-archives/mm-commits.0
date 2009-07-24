From: akpm@linux-foundation.org
Subject: + powerpc-cell-replace-strncpy-by-strlcpy.patch added to -mm tree
Date: Thu, 23 Jul 2009 17:08:57 -0700
Message-ID: <200907240008.n6O08vGK022205@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47059 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754100AbZGXAJJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Jul 2009 20:09:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, arnd@arndb.de, benh@kernel.crashing.org, ken.kawakami@toshiba.co.jp


The patch titled
     powerpc/cell: replace strncpy by strlcpy
has been added to the -mm tree.  Its filename is
     powerpc-cell-replace-strncpy-by-strlcpy.patch

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
Subject: powerpc/cell: replace strncpy by strlcpy
From: Roel Kluin <roel.kluin@gmail.com>

Replace strncpy() and explicit null-termination by strlcpy()

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Ken Kawakami <ken.kawakami@toshiba.co.jp>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/celleb_setup.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/powerpc/platforms/cell/celleb_setup.c~powerpc-cell-replace-strncpy-by-strlcpy arch/powerpc/platforms/cell/celleb_setup.c
--- a/arch/powerpc/platforms/cell/celleb_setup.c~powerpc-cell-replace-strncpy-by-strlcpy
+++ a/arch/powerpc/platforms/cell/celleb_setup.c
@@ -80,8 +80,7 @@ static void celleb_show_cpuinfo(struct s
 
 static int __init celleb_machine_type_hack(char *ptr)
 {
-	strncpy(celleb_machine_type, ptr, sizeof(celleb_machine_type));
-	celleb_machine_type[sizeof(celleb_machine_type)-1] = 0;
+	strlcpy(celleb_machine_type, ptr, sizeof(celleb_machine_type));
 	return 0;
 }
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
powerpc-cell-replace-strncpy-by-strlcpy.patch
media-strncpy-does-not-null-terminate-string.patch
ivtv-read-buffer-overflow.patch
ipath-strncpy-does-not-null-terminate-string.patch
atlx-strncpy-does-not-null-terminate-string.patch
ext4-remove-redundant-test-on-unsigned.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m32r-remove-redundant-tests-on-unsigned.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
platinumfb-misplaced-parenthesis.patch
documentation-strncpy-does-not-null-terminate-string.patch
adfs-remove-redundant-test-on-unsigned.patch

