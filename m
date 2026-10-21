Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792560635;
	b=o/QhoxC3ORN05ykDlN4K/RNY/v4FkAsAC8xwva0Xl8A1uezHayfoobjLpC9Ol44ZWQRG
	 WfMC48eEH4/d05bMO3dr/jD4WaBNVHnzyZfKCkwGRzehD+PttiPTq/PqI8iCsQT1VoLe3
	 t8nSIeLA7uleTgv+lqDkewjpAeZqFSC0yKy3I7Y48HKqA26Ci/1ML5ASsakdwMU9BSrih
	 yLkMJVdQPrEeILhy8+3C//RneALlMHcS+25rhIiMRMKYpJNkE9vR0TqrrFI3z+rpsQ7ad
	 GKshs5qqy1p52nYgxKZKfu4nlqwoFvZ7aedPWraP1kZWvIswggM0lKkcel8ZT6Kb4Iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792560635;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=MRI+B7/007kEsDDijS1yz+rlc/cNjX6TPK7WcBreGZM=;
	b=VX1LeQv0PRRXQcmSB4rlUOWGxJ6HmR7JV3ynEHKb0ysblkR8ewkQFvu5kyYUN4D4Zg18
	 sq+W2ZLJmC9ATrE7Z9Gc9GjVUNGc9neMWqZx1bRKWrTIv0lKpCp/HygCUDNA56++LShA1
	 v6HFk4I14lCJrH0hTNSUaDlB6IawpldSkLhF/leWi1z1X6fEgpncktJ8QV7K5IqsckDGy
	 5FKSELkPKo3vrIMWQbUHyRGtSXupH40OCEtDjZU/t4KnROmiz5BwRg7xRc1DLSFjlhMYS
	 +jAgzq8pGQX7L0S9HWRMn8grOlaAlooCaK9F2UHliRkVf3lnykVRxRdJsnWORTrtWjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0BvZADoN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52E0606A31C;
	Wed, 21 Oct 2026 05:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0BvZADoN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37CED1F000C9;
	Wed, 21 Oct 2026 05:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792560634;
	bh=MRI+B7/007kEsDDijS1yz+rlc/cNjX6TPK7WcBreGZM=;
	h=Date:To:From:Subject;
	b=0BvZADoNwpVRHHeYey82fIhQxDK2b89qoZ0OTE3R8T6vXC3etiYKWdm+NAUVcbwhr
	 c1/nvB0ih8G2/1KLRPk+q8t2BNwaPD0u0WCVOfj12IoLfAbBmopPDl0Bsvaper+EiM
	 +vJj0IImLdaiBCQxSiBWwzCgbIxqxMGqpGoMA+V0=
Date: Tue, 20 Oct 2026 22:30:33 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,jlbec@evilplan.org,heming.zhao@suse.com,anderson.ferneda@braza.com.br,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-deal-with-legacy-signed-dir-index-name-hash-values.patch removed from -mm tree
Message-Id: <20261021053034.37CED1F000C9@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: ocfs2: deal with legacy signed dir index name hash values
has been removed from the -mm tree.  Its filename was
     ocfs2-deal-with-legacy-signed-dir-index-name-hash-values.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: deal with legacy signed dir index name hash values
Date: Fri, 09 Oct 2026 16:30:00 +0800

Patch series "ocfs2: deal with legacy signed name hash values", v2.

Commit 3bc753c06dd0 ("kbuild: treat char as always unsigned") turned on
-funsigned-char globally, which changed the result of two naked 'char'
loads in ocfs2 hashing code:

	str2hashbuf()            val = msg[i] + (val << 8);
	ocfs2_xattr_name_hash()  hash = (hash << 5) ^ (hash >> 27) ^ *name++;

A name byte >= 0x80 used to sign-extend and now zero-extends.  Both
results are written to disk, the first into the dx leaf when a directory
entry is indexed and the second into xe_name_hash when an xattr is
stored, so anything written by a pre-6.2 kernel is looked up under a
different hash and is no longer found.  readdir and listxattr still list
those names because neither of them hashes, which makes this look like
the filesystem losing entries rather than like a lookup bug.  Anderson
Ferneda reported it that way for directories with non-ASCII names [1].

Patches 1 and 3 do what ext4 did in commit f3bbac32475b2 ("ext4: deal
with legacy signed xattr name hash values"): look up with the current
unsigned hash, retry with the legacy signed one on a miss, and always
store new entries under the unsigned hash.  The retry is skipped when the
two hashes come out equal, so an ASCII name does not walk the index
twice.  Both hash functions now spell out the signedness instead of
leaving it to -funsigned-char, as commit 854f0912f813 ("ext4: make xattr
char unsignedness in hash explicit") did, so a backport to a kernel
without the flag still computes both variants correctly.

Patch 2 is a separate fix, placed before patch 3 so that every commit in
the series is correct on its own.  ocfs2_check_xattr_bucket_collision()
recomputes the hash of the name to decide whether splitting a full bucket
can make room for the entry being set.  That is right for a new entry and
wrong for one that already exists, since an update leaves xe_name_hash
alone.  Against a bucket holding legacy hashes the comparison does not
match, so the split goes ahead and cannot help: a bucket whose entries
all share one hash has no divide position.  How that ends depends on
where the unsigned hash sorts.  Below the legacy ones, the set fails with
-ENOSPC after growing the tree for nothing.  Above them, it lands in the
empty bucket the split just appended and stores a second copy of the
entry there while the original stays behind, so listxattr reports the
name twice.  Using the stored hash closes both.

Nothing retires a legacy hash at runtime.  Deleting or updating an entry
does not rewrite it, and the only code that rehashes existing dirents is
ocfs2_expand_inline_dir() on the inline to extent conversion, so the
retry stays for as long as the legacy entries do.  Rebuilding the index
offline is what removes it for good.


This patch (of 3):

Commit 3bc753c06dd0 ("kbuild: treat char as always unsigned") set
-funsigned-char globally, which changed the result of the naked 'char'
load in str2hashbuf():

	val = msg[i] + (val << 8);

A name byte >= 0x80 used to sign-extend and now zero-extends, so
ocfs2_dx_dir_name_hash() computes a different hash pair for every name
containing one.  The pair is written into the dx leaf when the entry is
created, so an index built by an older kernel no longer matches and
ocfs2_dx_dir_search() returns -ENOENT for a name that readdir still
lists.

Search with the current unsigned hash and, on a miss, retry with the
legacy signed one, as ext4 does in commit f3bbac32475b2 ("ext4: deal
with legacy signed xattr name hash values").  New entries are always
indexed under the unsigned hash.  Skip the retry when the two hashes
are equal, so that a miss on an ASCII name does not walk the index
twice.

The retry costs a second walk of the dx tree, so a negative lookup of a
name containing a byte >= 0x80 does twice the work.  That is bounded and
worth it, and directories whose dx root is still inline pay nothing
extra, since there the retry only rescans the root block that is already
loaded.  Nothing retires it at runtime: a legacy entry keeps its legacy
hash, because neither deleting nor updating an entry rewrites the dx
hash, and the only code that rehashes existing dirents is
ocfs2_expand_inline_dir() on the inline to extent conversion.
Rebuilding the index offline is what removes the cost for good.

Also spell out the signedness in str2hashbuf() instead of leaving the
current hash to -funsigned-char, as commit 854f0912f813 ("ext4: make
xattr char unsignedness in hash explicit") did, so that both variants
stay correct if this is backported to a kernel without the flag.

Link: https://lore.kernel.org/20261009083002.2621201-1-joseph.qi@linux.alibaba.com
Link: https://lore.kernel.org/20261009083002.2621201-2-joseph.qi@linux.alibaba.com
Fixes: 3bc753c06dd0 ("kbuild: treat char as always unsigned")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Anderson Ferneda <anderson.ferneda@braza.com.br>
Closes: https://lore.kernel.org/ocfs2-devel/CP5P284MB2780AC2C3C2AB2CF2B6CB7AFBE942@CP5P284MB2780.BRAP284.PROD.OUTLOOK.COM/
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


