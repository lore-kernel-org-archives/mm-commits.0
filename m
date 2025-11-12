Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852FF14B96E
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762908603; cv=none; b=Ahj6OG0LgCDXo4n7d2jIJVdyNzWm1CKDZUFNt/Kq2kXDlcnQn2ltIN7/AUWZV35km/DiI7FeMA1BoIzbKNge5EFSLMcjmkDEvuOyGdeR8hfpgvrEVHo40NqdTkpAXqfQFZH6dMX7W3C4NLPo2n3FtrEnqyXleCOqokTlUYmT0FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762908603; c=relaxed/simple;
	bh=NYHtrcGgKy3JK/xXVH99X7NvaV8VqASc91w3v66AAS0=;
	h=Date:To:From:Subject:Message-Id; b=Hnr0iIZkE1RIdHnix8bnH5rSDEIfI1TBPyt7E4ONJ40BVT2aqbBojo2mjw9v6U+48xwf4UX8wIWT0sJnvjgB7nD43/4Hu2QopPeW6gxbvlceQLMvQ4c3hAL2e5UDnuXutZDcXlYBNbIvmxDdlCfC13t8Ps966Dc5E/x5ofQKMfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wnOMsDup; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wnOMsDup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C1BDC4CEFB;
	Wed, 12 Nov 2025 00:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762908602;
	bh=NYHtrcGgKy3JK/xXVH99X7NvaV8VqASc91w3v66AAS0=;
	h=Date:To:From:Subject:From;
	b=wnOMsDupizixjvY0sj7a7IjKXgObY0KZlq7G1rhBr70ncLkVKsevzRJiqU/bEaX9n
	 H7gOjmZDiOh8RD6hFTCmAntqxu7+3T+pF6Qp9M59krfdbwkuRf25EW0H0o+hDtmXSK
	 bBeky2jNDPQF9Ay2EDwcUxurcJ2fTnWbhcZrHbbQ=
Date: Tue, 11 Nov 2025 16:50:01 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,jiangqi903@gmail.com,heming.zhao@suse.com,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-add-boundary-check-to-ocfs2_check_dir_entry.patch removed from -mm tree
Message-Id: <20251112005002.1C1BDC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: add boundary check to ocfs2_check_dir_entry()
has been removed from the -mm tree.  Its filename was
     ocfs2-add-boundary-check-to-ocfs2_check_dir_entry.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

ocfs2-add-extra-consistency-checks-for-chain-allocator-dinodes.patch

