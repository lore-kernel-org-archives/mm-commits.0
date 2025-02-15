Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2D13B1A2
	for <mm-commits@vger.kernel.org>; Sat, 15 Feb 2025 00:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739578018; cv=none; b=e4EPOI+tPDAPhVTobzQJv05LIAgI/5XRQuecAl0wtzBAYSnj9eEXWn5jAtSmFSlIw9KBsMwdEGxhjAmp7pFADgf1eL2WqDAN6jmmVQl07FDTTOqfux5XsY4UaDIxvw8x6HthW5C8wwUTX7hAnoHXeW68mZU8WixAU23yKCFUYtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739578018; c=relaxed/simple;
	bh=+2qFYad2RG8laU+R+EQnKAMUMsIrG/6rI6ov4AlG4hM=;
	h=Date:To:From:Subject:Message-Id; b=fibxNYGjmWcu+9+pLCb/7HzhUh9kc+BOHiHZGUp/twAMhWx5COlGUuY7MegzCHTGjgMWwmkoTCn8RYJcQ8Jr7YQwcLj62l64Vi4GfuJT75TVS3uuFxxYHrOSxpOL2Q6gJChkoGTFBowO2sbHETo46DdyZnTlV+sdVI0+kFZqtMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s0+hwwb0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s0+hwwb0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECE56C4CED1;
	Sat, 15 Feb 2025 00:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739578018;
	bh=+2qFYad2RG8laU+R+EQnKAMUMsIrG/6rI6ov4AlG4hM=;
	h=Date:To:From:Subject:From;
	b=s0+hwwb0OP+qkAaK0plb7oDtzp/2t7VeF/uB/2QioPHRXian9LoE3HOGZLbilDpS3
	 R5pQaKgulYq17s5XsrSfa21YQL05KJq5oQV+QlXR71GYE/VUGINiOUPfotuoCwRy8/
	 8vLD9TxUKKMX1UgIlVXBM7+lIVV0XVVJ96q0yg3w=
Date: Fri, 14 Feb 2025 16:06:57 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark.tinguely@oracle.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-remove-reference-to-bh-b_page.patch added to mm-nonmm-unstable branch
Message-Id: <20250215000657.ECE56C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: remove reference to bh->b_page
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-remove-reference-to-bh-b_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-remove-reference-to-bh-b_page.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: ocfs2: remove reference to bh->b_page
Date: Thu, 13 Feb 2025 21:45:31 +0000

Buffer heads are attached to folios, not to pages.  Also
flush_dcache_page() is now deprecated in favour of flush_dcache_folio().

Link: https://lkml.kernel.org/r/20250213214533.2242224-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Mark Tinguely <mark.tinguely@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/quota_global.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/quota_global.c~ocfs2-remove-reference-to-bh-b_page
+++ a/fs/ocfs2/quota_global.c
@@ -273,7 +273,7 @@ ssize_t ocfs2_quota_write(struct super_b
 	if (new)
 		memset(bh->b_data, 0, sb->s_blocksize);
 	memcpy(bh->b_data + offset, data, len);
-	flush_dcache_page(bh->b_page);
+	flush_dcache_folio(bh->b_folio);
 	set_buffer_uptodate(bh);
 	unlock_buffer(bh);
 	ocfs2_set_buffer_uptodate(INODE_CACHE(gqinode), bh);
_

Patches currently in -mm which might be from willy@infradead.org are

dax-remove-access-to-page-index.patch
dax-use-folios-more-widely-within-dax.patch
ocfs2-use-memcpy_to_folio-in-ocfs2_symlink_get_block.patch
ocfs2-remove-reference-to-bh-b_page.patch

