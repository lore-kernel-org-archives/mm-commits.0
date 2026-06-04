Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB263BBFAD
	for <mm-commits@vger.kernel.org>; Thu,  4 Jun 2026 21:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780609810; cv=none; b=rJ0UdGrg7rvShiFbqKAyDcbDbwgoWVN/mhz42tsr54QQITjncGHT9doJ6KROvtTg2Tq8ocqzL8O/z0NDBOunc4e7QQgf8TcFzHYfXG31hOkaxx9bR6IXlAH7XagD2of3g7YfAn4BCRHlW66EFaK43BehaePZy25LMVaGMLh4Tfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780609810; c=relaxed/simple;
	bh=QB4SWUgLauDZjiyGNSMlwTftQsBESN48Qhz1CyNEQSY=;
	h=Date:To:From:Subject:Message-Id; b=koGJ7dTzpSBZGAy7GuN5PD/3/gOPl5K64AiKWclCJiv6Lg5aJEbl29olf4pxkyDI4gMhoMM6TrQ6WlhIf6Oh0Hdws0yIBIFf3vKEj1S46TZacHUvv26Hf8QOIAlOplxM9eVMJIbq4OOLts3Yk2QyQuvx2yCAJ65IPAPttnGcYo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=llHUO+CQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="llHUO+CQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C9731F00899;
	Thu,  4 Jun 2026 21:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780609809;
	bh=dcUeVc79hX3P99uHNcWaFg3DXc6t/uflZFGqPCAuKDg=;
	h=Date:To:From:Subject;
	b=llHUO+CQS7EaFwNIOfL6dT5SiMimfS/uHI2foQJsBr98tpWYACxlWWZ55Lv1tNpPH
	 2FsV6fZC/CArtwxl79zru+Vw6S2Spkynr4ch3VRcr+L7b5vw/mFId1ClqpXgGUpkJ5
	 1piinIeDaykoa6W2BnZEtKT/9NtwOXxUUaECQA/0=
Date: Thu, 04 Jun 2026 14:50:08 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-fix-buffer-head-management-in-ocfs2_read_blocks.patch removed from -mm tree
Message-Id: <20260604215009.2C9731F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix buffer head management in ocfs2_read_blocks()
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-buffer-head-management-in-ocfs2_read_blocks.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: ocfs2: fix buffer head management in ocfs2_read_blocks()
Date: Fri, 29 May 2026 12:41:28 +0300

In ocfs2_read_blocks(), caller should't assume that buffer head returned
by 'sb_getblk()' is exclusively owned and so 'put_bh()' always drops
b_count from 1 to 0.  If it is not so, buffer head remains on hold and
likely to be returned by the next call to 'sb_getblk()' unchanged - that
is, with BH_Uptodate bit set even if it has failed validation previously,
thus allowing to insert that buffer head into OCFS2 metadata cache and
submit it to upper layers.  To avoid such a scenario, BH_Uptodate should
be cleared immediately after 'validate()' callback has detected some data
inconsistency.

Link: https://lore.kernel.org/20260529094128.494293-1-dmantipov@yandex.ru
Fixes: cf76c78595ca ("ocfs2: don't put and assigning null to bh allocated outside")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reported-by: syzbot+caacd220635a9cc3bac9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=caacd220635a9cc3bac9
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/buffer_head_io.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/ocfs2/buffer_head_io.c~ocfs2-fix-buffer-head-management-in-ocfs2_read_blocks
+++ a/fs/ocfs2/buffer_head_io.c
@@ -350,8 +350,6 @@ read_failure:
 						wait_on_buffer(bh);
 					put_bh(bh);
 					bhs[i] = NULL;
-				} else if (bh && buffer_uptodate(bh)) {
-					clear_buffer_uptodate(bh);
 				}
 				continue;
 			}
@@ -380,8 +378,11 @@ read_failure:
 				BUG_ON(buffer_jbd(bh));
 				clear_buffer_needs_validate(bh);
 				status = validate(sb, bh);
-				if (status)
+				if (status) {
+					if (buffer_uptodate(bh))
+						clear_buffer_uptodate(bh);
 					goto read_failure;
+				}
 			}
 		}
 
_

Patches currently in -mm which might be from dmantipov@yandex.ru are


