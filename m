Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218D43876A1;
	Thu,  8 Oct 2026 17:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791479336; cv=none; b=ISJuM9JAAY/fVYSMgnN7bvbf77iB0tkf2iUQeBnvbZU/3zJtHeEZ4BU+rRgQDK91//l9CSHi+ebFbewrBr02mC+UWi60hZUZ8Qqi/tgi6qk1FGsyzSaz7Y9MhUoWgOk0ihyzaJyyUfyWNpYfyV8Ky5Am0faQ3/4/7Qvk8Wziop0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791479336; c=relaxed/simple;
	bh=NHFwv42+B+/cjYazOJrkFEEPIOs+Qju+W6s1FuyqHQY=;
	h=Date:To:From:Subject:Message-Id; b=pA6KbfNZQBYRgo7hLhDwHnuwfV7eGPFQOAgnELSD4JGWXop+snPUXyxcXp4aQ9XKp7PacIr1Bm+8DF+/0Wc8YX5Wd6G1FrE7zw5hMimGYqOZ+IsbpfCZnXi9aFxLD5ccvVAGV68366oWSWzJ9ACG+uZZOjgGQD+6iXYIcuyLQRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jtp7s2be; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jtp7s2be"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 982441F000FF;
	Thu,  8 Oct 2026 17:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791479334;
	bh=u3YWsQaZwzLvgafyoht6k9TnGzS6l+DIGLZMFs+sXdU=;
	h=Date:To:From:Subject;
	b=Jtp7s2beg5rAars05xbxLgHDoK0OwwIurddGANg1v4bJ8EbAGflbFuh462qGACh1g
	 oAUJt+SWjjHWHvQVsBcSK59V/l1Hs/7m4yIZ1DN6hru/7LyFtQ8IE1uzjJb/Zfl+dl
	 cwcuEiSlf8sQRn0Sohag1NVK1/QYlxMg6l2ecZmA=
Date: Thu, 08 Oct 2026 10:08:54 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,jlbec@evilplan.org,heming.zhao@suse.com,anderson.ferneda@braza.com.br,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-deal-with-legacy-signed-dir-index-name-hash-values.patch added to mm-nonmm-unstable branch
Message-Id: <20261008170854.982441F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: deal with legacy signed dir index name hash values
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-deal-with-legacy-signed-dir-index-name-hash-values.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-deal-with-legacy-signed-dir-index-name-hash-values.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Cc: Heming Zhao <heming.zhao@suse.com>
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

ocfs2-retain-all-security-xattrs-during-inode-creation.patch
ocfs2-restore-erange-check-in-ocfs2_xattr_tree_list_index_block.patch
ocfs2-fix-possible-deadlock-between-nfs_sync_rwlock-and-fs_reclaim.patch
ocfs2-deal-with-legacy-signed-dir-index-name-hash-values.patch
ocfs2-deal-with-legacy-signed-xattr-name-hash-values.patch

