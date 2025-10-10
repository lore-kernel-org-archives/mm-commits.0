Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34AC433B3
	for <mm-commits@vger.kernel.org>; Fri, 10 Oct 2025 00:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760054669; cv=none; b=acxPrJk5sqz3TwfgSJGIV7QEBiQvGr+hDnNqrW2JgxhuelRv8+9u6R5BkXAmovJQ/z6MYzymmLtVXllMtftktt+DSAqzmOt9UDQPv+XqolkE86IewrzhAm0EL8RS7Eum4v1oNR1+AHoAj5v15+8G7CTGmigSQy7K8zlANeMy/NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760054669; c=relaxed/simple;
	bh=IkV16S5+IygshybNqS5ceQ+1ALNh4VaY5J8Qzerf8RQ=;
	h=Date:To:From:Subject:Message-Id; b=qBFVMVTaoBIuj2b0bjQ5fkCenUjA2Cq3uIXu9A0dBuH7ll9rkkSQPU15pvYahPZcccq0E0l39szFlut3vEwUjuJoQ4cT3LSWrhU7yZTLvfKY0LKXjIR9ykT4Mwtdm/BZZG01TS8LktUIp4Rh6crkPCkkWLZxQJF8k2J6TuD87bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qRi2PaJL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qRi2PaJL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BAEBC4CEE7;
	Fri, 10 Oct 2025 00:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760054668;
	bh=IkV16S5+IygshybNqS5ceQ+1ALNh4VaY5J8Qzerf8RQ=;
	h=Date:To:From:Subject:From;
	b=qRi2PaJLEcK3XyaQBE0qw9ItXTfFeLR1Kcas08dZ89joDZ/J353EgSx3GYv1JAEOw
	 PuLn27g2cKFGp2cmM6696ReOrd5bZXRsD6yeEZhDeufLvm/AtDBN8sV0uGMMtBvaV0
	 uDhrqHlWnG8zwe5ZenPvlSD814egaWwZMZM0s1Lg=
Date: Thu, 09 Oct 2025 17:04:27 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-add-extra-flags-check-in-ocfs2_ioctl_move_extents.patch added to mm-nonmm-unstable branch
Message-Id: <20251010000428.2BAEBC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: add extra flags check in ocfs2_ioctl_move_extents()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-add-extra-flags-check-in-ocfs2_ioctl_move_extents.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-add-extra-flags-check-in-ocfs2_ioctl_move_extents.patch

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
Subject: ocfs2: add extra flags check in ocfs2_ioctl_move_extents()
Date: Thu, 9 Oct 2025 13:23:48 +0300

In 'ocfs2_ioctl_move_extents()', add extra check whether only actually
supported flags are passed via 'ioctl(..., OCFS2_IOC_MOVE_EXT, ...)',
and reject anything beyond OCFS2_MOVE_EXT_FL_AUTO_DEFRAG and
OCFS2_MOVE_EXT_FL_PART_DEFRAG with -EINVAL. In particular,
OCFS2_MOVE_EXT_FL_COMPLETE may be set by the kernel only and
should never be passed from userspace.

Link: https://lkml.kernel.org/r/20251009102349.181126-1-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/move_extents.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/ocfs2/move_extents.c~ocfs2-add-extra-flags-check-in-ocfs2_ioctl_move_extents
+++ a/fs/ocfs2/move_extents.c
@@ -1031,6 +1031,12 @@ int ocfs2_ioctl_move_extents(struct file
 	if (range.me_threshold > i_size_read(inode))
 		range.me_threshold = i_size_read(inode);
 
+	if (range.me_flags & ~(OCFS2_MOVE_EXT_FL_AUTO_DEFRAG |
+			       OCFS2_MOVE_EXT_FL_PART_DEFRAG)) {
+		status = -EINVAL;
+		goto out_free;
+	}
+
 	if (range.me_flags & OCFS2_MOVE_EXT_FL_AUTO_DEFRAG) {
 		context->auto_defrag = 1;
 
_

Patches currently in -mm which might be from dmantipov@yandex.ru are

ocfs2-add-extra-flags-check-in-ocfs2_ioctl_move_extents.patch
ocfs2-relax-bug-to-ocfs2_error-in-__ocfs2_move_extent.patch

