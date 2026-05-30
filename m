Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8DEE54B
	for <mm-commits@vger.kernel.org>; Sat, 30 May 2026 02:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780106487; cv=none; b=BX7hhLtwHQXzF0EvCHQuls4g6QIvIRWrRYZijrpuxBTAO/UY09Za9/cGNEXAtmR1FkzsyOuJHbCMgrUSQB3y3J5lfiAA9g94IROaR24i7zwivudoZulqCT67UK+z51l6B5qmzxCR1jJptu3tfPVIm7HLMuRlk0lErnro8OL6v6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780106487; c=relaxed/simple;
	bh=LdsJsnXODdRq9RJW9u7glDteNKj+OdYwH5uApSnH4QQ=;
	h=Date:To:From:Subject:Message-Id; b=gQNUaK53NXksQ2pyoUxU0P1xWNmNAO3rNXcdfRxIS3N2aY5+893E5kD8d17GRSUAfoV3w4I/lmuZaX5cwiSKUMwCtj47V7OfVNPgCxOrBxoBxPZ5Z+nvgQQRKqFonTbYtoWlKQzy6xnCXQrlNVHe34tYSDfwOQ/aU3zUVjex2HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RKKY7Iaz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RKKY7Iaz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016061F00893;
	Sat, 30 May 2026 02:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780106486;
	bh=Dkd8XsZnZZ3GtFmqH94mMzzi6kWPovdipyMFsnq48i0=;
	h=Date:To:From:Subject;
	b=RKKY7Iaz6n72Yi0RkBTS/myjAox0gx31VjkoaUZdMOEUMAefZ2gj7pgSN7SnfcCra
	 F5pS7qbxZsiJnFxtDXkrhFESuwAaa16/uCxU+LqYnyOh4UD/icMeIT5RYT78Yf9iyk
	 r45lcVImVdsrTCKZajj0kCoVzQf+WbkDqGYaWRLk=
Date: Fri, 29 May 2026 19:01:25 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-buffer-head-management-in-ocfs2_read_blocks.patch added to mm-nonmm-unstable branch
Message-Id: <20260530020126.016061F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix buffer head management in ocfs2_read_blocks()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-fix-buffer-head-management-in-ocfs2_read_blocks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-buffer-head-management-in-ocfs2_read_blocks.patch

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

lib-free-pagelist-on-error-in-iov_iter_extract_pages.patch
ocfs2-fix-buffer-head-management-in-ocfs2_read_blocks.patch

