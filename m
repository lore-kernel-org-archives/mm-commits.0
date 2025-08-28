Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E09279333;
	Thu, 28 Aug 2025 05:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756359987; cv=none; b=sRuqENtPZIZ5h+WFJAr+GexZctpwIVf58fRp/e43Gr+rnX1SAEEyVMcEnPWlFBuvR4e2JLaCUuelLTkYx0+2E4qmFWuCW9L4A6T6Lqu/CuugK/S+UA6K+yJBvaZwznkIGxSAFqgxefpP/b4otVaiI2JnpbFQlxyeEHMhhof5Gd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756359987; c=relaxed/simple;
	bh=jCd0AAi/PGsbf5nwOzxPhSsNZmCAvpudI/1QS5wEFnc=;
	h=Date:To:From:Subject:Message-Id; b=lF/Cs/nt+1SVIJbvLS6G5PgdpphIHSG0fpTBFPUmVUaXATwjRkzU+4dr4ojvZEhMr6eaLGqhYwIpl/18H2jJ2jOrTdWwxzqOr/a9WPjJTRKrkco2H1DmxhB9kbojJP4ZmwiNU2+yquAErypexDtFiUIPPnHcnbfF4cVCyMBBMe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=awXeXYfz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="awXeXYfz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D283C4CEEB;
	Thu, 28 Aug 2025 05:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756359987;
	bh=jCd0AAi/PGsbf5nwOzxPhSsNZmCAvpudI/1QS5wEFnc=;
	h=Date:To:From:Subject:From;
	b=awXeXYfzGu0TY9nJZkZzb8YCW5MiHQa6Z+Y18GFLrEaVa1VYJbRhOhO0xoYYgQW4L
	 18t4znEPodOsMcXYY+Rjqdq9ATKwNksp4IyoP1Q5aobMzPdlESdfHxGnL81Qybiulp
	 1s8NbQpRgqRus6ew+s7dNwLfZ1bIwge45CBKq9zE=
Date: Wed, 27 Aug 2025 22:46:26 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,stable@vger.kernel.org,sbrivio@redhat.com,rick.p.edgecombe@intel.com,pv@excello.cz,polynomial-c@gmx.de,k.shutemov@gmail.com,jirislaby@kernel.org,gregkh@linuxfoundation.org,ast@kernel.org,adobriyan@gmail.com,wangzijie1@honor.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] proc-fix-missing-pde_set_flags-for-net-proc-files.patch removed from -mm tree
Message-Id: <20250828054627.4D283C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc: fix missing pde_set_flags() for net proc files
has been removed from the -mm tree.  Its filename was
     proc-fix-missing-pde_set_flags-for-net-proc-files.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: wangzijie <wangzijie1@honor.com>
Subject: proc: fix missing pde_set_flags() for net proc files
Date: Mon, 18 Aug 2025 20:31:02 +0800

To avoid potential UAF issues during module removal races, we use
pde_set_flags() to save proc_ops flags in PDE itself before
proc_register(), and then use pde_has_proc_*() helpers instead of directly
dereferencing pde->proc_ops->*.

However, the pde_set_flags() call was missing when creating net related
proc files.  This omission caused incorrect behavior which FMODE_LSEEK was
being cleared inappropriately in proc_reg_open() for net proc files.  Lars
reported it in this link[1].

Fix this by ensuring pde_set_flags() is called when register proc entry,
and add NULL check for proc_ops in pde_set_flags().

[wangzijie1@honor.com: stash pde->proc_ops in a local const variable, per Christian]
  Link: https://lkml.kernel.org/r/20250821105806.1453833-1-wangzijie1@honor.com
Link: https://lkml.kernel.org/r/20250818123102.959595-1-wangzijie1@honor.com
Link: https://lore.kernel.org/all/20250815195616.64497967@chagall.paradoxon.rec/ [1]
Fixes: ff7ec8dc1b64 ("proc: use the same treatment to check proc_lseek as ones for proc_read_iter et.al")
Signed-off-by: wangzijie <wangzijie1@honor.com>
Reported-by: Lars Wendler <polynomial-c@gmx.de>
Tested-by: Stefano Brivio <sbrivio@redhat.com>
Tested-by: Petr Vaněk <pv@excello.cz>
Tested by: Lars Wendler <polynomial-c@gmx.de>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Kirill A. Shutemov <k.shutemov@gmail.com>
Cc: wangzijie <wangzijie1@honor.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |   38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

--- a/fs/proc/generic.c~proc-fix-missing-pde_set_flags-for-net-proc-files
+++ a/fs/proc/generic.c
@@ -367,6 +367,25 @@ static const struct inode_operations pro
 	.setattr	= proc_notify_change,
 };
 
+static void pde_set_flags(struct proc_dir_entry *pde)
+{
+	const struct proc_ops *proc_ops = pde->proc_ops;
+
+	if (!proc_ops)
+		return;
+
+	if (proc_ops->proc_flags & PROC_ENTRY_PERMANENT)
+		pde->flags |= PROC_ENTRY_PERMANENT;
+	if (proc_ops->proc_read_iter)
+		pde->flags |= PROC_ENTRY_proc_read_iter;
+#ifdef CONFIG_COMPAT
+	if (proc_ops->proc_compat_ioctl)
+		pde->flags |= PROC_ENTRY_proc_compat_ioctl;
+#endif
+	if (proc_ops->proc_lseek)
+		pde->flags |= PROC_ENTRY_proc_lseek;
+}
+
 /* returns the registered entry, or frees dp and returns NULL on failure */
 struct proc_dir_entry *proc_register(struct proc_dir_entry *dir,
 		struct proc_dir_entry *dp)
@@ -374,6 +393,8 @@ struct proc_dir_entry *proc_register(str
 	if (proc_alloc_inum(&dp->low_ino))
 		goto out_free_entry;
 
+	pde_set_flags(dp);
+
 	write_lock(&proc_subdir_lock);
 	dp->parent = dir;
 	if (pde_subdir_insert(dir, dp) == false) {
@@ -561,20 +582,6 @@ struct proc_dir_entry *proc_create_reg(c
 	return p;
 }
 
-static void pde_set_flags(struct proc_dir_entry *pde)
-{
-	if (pde->proc_ops->proc_flags & PROC_ENTRY_PERMANENT)
-		pde->flags |= PROC_ENTRY_PERMANENT;
-	if (pde->proc_ops->proc_read_iter)
-		pde->flags |= PROC_ENTRY_proc_read_iter;
-#ifdef CONFIG_COMPAT
-	if (pde->proc_ops->proc_compat_ioctl)
-		pde->flags |= PROC_ENTRY_proc_compat_ioctl;
-#endif
-	if (pde->proc_ops->proc_lseek)
-		pde->flags |= PROC_ENTRY_proc_lseek;
-}
-
 struct proc_dir_entry *proc_create_data(const char *name, umode_t mode,
 		struct proc_dir_entry *parent,
 		const struct proc_ops *proc_ops, void *data)
@@ -585,7 +592,6 @@ struct proc_dir_entry *proc_create_data(
 	if (!p)
 		return NULL;
 	p->proc_ops = proc_ops;
-	pde_set_flags(p);
 	return proc_register(parent, p);
 }
 EXPORT_SYMBOL(proc_create_data);
@@ -636,7 +642,6 @@ struct proc_dir_entry *proc_create_seq_p
 	p->proc_ops = &proc_seq_ops;
 	p->seq_ops = ops;
 	p->state_size = state_size;
-	pde_set_flags(p);
 	return proc_register(parent, p);
 }
 EXPORT_SYMBOL(proc_create_seq_private);
@@ -667,7 +672,6 @@ struct proc_dir_entry *proc_create_singl
 		return NULL;
 	p->proc_ops = &proc_single_ops;
 	p->single_show = show;
-	pde_set_flags(p);
 	return proc_register(parent, p);
 }
 EXPORT_SYMBOL(proc_create_single_data);
_

Patches currently in -mm which might be from wangzijie1@honor.com are


