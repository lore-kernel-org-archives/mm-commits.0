Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0585303C88
	for <mm-commits@vger.kernel.org>; Sun, 21 Dec 2025 19:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766344355; cv=none; b=RL3QZhEGOoACjhYm1pX4EsQZMN1jDoMhjGFi8bC/zUkT0h9CCZ0xNflMS6F1TbRH79WXLrv7PfaNVp4YsQ0nDllrfjSN+opCTgsppfbyvA1F1xKUj5KuLCm2b442p/NjsvwzmrWSzimTSxXdkf+NbhTlFvZjr5Rhxk8hSn9hSD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766344355; c=relaxed/simple;
	bh=VoILMKEju0iBmtv/dd6aRHGT4cm2Fxn+/ES8paj4+kE=;
	h=Date:To:From:Subject:Message-Id; b=JZpzRb5XnJsg8YP2Tk4ChnGty67sNvwuDPM93Ei9c6XQhlrPrQl31hkJKnvdCY6EpwUeLn+tHmshjuLnPc9lo72dwxyUIR50hd2fjzCurqChgcNZtxId48df+CLcO8sljE0LXQ1lbnaqFIWX0T2Un8GUa1eqWGPKkmRBAl/wEQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KyfjnqLv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KyfjnqLv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4146EC4CEFB;
	Sun, 21 Dec 2025 19:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766344355;
	bh=VoILMKEju0iBmtv/dd6aRHGT4cm2Fxn+/ES8paj4+kE=;
	h=Date:To:From:Subject:From;
	b=KyfjnqLvk+3lQIYZK1UXgAmw4N/Ztp5vUREbuG0VBV7nGrfYoU//uFpHHdXdvhlqS
	 wjqcqt+LGBqA0j+ZK3WiaCs8mfPRvYYUTakA0loin7UptYYm7d/BkNviox7HvC8qVH
	 6v7R0nUyuWZ6cSdtHqX2FeMXKNIXc9Tka9hLrUF0=
Date: Sun, 21 Dec 2025 11:12:34 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,jiangqi903@gmail.com,heming.zhao@suse.com,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-annotate-more-flexible-array-members-with-__counted_by_le.patch added to mm-nonmm-unstable branch
Message-Id: <20251221191235.4146EC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: annotate more flexible array members with __counted_by_le()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-annotate-more-flexible-array-members-with-__counted_by_le.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-annotate-more-flexible-array-members-with-__counted_by_le.patch

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
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: ocfs2: annotate more flexible array members with __counted_by_le()
Date: Tue, 21 Oct 2025 13:55:18 +0300

Annotate flexible array members of 'struct ocfs2_local_alloc' and 'struct
ocfs2_inline_data' with '__counted_by_le()' attribute to improve array
bounds checking when CONFIG_UBSAN_BOUNDS is enabled, and prefer the
convenient 'memset()' over an explicit loop to simplify
'ocfs2_clear_local_alloc()'.

Link: https://lkml.kernel.org/r/20251021105518.119953-1-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/localalloc.c |    4 +---
 fs/ocfs2/ocfs2_fs.h   |    4 ++--
 2 files changed, 3 insertions(+), 5 deletions(-)

--- a/fs/ocfs2/localalloc.c~ocfs2-annotate-more-flexible-array-members-with-__counted_by_le
+++ a/fs/ocfs2/localalloc.c
@@ -905,13 +905,11 @@ bail:
 static void ocfs2_clear_local_alloc(struct ocfs2_dinode *alloc)
 {
 	struct ocfs2_local_alloc *la = OCFS2_LOCAL_ALLOC(alloc);
-	int i;
 
 	alloc->id1.bitmap1.i_total = 0;
 	alloc->id1.bitmap1.i_used = 0;
 	la->la_bm_off = 0;
-	for(i = 0; i < le16_to_cpu(la->la_size); i++)
-		la->la_bitmap[i] = 0;
+	memset(la->la_bitmap, 0, le16_to_cpu(la->la_size));
 }
 
 #if 0
--- a/fs/ocfs2/ocfs2_fs.h~ocfs2-annotate-more-flexible-array-members-with-__counted_by_le
+++ a/fs/ocfs2/ocfs2_fs.h
@@ -641,7 +641,7 @@ struct ocfs2_local_alloc
 	__le16 la_size;		/* Size of included bitmap, in bytes */
 	__le16 la_reserved1;
 	__le64 la_reserved2;
-/*10*/	__u8   la_bitmap[];
+/*10*/	__u8   la_bitmap[] __counted_by_le(la_size);
 };
 
 /*
@@ -654,7 +654,7 @@ struct ocfs2_inline_data
 				 * for data, starting at id_data */
 	__le16	id_reserved0;
 	__le32	id_reserved1;
-	__u8	id_data[];	/* Start of user data */
+	__u8	id_data[] __counted_by_le(id_count);	/* Start of user data */
 };
 
 /*
_

Patches currently in -mm which might be from dmantipov@yandex.ru are

ocfs2-adjust-ocfs2_xa_remove_entry-to-match-ubsan-boundary-checks.patch
ocfs2-annotate-more-flexible-array-members-with-__counted_by_le.patch

