Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792560637;
	b=fUOAf35FUjDGo7w8MNQRS5e67qk9UJtZLWDmLhEYbHSUC4M0KsyfLpFW6dgLLa3DNC7Y
	 pxUNKuDDQ4NXBSgosRWdUwEI8tx6bufpMUcJQ6Fqplzypadk37OBE7K3/ji6TJ+C1iOiM
	 mQXoBNm4fje/REuJjzK1bKZ61sx4vWVbq5pUPBkp6IFbvSdEJRQJ9zaiKGe+I0tufpTuW
	 7NsHoSxKJ/MIVlW/5+KCVwcHuB3XYZQNlUxfQr80qbO/hkp0ffQorg7G2R3yDlUSwNwPL
	 /+x3adVfVHMElUGkP+IQHXPiLdC6cYaYQNhrsryRPr/xplUILSnggpB35+G1+qGSR+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792560637;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=8ROjgui+11qW/Bew8qIpy0A+SXcxt65fEwy0DC08lPM=;
	b=4fWfMBS6JPGw3hkJREFSDgOgUY21mlq4KWA5dzPy6XR25OrCWuGn36xeR6wSHlo4ytRV
	 tikPsR4nRDDvQ6gaxjLQGJZJnCjsz7voqbyO6kT4gBhe2XwtNEKKr+mgGjXlcgFepntE6
	 cgyGe31X64P/djuE1ZoUnW//Pt/0Hpbx/F17W6iShja0YQJgAjCe2XeSvaImNgo6gpkQh
	 rQch3FKu2bw27awCM7a/69Vh74gi6zI9tjZBeR/q5n3hnKAn/vK9wrxIcftJUYGh+gNq8
	 Bvvi3QuMS6zLe/GJye7KZnzh3gcYCHH9tEaPjiTBSGLpgM4athdPCVDSPFSEhGAQBUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QlFKN9tx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CC2606A31E;
	Wed, 21 Oct 2026 05:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QlFKN9tx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A897F1F000C9;
	Wed, 21 Oct 2026 05:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792560636;
	bh=8ROjgui+11qW/Bew8qIpy0A+SXcxt65fEwy0DC08lPM=;
	h=Date:To:From:Subject;
	b=QlFKN9tx+Rv+U2z+WKbgoXHeQrueQTH6YA3rTFns8xCouJLux71yzlxh0mwSZG1wS
	 KJKcXZPrb2iS61/4gycFaUqHxC8i8ps3SPNIg6BoVaNJAtC0E5Y85NYuDU6Acy9n7O
	 OUOMYxN3R7+KK97a/xA3n1Jg7fnzgz5Z81Xu3ft4=
Date: Tue, 20 Oct 2026 22:30:36 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,jlbec@evilplan.org,heming.zhao@suse.com,anderson.ferneda@braza.com.br,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-deal-with-legacy-signed-xattr-name-hash-values.patch removed from -mm tree
Message-Id: <20261021053036.A897F1F000C9@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: ocfs2: deal with legacy signed xattr name hash values
has been removed from the -mm tree.  Its filename was
     ocfs2-deal-with-legacy-signed-xattr-name-hash-values.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: deal with legacy signed xattr name hash values
Date: Fri, 09 Oct 2026 16:30:02 +0800

Commit 3bc753c06dd0 ("kbuild: treat char as always unsigned") set
-funsigned-char globally, which changed the result of the naked 'char'
load in ocfs2_xattr_name_hash():

	hash = (hash << OCFS2_HASH_SHIFT) ^
	       (hash >> (8*sizeof(hash) - OCFS2_HASH_SHIFT)) ^
	       *name++;

A name byte >= 0x80 used to sign-extend and now zero-extends, so the
hash no longer matches the xe_name_hash an older kernel stored.  An
indexed xattr tree is searched by that hash alone, and both the bucket
binary search and the entry scan within it stop as soon as the wanted
hash falls below an entry's, so the entry is never reached: getxattr,
setxattr and removexattr return -ENODATA for a name that listxattr
still lists.

Search with the current unsigned hash and, on a miss, retry with the
legacy signed one, as ext4 does in commit f3bbac32475b2 ("ext4: deal
with legacy signed xattr name hash values").  New entries are always
stored under the unsigned hash.  Skip the retry when the two hashes are
equal, so that a miss on an ASCII name does not walk the tree twice.

A miss is not empty handed: ocfs2_xattr_bucket_find() leaves xs->bucket
holding the bucket a new entry would go into.  So after a double miss
drop it and search once more with the unsigned hash, otherwise a new
entry would be placed by its legacy hash and stored under its unsigned
one, breaking the ordering the search relies on.

Only indexed trees are affected; inline xattrs and non-indexed xattr
blocks compare names with memcmp and never look at the hash.

Also spell out the signedness instead of leaving the current hash to
-funsigned-char, as commit 854f0912f813 ("ext4: make xattr char
unsignedness in hash explicit") did, so that both variants stay correct
if this is backported to a kernel without the flag.

Link: https://lore.kernel.org/20261009083002.2621201-4-joseph.qi@linux.alibaba.com
Fixes: 3bc753c06dd0 ("kbuild: treat char as always unsigned")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Anderson Ferneda <anderson.ferneda@braza.com.br>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org> # 6.2+
---

 fs/ocfs2/xattr.c |   93 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 82 insertions(+), 11 deletions(-)

--- a/fs/ocfs2/xattr.c~ocfs2-deal-with-legacy-signed-xattr-name-hash-values
+++ a/fs/ocfs2/xattr.c
@@ -601,9 +601,10 @@ static inline const char *ocfs2_xattr_pr
 	return handler ? xattr_prefix(handler) : NULL;
 }
 
-static u32 ocfs2_xattr_name_hash(struct inode *inode,
-				 const char *name,
-				 int name_len)
+static u32 __ocfs2_xattr_name_hash(struct inode *inode,
+				   const char *name,
+				   int name_len,
+				   bool legacy_signed)
 {
 	/* Get hash value of uuid from super block */
 	u32 hash = OCFS2_SB(inode->i_sb)->uuid_hash;
@@ -612,13 +613,30 @@ static u32 ocfs2_xattr_name_hash(struct
 	/* hash extended attribute name */
 	for (i = 0; i < name_len; i++) {
 		hash = (hash << OCFS2_HASH_SHIFT) ^
-		       (hash >> (8*sizeof(hash) - OCFS2_HASH_SHIFT)) ^
-		       *name++;
+		       (hash >> (8*sizeof(hash) - OCFS2_HASH_SHIFT));
+		if (legacy_signed)
+			hash ^= (signed char)name[i];
+		else
+			hash ^= (unsigned char)name[i];
 	}
 
 	return hash;
 }
 
+static u32 ocfs2_xattr_name_hash(struct inode *inode,
+				 const char *name,
+				 int name_len)
+{
+	return __ocfs2_xattr_name_hash(inode, name, name_len, false);
+}
+
+static u32 ocfs2_xattr_name_hash_signed(struct inode *inode,
+					const char *name,
+					int name_len)
+{
+	return __ocfs2_xattr_name_hash(inode, name, name_len, true);
+}
+
 static int ocfs2_xattr_entry_real_size(int name_len, size_t value_len)
 {
 	return namevalue_size(name_len, value_len) +
@@ -4331,11 +4349,12 @@ out:
 	return ret;
 }
 
-static int ocfs2_xattr_index_block_find(struct inode *inode,
-					struct buffer_head *root_bh,
-					int name_index,
-					const char *name,
-					struct ocfs2_xattr_search *xs)
+static int __ocfs2_xattr_index_block_find(struct inode *inode,
+					  struct buffer_head *root_bh,
+					  int name_index,
+					  const char *name,
+					  u32 name_hash,
+					  struct ocfs2_xattr_search *xs)
 {
 	int ret;
 	struct ocfs2_xattr_block *xb =
@@ -4344,7 +4363,6 @@ static int ocfs2_xattr_index_block_find(
 	struct ocfs2_extent_list *el = &xb_root->xt_list;
 	u64 p_blkno = 0;
 	u32 first_hash, num_clusters = 0;
-	u32 name_hash = ocfs2_xattr_name_hash(inode, name, strlen(name));
 
 	if (le16_to_cpu(el->l_next_free_rec) == 0)
 		return -ENODATA;
@@ -4375,6 +4393,59 @@ out:
 	return ret;
 }
 
+static int ocfs2_xattr_index_block_find(struct inode *inode,
+					struct buffer_head *root_bh,
+					int name_index,
+					const char *name,
+					struct ocfs2_xattr_search *xs)
+{
+	u32 name_hash, legacy_hash;
+	int name_len = strlen(name);
+	int ret;
+
+	name_hash = ocfs2_xattr_name_hash(inode, name, name_len);
+
+	ret = __ocfs2_xattr_index_block_find(inode, root_bh, name_index, name,
+					     name_hash, xs);
+	if (ret != -ENODATA)
+		return ret;
+
+	/*
+	 * Nothing under the current hash.  The entry may have been stored by
+	 * an older kernel, which sign-extended the name bytes when hashing.
+	 * Skip the retry when the two hashes are equal, so that a name made
+	 * only of ASCII does not have to walk the tree twice.
+	 */
+	legacy_hash = ocfs2_xattr_name_hash_signed(inode, name, name_len);
+	if (legacy_hash == name_hash)
+		return ret;
+
+	/*
+	 * A miss still leaves xs->bucket holding the bucket a new entry would
+	 * be inserted into, so drop it before searching again.
+	 */
+	ocfs2_xattr_bucket_relse(xs->bucket);
+
+	ret = __ocfs2_xattr_index_block_find(inode, root_bh, name_index, name,
+					     legacy_hash, xs);
+	if (!ret) {
+		pr_warn_once("ocfs2: xattr tree with signed name hash\n");
+		return ret;
+	}
+	if (ret != -ENODATA)
+		return ret;
+
+	/*
+	 * Not under either hash.  Restore the unsigned placement, since that
+	 * is where a new entry is stored: leaving the bucket where the legacy
+	 * hash put it would break the ordering the search relies on.
+	 */
+	ocfs2_xattr_bucket_relse(xs->bucket);
+
+	return __ocfs2_xattr_index_block_find(inode, root_bh, name_index, name,
+					      name_hash, xs);
+}
+
 static int ocfs2_iterate_xattr_buckets(struct inode *inode,
 				       u64 blkno,
 				       u32 clusters,
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are


