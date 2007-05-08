From: akpm@linux-foundation.org
Subject: - cris-check-for-memory-allocation.patch removed from -mm tree
Date: Mon, 07 May 2007 17:05:49 -0700
Message-ID: <200705080005.l4805ntK009123@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967362AbXEHAGO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:06:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     CRIS: check for memory allocation
has been removed from the -mm tree.  Its filename was
     cris-check-for-memory-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: CRIS: check for memory allocation
From: Cyrill Gorcunov <gorcunov@gmail.com>

Add checking for allocated memory.  Indents and spaces are added to be
familiar with the kernel coding style.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Acked-by: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/kernel/profile.c |   81 ++++++++++++++++++++---------------
 1 file changed, 48 insertions(+), 33 deletions(-)

diff -puN arch/cris/kernel/profile.c~cris-check-for-memory-allocation arch/cris/kernel/profile.c
--- a/arch/cris/kernel/profile.c~cris-check-for-memory-allocation
+++ a/arch/cris/kernel/profile.c
@@ -15,39 +15,47 @@ static int prof_running = 0;
 void
 cris_profile_sample(struct pt_regs* regs)
 {
-  if (!prof_running)
-    return;
-  if (user_mode(regs))
-    *(unsigned int*)sample_buffer_pos = current->pid;
-  else
-    *(unsigned int*)sample_buffer_pos = 0;
-  *(unsigned int*)(sample_buffer_pos + 4) = instruction_pointer(regs);
-  sample_buffer_pos += 8;
-  if (sample_buffer_pos == sample_buffer + SAMPLE_BUFFER_SIZE)
-    sample_buffer_pos = sample_buffer;
+	if (!prof_running)
+		return;
+
+	if (user_mode(regs))
+		*(unsigned int*)sample_buffer_pos = current->pid;
+	else
+		*(unsigned int*)sample_buffer_pos = 0;
+
+	*(unsigned int*)(sample_buffer_pos + 4) = instruction_pointer(regs);
+	sample_buffer_pos += 8;
+
+	if (sample_buffer_pos == sample_buffer + SAMPLE_BUFFER_SIZE)
+		sample_buffer_pos = sample_buffer;
 }
 
 static ssize_t
-read_cris_profile(struct file *file, char __user *buf, size_t count, loff_t *ppos)
+read_cris_profile(struct file *file, char __user *buf,
+		  size_t count, loff_t *ppos)
 {
-  unsigned long p = *ppos;
-  if (p > SAMPLE_BUFFER_SIZE)
-    return 0;
-  if (p + count > SAMPLE_BUFFER_SIZE)
-    count = SAMPLE_BUFFER_SIZE - p;
-  if (copy_to_user(buf, sample_buffer + p,count))
+	unsigned long p = *ppos;
+
+	if (p > SAMPLE_BUFFER_SIZE)
+		return 0;
+
+	if (p + count > SAMPLE_BUFFER_SIZE)
+		count = SAMPLE_BUFFER_SIZE - p;
+	if (copy_to_user(buf, sample_buffer + p,count))
 		return -EFAULT;
-  memset(sample_buffer + p, 0, count);
-  *ppos += count;
-  return count;
+
+	memset(sample_buffer + p, 0, count);
+	*ppos += count;
+
+	return count;
 }
 
 static ssize_t
 write_cris_profile(struct file *file, const char __user *buf,
-              size_t count, loff_t *ppos)
+		   size_t count, loff_t *ppos)
 {
-  sample_buffer_pos = sample_buffer;
-  memset(sample_buffer, 0, SAMPLE_BUFFER_SIZE);
+	sample_buffer_pos = sample_buffer;
+	memset(sample_buffer, 0, SAMPLE_BUFFER_SIZE);
 }
 
 static const struct file_operations cris_proc_profile_operations = {
@@ -58,16 +66,23 @@ static const struct file_operations cris
 static int
 __init init_cris_profile(void)
 {
-  struct proc_dir_entry *entry;
-  sample_buffer = kmalloc(SAMPLE_BUFFER_SIZE, GFP_KERNEL);
-  sample_buffer_pos = sample_buffer;
-  entry = create_proc_entry("system_profile", S_IWUSR | S_IRUGO, NULL);
-  if (entry) {
-    entry->proc_fops = &cris_proc_profile_operations;
-    entry->size = SAMPLE_BUFFER_SIZE;
-  }
-  prof_running = 1;
-  return 0;
+	struct proc_dir_entry *entry;
+
+	sample_buffer = kmalloc(SAMPLE_BUFFER_SIZE, GFP_KERNEL);
+	if (!sample_buffer) {
+		return -ENOMEM;
+	}
+
+	sample_buffer_pos = sample_buffer;
+
+	entry = create_proc_entry("system_profile", S_IWUSR | S_IRUGO, NULL);
+	if (entry) {
+		entry->proc_fops = &cris_proc_profile_operations;
+		entry->size = SAMPLE_BUFFER_SIZE;
+	}
+	prof_running = 1;
+
+	return 0;
 }
 
 __initcall(init_cris_profile);
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
