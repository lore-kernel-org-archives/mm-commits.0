From: akpm@linux-foundation.org
Subject: [merged] kernel-kexecc-convert-printk-to-pr_foo.patch removed
 from -mm tree
Date: Mon, 09 Jun 2014 12:34:52 -0700
Message-ID: <53960c5c.H55wNqbUhua3nzO1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54122 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbaFITex (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:34:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgoyal@redhat.com, ebiederm@xmission.com, fabf@skynet.be

Subject: [merged] kernel-kexecc-convert-printk-to-pr_foo.patch removed from -mm tree
To: fabf@skynet.be,ebiederm@xmission.com,vgoyal@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:34:52 -0700


The patch titled
     Subject: kernel/kexec.c: convert printk to pr_foo()
has been removed from the -mm tree.  Its filename was
     kernel-kexecc-convert-printk-to-pr_foo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: kernel/kexec.c: convert printk to pr_foo()

+ some pr_warning -> pr_warn and checkpatch warning fixes

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |   69 +++++++++++++++++++++--------------------------
 1 file changed, 32 insertions(+), 37 deletions(-)

diff -puN kernel/kexec.c~kernel-kexecc-convert-printk-to-pr_foo kernel/kexec.c
--- a/kernel/kexec.c~kernel-kexecc-convert-printk-to-pr_foo
+++ a/kernel/kexec.c
@@ -125,8 +125,8 @@ static struct page *kimage_alloc_page(st
 				       unsigned long dest);
 
 static int do_kimage_alloc(struct kimage **rimage, unsigned long entry,
-	                    unsigned long nr_segments,
-                            struct kexec_segment __user *segments)
+			   unsigned long nr_segments,
+			   struct kexec_segment __user *segments)
 {
 	size_t segment_bytes;
 	struct kimage *image;
@@ -257,13 +257,13 @@ static int kimage_normal_alloc(struct ki
 	image->control_code_page = kimage_alloc_control_pages(image,
 					   get_order(KEXEC_CONTROL_PAGE_SIZE));
 	if (!image->control_code_page) {
-		printk(KERN_ERR "Could not allocate control_code_buffer\n");
+		pr_err("Could not allocate control_code_buffer\n");
 		goto out_free;
 	}
 
 	image->swap_page = kimage_alloc_control_pages(image, 0);
 	if (!image->swap_page) {
-		printk(KERN_ERR "Could not allocate swap buffer\n");
+		pr_err("Could not allocate swap buffer\n");
 		goto out_free;
 	}
 
@@ -332,7 +332,7 @@ static int kimage_crash_alloc(struct kim
 	image->control_code_page = kimage_alloc_control_pages(image,
 					   get_order(KEXEC_CONTROL_PAGE_SIZE));
 	if (!image->control_code_page) {
-		printk(KERN_ERR "Could not allocate control_code_buffer\n");
+		pr_err("Could not allocate control_code_buffer\n");
 		goto out_free;
 	}
 
@@ -621,8 +621,8 @@ static void kimage_terminate(struct kima
 
 #define for_each_kimage_entry(image, ptr, entry) \
 	for (ptr = &image->head; (entry = *ptr) && !(entry & IND_DONE); \
-		ptr = (entry & IND_INDIRECTION)? \
-			phys_to_virt((entry & PAGE_MASK)): ptr +1)
+		ptr = (entry & IND_INDIRECTION) ? \
+			phys_to_virt((entry & PAGE_MASK)) : ptr + 1)
 
 static void kimage_free_entry(kimage_entry_t entry)
 {
@@ -650,8 +650,7 @@ static void kimage_free(struct kimage *i
 			 * done with it.
 			 */
 			ind = entry;
-		}
-		else if (entry & IND_SOURCE)
+		} else if (entry & IND_SOURCE)
 			kimage_free_entry(entry);
 	}
 	/* Free the final indirection page */
@@ -774,8 +773,7 @@ static struct page *kimage_alloc_page(st
 			addr = old_addr;
 			page = old_page;
 			break;
-		}
-		else {
+		} else {
 			/* Place the page on the destination list I
 			 * will use it later.
 			 */
@@ -1059,7 +1057,7 @@ COMPAT_SYSCALL_DEFINE4(kexec_load, compa
 		return -EINVAL;
 
 	ksegments = compat_alloc_user_space(nr_segments * sizeof(out));
-	for (i=0; i < nr_segments; i++) {
+	for (i = 0; i < nr_segments; i++) {
 		result = copy_from_user(&in, &segments[i], sizeof(in));
 		if (result)
 			return -EFAULT;
@@ -1214,14 +1212,14 @@ void crash_save_cpu(struct pt_regs *regs
 	 * squirrelled away.  ELF notes happen to provide
 	 * all of that, so there is no need to invent something new.
 	 */
-	buf = (u32*)per_cpu_ptr(crash_notes, cpu);
+	buf = (u32 *)per_cpu_ptr(crash_notes, cpu);
 	if (!buf)
 		return;
 	memset(&prstatus, 0, sizeof(prstatus));
 	prstatus.pr_pid = current->pid;
 	elf_core_copy_kernel_regs(&prstatus.pr_reg, regs);
 	buf = append_elf_note(buf, KEXEC_CORE_NOTE_NAME, NT_PRSTATUS,
-		      	      &prstatus, sizeof(prstatus));
+			      &prstatus, sizeof(prstatus));
 	final_note(buf);
 }
 
@@ -1230,8 +1228,7 @@ static int __init crash_notes_memory_ini
 	/* Allocate memory for saving cpu registers. */
 	crash_notes = alloc_percpu(note_buf_t);
 	if (!crash_notes) {
-		printk("Kexec: Memory allocation for saving cpu register"
-		" states failed\n");
+		pr_warn("Kexec: Memory allocation for saving cpu register states failed\n");
 		return -ENOMEM;
 	}
 	return 0;
@@ -1253,10 +1250,10 @@ subsys_initcall(crash_notes_memory_init)
  *
  * The function returns 0 on success and -EINVAL on failure.
  */
-static int __init parse_crashkernel_mem(char 			*cmdline,
-					unsigned long long	system_ram,
-					unsigned long long	*crash_size,
-					unsigned long long	*crash_base)
+static int __init parse_crashkernel_mem(char *cmdline,
+					unsigned long long system_ram,
+					unsigned long long *crash_size,
+					unsigned long long *crash_base)
 {
 	char *cur = cmdline, *tmp;
 
@@ -1267,12 +1264,12 @@ static int __init parse_crashkernel_mem(
 		/* get the start of the range */
 		start = memparse(cur, &tmp);
 		if (cur == tmp) {
-			pr_warning("crashkernel: Memory value expected\n");
+			pr_warn("crashkernel: Memory value expected\n");
 			return -EINVAL;
 		}
 		cur = tmp;
 		if (*cur != '-') {
-			pr_warning("crashkernel: '-' expected\n");
+			pr_warn("crashkernel: '-' expected\n");
 			return -EINVAL;
 		}
 		cur++;
@@ -1281,31 +1278,30 @@ static int __init parse_crashkernel_mem(
 		if (*cur != ':') {
 			end = memparse(cur, &tmp);
 			if (cur == tmp) {
-				pr_warning("crashkernel: Memory "
-						"value expected\n");
+				pr_warn("crashkernel: Memory value expected\n");
 				return -EINVAL;
 			}
 			cur = tmp;
 			if (end <= start) {
-				pr_warning("crashkernel: end <= start\n");
+				pr_warn("crashkernel: end <= start\n");
 				return -EINVAL;
 			}
 		}
 
 		if (*cur != ':') {
-			pr_warning("crashkernel: ':' expected\n");
+			pr_warn("crashkernel: ':' expected\n");
 			return -EINVAL;
 		}
 		cur++;
 
 		size = memparse(cur, &tmp);
 		if (cur == tmp) {
-			pr_warning("Memory value expected\n");
+			pr_warn("Memory value expected\n");
 			return -EINVAL;
 		}
 		cur = tmp;
 		if (size >= system_ram) {
-			pr_warning("crashkernel: invalid size\n");
+			pr_warn("crashkernel: invalid size\n");
 			return -EINVAL;
 		}
 
@@ -1323,8 +1319,7 @@ static int __init parse_crashkernel_mem(
 			cur++;
 			*crash_base = memparse(cur, &tmp);
 			if (cur == tmp) {
-				pr_warning("Memory value expected "
-						"after '@'\n");
+				pr_warn("Memory value expected after '@'\n");
 				return -EINVAL;
 			}
 		}
@@ -1336,26 +1331,26 @@ static int __init parse_crashkernel_mem(
 /*
  * That function parses "simple" (old) crashkernel command lines like
  *
- * 	crashkernel=size[@offset]
+ *	crashkernel=size[@offset]
  *
  * It returns 0 on success and -EINVAL on failure.
  */
-static int __init parse_crashkernel_simple(char 		*cmdline,
-					   unsigned long long 	*crash_size,
-					   unsigned long long 	*crash_base)
+static int __init parse_crashkernel_simple(char *cmdline,
+					   unsigned long long *crash_size,
+					   unsigned long long *crash_base)
 {
 	char *cur = cmdline;
 
 	*crash_size = memparse(cmdline, &cur);
 	if (cmdline == cur) {
-		pr_warning("crashkernel: memory value expected\n");
+		pr_warn("crashkernel: memory value expected\n");
 		return -EINVAL;
 	}
 
 	if (*cur == '@')
 		*crash_base = memparse(cur+1, &cur);
 	else if (*cur != ' ' && *cur != '\0') {
-		pr_warning("crashkernel: unrecognized char\n");
+		pr_warn("crashkernel: unrecognized char\n");
 		return -EINVAL;
 	}
 
@@ -1691,7 +1686,7 @@ int kernel_kexec(void)
 		 * CPU hotplug again; so re-enable it here.
 		 */
 		cpu_hotplug_enable();
-		printk(KERN_EMERG "Starting new kernel\n");
+		pr_emerg("Starting new kernel\n");
 		machine_shutdown();
 	}
 
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

