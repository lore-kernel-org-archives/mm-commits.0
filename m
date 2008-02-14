From: akpm@linux-foundation.org
Subject: + ntfs-le_add_cpu-conversion.patch added to -mm tree
Date: Wed, 13 Feb 2008 16:24:45 -0800
Message-ID: <200802140024.m1E0Oj7c021987@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32853 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933938AbYBNAZ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 19:25:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, aia21@cantab.net


The patch titled
     ntfs: le*_add_cpu conversion
has been added to the -mm tree.  Its filename is
     ntfs-le_add_cpu-conversion.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ntfs: le*_add_cpu conversion
From: Marcin Slusarz <marcin.slusarz@gmail.com>

replace all:
little_endian_variable = cpu_to_leX(leX_to_cpu(little_endian_variable) +
					expression_in_cpu_byteorder);
with:
	leX_add_cpu(&little_endian_variable, expression_in_cpu_byteorder);
generated with semantic patch

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Anton Altaparmakov <aia21@cantab.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/upcase.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/ntfs/upcase.c~ntfs-le_add_cpu-conversion fs/ntfs/upcase.c
--- a/fs/ntfs/upcase.c~ntfs-le_add_cpu-conversion
+++ a/fs/ntfs/upcase.c
@@ -77,11 +77,10 @@ ntfschar *generate_default_upcase(void)
 		uc[i] = cpu_to_le16(i);
 	for (r = 0; uc_run_table[r][0]; r++)
 		for (i = uc_run_table[r][0]; i < uc_run_table[r][1]; i++)
-			uc[i] = cpu_to_le16(le16_to_cpu(uc[i]) +
-					uc_run_table[r][2]);
+			le16_add_cpu(&uc[i], uc_run_table[r][2]);
 	for (r = 0; uc_dup_table[r][0]; r++)
 		for (i = uc_dup_table[r][0]; i < uc_dup_table[r][1]; i += 2)
-			uc[i + 1] = cpu_to_le16(le16_to_cpu(uc[i + 1]) - 1);
+			le16_add_cpu(&uc[i + 1], -1);
 	for (r = 0; uc_word_table[r][0]; r++)
 		uc[uc_word_table[r][0]] = cpu_to_le16(uc_word_table[r][1]);
 	return uc;
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

xfs-convert-bex_add-to-bex_add_cpu-new-common-api.patch
udf-fix-directory-offset-handling.patch
udf-fix-udf_add_free_space.patch
git-gfs2-nmw.patch
affs-be_add_cpu-conversion.patch
hfs-hfsplus-be_add_cpu-conversion.patch
ipw2200-le_add_cpu-conversion.patch
scsi-le_add_cpu-conversion.patch
ext2-le_add_cpu-conversion.patch
ext4-le_add_cpu-conversion.patch
jfs-le_add_cpu-conversion.patch
ntfs-le_add_cpu-conversion.patch
ocfs2-le_add_cpu-conversion.patch
quota-le_add_cpu-conversion.patch
reiserfs-le_add_cpu-conversion.patch
sysv-e_add_cpu-conversion.patch
ufs-e_add_cpu-conversion.patch
ufs-e_add_cpu-conversion-in-return.patch
