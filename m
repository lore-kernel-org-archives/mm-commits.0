Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13FE35950
	for <mm-commits@vger.kernel.org>; Fri, 10 Oct 2025 00:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760054670; cv=none; b=rxbzgtDsCEvvTaGsIx6beC30tuh5dvTAEgXJmq2NOmMsVXAsG4Hym4moLcnmatFYPL9QyflgcS/Nk8X3uiG8WIG5Z9DWtAiarVmhIuIsrPvi0t2Ah3e4A3+pGlOOyxWrEEn/5EgHlFjSOy8FUiFQAO6Jh7YNYTL1aBfE8bRea5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760054670; c=relaxed/simple;
	bh=/rXy9kjffDK4XmHFHtnO2hBLwXLpWXY2kRAEzzCMIg0=;
	h=Date:To:From:Subject:Message-Id; b=qxHI/M3VttomH/vax8oWzCT/7KMpqqzdt/h8IaTdNvNEBsvHlK5YiHpciVe115DtQJb6gCrrcxgbxmkT6nf0UKacu3GEdmnPQyRmrndnh3xdwWDxXDngKXQVWmQJmd3rG1IGUtSuHbDRmTRB+hWnE4vttAQzmWQva9pEmJ2hkP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZzoeIp0V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZzoeIp0V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26EE7C4CEE7;
	Fri, 10 Oct 2025 00:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760054670;
	bh=/rXy9kjffDK4XmHFHtnO2hBLwXLpWXY2kRAEzzCMIg0=;
	h=Date:To:From:Subject:From;
	b=ZzoeIp0VuDYw3YNur2Ksv/K0/J7kjliIsu+yOJeFCfByFNLCW29u1WOfr7cETP0wA
	 2Vclnqnh4/OziYHtegT/t0OHJpMIZAamZqfqcti1HjcIEs4oDhnsJssDOp/bgxd5zU
	 TV+SWboYSOJB1FeBDe0o22v0Q0rR9c39siUguB7g=
Date: Thu, 09 Oct 2025 17:04:29 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-relax-bug-to-ocfs2_error-in-__ocfs2_move_extent.patch added to mm-nonmm-unstable branch
Message-Id: <20251010000430.26EE7C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: relax BUG() to ocfs2_error() in __ocfs2_move_extent()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-relax-bug-to-ocfs2_error-in-__ocfs2_move_extent.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-relax-bug-to-ocfs2_error-in-__ocfs2_move_extent.patch

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
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: ocfs2: relax BUG() to ocfs2_error() in __ocfs2_move_extent()
Date: Thu, 9 Oct 2025 13:23:49 +0300

In '__ocfs2_move_extent()', relax 'BUG()' to 'ocfs2_error()' just
to avoid crashing the whole kernel due to a filesystem corruption.

Fixes: 8f603e567aa7 ("Ocfs2/move_extents: move a range of extent.")
Link: https://lkml.kernel.org/r/20251009102349.181126-2-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>Closes: https://syzkaller.appspot.com/bug?extid=727d161855d11d81e411
Reported-by: syzbot+727d161855d11d81e411@syzkaller.appspotmail.com
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/move_extents.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/move_extents.c~ocfs2-relax-bug-to-ocfs2_error-in-__ocfs2_move_extent
+++ a/fs/ocfs2/move_extents.c
@@ -98,7 +98,13 @@ static int __ocfs2_move_extent(handle_t
 
 	rec = &el->l_recs[index];
 
-	BUG_ON(ext_flags != rec->e_flags);
+	if (ext_flags != rec->e_flags) {
+		ret = ocfs2_error(inode->i_sb,
+				  "Inode %llu has corrupted extent %d with flags 0x%x at cpos %u\n",
+				  (unsigned long long)ino, index, rec->e_flags, cpos);
+		goto out;
+	}
+
 	/*
 	 * after moving/defraging to new location, the extent is not going
 	 * to be refcounted anymore.
_

Patches currently in -mm which might be from dmantipov@yandex.ru are

ocfs2-add-extra-flags-check-in-ocfs2_ioctl_move_extents.patch
ocfs2-relax-bug-to-ocfs2_error-in-__ocfs2_move_extent.patch

