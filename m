From: akpm@linux-foundation.org
Subject: [merged] ocfs2-constify-attribute_group-structures.patch
 removed from -mm tree
Date: Fri, 07 Jul 2017 12:07:42 -0700
Message-ID: <20170707190742.jArR5Wh7O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60684 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751757AbdGGTHn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2017 15:07:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arvind.yadav.cs@gmail.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: constify attribute_group structures
has been removed from the -mm tree.  Its filename was
     ocfs2-constify-attribute_group-structures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: ocfs2: constify attribute_group structures

attribute_groups are not supposed to change at runtime.  All functions
working with attribute_groups provided by <linux/sysfs.h> work with const
attribute_group.  So mark the non-const structs as const.

File size before:
   text	   data	    bss	    dec	    hex	filename
   4402	   1088	     38	   5528	   1598	fs/ocfs2/stackglue.o

File size After adding 'const':
   text	   data	    bss	    dec	    hex	filename
   4442	   1024	     38	   5504	   1580	fs/ocfs2/stackglue.o

Link: http://lkml.kernel.org/r/cab4e59b4918db3ed2ec77073a4cb310c4429ef5.1498808026.git.arvind.yadav.cs@gmail.com
Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stackglue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/stackglue.c~ocfs2-constify-attribute_group-structures fs/ocfs2/stackglue.c
--- a/fs/ocfs2/stackglue.c~ocfs2-constify-attribute_group-structures
+++ a/fs/ocfs2/stackglue.c
@@ -631,7 +631,7 @@ static struct attribute *ocfs2_attrs[] =
 	NULL,
 };
 
-static struct attribute_group ocfs2_attr_group = {
+static const struct attribute_group ocfs2_attr_group = {
 	.attrs = ocfs2_attrs,
 };
 
_

Patches currently in -mm which might be from arvind.yadav.cs@gmail.com are

zram-constify-attribute_group-structures.patch
kernel-ksysfs-constify-attribute_group-structures.patch

