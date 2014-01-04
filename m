From: akpm@linux-foundation.org
Subject: + fs-nilfs2-fix-integer-overflow-in-nilfs_ioctl_wrap_copy.patch
 added to -mm tree
Date: Fri, 03 Jan 2014 16:10:23 -0800
Message-ID: <52c7516f.D9t4Wmd8s3dxiAkk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51819 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408AbaADAKY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jan 2014 19:10:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, slava@dubeyko.com, konishi.ryusuke@lab.ntt.co.jp, fanwlexca@gmail.com

Subject: + fs-nilfs2-fix-integer-overflow-in-nilfs_ioctl_wrap_copy.patch added to -mm tree
To: fanwlexca@gmail.com,konishi.ryusuke@lab.ntt.co.jp,slava@dubeyko.com
From: akpm@linux-foundation.org
Date: Fri, 03 Jan 2014 16:10:23 -0800


The patch titled
     Subject: fs/nilfs2: fix integer overflow in nilfs_ioctl_wrap_copy()
has been added to the -mm tree.  Its filename is
     fs-nilfs2-fix-integer-overflow-in-nilfs_ioctl_wrap_copy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-nilfs2-fix-integer-overflow-in-nilfs_ioctl_wrap_copy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-nilfs2-fix-integer-overflow-in-nilfs_ioctl_wrap_copy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wenliang Fan <fanwlexca@gmail.com>
Subject: fs/nilfs2: fix integer overflow in nilfs_ioctl_wrap_copy()

Check before entering into cycle.

The local variable 'pos' comes from userspace. If a large number was
passed, there would be an integer overflow in the following line:
        pos += n;

Signed-off-by: Wenliang Fan <fanwlexca@gmail.com>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/ioctl.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/nilfs2/ioctl.c~fs-nilfs2-fix-integer-overflow-in-nilfs_ioctl_wrap_copy fs/nilfs2/ioctl.c
--- a/fs/nilfs2/ioctl.c~fs-nilfs2-fix-integer-overflow-in-nilfs_ioctl_wrap_copy
+++ a/fs/nilfs2/ioctl.c
@@ -57,6 +57,9 @@ static int nilfs_ioctl_wrap_copy(struct
 	if (argv->v_size > PAGE_SIZE)
 		return -EINVAL;
 
+	if (argv->v_index > (~(__u64)0 - argv->v_nmembs))
+		return -EINVAL;
+
 	buf = (void *)__get_free_pages(GFP_NOFS, 0);
 	if (unlikely(!buf))
 		return -ENOMEM;
_

Patches currently in -mm which might be from fanwlexca@gmail.com are

origin.patch
fs-nilfs2-fix-integer-overflow-in-nilfs_ioctl_wrap_copy.patch
linux-next.patch

