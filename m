Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E8D14B96E
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762908562; cv=none; b=tOyHCRi4WPYhKyBfggr7x0vnFBiUT3ZzRGOiIf1U69kLiCekV7wqukfCbcfHYLr8Ca/oNAGPw2vcep6Ob44PNe7GmGKn8D6dalzip04z9qCbdPxTJ2jSZaJ9zjnuS+v1vThrIxHVEp74D5FLdTjZchAV9ZR6S4Z/qEhOqkSMRCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762908562; c=relaxed/simple;
	bh=upYp1EP8EoZQ24qMSOVuh2A993ul8LpXOdr2AmvZHx4=;
	h=Date:To:From:Subject:Message-Id; b=KWewHrqocTo0iHy+zRRXz8U1Jxh2yQcXPGKkaZSwH9EqqOnf8J0SmYsTA6tRbzihAKVaptsWf2ZZRnIOYa+V785hf2NEiSR3tAlCRGweyVngXQGXTDQGqL/MEl3wfYoFVXiSLl2JQzDG4baU7ghJsPPY0yNfv9AjpW1dkFi0AMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VE+Bx2Dp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VE+Bx2Dp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E848C4CEFB;
	Wed, 12 Nov 2025 00:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762908562;
	bh=upYp1EP8EoZQ24qMSOVuh2A993ul8LpXOdr2AmvZHx4=;
	h=Date:To:From:Subject:From;
	b=VE+Bx2DpeuIEHFmWAX6yGAY46eQ91sANWmo4uvdVUwSpBDVNay3gQAIbk0yJZvhvk
	 ltSAJULBIl6iXxImxfIRHfwYaxTuZfjE0WQuxnqPm+QK1L6uaQuvhyhnGCH26gL8KL
	 pyyuCV+Z/dkfCM6THx78yT5lmoKApf9qzL1pJujI=
Date: Tue, 11 Nov 2025 16:49:21 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-add-extra-flags-check-in-ocfs2_ioctl_move_extents.patch removed from -mm tree
Message-Id: <20251112004922.1E848C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: add extra flags check in ocfs2_ioctl_move_extents()
has been removed from the -mm tree.  Its filename was
     ocfs2-add-extra-flags-check-in-ocfs2_ioctl_move_extents.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1036,6 +1036,12 @@ int ocfs2_ioctl_move_extents(struct file
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

ocfs2-add-extra-consistency-checks-for-chain-allocator-dinodes.patch

