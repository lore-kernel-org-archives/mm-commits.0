From: akpm@linux-foundation.org
Subject: [merged] fs-affs-use-unsigned-int-for-string-lengths.patch
 removed from -mm tree
Date: Wed, 18 Feb 2015 11:43:34 -0800
Message-ID: <54e4eb66.brx/egTI1yI7iuAR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46086 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbbBRTnf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:43:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs: use unsigned int for string lengths
has been removed from the -mm tree.  Its filename was
     fs-affs-use-unsigned-int-for-string-lengths.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs: use unsigned int for string lengths

- Some min() were used with different types.

- Create a new variable in __affs_hash_dentry() to process
  affs_check_name()/min() return

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/amigaffs.c |    2 +-
 fs/affs/namei.c    |   15 ++++++++-------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff -puN fs/affs/amigaffs.c~fs-affs-use-unsigned-int-for-string-lengths fs/affs/amigaffs.c
--- a/fs/affs/amigaffs.c~fs-affs-use-unsigned-int-for-string-lengths
+++ a/fs/affs/amigaffs.c
@@ -508,7 +508,7 @@ affs_check_name(const unsigned char *nam
 int
 affs_copy_name(unsigned char *bstr, struct dentry *dentry)
 {
-	int len = min(dentry->d_name.len, 30u);
+	u32 len = min(dentry->d_name.len, 30u);
 
 	*bstr++ = len;
 	memcpy(bstr, dentry->d_name.name, len);
diff -puN fs/affs/namei.c~fs-affs-use-unsigned-int-for-string-lengths fs/affs/namei.c
--- a/fs/affs/namei.c~fs-affs-use-unsigned-int-for-string-lengths
+++ a/fs/affs/namei.c
@@ -64,15 +64,16 @@ __affs_hash_dentry(struct qstr *qstr, to
 {
 	const u8 *name = qstr->name;
 	unsigned long hash;
-	int i;
+	int retval;
+	u32 len;
 
-	i = affs_check_name(qstr->name, qstr->len, notruncate);
-	if (i)
-		return i;
+	retval = affs_check_name(qstr->name, qstr->len, notruncate);
+	if (retval)
+		return retval;
 
 	hash = init_name_hash();
-	i = min(qstr->len, 30u);
-	for (; i > 0; name++, i--)
+	len = min(qstr->len, 30u);
+	for (; len > 0; name++, len--)
 		hash = partial_name_hash(toupper(*name), hash);
 	qstr->hash = end_name_hash(hash);
 
@@ -173,7 +174,7 @@ int
 affs_hash_name(struct super_block *sb, const u8 *name, unsigned int len)
 {
 	toupper_t toupper = affs_get_toupper(sb);
-	int hash;
+	u32 hash;
 
 	hash = len = min(len, 30u);
 	for (; len > 0; len--)
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch

