Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F7E1D9A54
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 02:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765853491; cv=none; b=Q239UG2n53UEEAz6/63s1TPk0s6R6q9bMBzHUOrZ7vlOtGGy+YZZPeBvBcFsycl4oPnrI6jp1chJa6nncojO51Xr/Yzz0mLtEIngLKr392UEVYygDzRg0wgifQAxREAYD1TYNwoz2VZrEd5feCu2aRSk4kUrSxJ/IUvATYc8ySI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765853491; c=relaxed/simple;
	bh=7PD526Tcjeri1FC7hXk2nd4KBfrBO9Shfz4fVcYQs3A=;
	h=Date:To:From:Subject:Message-Id; b=lMEh4eX64SSjxW4SUdDCHBfJZNWuHm8PH0HcBpXel/4sGX1lgOAAHCCXKbbVincThuXhFn1FAc8x0HCheM62TGaYq1UBhdXpwKZOxdP0VmCHUGzZ0K/Y7Ty3TycB75Qp3DnxN4ZxZK1KXLAP96YuXm90HhWdsIaMkV0MQqWNBKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mte4hmlE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mte4hmlE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B3F8C4CEF5;
	Tue, 16 Dec 2025 02:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765853491;
	bh=7PD526Tcjeri1FC7hXk2nd4KBfrBO9Shfz4fVcYQs3A=;
	h=Date:To:From:Subject:From;
	b=mte4hmlE2rBkV6QCz3z9kJQZ/w9uddIGJNNo5mr0e0IPK071daBJX/xwYlNY8ax3j
	 VwE+k74/5h5Kw7TeluCKPmdhsXQtCYIUpTkHbebF7leLg2SALrXfKdPgyH293K6CqE
	 YTZfceE7TWMz+5Ah4wKmx99C/XXtuTSA+RYaW2xQ=
Date: Mon, 15 Dec 2025 18:51:30 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,kartikey406@gmail.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,jiangqi903@gmail.com,heming.zhao@suse.com,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-adjust-ocfs2_xa_remove_entry-to-match-ubsan-boundary-checks.patch added to mm-nonmm-unstable branch
Message-Id: <20251216025131.0B3F8C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: adjust ocfs2_xa_remove_entry() to match UBSAN boundary checks
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-adjust-ocfs2_xa_remove_entry-to-match-ubsan-boundary-checks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-adjust-ocfs2_xa_remove_entry-to-match-ubsan-boundary-checks.patch

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
Subject: ocfs2: adjust ocfs2_xa_remove_entry() to match UBSAN boundary checks
Date: Thu, 11 Dec 2025 18:59:49 +0300

After introducing 2f26f58df041 ("ocfs2: annotate flexible array members
with __counted_by_le()"), syzbot has reported the following issue:

UBSAN: array-index-out-of-bounds in fs/ocfs2/xattr.c:1955:3
index 2 is out of range for type 'struct ocfs2_xattr_entry[]
__counted_by(xh_count)' (aka 'struct ocfs2_xattr_entry[]')
...
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 ubsan_epilogue+0xa/0x40 lib/ubsan.c:233
 __ubsan_handle_out_of_bounds+0xe9/0xf0 lib/ubsan.c:455
 ocfs2_xa_remove_entry+0x36d/0x3e0 fs/ocfs2/xattr.c:1955
 ...

To address this issue, 'xh_entries[]' member removal should be performed
before actually changing 'xh_count', thus making sure that all array
accesses matches the boundary checks performed by UBSAN.

Link: https://lkml.kernel.org/r/20251211155949.774485-1-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reported-by: syzbot+cf96bc82a588a27346a8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=cf96bc82a588a27346a8
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/xattr.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/xattr.c~ocfs2-adjust-ocfs2_xa_remove_entry-to-match-ubsan-boundary-checks
+++ a/fs/ocfs2/xattr.c
@@ -1971,8 +1971,7 @@ static void ocfs2_xa_remove_entry(struct
 	ocfs2_xa_wipe_namevalue(loc);
 	loc->xl_entry = NULL;
 
-	le16_add_cpu(&xh->xh_count, -1);
-	count = le16_to_cpu(xh->xh_count);
+	count = le16_to_cpu(xh->xh_count) - 1;
 
 	/*
 	 * Only zero out the entry if there are more remaining.  This is
@@ -1987,6 +1986,8 @@ static void ocfs2_xa_remove_entry(struct
 		memset(&xh->xh_entries[count], 0,
 		       sizeof(struct ocfs2_xattr_entry));
 	}
+
+	xh->xh_count = cpu_to_le16(count);
 }
 
 /*
_

Patches currently in -mm which might be from dmantipov@yandex.ru are

ocfs2-adjust-ocfs2_xa_remove_entry-to-match-ubsan-boundary-checks.patch

