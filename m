Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01EFE1754B
	for <mm-commits@vger.kernel.org>; Tue,  8 Jul 2025 02:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751940533; cv=none; b=Zvy3jLu312XToLelwCxy/m8Wb0KLKBr/GNic+2Y/kofWA+GqCl4dZPjh3YwBinNASrDUCC+M2BN+h3ghsZ97PMIzBDIZHm1mwMX9X6LznRMzdsmsAJQEvBmBa6zi+rkobosS+q/4dmXI173sJb2y4KrONYlhPRL+YjM53Ip5bmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751940533; c=relaxed/simple;
	bh=IXnG3dRYLjHXShj4ky3R2r181HYlVPWWprrrFeVad44=;
	h=Date:To:From:Subject:Message-Id; b=AQzp0k390wRieNraiNl1TOX1b1V+Tc4Nu/1L6Xy1RaFduCahKe3hIg2hF1XR6wEuVI7osi2z0kZhHU2c4qWrrq5xmd5a73SPk7jIlMVCM3Ge+LkAKUF0yheL3Xm4BAsNJBfEh0mt3JkS6kVM2BDkJEFm1CZpmGV0pKnhUUs4Fwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y5UAZTXn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y5UAZTXn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77425C4CEE3;
	Tue,  8 Jul 2025 02:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751940532;
	bh=IXnG3dRYLjHXShj4ky3R2r181HYlVPWWprrrFeVad44=;
	h=Date:To:From:Subject:From;
	b=y5UAZTXngFH52corq3viOMpLAFW6ARAStdd3kMfCH72B2CKRvhMz3AtTx5wiuJpwZ
	 oGhWGF8aSYSs1jRTbKZLgE+YXltGDa+sHoBZl6lEm8nhht+mlj+RjvMqx+NtPlpMlz
	 lseMNlhZxzEGFGxlMnIscp//p2eTTSp8sp7uSMVA=
Date: Mon, 07 Jul 2025 19:08:41 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,ipravdin.official@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-avoid-null-pointer-dereference-in-dx_dir_lookup_rec.patch added to mm-nonmm-unstable branch
Message-Id: <20250708020852.77425C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: avoid NULL pointer dereference in dx_dir_lookup_rec()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-avoid-null-pointer-dereference-in-dx_dir_lookup_rec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-avoid-null-pointer-dereference-in-dx_dir_lookup_rec.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Ivan Pravdin <ipravdin.official@gmail.com>
Subject: ocfs2: avoid NULL pointer dereference in dx_dir_lookup_rec()
Date: Mon, 7 Jul 2025 20:10:09 -0400

When a directory entry is not found, ocfs2_dx_dir_lookup_rec() prints an
error message that unconditionally dereferences the 'rec' pointer. 
However, if 'rec' is NULL, this leads to a NULL pointer dereference and a
kernel panic.

Add an explicit check empty extent list to avoid dereferencing NULL
'rec' pointer.

Link: https://lkml.kernel.org/r/20250708001009.372263-1-ipravdin.official@gmail.com
Reported-by: syzbot+20282c1b2184a857ac4c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/67cd7e29.050a0220.e1a89.0007.GAE@google.com/
Signed-off-by: Ivan Pravdin <ipravdin.official@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ocfs2/dir.c~ocfs2-avoid-null-pointer-dereference-in-dx_dir_lookup_rec
+++ a/fs/ocfs2/dir.c
@@ -798,6 +798,14 @@ static int ocfs2_dx_dir_lookup_rec(struc
 		}
 	}
 
+	if (le16_to_cpu(el->l_next_free_rec) == 0) {
+		ret = ocfs2_error(inode->i_sb,
+				  "Inode %lu has empty extent list at depth %u\n",
+				  inode->i_ino, 
+				  le16_to_cpu(el->l_tree_depth));
+		goto out;
+	}
+
 	found = 0;
 	for (i = le16_to_cpu(el->l_next_free_rec) - 1; i >= 0; i--) {
 		rec = &el->l_recs[i];
_

Patches currently in -mm which might be from ipravdin.official@gmail.com are

ocfs2-avoid-null-pointer-dereference-in-dx_dir_lookup_rec.patch

