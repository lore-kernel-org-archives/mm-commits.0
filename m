Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794257579;
	b=ZHO+IPp0yy26PDFYqPTp1JTisxTsolCMr8Uf/QooTDiAXU6ESXq8rGjo+jt7cXnuC9Ir
	 YwSSah7SF581RMQCJ79erYbKIqu9/DW9ZfQOQVyilgO6bJXBWbDMwuqBcRSJovFY71294
	 nHzsf3NtXUN5I0jJ1QHYSWyGHfJ0V8CZ4ewjcApmsgQ/hiVdgRv8PTjJ1qJEWQh+hhyMo
	 D6baHAvU8s5mKQdDDsTnvKs8i8zcxlpL0SwOb4CokfiyIbIN5PtkM/q67GYgwNnEIYo38
	 4wenysIHOFm1Bf2fVER9+6ZtXdjao2YTW+QBEXFtF37yUI71+F/CydwlC3R3YS2ri3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794257579;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Xum0ddfKnRtrM+lppVzZFmN6GX6QHhCimlILj+VQo28=;
	b=s4wRvDRMWoADWX4CbW486jmDyI5A4rfE7R5tgXCIyz1vY+BgbK0uVfWW5BhUcdQOh9z/
	 SPTbJYQx9wUcKvWMJokG+rpepuNF5tce6moorWF3EQhfhdSaAm5bm9GkV6rnAgwjPoRLF
	 KKflNVHBteirlIVOf1u4W+lA36cUEfZoqYyhkdWXo80p7j5dNqDL0eQEfdlpwJxYl5W0s
	 SJz01glTtAG1nZRFxKS60NaoguxQGdzPIIZFOP1ftlzLvhWBpwuY9P2XUOmUbyBJN+f81
	 fNSgsf7uO9O9tT1yI2CiUmfPSCComUA5jYeQHmKGNdeC0fB9dW/m3qAc6l0ZMMuiRig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fZN5qG4M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80306606A31C
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 20:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fZN5qG4M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145191F0089F;
	Mon,  9 Nov 2026 20:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794257579;
	bh=Xum0ddfKnRtrM+lppVzZFmN6GX6QHhCimlILj+VQo28=;
	h=Date:To:From:Subject;
	b=fZN5qG4MNnIpgxJ8hKZ3DRedmIp96w7aTQVqc0p6RrwepRJVOtcIL+2JTnpl/TlnP
	 3ZKl5rBmsDdkaADyUKN6v+YIjKBOrhadgOcOMVsoF9w8tbHBm/TMa85F7FghAvnIkm
	 4/ceZCS0BlJYfdRiE8aSnqbmqVHLBOzBL00Kc+w0=
Date: Mon, 09 Nov 2026 12:52:58 -0800
To: mm-commits@vger.kernel.org,joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-abstract-the-inline-data-id_count-bound-check.patch added to mm-nonmm-unstable branch
Message-Id: <20261109205259.145191F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: abstract the inline data id_count bound check
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-abstract-the-inline-data-id_count-bound-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-abstract-the-inline-data-id_count-bound-check.patch

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
Subject: ocfs2: abstract the inline data id_count bound check
Date: Mon, 09 Nov 2026 20:21:01 +0800

Fold the id_count against ocfs2_max_inline_data_with_xattr() test into a
predicate.

The comparison stays signed.  ocfs2_max_inline_data_with_xattr() returns
int and subtracts the unvalidated on-disk i_xattr_inline_size from the
space available in the inode block, so it can go negative on small block
sizes.  Caching it in an unsigned local would turn a negative maximum
into a huge bound and silently accept the oversized id_count.  The
message keeps its %d for the same reason.

No functional change intended.

Link: https://lore.kernel.org/20261109122121.21473-12-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
---

 fs/ocfs2/inode.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/inode.c~ocfs2-abstract-the-inline-data-id_count-bound-check
+++ a/fs/ocfs2/inode.c
@@ -174,6 +174,19 @@ static bool ocfs2_dinode_has_inline_clus
 	return le32_to_cpu(di->i_clusters) != 0;
 }
 
+static bool ocfs2_dinode_has_oversized_inline_data(struct super_block *sb,
+						   struct ocfs2_dinode *di)
+{
+	/*
+	 * The maximum is a signed int and can go negative, because
+	 * i_xattr_inline_size is itself unvalidated.  Keep the comparison
+	 * signed: an unsigned bound would turn a negative maximum into a
+	 * huge one and let the oversized id_count through.
+	 */
+	return le16_to_cpu(di->id2.i_data.id_count) >
+		ocfs2_max_inline_data_with_xattr(sb, di);
+}
+
 void ocfs2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = OCFS2_I(inode)->ip_attr;
@@ -1747,8 +1760,7 @@ int ocfs2_validate_inode_block(struct su
 			goto bail;
 		}
 
-		if (le16_to_cpu(data->id_count) >
-		    ocfs2_max_inline_data_with_xattr(sb, di)) {
+		if (ocfs2_dinode_has_oversized_inline_data(sb, di)) {
 			rc = ocfs2_error(sb,
 					 "Invalid dinode #%llu: inline data id_count %u exceeds max %d\n",
 					 (unsigned long long)bh->b_blocknr,
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-exempt-orphaned-dinodes-from-the-zero-nlink-check.patch
ocfs2-abstract-the-zero-nlink-or-mode-dinode-check.patch
ocfs2-abstract-the-dinode-i_blkno-mismatch-check.patch
ocfs2-abstract-the-dinode-ocfs2_valid_fl-check.patch
ocfs2-abstract-the-dinode-fs_generation-mismatch-check.patch
ocfs2-abstract-the-dinode-suballoc-slot-checks.patch
ocfs2-abstract-the-dinode-suballoc-bit-check.patch
ocfs2-abstract-the-dinode-orphaned-slot-check.patch
ocfs2-abstract-the-dinode-dio-orphaned-slot-check.patch
ocfs2-abstract-the-inline-data-dinode-guard-and-cluster-check.patch
ocfs2-abstract-the-inline-data-id_count-bound-check.patch
ocfs2-abstract-the-inline-data-i_size-bound-check.patch
ocfs2-abstract-the-fast-symlink-dinode-guard-and-size-check.patch
ocfs2-abstract-the-fast-symlink-nul-termination-check.patch
ocfs2-abstract-the-chain-list-dinode-guard-and-count-check.patch
ocfs2-abstract-the-chain-list-next-free-record-check.patch
ocfs2-abstract-the-chain-list-bits-per-cluster-check.patch
ocfs2-abstract-the-dinode-refcount-location-check.patch
ocfs2-abstract-the-zero-extent-list-count-check.patch
ocfs2-abstract-the-oversized-extent-list-count-check.patch
ocfs2-abstract-the-extent-list-next-free-record-check.patch
ocfs2-report-unrepairable-corruption-from-online-filecheck-fix.patch
ocfs2-check-dinode-nlink-and-mode-in-online-filecheck.patch
ocfs2-check-dinode-suballoc-slot-in-online-filecheck.patch
ocfs2-check-dinode-suballoc-bit-in-online-filecheck.patch
ocfs2-check-dinode-orphaned-slots-in-online-filecheck.patch
ocfs2-check-inline-data-dinodes-in-online-filecheck.patch
ocfs2-check-fast-symlink-dinodes-in-online-filecheck.patch
ocfs2-check-chain-list-dinodes-in-online-filecheck.patch
ocfs2-check-dinode-refcount-location-in-online-filecheck.patch
ocfs2-check-extent-list-dinodes-in-online-filecheck.patch

