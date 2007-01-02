From: akpm@osdl.org
Subject: + adfs-fix-filename-handling.patch added to -mm tree
Date: Tue, 02 Jan 2007 15:38:14 -0800
Message-ID: <200701022338.l02NcE6e001399@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:44887 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965093AbXABXiQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 18:38:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: james@zamez.org


The patch titled
     adfs: fix filename handling
has been added to the -mm tree.  Its filename is
     adfs-fix-filename-handling.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: adfs: fix filename handling
From: James Bursa <james@zamez.org>

Fix filenames on adfs discs being terminated at the first character greater
than 128 (adfs filenames are Latin 1).  I saw this problem when using a
loopback adfs image on a 2.6.17-rc5 x86_64 machine, and the patch fixed it
there.


Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/adfs/dir_f.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/adfs/dir_f.c~adfs-fix-filename-handling fs/adfs/dir_f.c
--- a/fs/adfs/dir_f.c~adfs-fix-filename-handling
+++ a/fs/adfs/dir_f.c
@@ -53,7 +53,7 @@ static inline int adfs_readname(char *bu
 {
 	char *old_buf = buf;
 
-	while (*ptr >= ' ' && maxlen--) {
+	while ((unsigned char)*ptr >= ' ' && maxlen--) {
 		if (*ptr == '/')
 			*buf++ = '.';
 		else
_

Patches currently in -mm which might be from james@zamez.org are

adfs-fix-filename-handling.patch
