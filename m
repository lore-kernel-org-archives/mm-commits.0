From: akpm@linux-foundation.org
Subject: - ufs-fix-parenthesisation-in-ufs_set_fs_state.patch removed from -mm tree
Date: Sun, 24 Feb 2008 16:44:12 -0800
Message-ID: <200802250044.m1P0iCU8006090@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752729AbYBYAoi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:44:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, dushistov@mail.ru, mark@mtfhpc.demon.co.uk, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     ufs: fix parenthesisation in ufs_set_fs_state()
has been removed from the -mm tree.  Its filename was
     ufs-fix-parenthesisation-in-ufs_set_fs_state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ufs: fix parenthesisation in ufs_set_fs_state()
From: Roel Kluin <12o3l@tiscali.nl>

This bug snuck in with

commit 252e211e90ce56bf005cb533ad5a297c18c19407
Author: Mark Fortescue <mark@mtfhpc.demon.co.uk>
Date:   Tue Oct 16 23:26:31 2007 -0700

    Add in SunOS 4.1.x compatible mode for UFS

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Acked-by: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Mark Fortescue <mark@mtfhpc.demon.co.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/util.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ufs/util.h~ufs-fix-parenthesisation-in-ufs_set_fs_state fs/ufs/util.h
--- a/fs/ufs/util.h~ufs-fix-parenthesisation-in-ufs_set_fs_state
+++ a/fs/ufs/util.h
@@ -58,7 +58,7 @@ ufs_set_fs_state(struct super_block *sb,
 {
 	switch (UFS_SB(sb)->s_flags & UFS_ST_MASK) {
 	case UFS_ST_SUNOS:
-		if (fs32_to_cpu(sb, usb3->fs_postblformat == UFS_42POSTBLFMT)) {
+		if (fs32_to_cpu(sb, usb3->fs_postblformat) == UFS_42POSTBLFMT) {
 			usb1->fs_u0.fs_sun.fs_state = cpu_to_fs32(sb, value);
 			break;
 		}
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

git-alsa.patch
git-cifs.patch
git-dvb.patch
arch-sh-drivers-heartbeatc-ioremap-is-expected-to-succeed.patch
