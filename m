From: akpm@linux-foundation.org
Subject: + kexec-premit-reduction-of-the-reserved-memory-size.patch added to -mm tree
Date: Mon, 23 Nov 2009 13:14:02 -0800
Message-ID: <200911232114.nANLE2q0024920@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56742 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755098AbZKWVOW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Nov 2009 16:14:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amwang@redhat.com, andi@firstfloor.org, ebiederm@xmission.com, nhorman@redhat.com


The patch titled
     kexec: premit reduction of the reserved memory size
has been added to the -mm tree.  Its filename is
     kexec-premit-reduction-of-the-reserved-memory-size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kexec: premit reduction of the reserved memory size
From: Amerigo Wang <amwang@redhat.com>

Implement shrinking the reserved memory for crash kernel, if it is more
than enough.

For example, if you have already reserved 128M, now you just want 100M,
you can do:

# echo $((100*1024*1024)) > /sys/kernel/kexec_crash_size

Note, you can only do this before loading the crash kernel.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Neil Horman <nhorman@redhat.com>
Acked-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec.h |    2 +
 kernel/kexec.c        |   59 ++++++++++++++++++++++++++++++++++++++++
 kernel/ksysfs.c       |   21 ++++++++++++++
 3 files changed, 82 insertions(+)

diff -puN include/linux/kexec.h~kexec-premit-reduction-of-the-reserved-memory-size include/linux/kexec.h
--- a/include/linux/kexec.h~kexec-premit-reduction-of-the-reserved-memory-size
+++ a/include/linux/kexec.h
@@ -206,6 +206,8 @@ extern size_t vmcoreinfo_max_size;
 
 int __init parse_crashkernel(char *cmdline, unsigned long long system_ram,
 		unsigned long long *crash_size, unsigned long long *crash_base);
+int crash_shrink_memory(unsigned long new_size);
+size_t crash_get_memory_size(void);
 
 #else /* !CONFIG_KEXEC */
 struct pt_regs;
diff -puN kernel/kexec.c~kexec-premit-reduction-of-the-reserved-memory-size kernel/kexec.c
--- a/kernel/kexec.c~kexec-premit-reduction-of-the-reserved-memory-size
+++ a/kernel/kexec.c
@@ -31,6 +31,7 @@
 #include <linux/cpu.h>
 #include <linux/console.h>
 #include <linux/vmalloc.h>
+#include <linux/swap.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
@@ -1082,6 +1083,64 @@ void crash_kexec(struct pt_regs *regs)
 	}
 }
 
+size_t crash_get_memory_size(void)
+{
+	size_t size;
+	mutex_lock(&kexec_mutex);
+	size = crashk_res.end - crashk_res.start + 1;
+	mutex_unlock(&kexec_mutex);
+	return size;
+}
+
+static void free_reserved_phys_range(unsigned long begin, unsigned long end)
+{
+	unsigned long addr;
+
+	for (addr = begin; addr < end; addr += PAGE_SIZE) {
+		ClearPageReserved(pfn_to_page(addr >> PAGE_SHIFT));
+		init_page_count(pfn_to_page(addr >> PAGE_SHIFT));
+		free_page((unsigned long)__va(addr));
+		totalram_pages++;
+	}
+}
+
+int crash_shrink_memory(unsigned long new_size)
+{
+	int ret = 0;
+	unsigned long start, end;
+
+	mutex_lock(&kexec_mutex);
+
+	if (kexec_crash_image) {
+		ret = -ENOENT;
+		goto unlock;
+	}
+	start = crashk_res.start;
+	end = crashk_res.end;
+
+	if (new_size >= end - start + 1) {
+		ret = -EINVAL;
+		if (new_size == end - start + 1)
+			ret = 0;
+		goto unlock;
+	}
+
+	start = roundup(start, PAGE_SIZE);
+	end = roundup(start + new_size, PAGE_SIZE);
+
+	free_reserved_phys_range(end, crashk_res.end);
+
+	if (start == end) {
+		crashk_res.end = end;
+		release_resource(&crashk_res);
+	} else
+		crashk_res.end = end - 1;
+
+unlock:
+	mutex_unlock(&kexec_mutex);
+	return ret;
+}
+
 static u32 *append_elf_note(u32 *buf, char *name, unsigned type, void *data,
 			    size_t data_len)
 {
diff -puN kernel/ksysfs.c~kexec-premit-reduction-of-the-reserved-memory-size kernel/ksysfs.c
--- a/kernel/ksysfs.c~kexec-premit-reduction-of-the-reserved-memory-size
+++ a/kernel/ksysfs.c
@@ -100,6 +100,26 @@ static ssize_t kexec_crash_loaded_show(s
 }
 KERNEL_ATTR_RO(kexec_crash_loaded);
 
+static ssize_t kexec_crash_size_show(struct kobject *kobj,
+				       struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%lu\n", crash_get_memory_size());
+}
+static ssize_t kexec_crash_size_store(struct kobject *kobj,
+				   struct kobj_attribute *attr,
+				   const char *buf, size_t count)
+{
+	unsigned long cnt;
+	int ret;
+
+	if (strict_strtoul(buf, 0, &cnt))
+		return -EINVAL;
+
+	ret = crash_shrink_memory(cnt);
+	return ret < 0 ? ret : count;
+}
+KERNEL_ATTR_RW(kexec_crash_size);
+
 static ssize_t vmcoreinfo_show(struct kobject *kobj,
 			       struct kobj_attribute *attr, char *buf)
 {
@@ -147,6 +167,7 @@ static struct attribute * kernel_attrs[]
 #ifdef CONFIG_KEXEC
 	&kexec_loaded_attr.attr,
 	&kexec_crash_loaded_attr.attr,
+	&kexec_crash_size_attr.attr,
 	&vmcoreinfo_attr.attr,
 #endif
 	NULL
_

Patches currently in -mm which might be from amwang@redhat.com are

linux-next.patch
xtensa-use-generic-sys_pipe.patch
rwsem-spinlock-remove-useless-function-exports.patch
rwsem-fix-rwsem_is_locked-bugs.patch
rwsem-fix-rwsem_is_locked-bugs-fix.patch
kallsyms-remove-deprecated-print_fn_descriptor_symbol.patch
kexec-premit-reduction-of-the-reserved-memory-size.patch

