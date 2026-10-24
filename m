Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792828041;
	b=i0P9IuA4nf8sihgwy+7++chd/gx8tHnBW26jVSsvjFZp00WIwE2ub36ivrpZvQtFgWnt
	 wm0lFjjqprrQsyxvFbXKewBwVmt3gHi5BtjzOn3xnBeBKPD/fvS3EnKG5YnvTgOVXSarG
	 D6kYg1YkVmAyVDQZ+79QD8dEdK/Clxd/RIcT+mEXlS+xCz9DVeppYxYkx3+xbfIKV0Lgt
	 ffyw2zDB28RIQ873Z0clNVPwG+lpZtLxnnJhIvWrcWOe2xLjPhyuIE3D4iFm11eFsPPGE
	 oITYc+VYLvqAlloAlq0tN27QnWCokovBvJtzgrg14UAoMIcLY03Ew4zLFn+A7pOo4+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792828041;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=N7ZsX50IR/85t5Cyzpn99Kf6RbbDa2lp0xY+S9poOq0=;
	b=afxpZAdoOBYlu3tWqaeIM6F1Uac3ehMtjCs49mKgDhL9VsV+EmtrRa9lc32lcstrj9u5
	 yceYIi+1HobwXpwyXRE2ZkhViLT43mHorexDH3nPcDpPjrH9epdga3UFuxaGxX1aOO9Bi
	 qssBLp5qm8788+nEfL4tJLq7E+RlY3+8gWKx5lLs0m+vDRMed6/vRmdOTqk6uvLIUuWHh
	 aurSy4wMDj6fH7rGBDJqcq4E8WUJaWjoJ1l7pp6hOl0eziS0ezddq2emeC1OgzXyCVrNI
	 IL8jScR42+Ie1uzQeQ3lCBtitYhCJskXaC6fjir2phgdU86DW86d2/HKa/H2T7Fkbog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0T+JxBJn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDA3606A320;
	Sat, 24 Oct 2026 07:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0T+JxBJn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 977A61F01825;
	Sat, 24 Oct 2026 07:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792828040;
	bh=N7ZsX50IR/85t5Cyzpn99Kf6RbbDa2lp0xY+S9poOq0=;
	h=Date:To:From:Subject;
	b=0T+JxBJnrnnF1VgALlnTXEHq5ozav3ctt0Ci0502vVK4g9+uuuCJ44/Ej3BiP9v+h
	 jV9hPedYfJruttjDY2XL7KOWnXwgTkZMV5Z6FXlRErRXTWuwwhKPbPyqhtGt75iRbj
	 0jnvA4lR2XJMi2TlpXmXpQWqjv+ZQ1jV73NROeIA=
Date: Sat, 24 Oct 2026 00:47:20 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,jjzuming@gmail.com,heming.zhao@suse.com,baijiaju1990@gmail.com,zzzccc427@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-snapshot-the-dentry-name-while-tracing-file-release.patch removed from -mm tree
Message-Id: <20261024074720.977A61F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: ocfs2: snapshot the dentry name while tracing file release
has been removed from the -mm tree.  Its filename was
     ocfs2-snapshot-the-dentry-name-while-tracing-file-release.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Cen Zhang <zzzccc427@gmail.com>
Subject: ocfs2: snapshot the dentry name while tracing file release
Date: Thu, 22 Oct 2026 17:08:42 +0800

ocfs2_file_release() passes the live dentry name and length to a trace
event while holding oi->ip_lock. This lock protects the open count and
delays RCU reclamation of external names, but it does not serialize name
changes during rename. The dentry can switch between inline and external
names, and a separately loaded length can describe a different name.

The ocfs2__file_ops event sizes and copies its __string separately.
A concurrently rewritten inline name need not remain consistent between
those operations. External names can also be selected at this call site;
the existing spinlock critical section protects their allocation lifetime,
while a snapshot additionally pairs a stable name with its length.

Take a name snapshot before acquiring oi->ip_lock and release it after
dropping the lock. Keep the trace call and open-count argument inside
the original critical section. Cache the event-enabled check so the
snapshot stays paired even if tracing is toggled meanwhile.

Link: https://lore.kernel.org/pm-ocfs2-objects-candidate-0088-v7-6324344256f0c3b1c3d8-2@gmail.com
Fixes: 468eedde23d6 ("ocfs2: Remove mlog(0) from fs/ocfs2/file.c")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Assisted-by: LLM
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <jjzuming@gmail.com>
Cc: <stable@vger.kernel.org>
---

 fs/ocfs2/file.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/fs/ocfs2/file.c~ocfs2-snapshot-the-dentry-name-while-tracing-file-release
+++ a/fs/ocfs2/file.c
@@ -141,18 +141,26 @@ leave:
 static int ocfs2_file_release(struct inode *inode, struct file *file)
 {
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct dentry *dentry = file->f_path.dentry;
+	struct name_snapshot name;
+	bool trace_enabled = trace_ocfs2_file_release_enabled();
+
+	if (trace_enabled)
+		take_dentry_name_snapshot(&name, dentry);
 
 	spin_lock(&oi->ip_lock);
 	if (!--oi->ip_open_count)
 		oi->ip_flags &= ~OCFS2_INODE_OPEN_DIRECT;
 
-	trace_ocfs2_file_release(inode, file, file->f_path.dentry,
-				 oi->ip_blkno,
-				 file->f_path.dentry->d_name.len,
-				 file->f_path.dentry->d_name.name,
-				 oi->ip_open_count);
+	if (trace_enabled)
+		trace_ocfs2_file_release(inode, file, dentry,
+					 oi->ip_blkno, name.name.len,
+					 name.name.name, oi->ip_open_count);
 	spin_unlock(&oi->ip_lock);
 
+	if (trace_enabled)
+		release_dentry_name_snapshot(&name);
+
 	ocfs2_free_file_private(inode, file);
 
 	return 0;
_

Patches currently in -mm which might be from zzzccc427@gmail.com are

ocfs2-cluster-remove-zero-address-nodes-from-ip-tree-on-teardown.patch

