From: akpm@linux-foundation.org
Subject: - ufs-e_add_cpu-conversion-in-return.patch removed from -mm tree
Date: Fri, 15 Feb 2008 22:28:25 -0700
Message-ID: <200802160528.m1G5SQxX010274@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40168 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755151AbYBPF3C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 16 Feb 2008 00:29:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, dushistov@mail.ru, marcin.slusarz@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ufs: [bl]e_add_cpu conversion in return
has been removed from the -mm tree.  Its filename was
     ufs-e_add_cpu-conversion-in-return.patch

This patch was dropped because it had testing failures

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
