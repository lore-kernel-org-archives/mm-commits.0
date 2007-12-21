From: akpm@linux-foundation.org
Subject: + ext3-remove-unused-code-from-ext3_find_entry.patch added to -mm tree
Date: Thu, 20 Dec 2007 16:29:45 -0800
Message-ID: <200712210029.lBL0Tj4R021097@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55279 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754759AbXLUAaU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 19:30:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl


The patch titled
     ext3: remove unused code from ext3_find_entry()
has been added to the -mm tree.  Its filename is
     ext3-remove-unused-code-from-ext3_find_entry.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext3: remove unused code from ext3_find_entry()
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/namei.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN fs/ext3/namei.c~ext3-remove-unused-code-from-ext3_find_entry fs/ext3/namei.c
--- a/fs/ext3/namei.c~ext3-remove-unused-code-from-ext3_find_entry
+++ a/fs/ext3/namei.c
@@ -860,14 +860,10 @@ static struct buffer_head * ext3_find_en
 	int nblocks, i, err;
 	struct inode *dir = dentry->d_parent->d_inode;
 	int namelen;
-	const u8 *name;
-	unsigned blocksize;
 
 	*res_dir = NULL;
 	sb = dir->i_sb;
-	blocksize = sb->s_blocksize;
 	namelen = dentry->d_name.len;
-	name = dentry->d_name.name;
 	if (namelen > EXT3_NAME_LEN)
 		return NULL;
 	if (is_dx(dir)) {
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

timerfd-v3-new-timerfd-api-sparc64-fix.patch
git-mmc.patch
config_highpte-vs-sub-page-page-tables-fix-2.patch
ext3-remove-unused-code-from-ext3_find_entry.patch
pid-fix-mips-irix-emulation-pid-usage-fix.patch
reiser4.patch
