From: akpm@linux-foundation.org
Subject: - uml-fix-hostfs-tv_usec-calculations.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:38:00 -0800
Message-ID: <200802052237.m15MbfEA012878@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39069 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762344AbYBEWlU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dominique@quatravaux.org, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: fix hostfs tv_usec calculations
has been removed from the -mm tree.  Its filename was
     uml-fix-hostfs-tv_usec-calculations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: fix hostfs tv_usec calculations
From: Dominique Quatravaux <dominique@quatravaux.org>

To convert from tv_nsec to tv_usec, one needs to divide by 1000, not multiply.

Signed-off-by: Dominique Quatravaux <dominique@quatravaux.org>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hostfs/hostfs_user.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/hostfs/hostfs_user.c~uml-fix-hostfs-tv_usec-calculations fs/hostfs/hostfs_user.c
--- a/fs/hostfs/hostfs_user.c~uml-fix-hostfs-tv_usec-calculations
+++ a/fs/hostfs/hostfs_user.c
@@ -285,17 +285,17 @@ int set_attr(const char *file, struct ho
 			return err;
 
 		times[0].tv_sec = atime_ts.tv_sec;
-		times[0].tv_usec = atime_ts.tv_nsec * 1000;
+		times[0].tv_usec = atime_ts.tv_nsec / 1000;
 		times[1].tv_sec = mtime_ts.tv_sec;
-		times[1].tv_usec = mtime_ts.tv_nsec * 1000;
+		times[1].tv_usec = mtime_ts.tv_nsec / 1000;
 
 		if (attrs->ia_valid & HOSTFS_ATTR_ATIME_SET) {
 			times[0].tv_sec = attrs->ia_atime.tv_sec;
-			times[0].tv_usec = attrs->ia_atime.tv_nsec * 1000;
+			times[0].tv_usec = attrs->ia_atime.tv_nsec / 1000;
 		}
 		if (attrs->ia_valid & HOSTFS_ATTR_MTIME_SET) {
 			times[1].tv_sec = attrs->ia_mtime.tv_sec;
-			times[1].tv_usec = attrs->ia_mtime.tv_nsec * 1000;
+			times[1].tv_usec = attrs->ia_mtime.tv_nsec / 1000;
 		}
 
 		if (fd >= 0) {
_

Patches currently in -mm which might be from dominique@quatravaux.org are

origin.patch
