Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792729074;
	b=XHF2+boVf4dT9S2FvjRqJt9iLD4/QV00zdYxbYkyzxGGh7qNqLpmR+CyQ+Zkp7oN4p3r
	 VF2pE8+X5XujPpNPZWF/slbJ3NmZZg2X5j42qYt2tJmFpsHYEpZEWNog3lrZ/J6UQpx+I
	 LCrWOeveKIa6xpc3dNQHA4r2/GADreKKHGkcHDowoS0bCdF1vuQnC5pOX1uLdgV3Rr+dL
	 FlVt1sSX79ZKo2sTJD9pAeDMD4rnK2D5Y3HeI2hTwJGXt5n+PkHrtiCF+ZK7PszfmeYCf
	 NeSz6LT3stWsXh2llGjyJZ4KKWpAmL8wGdv0x82gMyMfbDklqu0nNV2RNA548ryJ8Rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792729074;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=0Zn3s06o3TEylkaX4dy3DAYUJXyr2p3krDR8s0FmyFg=;
	b=eihaGqmS3F7xWkED1hgTmomQ6deEOYM3NeivbZXUg4sXeZWzxn1aT/1J9Nbx+dJz7dL/
	 ppF98h0dUiED06qCOnCNN3TcRN/hkCH/Qn4UETW38RBARv9ytAchgatarugpOtkEFGeqf
	 13UyJ/nAJC59zfuosV/JL78jXthVy/VNesFK826XOltCQWAMiI3/vvmxs2eFppF9GLOgR
	 9SQOlnMCBzNbtqnxTeUBzaqZftvcaaafzaVA8IropSoV/Bo3bvErMUAtvH4bw9ixr1p7I
	 jLC21nTfzsPb6NbbVxG0dKoxMwFqMKLKkbrnYGLYbQLaP8INPtp+zNvlvKdp8tZAdWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=jKWJdh3W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95EE606A31F;
	Fri, 23 Oct 2026 04:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=jKWJdh3W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395831F01825;
	Fri, 23 Oct 2026 04:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792729073;
	bh=0Zn3s06o3TEylkaX4dy3DAYUJXyr2p3krDR8s0FmyFg=;
	h=Date:To:From:Subject;
	b=jKWJdh3WrXO/RURMcaln3Eq/QEkC+hiYkrD3a0zmeX5+mEjdzmdNSOcIKfgISZq9e
	 CvbWJg5dALwIYPooxRhDqW1kbAb4Wsp9ZCIQ4XgzjpjX9ZtLt5uRTbpQ+3pqkAMboh
	 xNtEfPQVcPit3aQE1VayVtw2JoAAXmfS+Qgk87hY=
Date: Thu, 22 Oct 2026 21:17:52 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,jjzuming@gmail.com,heming.zhao@suse.com,baijiaju1990@gmail.com,zzzccc427@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-snapshot-the-dentry-name-while-tracing-file-release.patch added to mm-nonmm-unstable branch
Message-Id: <20261023041753.395831F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: snapshot the dentry name while tracing file release
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-snapshot-the-dentry-name-while-tracing-file-release.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-snapshot-the-dentry-name-while-tracing-file-release.patch

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

ocfs2-drain-quorum-work-before-removing-the-cluster.patch
ocfs2-dlm-drain-join-handlers-before-releasing-module-text.patch
ocfs2-snapshot-dentry-names-in-file-and-setattr-traces.patch
ocfs2-snapshot-the-dentry-name-while-tracing-file-release.patch

