From: akpm@linux-foundation.org
Subject: + profiling-dynamically-enable-readprofile-at-runtime.patch added to -mm tree
Date: Tue, 02 Sep 2008 15:16:17 -0700
Message-ID: <200809022216.m82MGHMN015598@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40787 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752986AbYIBWRN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 18:17:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dave@linux.vnet.ibm.com, mingo@elte.hu


The patch titled
     profiling: dynamically enable readprofile at runtime
has been added to the -mm tree.  Its filename is
     profiling-dynamically-enable-readprofile-at-runtime.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ksysfs.c  |   29 +++++++++++++++++++++++++++++
 kernel/profile.c |   33 ++++++++++++++++++++++++---------
 2 files changed, 53 insertions(+), 9 deletions(-)

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
@@ -53,6 +54,31 @@ static ssize_t uevent_helper_store(struc
 KERNEL_ATTR_RW(uevent_helper);
 #endif
 
+#ifdef CONFIG_PROFILING
+/* uevent helper program, used during early boo */
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
+	profile_setup(buf);
+	profile_init();
+	if (!prof_buffer)
+		return -ENOMEM;
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
@@ -109,6 +135,9 @@ static struct attribute * kernel_attrs[]
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
@@ -50,11 +50,11 @@ static DEFINE_PER_CPU(int, cpu_profile_f
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
@@ -100,14 +100,29 @@ static int __init profile_setup(char *st
 __setup("profile=", profile_setup);
 
 
-void __init profile_init(void)
+void profile_init(void)
 {
+	int buffer_bytes;
 	if (!prof_on)
 		return;
 
 	/* only text is profiled */
 	prof_len = (_etext - _stext) >> prof_shift;
-	prof_buffer = alloc_bootmem(prof_len*sizeof(atomic_t));
+	buffer_bytes = prof_len*sizeof(atomic_t);
+	if (!slab_is_available()) {
+		prof_buffer = alloc_bootmem(buffer_bytes);
+		return;
+	}
+
+	prof_buffer = kzalloc(buffer_bytes, GFP_KERNEL);
+	if (prof_buffer)
+		return;
+
+	prof_buffer = alloc_pages_exact(buffer_bytes, GFP_KERNEL|__GFP_ZERO);
+	if (prof_buffer)
+		return;
+
+	prof_buffer = vmalloc(buffer_bytes);
 }
 
 /* Profile event notifications */
@@ -527,7 +542,7 @@ static void __init profile_nop(void *unu
 {
 }
 
-static int __init create_hash_tables(void)
+static int create_hash_tables(void)
 {
 	int cpu;
 
@@ -575,14 +590,14 @@ out_cleanup:
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

mm-make-setup_zone_migrate_reserve-aware-of-overlapping-nodes.patch
linux-next.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
profiling-dynamically-enable-readprofile-at-runtime.patch

