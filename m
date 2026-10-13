Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA283A6B66;
	Tue, 13 Oct 2026 02:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791860392; cv=none; b=DYcOuVYfuTxpRynv69skn1o2nIvTYzhOptM0edwkzRn100JV8uEI2JWiIOCNuEWT1gL+suZif9pQ2oLF5PgN/nJU1FVtAFlR22MBLXamwUcZEe/s+IPauKPk37cFStKS/fah7UzJ/g5VXA1YY7aggSOhu0GzKwj3I77EaPDNuRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791860392; c=relaxed/simple;
	bh=PYSJiGd0l5WJz+JNVGOEPeRcx8tm/i9fUuFmwZA6wNw=;
	h=Date:To:From:Subject:Message-Id; b=CqGpO+zOpTWuiyoSNZ/iyebnuRLOs3Sy0/o5/iF4BkTTVQQhtbo56SAGuvdDf4tbXDggQYcqFxnz1tXWojpykDxKDexue6KX7cVCfQcl+zbYTJzPKkR4TVst6YFIqejgCO+qdF3BUTsEZrGq5CWPyn8Wj7YkqVrxx6Ac0qI0Veg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0O9emrW1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0O9emrW1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AADF61F000FF;
	Tue, 13 Oct 2026 02:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791860390;
	bh=jLGAIDiHYECYT2h2ALjpRCXmcQT+GU+H5NQDpPAkAVs=;
	h=Date:To:From:Subject;
	b=0O9emrW1S0+HHQ2v5RCFHav/8dhe+V1mMOJ23BIZLiTkCH1wVVfqz3+ncV91OWhJs
	 6fu8JoN38RqzhGKxxLNjNRABrkAfEku5w15JEX2j59s5I4QQ8riZS+PFmqp2bPsX6U
	 ZrgtfMfneN4Ghbp9jSXJ/ArJI2s7n88RqHisO+gA=
Date: Mon, 12 Oct 2026 19:59:50 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,jlbec@evilplan.org,heming.zhao@suse.com,anderson.ferneda@braza.com.br,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] ocfs2-deal-with-legacy-signed-dir-index-name-hash-values.patch removed from -mm tree
Message-Id: <20261013025950.AADF61F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: deal with legacy signed dir index name hash values
has been removed from the -mm tree.  Its filename was
     ocfs2-deal-with-legacy-signed-dir-index-name-hash-values.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: deal with legacy signed dir index name hash values
Date: Thu,  8 Oct 2026 20:27:42 +0800

Commit 3bc753c06dd0 ("kbuild: treat char as always unsigned") set
-funsigned-char globally, which changed the result of the naked 'char'
load in str2hashbuf():

	val = msg[i] + (val << 8);

A name byte >= 0x80 used to sign-extend and now zero-extends, so
ocfs2_dx_dir_name_hash() computes a different hash pair for every name
containing one.  The pair is written into the dx leaf when the entry is
created, so an index built by an older kernel no longer matches and
ocfs2_dx_dir_search() returns -ENOENT for a name that readdir still lists.

Search with the current unsigned hash and, on a miss, retry with the
legacy signed one, as ext4 does in commit f3bbac32475b2 ("ext4: deal with
legacy signed xattr name hash values").  New entries are always indexed
under the unsigned hash.  Skip the retry when the two hashes are equal, so
that a miss on an ASCII name does not walk the index twice.

The retry costs a second walk of the dx tree, so a negative lookup of a
name containing a byte >= 0x80 does twice the work.  That is bounded and
worth it, and directories whose dx root is still inline pay nothing extra,
since there the retry only rescans the root block that is already loaded. 
Nothing retires it at runtime: a legacy entry keeps its legacy hash,
because neither deleting nor updating an entry rewrites the dx hash, and
the only code that rehashes existing dirents is ocfs2_expand_inline_dir()
on the inline to extent conversion.  Rebuilding the index offline is what
removes the cost for good.

Also spell out the signedness in str2hashbuf() instead of leaving the
current hash to -funsigned-char, as commit 854f0912f813 ("ext4: make xattr
char unsignedness in hash explicit") did, so that both variants stay
correct if this is backported to a kernel without the flag.

Link: https://lore.kernel.org/20261008122743.616779-1-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Anderson Ferneda <anderson.ferneda@braza.com.br>
Closes: https://lore.kernel.org/ocfs2-devel/CP5P284MB2780AC2C3C2AB2CF2B6CB7AFBE942@CP5P284MB2780.BRAP284.PROD.OUTLOOK.COM/
Exposed-by: 3bc753c06dd0 ("kbuild: treat char as always unsigned")
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org> # 6.2+
---

 fs/ocfs2/dir.c |   76 ++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 65 insertions(+), 11 deletions(-)

--- a/fs/ocfs2/dir.c~ocfs2-deal-with-legacy-signed-dir-index-name-hash-values
+++ a/fs/ocfs2/dir.c
@@ -221,7 +221,8 @@ static void TEA_transform(__u32 buf[4],
 	buf[1] += b1;
 }
 
-static void str2hashbuf(const char *msg, int len, __u32 *buf, int num)
+static void str2hashbuf(const char *msg, int len, __u32 *buf, int num,
+			bool legacy_signed)
 {
 	__u32	pad, val;
 	int	i;
@@ -235,7 +236,10 @@ static void str2hashbuf(const char *msg,
 	for (i = 0; i < len; i++) {
 		if ((i % 4) == 0)
 			val = pad;
-		val = msg[i] + (val << 8);
+		if (legacy_signed)
+			val = (signed char)msg[i] + (val << 8);
+		else
+			val = (unsigned char)msg[i] + (val << 8);
 		if ((i % 4) == 3) {
 			*buf++ = val;
 			val = pad;
@@ -248,8 +252,9 @@ static void str2hashbuf(const char *msg,
 		*buf++ = pad;
 }
 
-static void ocfs2_dx_dir_name_hash(struct inode *dir, const char *name, int len,
-				   struct ocfs2_dx_hinfo *hinfo)
+static void __ocfs2_dx_dir_name_hash(struct inode *dir, const char *name,
+				     int len, struct ocfs2_dx_hinfo *hinfo,
+				     bool legacy_signed)
 {
 	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
 	const char	*p;
@@ -279,7 +284,7 @@ static void ocfs2_dx_dir_name_hash(struc
 
 	p = name;
 	while (len > 0) {
-		str2hashbuf(p, len, in, 4);
+		str2hashbuf(p, len, in, 4, legacy_signed);
 		TEA_transform(buf, in);
 		len -= 16;
 		p += 16;
@@ -290,6 +295,19 @@ out:
 	hinfo->minor_hash = buf[1];
 }
 
+static void ocfs2_dx_dir_name_hash(struct inode *dir, const char *name, int len,
+				   struct ocfs2_dx_hinfo *hinfo)
+{
+	__ocfs2_dx_dir_name_hash(dir, name, len, hinfo, false);
+}
+
+static void ocfs2_dx_dir_name_hash_signed(struct inode *dir, const char *name,
+					  int len,
+					  struct ocfs2_dx_hinfo *hinfo)
+{
+	__ocfs2_dx_dir_name_hash(dir, name, len, hinfo, true);
+}
+
 /*
  * bh passed here can be an inode block or a dir data block, depending
  * on the inode inline data flag.
@@ -1021,10 +1039,10 @@ out:
 	return ret;
 }
 
-static int ocfs2_dx_dir_search(const char *name, int namelen,
-			       struct inode *dir,
-			       struct ocfs2_dx_root_block *dx_root,
-			       struct ocfs2_dir_lookup_result *res)
+static int __ocfs2_dx_dir_search(const char *name, int namelen,
+				 struct inode *dir,
+				 struct ocfs2_dx_root_block *dx_root,
+				 struct ocfs2_dir_lookup_result *res)
 {
 	int ret, i, found;
 	u64 phys;
@@ -1037,8 +1055,6 @@ static int ocfs2_dx_dir_search(const cha
 	struct ocfs2_extent_list *dr_el;
 	struct ocfs2_dx_entry_list *entry_list;
 
-	ocfs2_dx_dir_name_hash(dir, name, namelen, &res->dl_hinfo);
-
 	if (ocfs2_dx_root_inline(dx_root)) {
 		entry_list = &dx_root->dr_entries;
 		goto search;
@@ -1135,6 +1151,44 @@ out:
 	return ret;
 }
 
+static int ocfs2_dx_dir_search(const char *name, int namelen,
+			       struct inode *dir,
+			       struct ocfs2_dx_root_block *dx_root,
+			       struct ocfs2_dir_lookup_result *res)
+{
+	struct ocfs2_dx_hinfo legacy;
+	int ret;
+
+	ocfs2_dx_dir_name_hash(dir, name, namelen, &res->dl_hinfo);
+
+	ret = __ocfs2_dx_dir_search(name, namelen, dir, dx_root, res);
+	if (ret != -ENOENT)
+		return ret;
+
+	/*
+	 * Nothing under the current hash.  The entry may have been indexed by
+	 * an older kernel, which sign-extended the name bytes when hashing.
+	 * New entries are always indexed under the unsigned hash, so only fall
+	 * back to the legacy signed one when it can actually differ: an ASCII
+	 * name hashes the same either way, and a genuine miss on one should
+	 * not have to walk the index twice.
+	 */
+	ocfs2_dx_dir_name_hash_signed(dir, name, namelen, &legacy);
+	if (legacy.major_hash == res->dl_hinfo.major_hash &&
+	    legacy.minor_hash == res->dl_hinfo.minor_hash)
+		return ret;
+
+	res->dl_hinfo = legacy;
+
+	ret = __ocfs2_dx_dir_search(name, namelen, dir, dx_root, res);
+	if (ret)
+		return ret;
+
+	pr_warn_once("ocfs2: directory index with signed name hash\n");
+
+	return 0;
+}
+
 static int ocfs2_find_entry_dx(const char *name, int namelen,
 			       struct inode *dir,
 			       struct ocfs2_dir_lookup_result *lookup)
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-deal-with-legacy-signed-xattr-name-hash-values.patch
ocfs2-reserve-metadata-for-a-new-xattr-block-and-its-value-tree.patch
ocfs2-reserve-value-tree-metadata-when-moving-an-xattr-into-the-inode.patch
ocfs2-reserve-xattr-value-tree-metadata-only-once.patch

