From: akpm@linux-foundation.org
Subject: [merged] cifs-replace-strnicmp-with-strncasecmp.patch removed
 from -mm tree
Date: Tue, 14 Oct 2014 11:22:12 -0700
Message-ID: <543d69d4.taDiuUgA5Pq3ffSz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44491 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbaJNSWL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:22:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, sfrench@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: cifs: replace strnicmp with strncasecmp
has been removed from the -mm tree.  Its filename was
     cifs-replace-strnicmp-with-strncasecmp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: cifs: replace strnicmp with strncasecmp

The kernel used to contain two functions for length-delimited,
case-insensitive string comparison, strnicmp with correct semantics and a
slightly buggy strncasecmp.  The latter is the POSIX name, so strnicmp was
renamed to strncasecmp, and strnicmp made into a wrapper for the new
strncasecmp to avoid breaking existing users.

To allow the compat wrapper strnicmp to be removed at some point in the
future, and to avoid the extra indirection cost, do
s/strnicmp/strncasecmp/g.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Steve French <sfrench@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/cifs_dfs_ref.c |    6 +++---
 fs/cifs/connect.c      |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/cifs/cifs_dfs_ref.c~cifs-replace-strnicmp-with-strncasecmp fs/cifs/cifs_dfs_ref.c
--- a/fs/cifs/cifs_dfs_ref.c~cifs-replace-strnicmp-with-strncasecmp
+++ a/fs/cifs/cifs_dfs_ref.c
@@ -195,15 +195,15 @@ char *cifs_compose_mount_options(const c
 		else
 			noff = tkn_e - (sb_mountdata + off) + 1;
 
-		if (strnicmp(sb_mountdata + off, "unc=", 4) == 0) {
+		if (strncasecmp(sb_mountdata + off, "unc=", 4) == 0) {
 			off += noff;
 			continue;
 		}
-		if (strnicmp(sb_mountdata + off, "ip=", 3) == 0) {
+		if (strncasecmp(sb_mountdata + off, "ip=", 3) == 0) {
 			off += noff;
 			continue;
 		}
-		if (strnicmp(sb_mountdata + off, "prefixpath=", 11) == 0) {
+		if (strncasecmp(sb_mountdata + off, "prefixpath=", 11) == 0) {
 			off += noff;
 			continue;
 		}
diff -puN fs/cifs/connect.c~cifs-replace-strnicmp-with-strncasecmp fs/cifs/connect.c
--- a/fs/cifs/connect.c~cifs-replace-strnicmp-with-strncasecmp
+++ a/fs/cifs/connect.c
@@ -1718,7 +1718,7 @@ cifs_parse_mount_options(const char *mou
 				goto cifs_parse_mount_err;
 			}
 
-			 if (strnicmp(string, "default", 7) != 0) {
+			 if (strncasecmp(string, "default", 7) != 0) {
 				vol->iocharset = kstrdup(string,
 							 GFP_KERNEL);
 				if (!vol->iocharset) {
@@ -1790,7 +1790,7 @@ cifs_parse_mount_options(const char *mou
 			if (string == NULL)
 				goto out_nomem;
 
-			if (strnicmp(string, "1", 1) == 0) {
+			if (strncasecmp(string, "1", 1) == 0) {
 				/* This is the default */
 				break;
 			}
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch

