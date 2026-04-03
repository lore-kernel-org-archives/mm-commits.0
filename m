Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C6C2D3A69;
	Fri,  3 Apr 2026 06:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775198902; cv=none; b=bU40uqWhzT3rc/OAXkFFMvmxl+WYnkcTXS0XkmdBlXCjMSwC41wE+f3ywZHKqAT/sqFYR8KCrjtyCMRuCSUCt5OhKV/QxDQlq/dtUEmmJs4eHrBbk4ZGGBO5HfxAyvfGQcidpyUt+5hkGKTL17CuanxtCqoTqrgGO7x1p0es0co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775198902; c=relaxed/simple;
	bh=9exuHLBU3gjAiJ+0lwPg7LKdmGXsL9au6qm+jR2lUMk=;
	h=Date:To:From:Subject:Message-Id; b=Pc1QdySwtPvgusxT/sK/JfSt4ntjNrrzHROfl5BPvfY+bt35LmODOAMFrshYxVbTeFRr4PGNJEAIxZqaUmXZvjP+iby5eGHLgD7cPORHyqxCguJWW61H5UOvfxKKHcoCu7h7Lg7nHm5UQ9e8iBsqwayEf4dP1uISFUQ0nHxspZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zihTdRcP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zihTdRcP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36DFC4CEF7;
	Fri,  3 Apr 2026 06:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775198901;
	bh=9exuHLBU3gjAiJ+0lwPg7LKdmGXsL9au6qm+jR2lUMk=;
	h=Date:To:From:Subject:From;
	b=zihTdRcPfd7bq0iVCW32PjzzYwsxBtAqplVOh7uuNdZwb4bfHFgoGhicDIw383ZQ4
	 aRKh10NwV4/NGm42WsEfCw6kUlNEoHN7tvaYe07Ucdjo0vsEaYnZqYhR+7r40Zn1dc
	 gNjwhr98kk5rZi4jkAbtGh/G0Pxt+dApxNc3ZEZU=
Date: Thu, 02 Apr 2026 23:48:21 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-out-of-bounds-write-in-ocfs2_write_end_inline.patch added to mm-hotfixes-unstable branch
Message-Id: <20260403064821.D36DFC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix out-of-bounds write in ocfs2_write_end_inline
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ocfs2-fix-out-of-bounds-write-in-ocfs2_write_end_inline.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-out-of-bounds-write-in-ocfs2_write_end_inline.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: fix out-of-bounds write in ocfs2_write_end_inline
Date: Fri, 3 Apr 2026 14:38:30 +0800

KASAN reports a use-after-free write of 4086 bytes in
ocfs2_write_end_inline, called from ocfs2_write_end_nolock during a
copy_file_range splice fallback on a corrupted ocfs2 filesystem mounted on
a loop device.  The actual bug is an out-of-bounds write past the inode
block buffer, not a true use-after-free.  The write overflows into an
adjacent freed page, which KASAN reports as UAF.

The root cause is that ocfs2_try_to_write_inline_data trusts the on-disk
id_count field to determine whether a write fits in inline data.  On a
corrupted filesystem, id_count can exceed the physical maximum inline data
capacity, causing writes to overflow the inode block buffer.

Call trace (crash path):

   vfs_copy_file_range (fs/read_write.c:1634)
     do_splice_direct
       splice_direct_to_actor
         iter_file_splice_write
           ocfs2_file_write_iter
             generic_perform_write
               ocfs2_write_end
                 ocfs2_write_end_nolock (fs/ocfs2/aops.c:1949)
                   ocfs2_write_end_inline (fs/ocfs2/aops.c:1915)
                     memcpy_from_folio     <-- KASAN: write OOB

So add id_count upper bound check in ocfs2_validate_inode_block() to
alongside the existing i_size check to fix it.

Link: https://lkml.kernel.org/r/20260403063830.3662739-1-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reported-by: syzbot+62c1793956716ea8b28a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=62c1793956716ea8b28a
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/fs/ocfs2/inode.c~ocfs2-fix-out-of-bounds-write-in-ocfs2_write_end_inline
+++ a/fs/ocfs2/inode.c
@@ -1505,6 +1505,16 @@ int ocfs2_validate_inode_block(struct su
 			goto bail;
 		}
 
+		if (le16_to_cpu(data->id_count) >
+		    ocfs2_max_inline_data_with_xattr(sb, di)) {
+			rc = ocfs2_error(sb,
+					 "Invalid dinode #%llu: inline data id_count %u exceeds max %d\n",
+					 (unsigned long long)bh->b_blocknr,
+					 le16_to_cpu(data->id_count),
+					 ocfs2_max_inline_data_with_xattr(sb, di));
+			goto bail;
+		}
+
 		if (le64_to_cpu(di->i_size) > le16_to_cpu(data->id_count)) {
 			rc = ocfs2_error(sb,
 					 "Invalid dinode #%llu: inline data i_size %llu exceeds id_count %u\n",
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-fix-out-of-bounds-write-in-ocfs2_write_end_inline.patch

