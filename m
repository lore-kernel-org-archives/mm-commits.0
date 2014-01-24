From: akpm@linux-foundation.org
Subject: [merged]
 fs-nilfs2-fix-integer-overflow-in-nilfs_ioctl_wrap_copy.patch removed from
 -mm tree
Date: Fri, 24 Jan 2014 11:03:08 -0800
Message-ID: <52e2b8ec.nh7LUFoLeUxJh+1D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43793 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbaAXTDJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:03:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, slava@dubeyko.com, konishi.ryusuke@lab.ntt.co.jp, fanwlexca@gmail.com

Subject: [merged] fs-nilfs2-fix-integer-overflow-in-nilfs_ioctl_wrap_copy.patch removed from -mm tree
To: fanwlexca@gmail.com,konishi.ryusuke@lab.ntt.co.jp,slava@dubeyko.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:03:08 -0800


The patch titled
     Subject: fs/nilfs2: fix integer overflow in nilfs_ioctl_wrap_copy()
has been removed from the -mm tree.  Its filename was
     fs-nilfs2-fix-integer-overflow-in-nilfs_ioctl_wrap_copy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wenliang Fan <fanwlexca@gmail.com>
Subject: fs/nilfs2: fix integer overflow in nilfs_ioctl_wrap_copy()

The local variable 'pos' in nilfs_ioctl_wrap_copy function can overflow if
a large number was passed to argv->v_index from userspace and the sum of
argv->v_index and argv->v_nmembs exceeds the maximum value of __u64 type
integer (= ~(__u64)0 = 18446744073709551615).

Here, argv->v_index is a 64-bit width argument to specify the start
position of target data items (such as segment number, checkpoint number,
or virtual block address of nilfs), and argv->v_nmembs gives the total
number of the items that userland programs (such as lssu, lscp, or
cleanerd) want to get information about, which also gives the maximum
element count of argv->v_base[] array.

nilfs_ioctl_wrap_copy() calls dofunc() repeatedly and increments the
position variable 'pos' at the end of each iteration if dofunc() itself
didn't update 'pos':

      if (pos == ppos)
              pos += n;

This patch prevents the overflow here by rejecting pairs of a start
position (argv->v_index) and a total count (argv->v_nmembs) which leads to
the overflow.

[konishi.ryusuke@lab.ntt.co.jp: fix signedness issue]
Signed-off-by: Wenliang Fan <fanwlexca@gmail.com>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/ioctl.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN fs/nilfs2/ioctl.c~fs-nilfs2-fix-integer-overflow-in-nilfs_ioctl_wrap_copy fs/nilfs2/ioctl.c
--- a/fs/nilfs2/ioctl.c~fs-nilfs2-fix-integer-overflow-in-nilfs_ioctl_wrap_copy
+++ a/fs/nilfs2/ioctl.c
@@ -57,6 +57,14 @@ static int nilfs_ioctl_wrap_copy(struct
 	if (argv->v_size > PAGE_SIZE)
 		return -EINVAL;
 
+	/*
+	 * Reject pairs of a start item position (argv->v_index) and a
+	 * total count (argv->v_nmembs) which leads position 'pos' to
+	 * overflow by the increment at the end of the loop.
+	 */
+	if (argv->v_index > ~(__u64)0 - argv->v_nmembs)
+		return -EINVAL;
+
 	buf = (void *)__get_free_pages(GFP_NOFS, 0);
 	if (unlikely(!buf))
 		return -ENOMEM;
_

Patches currently in -mm which might be from fanwlexca@gmail.com are

origin.patch
linux-next.patch

