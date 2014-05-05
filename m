From: akpm@linux-foundation.org
Subject: + kernel-kexecc-convert-printk-to-pr_foo.patch added to -mm tree
Date: Mon, 05 May 2014 13:14:05 -0700
Message-ID: <5367f10d.hwNWwjEVlqxniD27%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbaEEUOG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2014 16:14:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgoyal@redhat.com, ebiederm@xmission.com, fabf@skynet.be

Subject: + kernel-kexecc-convert-printk-to-pr_foo.patch added to -mm tree
To: fabf@skynet.be,ebiederm@xmission.com,vgoyal@redhat.com
From: akpm@linux-foundation.org
Date: Mon, 05 May 2014 13:14:05 -0700


The patch titled
     Subject: kernel/kexec.c: convert printk to pr_foo()
has been added to the -mm tree.  Its filename is
     kernel-kexecc-convert-printk-to-pr_foo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-kexecc-convert-printk-to-pr_foo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-kexecc-convert-printk-to-pr_foo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 
@@ -1684,7 +1679,7 @@ int kernel_kexec(void)
 		kexec_in_progress = true;
 		kernel_restart_prepare(NULL);
 		migrate_to_reboot_cpu();
-		printk(KERN_EMERG "Starting new kernel\n");
+		pr_emerg("Starting new kernel\n");
 		machine_shutdown();
 	}
 
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-ceph-replace-pr_warning-by-pr_warn.patch
fs-jfs-jfs_logmgrc-remove-null-assignment-on-static.patch
fs-jfs-superc-remove-0-assignement-to-static-code-clean-up.patch
ntfs-remove-null-value-assignments.patch
fs-squashfs-squashfsh-replace-pr_warning-by-pr_warn.patch
fs-configs-itemc-kernel-doc-fixes-clean-up.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
fs-9p-v9fsc-add-__init-to-v9fs_sysfs_init.patch
fs-9p-kerneldoc-fixes.patch
mm-slubc-convert-printk-to-pr_foo.patch
mm-slubc-convert-vnsprintf-static-to-va_format.patch
mm-memory_hotplugc-use-pfn_down.patch
mm-memblockc-use-pfn_down.patch
mm-memcontrolc-remove-null-assignment-on-static.patch
mm-vmallocc-replace-seq_printf-by-seq_puts.patch
mm-zbudc-make-size-unsigned-like-unique-callsite.patch
sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
lib-libcrc32cc-use-ptr_err_or_zero.patch
lib-vsprintfc-fix-comparison-to-bool.patch
fs-binfmt_elfc-fix-bool-assignements.patch
fs-autofs4-dev-ioctlc-add-__init-to-autofs_dev_ioctl_init.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
linux-next.patch
init-mainc-code-clean-up.patch
ufs-sb-mutex-merge-mutex_destroy.patch
kernel-cpuc-convert-printk-to-pr_foo.patch
kernel-backtracetestc-replace-no-level-printk-by-pr_info.patch
kernel-capabilityc-code-clean-up.patch
kernel-compatc-use-sizeof-instead-of-sizeof.patch
kernel-exec_domainc-code-clean-up.patch
kernel-kexecc-convert-printk-to-pr_foo.patch
kernel-cpusetc-kernel-doc-fixes.patch
kernel-cpusetc-convert-printk-to-pr_foo.patch

