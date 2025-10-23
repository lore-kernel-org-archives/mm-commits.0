Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755611990D9
	for <mm-commits@vger.kernel.org>; Thu, 23 Oct 2025 23:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761262321; cv=none; b=C9I6+HsWWJ57N5kWEB27ttrNct1FZVt88eNtUnf6l9TWVcOcog6RRwiKAw06JcHpm0Yd7QN638RiIzTXlg4rKeH69YDj7wMRrhiuKjBZYhkK/rlDh/6VK8d9TbQW3EiIO7NRU5V+drPDxi1tym9V6TPcvhPaWenFt1bsXIwSvVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761262321; c=relaxed/simple;
	bh=BnpRUwu/YumcXiKHIGwSQL/XsSynO2iyhZG8idL+K+o=;
	h=Date:To:From:Subject:Message-Id; b=NVYET7uOs8TRVmALLctph7Sy6aSvxhIwiJJsnAHOGF/HVwGmSvomsce6dOF/TU0GjjJd1smsByYVW+8Us1jUbQ+CeFlm6uydZn7GvOpoPJBfBC8joF/XGC02ecUe1/WiK9Q6IBNzYJW06oJPd+wdM31wTU4i+L6ToXSUQa0QW00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IuYIMzDo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IuYIMzDo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EECC4CEE7;
	Thu, 23 Oct 2025 23:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761262320;
	bh=BnpRUwu/YumcXiKHIGwSQL/XsSynO2iyhZG8idL+K+o=;
	h=Date:To:From:Subject:From;
	b=IuYIMzDoNkZuWzw/R78aFhutDn9Q8mUkjLoh++MYhT0fNjvaDbJPo568B2Xc317VT
	 5+o5YP1+V2b0kaaphjHdmuNC+E0c1fGAGgs4y+Z0YYM2yvlhNrKw+N38ZACgaj1kaD
	 H1zfQLgkOKA6BVGXBtO0iWZ6+0nIggFfOk1XNywY=
Date: Thu, 23 Oct 2025 16:31:59 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,jiangqi903@gmail.com,heming.zhao@suse.com,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-add-boundary-check-to-ocfs2_check_dir_entry.patch added to mm-nonmm-unstable branch
Message-Id: <20251023233159.F0EECC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: add boundary check to ocfs2_check_dir_entry()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-add-boundary-check-to-ocfs2_check_dir_entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-add-boundary-check-to-ocfs2_check_dir_entry.patch

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
Subject: ocfs2: add boundary check to ocfs2_check_dir_entry()
Date: Mon, 13 Oct 2025 09:28:26 +0300

In 'ocfs2_check_dir_entry()', add extra check whether at least the
smallest possible dirent may be located at the specified offset within
bh's data, thus preventing an out-of-bounds accesses below.

Link: https://lkml.kernel.org/r/20251013062826.122586-1-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reported-by: syzbot+b20bbf680bb0f2ecedae@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b20bbf680bb0f2ecedae
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/dir.c~ocfs2-add-boundary-check-to-ocfs2_check_dir_entry
+++ a/fs/ocfs2/dir.c
@@ -302,8 +302,21 @@ static int ocfs2_check_dir_entry(struct
 				 unsigned long offset)
 {
 	const char *error_msg = NULL;
-	const int rlen = le16_to_cpu(de->rec_len);
-	const unsigned long next_offset = ((char *) de - buf) + rlen;
+	unsigned long next_offset;
+	int rlen;
+
+	if (offset > size - OCFS2_DIR_REC_LEN(1)) {
+		/* Dirent is (maybe partially) beyond the buffer
+		 * boundaries so touching 'de' members is unsafe.
+		 */
+		mlog(ML_ERROR, "directory entry (#%llu: offset=%lu) "
+		     "too close to end or out-of-bounds",
+		     (unsigned long long)OCFS2_I(dir)->ip_blkno, offset);
+		return 0;
+	}
+
+	rlen = le16_to_cpu(de->rec_len);
+	next_offset = ((char *) de - buf) + rlen;
 
 	if (unlikely(rlen < OCFS2_DIR_REC_LEN(1)))
 		error_msg = "rec_len is smaller than minimal";
_

Patches currently in -mm which might be from dmantipov@yandex.ru are

ocfs2-add-extra-flags-check-in-ocfs2_ioctl_move_extents.patch
ocfs2-relax-bug-to-ocfs2_error-in-__ocfs2_move_extent.patch
ocfs2-annotate-flexible-array-members-with-__counted_by_le.patch
ocfs2-annotate-flexible-array-members-with-__counted_by_le-fix.patch
ocfs2-add-extra-consistency-check-to-ocfs2_dx_dir_lookup_rec.patch
ocfs2-add-directory-size-check-to-ocfs2_find_dir_space_id.patch
ocfs2-add-chain-list-sanity-check-to-ocfs2_block_group_alloc.patch
ocfs2-add-boundary-check-to-ocfs2_check_dir_entry.patch

