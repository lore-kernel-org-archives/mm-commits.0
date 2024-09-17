Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B3215699D
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 08:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726560711; cv=none; b=ezNxhGtIgIsZegZu4kTGhl1OzwXYKttY8pMtH1dn5YPix3qjVGJIy7n+PwIIskI8J8m3RZv2MkTlsRrpigP33x/tphEMoTHBn7LkQyqIuBWW6sZBZ0bxgx4Q5ARnJMSmFjVyNK63Qdlp9JpgG1q7DnJj3InJHq68ulDlvCYZgUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726560711; c=relaxed/simple;
	bh=k1Ev4mHMKTKx5W6zKc3X3qEwBjLi4xsdLkqemQpggFw=;
	h=Date:To:From:Subject:Message-Id; b=WIoKWg3Ny3zy7qJyfSf5RY9Lp7mdz23N/GW/jU2fhEi1WtvRRhI5uRhFD1FNH4UWrFubeopmsNU2dr8+05VMpcqCiQjOky/QngaDkI1s7ARyMqGsftqMqFb2Cx9q17oHM11PueQy81t4+QDlCAZJc9bAhK3bn+NlH3B0RFiTopQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eM0xabJr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eM0xabJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1EDFC4CEC6;
	Tue, 17 Sep 2024 08:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726560710;
	bh=k1Ev4mHMKTKx5W6zKc3X3qEwBjLi4xsdLkqemQpggFw=;
	h=Date:To:From:Subject:From;
	b=eM0xabJrnRNlmzSP2UFPAnFcqZtYYtrWDzGSwTEgsU1uAMRtkf/p8N74lOrhLTF2g
	 Kytg2r1gqRP2U2irgwiDSW1QgsKbsth4Cy7Ymm/K+mLsJ7lFpjeL890wvnigoKO4Gt
	 aZJ8zZtz8KU+MVgF82+qGbYpKynGhxf49aL5q2Jo=
Date: Tue, 17 Sep 2024 01:11:47 -0700
To: mm-commits@vger.kernel.org,adobriyan@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] proc-use-__auto_type-more.patch removed from -mm tree
Message-Id: <20240917081149.F1EDFC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc: use __auto_type more
has been removed from the -mm tree.  Its filename was
     proc-use-__auto_type-more.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: use __auto_type more
Date: Sun, 8 Sep 2024 12:26:22 +0300

Switch away from quite chatty declarations using typeof_member().

In theory this is faster to compile too because there is no macro
expansion and there is less type checking.

Link: https://lkml.kernel.org/r/81bf02fd-8724-4f4d-a2bb-c59620b7d716@p183
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |   31 ++++++++-----------------------
 1 file changed, 8 insertions(+), 23 deletions(-)

--- a/fs/proc/inode.c~proc-use-__auto_type-more
+++ a/fs/proc/inode.c
@@ -303,9 +303,7 @@ static ssize_t proc_reg_read_iter(struct
 
 static ssize_t pde_read(struct proc_dir_entry *pde, struct file *file, char __user *buf, size_t count, loff_t *ppos)
 {
-	typeof_member(struct proc_ops, proc_read) read;
-
-	read = pde->proc_ops->proc_read;
+	__auto_type read = pde->proc_ops->proc_read;
 	if (read)
 		return read(file, buf, count, ppos);
 	return -EIO;
@@ -327,9 +325,7 @@ static ssize_t proc_reg_read(struct file
 
 static ssize_t pde_write(struct proc_dir_entry *pde, struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 {
-	typeof_member(struct proc_ops, proc_write) write;
-
-	write = pde->proc_ops->proc_write;
+	__auto_type write = pde->proc_ops->proc_write;
 	if (write)
 		return write(file, buf, count, ppos);
 	return -EIO;
@@ -351,9 +347,7 @@ static ssize_t proc_reg_write(struct fil
 
 static __poll_t pde_poll(struct proc_dir_entry *pde, struct file *file, struct poll_table_struct *pts)
 {
-	typeof_member(struct proc_ops, proc_poll) poll;
-
-	poll = pde->proc_ops->proc_poll;
+	__auto_type poll = pde->proc_ops->proc_poll;
 	if (poll)
 		return poll(file, pts);
 	return DEFAULT_POLLMASK;
@@ -375,9 +369,7 @@ static __poll_t proc_reg_poll(struct fil
 
 static long pde_ioctl(struct proc_dir_entry *pde, struct file *file, unsigned int cmd, unsigned long arg)
 {
-	typeof_member(struct proc_ops, proc_ioctl) ioctl;
-
-	ioctl = pde->proc_ops->proc_ioctl;
+	__auto_type ioctl = pde->proc_ops->proc_ioctl;
 	if (ioctl)
 		return ioctl(file, cmd, arg);
 	return -ENOTTY;
@@ -400,9 +392,7 @@ static long proc_reg_unlocked_ioctl(stru
 #ifdef CONFIG_COMPAT
 static long pde_compat_ioctl(struct proc_dir_entry *pde, struct file *file, unsigned int cmd, unsigned long arg)
 {
-	typeof_member(struct proc_ops, proc_compat_ioctl) compat_ioctl;
-
-	compat_ioctl = pde->proc_ops->proc_compat_ioctl;
+	__auto_type compat_ioctl = pde->proc_ops->proc_compat_ioctl;
 	if (compat_ioctl)
 		return compat_ioctl(file, cmd, arg);
 	return -ENOTTY;
@@ -424,9 +414,7 @@ static long proc_reg_compat_ioctl(struct
 
 static int pde_mmap(struct proc_dir_entry *pde, struct file *file, struct vm_area_struct *vma)
 {
-	typeof_member(struct proc_ops, proc_mmap) mmap;
-
-	mmap = pde->proc_ops->proc_mmap;
+	__auto_type mmap = pde->proc_ops->proc_mmap;
 	if (mmap)
 		return mmap(file, vma);
 	return -EIO;
@@ -483,7 +471,6 @@ static int proc_reg_open(struct inode *i
 	struct proc_dir_entry *pde = PDE(inode);
 	int rv = 0;
 	typeof_member(struct proc_ops, proc_open) open;
-	typeof_member(struct proc_ops, proc_release) release;
 	struct pde_opener *pdeo;
 
 	if (!pde->proc_ops->proc_lseek)
@@ -510,7 +497,7 @@ static int proc_reg_open(struct inode *i
 	if (!use_pde(pde))
 		return -ENOENT;
 
-	release = pde->proc_ops->proc_release;
+	__auto_type release = pde->proc_ops->proc_release;
 	if (release) {
 		pdeo = kmem_cache_alloc(pde_opener_cache, GFP_KERNEL);
 		if (!pdeo) {
@@ -547,9 +534,7 @@ static int proc_reg_release(struct inode
 	struct pde_opener *pdeo;
 
 	if (pde_is_permanent(pde)) {
-		typeof_member(struct proc_ops, proc_release) release;
-
-		release = pde->proc_ops->proc_release;
+		__auto_type release = pde->proc_ops->proc_release;
 		if (release) {
 			return release(inode, file);
 		}
_

Patches currently in -mm which might be from adobriyan@gmail.com are


