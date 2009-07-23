From: akpm@linux-foundation.org
Subject: + dm-strncpy-does-not-null-terminate-string.patch added to -mm tree
Date: Thu, 23 Jul 2009 13:51:16 -0700
Message-ID: <200907232051.n6NKpGRZ001589@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754162AbZGWUve (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Jul 2009 16:51:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, agk@redhat.com


The patch titled
     dm: strncpy does not null terminate string
has been added to the -mm tree.  Its filename is
     dm-strncpy-does-not-null-terminate-string.patch

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
Subject: dm: strncpy does not null terminate string
From: Roel Kluin <roel.kluin@gmail.com>

strlcpy() will always null terminate the string.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-ioctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/md/dm-ioctl.c~dm-strncpy-does-not-null-terminate-string drivers/md/dm-ioctl.c
--- a/drivers/md/dm-ioctl.c~dm-strncpy-does-not-null-terminate-string
+++ a/drivers/md/dm-ioctl.c
@@ -634,9 +634,9 @@ static struct mapped_device *find_device
 		 * Sneakily write in both the name and the uuid
 		 * while we have the cell.
 		 */
-		strncpy(param->name, hc->name, sizeof(param->name));
+		strlcpy(param->name, hc->name, sizeof(param->name));
 		if (hc->uuid)
-			strncpy(param->uuid, hc->uuid, sizeof(param->uuid)-1);
+			strlcpy(param->uuid, hc->uuid, sizeof(param->uuid));
 		else
 			param->uuid[0] = '\0';
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
ipath-strncpy-does-not-null-terminate-string.patch
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

