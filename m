Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD67192B75
	for <mm-commits@vger.kernel.org>; Mon, 15 Dec 2025 00:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765759175; cv=none; b=WrajFJaCzsGJup591x8xl3Ax21sgJmQHttYOCVDoxW5DzdQ/dv46szY0usVhTDlyCYZEbVdRZn79DjfrRm82cpTf/EvcDLi8CHFxUrmw/9yWEeTielmeRRwEyJIwEQW+XMR+201mPPZ3rPudCKsmIgwJASEQvXe36fz3gWSdnrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765759175; c=relaxed/simple;
	bh=/Megz+xDUyZJiY4BsYftuuvkc6CfiuD3l0z8HgoBciE=;
	h=Date:To:From:Subject:Message-Id; b=WFRe2SMU8TKP83SBgEUMUKHnBZzShYqUpE3BarTuJpkTURfncl89C8mvE+eR4sEXfE+VILxQf6NGTgFDBgd0I3jtg+yMZgksM/IrC0qFw53GDq/m/yoeUdyYCYVRX8OnImnDuPpOl+YHtA7aquZddaygPmAF7OXnMe4jLmB3t9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Km+CY8tU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Km+CY8tU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA41C4CEFB;
	Mon, 15 Dec 2025 00:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765759173;
	bh=/Megz+xDUyZJiY4BsYftuuvkc6CfiuD3l0z8HgoBciE=;
	h=Date:To:From:Subject:From;
	b=Km+CY8tURK+dc2+oK1czunq9XN9BcIeiLeXgO3FdxR9S9pnrSsT6l7+CaJy2Von9u
	 ZFfmFFZJul393FPpBObUyXAC7fYY9XzPfw7czQ8551ZKqcCXnGGRO29m6/K8M96vJe
	 dBGcsH5rL6HI4Yu/jru68OcsTl5WhZ3Kvf7oMj1I=
Date: Sun, 14 Dec 2025 16:39:32 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,jiangqi903@gmail.com,heming.zhao@suse.com,gechangwei@live.cn,christophe.jaillet@wanadoo.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-constify-struct-configfs_item_operations-and-configfs_group_operations.patch added to mm-nonmm-unstable branch
Message-Id: <20251215003933.7CA41C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: constify struct configfs_item_operations and configfs_group_operations
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-constify-struct-configfs_item_operations-and-configfs_group_operations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-constify-struct-configfs_item_operations-and-configfs_group_operations.patch

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
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: ocfs2: constify struct configfs_item_operations and configfs_group_operations
Date: Sun, 14 Dec 2025 11:41:35 +0100

'struct configfs_item_operations' and 'configfs_group_operations' are not
modified in this driver.

Constifying these structures moves some data to a read-only section, so
increases overall security, especially when the structure holds some
function pointers.

On a x86_64, with allmodconfig, as an example:
Before:
======
   text	   data	    bss	    dec	    hex	filename
  74011	  19312	   5280	  98603	  1812b	fs/ocfs2/cluster/heartbeat.o

After:
=====
   text	   data	    bss	    dec	    hex	filename
  74171	  19152	   5280	  98603	  1812b	fs/ocfs2/cluster/heartbeat.o

Link: https://lkml.kernel.org/r/7c7c00ba328e5e514d8debee698154039e9640dd.1765708880.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c   |    4 ++--
 fs/ocfs2/cluster/nodemanager.c |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-constify-struct-configfs_item_operations-and-configfs_group_operations
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -1942,7 +1942,7 @@ static struct configfs_attribute *o2hb_r
 	NULL,
 };
 
-static struct configfs_item_operations o2hb_region_item_ops = {
+static const struct configfs_item_operations o2hb_region_item_ops = {
 	.release		= o2hb_region_release,
 };
 
@@ -2193,7 +2193,7 @@ static struct configfs_attribute *o2hb_h
 	NULL,
 };
 
-static struct configfs_group_operations o2hb_heartbeat_group_group_ops = {
+static const struct configfs_group_operations o2hb_heartbeat_group_group_ops = {
 	.make_item	= o2hb_heartbeat_group_make_item,
 	.drop_item	= o2hb_heartbeat_group_drop_item,
 };
--- a/fs/ocfs2/cluster/nodemanager.c~ocfs2-constify-struct-configfs_item_operations-and-configfs_group_operations
+++ a/fs/ocfs2/cluster/nodemanager.c
@@ -396,7 +396,7 @@ static struct configfs_attribute *o2nm_n
 	NULL,
 };
 
-static struct configfs_item_operations o2nm_node_item_ops = {
+static const struct configfs_item_operations o2nm_node_item_ops = {
 	.release		= o2nm_node_release,
 };
 
@@ -638,7 +638,7 @@ static void o2nm_node_group_drop_item(st
 	config_item_put(item);
 }
 
-static struct configfs_group_operations o2nm_node_group_group_ops = {
+static const struct configfs_group_operations o2nm_node_group_group_ops = {
 	.make_item	= o2nm_node_group_make_item,
 	.drop_item	= o2nm_node_group_drop_item,
 };
@@ -657,7 +657,7 @@ static void o2nm_cluster_release(struct
 	kfree(cluster);
 }
 
-static struct configfs_item_operations o2nm_cluster_item_ops = {
+static const struct configfs_item_operations o2nm_cluster_item_ops = {
 	.release	= o2nm_cluster_release,
 };
 
@@ -741,7 +741,7 @@ static void o2nm_cluster_group_drop_item
 	config_item_put(item);
 }
 
-static struct configfs_group_operations o2nm_cluster_group_group_ops = {
+static const struct configfs_group_operations o2nm_cluster_group_group_ops = {
 	.make_group	= o2nm_cluster_group_make_group,
 	.drop_item	= o2nm_cluster_group_drop_item,
 };
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are

crash_dump-constify-struct-configfs_item_operations-and-configfs_group_operations.patch
ocfs2-constify-struct-configfs_item_operations-and-configfs_group_operations.patch

