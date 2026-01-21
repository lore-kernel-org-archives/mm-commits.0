Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22BD3164C7
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967309; cv=none; b=YuR5P5Mcc7wQr3/1pfla2H08tIJkz2UGjiTf60jbD3gKRxt3jnUZ6hkS3oEl48lCCxjCV6yHLDzqfGYYDoQLhQ1rMV8+cJoxpOA6j0XPCSdolvlvj72KHC7Yl1eFr3iOeh6uIKPbeRPNCb2kG4nrYmQ4MjeN2SFb0WtQKJg8FNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967309; c=relaxed/simple;
	bh=5pb/EUqWJ+9wPZP5NVRuuCib69/Km4PaPX6WNxmCGDU=;
	h=Date:To:From:Subject:Message-Id; b=D20nfM+lZQxCiG3shvLd21BRZaLmmXUwR73Sb6Zh1ciqGxmIcI8+GI87vhr5OvZzF/lGbGF94BXEnjZrPbIRaf/LUf/wY6TbTRy7dx9JIY6Jf7QkofQM7lxkraVYlBmvv1Vz9jr1XnfE5c+o8hNeNyol+Bk/MFyZf8fThMT/cuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EKIGMGWo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EKIGMGWo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B370C16AAE;
	Wed, 21 Jan 2026 03:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967308;
	bh=5pb/EUqWJ+9wPZP5NVRuuCib69/Km4PaPX6WNxmCGDU=;
	h=Date:To:From:Subject:From;
	b=EKIGMGWoZKv/YwGzqNueXXJvKhzQDm71rEXlSJgbM1sB3P0qUF/vJHS5UqGQzUBnT
	 bSKb1JTN+eVtliqyJz78KJAtu286lfFCUZkgeIjZmmw7usUldEg2YE4A9fZ4YP+i8/
	 5MtT+NhGWBSTG35M/z3fOWvPKZWJgo90nKcTVfL8=
Date: Tue, 20 Jan 2026 19:48:27 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,christophe.jaillet@wanadoo.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-constify-struct-configfs_item_operations-and-configfs_group_operations.patch removed from -mm tree
Message-Id: <20260121034828.4B370C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: constify struct configfs_item_operations and configfs_group_operations
has been removed from the -mm tree.  Its filename was
     ocfs2-constify-struct-configfs_item_operations-and-configfs_group_operations.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
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


