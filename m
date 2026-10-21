Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792560657;
	b=UM5r5GWOJ9swJg6jqjF7DEdKCbjx5l/Xc008kcA5ZpDis7Mo1KQvQ1AWrXWyRCR695o6
	 Dglp+LJrtQGCCjZuiV3UhpoMW3QWXDw8uzfHqMHArpWiD2WmAdGd115VfpsfH0ChUiZGn
	 qIlRTiI3WqXLxeCVMuI2T5Ck0W6tvQHXsLVu397P/SFAANHFlY4AEm+eHPf0o/m5DrEzT
	 biyhF31gLc7fbHUWXNXcBZdzMNj3cMH41V/puRz5OB4TIP8PTO/aS3YifZH+NpHdXrDoD
	 J/ShMtCJj1xpnuvOwEbr9ohcVNKxVvSqiCgw6p0gc5+hWE4VVaH++vslCr7L54cwmEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792560657;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=ublMZcLIbcCEZ/1y8FrhU9TIh2gmLO9pPwLHb2PR2Lg=;
	b=nnLe4kPeXAUB9WnuY0EmfDgNiK4lCVEwAmx+rt55d1iV4JyrUbYAWl7+4xFjn9v2CuF+
	 VQBSq/rbOcSYc4SiL0MvH8umi5IZR/aptZX/yC9d3Alv6NlH5S7BDn+CzOz1xXsNw8nzr
	 aIX3T0QuQhntj6yyfOCSuwjmA/5VBwJ3AZykoeSGRpMYuhQ7kLVYlD0PZ0Nd5XZKAi0mj
	 xK9uTls7x1Mr6wd33DyvetdfwUiQbltIjhtHsZMiitFOZkbUHPKBRszMmzcYB2FCG2y0O
	 NFKyp4JdZHkxwzOmw+/cFfoOhtZasGZ41biB0rTgAEZ9Nixije05lsggcrlDNvqKIFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Lmnzs7fR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDA4606A333;
	Wed, 21 Oct 2026 05:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Lmnzs7fR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FAD41F000CA;
	Wed, 21 Oct 2026 05:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792560656;
	bh=ublMZcLIbcCEZ/1y8FrhU9TIh2gmLO9pPwLHb2PR2Lg=;
	h=Date:To:From:Subject;
	b=Lmnzs7fRtyRRSkemhQ1FbLu3KR8DOPWNu7XPqCkNfC0cHpLkZzDftq64960qiQjMb
	 F+gf3kaA9ZN8PYAs7p1EexKLbAJkmVSQLHGZZNfjr0nigYHveURBvxabkM3Fhz4533
	 JTvHqmEk2PVSXBolTbSHxptbZXtAxFcJHzxWNmNA=
Date: Tue, 20 Oct 2026 22:30:56 -0700
To: mm-commits@vger.kernel.org,sunil.mushran@oracle.com,stable@vger.kernel.org,rppt@kernel.org,rollkingzzc@gmail.com,mark@fasheh.com,kurt.hackel@oracle.com,kmehltretter@gmail.com,kees@kernel.org,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,jjzuming@gmail.com,jack@suse.cz,heming.zhao@suse.com,ericterminal@gmail.com,christophe.jaillet@wanadoo.fr,brauner@kernel.org,baijiaju1990@gmail.com,zzzccc427@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-pin-owning-modules-for-open-debugfs-files.patch removed from -mm tree
Message-Id: <20261021053056.9FAD41F000CA@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: ocfs2: pin owning modules for open debugfs files
has been removed from the -mm tree.  Its filename was
     ocfs2-pin-owning-modules-for-open-debugfs-files.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Cen Zhang <zzzccc427@gmail.com>
Subject: ocfs2: pin owning modules for open debugfs files
Date: Fri, 16 Oct 2026 09:17:13 +0800

The OCFS2 debugfs file operation tables do not set owner. The
full debugfs proxy obtains real_fops with fops_get() at open and
keeps it until final release. Without an owner, this does not acquire
a reference to the module containing the table and its callbacks.
Removing the debugfs entries does not drain retained open files.

An open connected_nodes file can therefore outlive ocfs2_nodemanager
and make full_proxy_release() read real_fops->release from freed
module memory. Heming also reproduced the issue with fs_state and
asked for the other OCFS2 debugfs operation tables to be checked.

Set owner to THIS_MODULE in all eleven explicit debugfs operation
tables: five in ocfs2_nodemanager, four in ocfs2_dlm, and two in
ocfs2. The existing debugfs get/put pair then holds the appropriate
module until final release. Leave the open, read and release callbacks
unchanged. The blockcheck table already sets owner through
DEFINE_DEBUGFS_ATTRIBUTE(), so it needs no change.

The original controlled test used an unloadable OCFS2 module and
case-local probe filters without changing the candidate open, unload
or release logic. Closing a retained connected_nodes file after
normal unload produced:

  BUG: unable to handle page fault for address: fffffbfff804cfef
  Oops: Oops: 0000 [#1] SMP KASAN NOPTI
  RIP: 0010:full_proxy_release+0xbf/0x190
  Call Trace:
   <TASK>
   __fput+0x39a/0xa60
   fput_close_sync+0xff/0x200
   __x64_sys_close+0x8c/0xf0
   do_syscall_64+0x114/0x620
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>
  Modules linked in: [last unloaded: ocfs2_nodemanager]

Link: https://lore.kernel.org/pm-ocfs2-objects-candidate-0089-v6-f7fda843f80887488145@gmail.com
Fixes: 2309e9e040fe ("ocfs2/net: Add debug interface to o2net")
Fixes: 87d3d3f3931f ("ocfs2/hb: Expose the list of heartbeating nodes via debugfs")
Fixes: 3ba169ccec1c ("ocfs2/cluster: Add new function o2net_fill_node_map()")
Fixes: 50397507e856 ("ocfs2: Expose the file system state via debugfs")
Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Fixes: 7209300a9b98 ("ocfs2/dlm: Dumps the purgelist into a debugfs file")
Fixes: d0129aceaecc ("ocfs2/dlm: Dumps the mles into a debugfs file")
Fixes: 4e3d24ed1a12 ("ocfs2/dlm: Dumps the lockres' into a debugfs file")
Fixes: 007dce53a29c ("ocfs2/dlm: Dump the dlm state in a debugfs file")
Fixes: db02754c8a12 ("ocfs2/cluster: Show o2net timing statistics")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Assisted-by: LLM
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Yufan Chen <ericterminal@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Zhang Cen <rollkingzzc@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Sunil Mushran <sunil.mushran@oracle.com>
Cc: Kurt Hackel <kurt.hackel@oracle.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <jjzuming@gmail.com>
Cc: <stable@vger.kernel.org>
---

 fs/ocfs2/cluster/heartbeat.c |    1 +
 fs/ocfs2/cluster/netdebug.c  |    4 ++++
 fs/ocfs2/dlm/dlmdebug.c      |    5 +++++
 fs/ocfs2/dlmglue.c           |    2 ++
 fs/ocfs2/super.c             |    1 +
 5 files changed, 13 insertions(+)

--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-pin-owning-modules-for-open-debugfs-files
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -1447,6 +1447,7 @@ static ssize_t o2hb_debug_read(struct fi
 #endif  /* CONFIG_DEBUG_FS */
 
 static const struct file_operations o2hb_debug_fops = {
+	.owner =	THIS_MODULE,
 	.open =		o2hb_debug_open,
 	.release =	o2hb_debug_release,
 	.read =		o2hb_debug_read,
--- a/fs/ocfs2/cluster/netdebug.c~ocfs2-pin-owning-modules-for-open-debugfs-files
+++ a/fs/ocfs2/cluster/netdebug.c
@@ -183,6 +183,7 @@ static int nst_fop_release(struct inode
 }
 
 static const struct file_operations nst_seq_fops = {
+	.owner = THIS_MODULE,
 	.open = nst_fop_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -415,6 +416,7 @@ static int stats_fop_open(struct inode *
 }
 
 static const struct file_operations stats_seq_fops = {
+	.owner = THIS_MODULE,
 	.open = stats_fop_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -427,6 +429,7 @@ static int sc_fop_open(struct inode *ino
 }
 
 static const struct file_operations sc_seq_fops = {
+	.owner = THIS_MODULE,
 	.open = sc_fop_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -476,6 +479,7 @@ static ssize_t o2net_debug_read(struct f
 }
 
 static const struct file_operations nodes_fops = {
+	.owner		= THIS_MODULE,
 	.open		= nodes_fop_open,
 	.release	= o2net_debug_release,
 	.read		= o2net_debug_read,
--- a/fs/ocfs2/dlm/dlmdebug.c~ocfs2-pin-owning-modules-for-open-debugfs-files
+++ a/fs/ocfs2/dlm/dlmdebug.c
@@ -7,6 +7,7 @@
  * Copyright (C) 2004, 2008 Oracle.  All rights reserved.
  */
 
+#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
@@ -339,6 +340,7 @@ static int debug_purgelist_open(struct i
 }
 
 static const struct file_operations debug_purgelist_fops = {
+	.owner =	THIS_MODULE,
 	.open =		debug_purgelist_open,
 	.release =	debug_release,
 	.read =		debug_read,
@@ -394,6 +396,7 @@ static int debug_mle_open(struct inode *
 }
 
 static const struct file_operations debug_mle_fops = {
+	.owner =	THIS_MODULE,
 	.open =		debug_mle_open,
 	.release =	debug_release,
 	.read =		debug_read,
@@ -601,6 +604,7 @@ static int debug_lockres_release(struct
 }
 
 static const struct file_operations debug_lockres_fops = {
+	.owner =	THIS_MODULE,
 	.open =		debug_lockres_open,
 	.release =	debug_lockres_release,
 	.read =		seq_read,
@@ -791,6 +795,7 @@ static int debug_state_open(struct inode
 }
 
 static const struct file_operations debug_state_fops = {
+	.owner =	THIS_MODULE,
 	.open =		debug_state_open,
 	.release =	debug_release,
 	.read =		debug_read,
--- a/fs/ocfs2/dlmglue.c~ocfs2-pin-owning-modules-for-open-debugfs-files
+++ a/fs/ocfs2/dlmglue.c
@@ -7,6 +7,7 @@
  * Copyright (C) 2003, 2004 Oracle.  All rights reserved.
  */
 
+#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
@@ -3332,6 +3333,7 @@ static int ocfs2_dlm_debug_open(struct i
 }
 
 static const struct file_operations ocfs2_dlm_debug_fops = {
+	.owner =	THIS_MODULE,
 	.open =		ocfs2_dlm_debug_open,
 	.release =	ocfs2_dlm_debug_release,
 	.read =		seq_read,
--- a/fs/ocfs2/super.c~ocfs2-pin-owning-modules-for-open-debugfs-files
+++ a/fs/ocfs2/super.c
@@ -387,6 +387,7 @@ static ssize_t ocfs2_debug_read(struct f
 #endif	/* CONFIG_DEBUG_FS */
 
 static const struct file_operations ocfs2_osb_debug_fops = {
+	.owner =	THIS_MODULE,
 	.open =		ocfs2_osb_debug_open,
 	.release =	ocfs2_debug_release,
 	.read =		ocfs2_debug_read,
_

Patches currently in -mm which might be from zzzccc427@gmail.com are


