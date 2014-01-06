From: akpm@linux-foundation.org
Subject: +
 fs-nilfs2-fix-integer-overflow-in-nilfs_ioctl_wrap_copy-fix.patch added to
 -mm tree
Date: Mon, 06 Jan 2014 13:47:08 -0800
Message-ID: <52cb245c.I/Z/HNHgj7OvMxC+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46475 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756335AbaAFVrJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jan 2014 16:47:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, slava@dubeyko.com, fanwlexca@gmail.com, konishi.ryusuke@lab.ntt.co.jp

Subject: + fs-nilfs2-fix-integer-overflow-in-nilfs_ioctl_wrap_copy-fix.patch added to -mm tree
To: konishi.ryusuke@lab.ntt.co.jp,fanwlexca@gmail.com,slava@dubeyko.com
From: akpm@linux-foundation.org
Date: Mon, 06 Jan 2014 13:47:08 -0800


The patch titled
     
has been added to the -mm tree.  Its filename is
     fs-nilfs2-fix-integer-overflow-in-nilfs_ioctl_wrap_copy-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-nilfs2-fix-integer-overflow-in-nilfs_ioctl_wrap_copy-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-nilfs2-fix-integer-overflow-in-nilfs_ioctl_wrap_copy-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Signed-off-by: Wenliang Fan <fanwlexca@gmail.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/ioctl.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN fs/nilfs2/ioctl.c~fs-nilfs2-fix-integer-overflow-in-nilfs_ioctl_wrap_copy-fix fs/nilfs2/ioctl.c
--- a/fs/nilfs2/ioctl.c~fs-nilfs2-fix-integer-overflow-in-nilfs_ioctl_wrap_copy-fix
+++ a/fs/nilfs2/ioctl.c
@@ -57,7 +57,12 @@ static int nilfs_ioctl_wrap_copy(struct
 	if (argv->v_size > PAGE_SIZE)
 		return -EINVAL;
 
-	if (argv->v_index > (~(__u64)0 - argv->v_nmembs))
+	/*
+	 * Reject pairs of a start item position (argv->v_index) and a
+	 * total count (argv->v_nmembs) which leads position 'pos' to
+	 * overflow by the increment at the end of the loop.
+	 */
+	if (argv->v_index > ~(__u64)0 - argv->v_nmembs)
 		return -EINVAL;
 
 	buf = (void *)__get_free_pages(GFP_NOFS, 0);
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

fs-nilfs2-fix-integer-overflow-in-nilfs_ioctl_wrap_copy.patch
fs-nilfs2-fix-integer-overflow-in-nilfs_ioctl_wrap_copy-fix.patch
linux-next.patch

