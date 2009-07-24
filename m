From: akpm@linux-foundation.org
Subject: + smbfs-read-buffer-overflow.patch added to -mm tree
Date: Fri, 24 Jul 2009 16:49:49 -0700
Message-ID: <200907242349.n6ONnnkG022027@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751362AbZGXXtv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Jul 2009 19:49:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com


The patch titled
     smbfs: read buffer overflow
has been added to the -mm tree.  Its filename is
     smbfs-read-buffer-overflow.patch

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
Subject: smbfs: read buffer overflow
From: Roel Kluin <roel.kluin@gmail.com>

This function uses signed integers for the unix_date and local variables -
if a negative number is supplied and the leap-year condition is not met,
month will be 0, leading to a read of day_n[-1]

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/smbfs/proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/smbfs/proc.c~smbfs-read-buffer-overflow fs/smbfs/proc.c
--- a/fs/smbfs/proc.c~smbfs-read-buffer-overflow
+++ a/fs/smbfs/proc.c
@@ -509,7 +509,7 @@ date_unix2dos(struct smb_sb_info *server
 		month = 2;
 	} else {
 		nl_day = (year & 3) || day <= 59 ? day : day - 1;
-		for (month = 0; month < 12; month++)
+		for (month = 1; month < 12; month++)
 			if (day_n[month] > nl_day)
 				break;
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
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
atlx-strncpy-does-not-null-terminate-string.patch
ext4-remove-redundant-test-on-unsigned.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m32r-remove-redundant-tests-on-unsigned.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
ncpfs-read-buffer-overflow.patch
smbfs-read-buffer-overflow.patch
platinumfb-misplaced-parenthesis.patch
documentation-strncpy-does-not-null-terminate-string.patch
adfs-remove-redundant-test-on-unsigned.patch

