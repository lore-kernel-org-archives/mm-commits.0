From: akpm@linux-foundation.org
Subject: + ufs-e_add_cpu-conversion-in-return.patch added to -mm tree
Date: Wed, 13 Feb 2008 16:42:31 -0800
Message-ID: <200802140042.m1E0gVS8022814@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46336 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758310AbYBNAsQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 19:48:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: 12o3l@tiscali.nl, dushistov@mail.ru, marcin.slusarz@gmail.com


The patch titled
     ufs: [bl]e_add_cpu conversion in return
has been added to the -mm tree.  Its filename is
     ufs-e_add_cpu-conversion-in-return.patch

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
Subject: ufs: [bl]e_add_cpu conversion in return
From: Roel Kluin <12o3l@tiscali.nl>

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/swab.h |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN fs/ufs/swab.h~ufs-e_add_cpu-conversion-in-return fs/ufs/swab.h
--- a/fs/ufs/swab.h~ufs-e_add_cpu-conversion-in-return
+++ a/fs/ufs/swab.h
@@ -44,18 +44,22 @@ static __inline u32
 fs64_add(struct super_block *sbp, u32 *n, int d)
 {
 	if (UFS_SB(sbp)->s_bytesex == BYTESEX_LE)
-		return *n = cpu_to_le64(le64_to_cpu(*n)+d);
+		le64_add_cpu(n, d);
 	else
-		return *n = cpu_to_be64(be64_to_cpu(*n)+d);
+		be64_add_cpu(n, d);
+
+	return *n;
 }
 
 static __inline u32
 fs64_sub(struct super_block *sbp, u32 *n, int d)
 {
 	if (UFS_SB(sbp)->s_bytesex == BYTESEX_LE)
-		return *n = cpu_to_le64(le64_to_cpu(*n)-d);
+		le64_add_cpu(n, -d);
 	else
-		return *n = cpu_to_be64(be64_to_cpu(*n)-d);
+		be64_add_cpu(n, -d);
+
+	return *n;
 }
 
 static __inline u32
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

git-alsa.patch
git-cifs.patch
git-dvb.patch
ufs-e_add_cpu-conversion-in-return.patch
