Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB1622FDE7
	for <mm-commits@vger.kernel.org>; Mon,  9 Jun 2025 23:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749513290; cv=none; b=evUk9mnRwJrw5RLRHOxi0FKIk2jDqcsn1sbBTt2q8/8EKH1bFqvM9kTjs4k+kZAtM9MZVkVv/2yRyLOpnCDvStgNxTQPUgp3l8bJFsBEiAI+mFn4vd15F+AgG8ASghJQC6IxjJUHgVJk04CDbqGDDO1szGvG1d4E9UfOTr7j9UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749513290; c=relaxed/simple;
	bh=d25SP5U5LtFr3KAKu9DdxlLT02yDe07JqdO9Fu6saUs=;
	h=Date:To:From:Subject:Message-Id; b=VdmIVlch3DoNILYmDEwg7/02sJ/60BdJnTJq4x7J3j6u0FnsiujYV/R3vQMGTjLgJFzicUEFibni1s/1ArqPEZDHtdS8XkTsjUqr0S37RovVBZa2IN/Pzi/4XEy0JgBXAp7bI9/gYu5gbX3XtNhtpNc7aAdPJ1uDW7Av5j4VSX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a/6pEfsD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a/6pEfsD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09562C4CEEB;
	Mon,  9 Jun 2025 23:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749513290;
	bh=d25SP5U5LtFr3KAKu9DdxlLT02yDe07JqdO9Fu6saUs=;
	h=Date:To:From:Subject:From;
	b=a/6pEfsDeylIp9NoMZAvcqByypGIhciI2FrJHcbIgGudsQyLCwXy/OK1OKFUCy19C
	 Ej3NAO+gKyFj0TlM/XSZqHuvaOkOJjpQZ0mrfBbI/6CLSeFnBazhCMrVJu8k4VEcU+
	 JFooXkTH9dXKzLQWZwFeqeW+DAahYrH58jPZzcdc=
Date: Mon, 09 Jun 2025 16:54:49 -0700
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,surenb@google.com,kent.overstreet@linux.dev,00107082@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-keep-codetag-iterator-active-between-read.patch added to mm-new branch
Message-Id: <20250609235450.09562C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: keep codetag iterator active between read()
has been added to the -mm mm-new branch.  Its filename is
     alloc_tag-keep-codetag-iterator-active-between-read.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-keep-codetag-iterator-active-between-read.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: David Wang <00107082@163.com>
Subject: alloc_tag: keep codetag iterator active between read()
Date: Mon, 9 Jun 2025 14:44:08 +0800

When reading /proc/allocinfo, for each read syscall, seq_file would invoke
start/stop callbacks.  In start callback, a memory is alloced to store
iterator and the iterator would start from beginning to walk linearly to
current read position.

seq_file read() takes at most 4096 bytes, even if read with a larger user
space buffer, meaning read out all of /proc/allocinfo, tens of read
syscalls are needed.  For example, a 306036 bytes allocinfo files need 76
reads:

 $ sudo cat /proc/allocinfo  | wc
    3964   16678  306036
 $ sudo strace -T -e read cat /proc/allocinfo
 ...
 read(3, "        4096        1 arch/x86/k"..., 131072) = 4063 <0.000062>
 ...
 read(3, "           0        0 sound/core"..., 131072) = 4021 <0.000150>
 ...
For those n=3964 lines, each read takes about m=3964/76=52 lines,
since iterator restart from beginning for each read(),
it would move forward
   m  steps on 1st read
 2*m  steps on 2nd read
 3*m  steps on 3rd read
 ...
   n  steps on last read
As read() along, those linear seek steps make read() calls slower and
slower.  Adding those up, codetag iterator moves about O(n*n/m) steps,
making data structure traversal take significant part of the whole
reading.  Profiling when stress reading /proc/allocinfo confirms it:

 vfs_read(99.959% 1677299/1677995)
     proc_reg_read_iter(99.856% 1674881/1677299)
         seq_read_iter(99.959% 1674191/1674881)
             allocinfo_start(75.664% 1266755/1674191)
                 codetag_next_ct(79.217% 1003487/1266755)  <---
                 srso_return_thunk(1.264% 16011/1266755)
                 __kmalloc_cache_noprof(0.102% 1296/1266755)
                 ...
             allocinfo_show(21.287% 356378/1674191)
             allocinfo_next(1.530% 25621/1674191)
codetag_next_ct() takes major part.

A private data alloced at open() time can be used to carry iterator alive
across read() calls, and avoid the memory allocation and iterator reset
for each read().  This way, only O(1) memory allocation and O(n) steps
iterating, and `time` shows performance improvement from ~7ms to ~4ms. 
Profiling with the change:

 vfs_read(99.865% 1581073/1583214)
     proc_reg_read_iter(99.485% 1572934/1581073)
         seq_read_iter(99.846% 1570519/1572934)
             allocinfo_show(87.428% 1373074/1570519)
                 seq_buf_printf(83.695% 1149196/1373074)
                 seq_buf_putc(1.917% 26321/1373074)
                 _find_next_bit(1.531% 21023/1373074)
                 ...
                 codetag_to_text(0.490% 6727/1373074)
                 ...
             allocinfo_next(6.275% 98543/1570519)
             ...
             allocinfo_start(0.369% 5790/1570519)
             ...
Now seq_buf_printf() takes major part.

Link: https://lkml.kernel.org/r/20250609064408.112783-1-00107082@163.com
Signed-off-by: David Wang <00107082@163.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/alloc_tag.c |   29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

--- a/lib/alloc_tag.c~alloc_tag-keep-codetag-iterator-active-between-read
+++ a/lib/alloc_tag.c
@@ -47,21 +47,16 @@ struct allocinfo_private {
 static void *allocinfo_start(struct seq_file *m, loff_t *pos)
 {
 	struct allocinfo_private *priv;
-	struct codetag *ct;
 	loff_t node = *pos;
 
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	m->private = priv;
-	if (!priv)
-		return NULL;
-
-	priv->print_header = (node == 0);
+	priv = (struct allocinfo_private *)m->private;
 	codetag_lock_module_list(alloc_tag_cttype, true);
-	priv->iter = codetag_get_ct_iter(alloc_tag_cttype);
-	while ((ct = codetag_next_ct(&priv->iter)) != NULL && node)
-		node--;
-
-	return ct ? priv : NULL;
+	if (node == 0) {
+		priv->print_header = true;
+		priv->iter = codetag_get_ct_iter(alloc_tag_cttype);
+		codetag_next_ct(&priv->iter);
+	}
+	return priv->iter.ct ? priv : NULL;
 }
 
 static void *allocinfo_next(struct seq_file *m, void *arg, loff_t *pos)
@@ -78,12 +73,7 @@ static void *allocinfo_next(struct seq_f
 
 static void allocinfo_stop(struct seq_file *m, void *arg)
 {
-	struct allocinfo_private *priv = (struct allocinfo_private *)m->private;
-
-	if (priv) {
-		codetag_lock_module_list(alloc_tag_cttype, false);
-		kfree(priv);
-	}
+	codetag_lock_module_list(alloc_tag_cttype, false);
 }
 
 static void print_allocinfo_header(struct seq_buf *buf)
@@ -813,7 +803,8 @@ static int __init alloc_tag_init(void)
 		return 0;
 	}
 
-	if (!proc_create_seq(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_seq_op)) {
+	if (!proc_create_seq_private(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_seq_op,
+				     sizeof(struct allocinfo_private), NULL)) {
 		pr_err("Failed to create %s file\n", ALLOCINFO_FILE_NAME);
 		shutdown_mem_profiling(false);
 		return -ENOMEM;
_

Patches currently in -mm which might be from 00107082@163.com are

alloc_tag-add-sequence-number-for-module-and-iterator.patch
alloc_tag-keep-codetag-iterator-active-between-read.patch

