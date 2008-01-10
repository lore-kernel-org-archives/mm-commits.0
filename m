From: akpm@linux-foundation.org
Subject: + uml-fix-hostfs-tv_usec-calculations.patch added to -mm tree
Date: Wed, 09 Jan 2008 23:59:43 -0800
Message-ID: <200801100759.m0A7xN26011861@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51400 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754332AbYAJH7p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 02:59:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dominique@quatravaux.org, jdike@linux.intel.com


The patch titled
     uml: fix hostfs tv_usec calculations
has been added to the -mm tree.  Its filename is
     uml-fix-hostfs-tv_usec-calculations.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

uml-fix-hostfs-tv_usec-calculations.patch
