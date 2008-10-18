From: akpm@linux-foundation.org
Subject: - profiling-dynamically-enable-readprofile-at-runtime.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:11:52 -0700
Message-ID: <200810182311.m9INBq9K027809@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53381 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751246AbYJRXMK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:12:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@linux.vnet.ibm.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     profiling: dynamically enable readprofile at runtime
has been removed from the -mm tree.  Its filename was
     profiling-dynamically-enable-readprofile-at-runtime.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: profiling: dynamically enable readprofile at runtime
From: Dave Hansen <dave@linux.vnet.ibm.com>

Way too often, I have a machine that exhibits some kind of crappy
behavior.  The CPU looks wedged in the kernel or it is spending way too
much system time and I wonder what is responsible.

I try to run readprofile.  But, of course, Ubuntu doesn't enable it by
default.  Dang!

The reason we boot-time enable it is that it takes a big bufffer that we
generally can only bootmem alloc.  But, does it hurt to at least try and
runtime-alloc it?

To use:
echo 2 > /sys/kernel/profile

Then run readprofile like normal.

This should fix the compile issue with allmodconfig.  I've compile-tested
on a bunch more configs now including a few more architectures.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-profiling |   13 ++++++
 include/linux/profile.h                   |    8 ++-
 kernel/ksysfs.c                           |   35 +++++++++++++++++
 kernel/profile.c                          |   41 +++++++++++++++-----
 4 files changed, 84 insertions(+), 13 deletions(-)

diff -puN /dev/null Documentation/ABI/testing/sysfs-profiling
--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-profiling
@@ -0,0 +1,13 @@
+What:		/sys/kernel/profile
+Date:		September 2008
+Contact:	Dave Hansen <dave@linux.vnet.ibm.com>
+Description:
+		/sys/kernel/profile is the runtime equivalent
+		of the boot-time profile= option.
+
+		You can get the same effect running:
+
+			echo 2 > /sys/kernel/profile
+
+		as you would by issuing profile=2 on the boot
+		command line.
diff -puN include/linux/profile.h~profiling-dynamically-enable-readprofile-at-runtime include/linux/profile.h
--- a/include/linux/profile.h~profiling-dynamically-enable-readprofile-at-runtime
+++ a/include/linux/profile.h
@@ -35,7 +35,9 @@ enum profile_type {
 extern int prof_on __read_mostly;
 
 /* init basic kernel profiler */
-void __init profile_init(void);
+int profile_init(void);
+int profile_setup(char *str);
+int create_proc_profile(void);
 void profile_tick(int type);
 
 /*
@@ -84,9 +86,9 @@ struct pt_regs;
 
 #define prof_on 0
 
-static inline void profile_init(void)
+static inline int profile_init(void)
 {
-	return;
+	return 0;
 }
 
 static inline void profile_tick(int type)
diff -puN kernel/ksysfs.c~profiling-dynamically-enable-readprofile-at-runtime kernel/ksysfs.c
--- a/kernel/ksysfs.c~profiling-dynamically-enable-readprofile-at-runtime
+++ a/kernel/ksysfs.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kexec.h>
+#include <linux/profile.h>
 #include <linux/sched.h>
 
 #define KERNEL_ATTR_RO(_name) \
@@ -53,6 +54,37 @@ static ssize_t uevent_helper_store(struc
 KERNEL_ATTR_RW(uevent_helper);
 #endif
 
+#ifdef CONFIG_PROFILING
+static ssize_t profiling_show(struct kobject *kobj,
+				  struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", prof_on);
+}
+static ssize_t profiling_store(struct kobject *kobj,
+				   struct kobj_attribute *attr,
+				   const char *buf, size_t count)
+{
+	int ret;
+
+	if (prof_on)
+		return -EEXIST;
+	/*
+	 * This eventually calls into get_option() which
+	 * has a ton of callers and is not const.  It is
+	 * easiest to cast it away here.
+	 */
+	profile_setup((char *)buf);
+	ret = profile_init();
+	if (ret)
+		return ret;
+	ret = create_proc_profile();
+	if (ret)
+		return ret;
+	return count;
+}
+KERNEL_ATTR_RW(profiling);
+#endif
+
 #ifdef CONFIG_KEXEC
 static ssize_t kexec_loaded_show(struct kobject *kobj,
 				 struct kobj_attribute *attr, char *buf)
@@ -109,6 +141,9 @@ static struct attribute * kernel_attrs[]
 	&uevent_seqnum_attr.attr,
 	&uevent_helper_attr.attr,
 #endif
+#ifdef CONFIG_PROFILING
+	&profiling_attr.attr,
+#endif
 #ifdef CONFIG_KEXEC
 	&kexec_loaded_attr.attr,
 	&kexec_crash_loaded_attr.attr,
diff -puN kernel/profile.c~profiling-dynamically-enable-readprofile-at-runtime kernel/profile.c
--- a/kernel/profile.c~profiling-dynamically-enable-readprofile-at-runtime
+++ a/kernel/profile.c
@@ -22,6 +22,8 @@
 #include <linux/cpu.h>
 #include <linux/highmem.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
 #include <asm/sections.h>
 #include <asm/irq_regs.h>
 #include <asm/ptrace.h>
@@ -50,11 +52,11 @@ static DEFINE_PER_CPU(int, cpu_profile_f
 static DEFINE_MUTEX(profile_flip_mutex);
 #endif /* CONFIG_SMP */
 
-static int __init profile_setup(char *str)
+int profile_setup(char *str)
 {
-	static char __initdata schedstr[] = "schedule";
-	static char __initdata sleepstr[] = "sleep";
-	static char __initdata kvmstr[] = "kvm";
+	static char schedstr[] = "schedule";
+	static char sleepstr[] = "sleep";
+	static char kvmstr[] = "kvm";
 	int par;
 
 	if (!strncmp(str, sleepstr, strlen(sleepstr))) {
@@ -100,14 +102,33 @@ static int __init profile_setup(char *st
 __setup("profile=", profile_setup);
 
 
-void __init profile_init(void)
+int profile_init(void)
 {
+	int buffer_bytes;
 	if (!prof_on)
-		return;
+		return 0;
 
 	/* only text is profiled */
 	prof_len = (_etext - _stext) >> prof_shift;
-	prof_buffer = alloc_bootmem(prof_len*sizeof(atomic_t));
+	buffer_bytes = prof_len*sizeof(atomic_t);
+	if (!slab_is_available()) {
+		prof_buffer = alloc_bootmem(buffer_bytes);
+		return 0;
+	}
+
+	prof_buffer = kzalloc(buffer_bytes, GFP_KERNEL);
+	if (prof_buffer)
+		return 0;
+
+	prof_buffer = alloc_pages_exact(buffer_bytes, GFP_KERNEL|__GFP_ZERO);
+	if (prof_buffer)
+		return 0;
+
+	prof_buffer = vmalloc(buffer_bytes);
+	if (prof_buffer)
+		return 0;
+
+	return -ENOMEM;
 }
 
 /* Profile event notifications */
@@ -527,7 +548,7 @@ static void __init profile_nop(void *unu
 {
 }
 
-static int __init create_hash_tables(void)
+static int create_hash_tables(void)
 {
 	int cpu;
 
@@ -575,14 +596,14 @@ out_cleanup:
 #define create_hash_tables()			({ 0; })
 #endif
 
-static int __init create_proc_profile(void)
+int create_proc_profile(void)
 {
 	struct proc_dir_entry *entry;
 
 	if (!prof_on)
 		return 0;
 	if (create_hash_tables())
-		return -1;
+		return -ENOMEM;
 	entry = proc_create("profile", S_IWUSR | S_IRUGO,
 			    NULL, &proc_profile_operations);
 	if (!entry)
_

Patches currently in -mm which might be from dave@linux.vnet.ibm.com are

origin.patch
mlock-mlocked-pages-are-unevictable.patch

