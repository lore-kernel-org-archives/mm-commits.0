From: akpm@linux-foundation.org
Subject: +
 include-lib-add-__printf-attributes-to-several-function-prototypes.patch
 added to -mm tree
Date: Tue, 07 Jul 2015 14:54:03 -0700
Message-ID: <559c4a7b.+99CYn1zSZTBY3Jo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58868 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932425AbbGGVyE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jul 2015 17:54:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.iooss_linux@m4x.org, balbi@ti.com, gregkh@linuxfoundation.org, jlbec@evilplan.org, mm-commits@vger.kernel.org


The patch titled
     Subject: include, lib: add __printf attributes to several function prototypes
has been added to the -mm tree.  Its filename is
     include-lib-add-__printf-attributes-to-several-function-prototypes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-lib-add-__printf-attributes-to-several-function-prototypes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-lib-add-__printf-attributes-to-several-function-prototypes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Subject: include, lib: add __printf attributes to several function prototypes

Using __printf attributes helps to detect several format string issues at
compile time (even though -Wformat-security is currently disabled in
Makefile).  For example it can detect when formatting a pointer as a
number, like the issue fixed in commit a3fa71c40f18 ("wl18xx: show
rx_frames_per_rates as an array as it really is"), or when the arguments
do not match the format string, c.f.  for example commit 5ce1aca81435
("reiserfs: fix __RASSERT format string").

To prevent similar bugs in the future, add a __printf attribute to every
function prototype which needs one in include/linux/ and lib/.  These
functions were mostly found by using gcc's -Wsuggest-attribute=format
flag.

Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/clkdev.h    |    7 ++++---
 include/linux/compat.h    |    2 +-
 include/linux/configfs.h  |    3 ++-
 include/linux/cpu.h       |    7 ++++---
 include/linux/dcache.h    |    3 ++-
 include/linux/device.h    |   15 +++++++--------
 include/linux/iommu.h     |    2 +-
 include/linux/kernel.h    |    9 +++++----
 include/linux/kobject.h   |    5 +++--
 include/linux/mmiotrace.h |    2 +-
 include/linux/printk.h    |    6 +++---
 lib/kobject.c             |    5 +++--
 12 files changed, 36 insertions(+), 30 deletions(-)

diff -puN include/linux/clkdev.h~include-lib-add-__printf-attributes-to-several-function-prototypes include/linux/clkdev.h
--- a/include/linux/clkdev.h~include-lib-add-__printf-attributes-to-several-function-prototypes
+++ a/include/linux/clkdev.h
@@ -33,18 +33,19 @@ struct clk_lookup {
 	}
 
 struct clk_lookup *clkdev_alloc(struct clk *clk, const char *con_id,
-	const char *dev_fmt, ...);
+	const char *dev_fmt, ...) __printf(3, 4);
 
 void clkdev_add(struct clk_lookup *cl);
 void clkdev_drop(struct clk_lookup *cl);
 
 struct clk_lookup *clkdev_create(struct clk *clk, const char *con_id,
-	const char *dev_fmt, ...);
+	const char *dev_fmt, ...) __printf(3, 4);
 
 void clkdev_add_table(struct clk_lookup *, size_t);
 int clk_add_alias(const char *, const char *, const char *, struct device *);
 
-int clk_register_clkdev(struct clk *, const char *, const char *, ...);
+int clk_register_clkdev(struct clk *, const char *, const char *, ...)
+	__printf(3, 4);
 int clk_register_clkdevs(struct clk *, struct clk_lookup *, size_t);
 
 #ifdef CONFIG_COMMON_CLK
diff -puN include/linux/compat.h~include-lib-add-__printf-attributes-to-several-function-prototypes include/linux/compat.h
--- a/include/linux/compat.h~include-lib-add-__printf-attributes-to-several-function-prototypes
+++ a/include/linux/compat.h
@@ -424,7 +424,7 @@ asmlinkage long compat_sys_settimeofday(
 
 asmlinkage long compat_sys_adjtimex(struct compat_timex __user *utp);
 
-extern int compat_printk(const char *fmt, ...);
+extern __printf(1, 2) int compat_printk(const char *fmt, ...);
 extern void sigset_from_compat(sigset_t *set, const compat_sigset_t *compat);
 extern void sigset_to_compat(compat_sigset_t *compat, const sigset_t *set);
 
diff -puN include/linux/configfs.h~include-lib-add-__printf-attributes-to-several-function-prototypes include/linux/configfs.h
--- a/include/linux/configfs.h~include-lib-add-__printf-attributes-to-several-function-prototypes
+++ a/include/linux/configfs.h
@@ -64,7 +64,8 @@ struct config_item {
 	struct dentry		*ci_dentry;
 };
 
-extern int config_item_set_name(struct config_item *, const char *, ...);
+extern __printf(2, 3)
+int config_item_set_name(struct config_item *, const char *, ...);
 
 static inline char *config_item_name(struct config_item * item)
 {
diff -puN include/linux/cpu.h~include-lib-add-__printf-attributes-to-several-function-prototypes include/linux/cpu.h
--- a/include/linux/cpu.h~include-lib-add-__printf-attributes-to-several-function-prototypes
+++ a/include/linux/cpu.h
@@ -40,9 +40,10 @@ extern void cpu_remove_dev_attr(struct d
 extern int cpu_add_dev_attr_group(struct attribute_group *attrs);
 extern void cpu_remove_dev_attr_group(struct attribute_group *attrs);
 
-extern struct device *cpu_device_create(struct device *parent, void *drvdata,
-					const struct attribute_group **groups,
-					const char *fmt, ...);
+extern __printf(4, 5)
+struct device *cpu_device_create(struct device *parent, void *drvdata,
+				 const struct attribute_group **groups,
+				 const char *fmt, ...);
 #ifdef CONFIG_HOTPLUG_CPU
 extern void unregister_cpu(struct cpu *cpu);
 extern ssize_t arch_cpu_probe(const char *, size_t);
diff -puN include/linux/dcache.h~include-lib-add-__printf-attributes-to-several-function-prototypes include/linux/dcache.h
--- a/include/linux/dcache.h~include-lib-add-__printf-attributes-to-several-function-prototypes
+++ a/include/linux/dcache.h
@@ -327,7 +327,8 @@ static inline unsigned d_count(const str
 /*
  * helper function for dentry_operations.d_dname() members
  */
-extern char *dynamic_dname(struct dentry *, char *, int, const char *, ...);
+extern __printf(4, 5)
+char *dynamic_dname(struct dentry *, char *, int, const char *, ...);
 extern char *simple_dname(struct dentry *, char *, int);
 
 extern char *__d_path(const struct path *, const struct path *, char *, int);
diff -puN include/linux/device.h~include-lib-add-__printf-attributes-to-several-function-prototypes include/linux/device.h
--- a/include/linux/device.h~include-lib-add-__printf-attributes-to-several-function-prototypes
+++ a/include/linux/device.h
@@ -637,8 +637,9 @@ extern int devres_release_group(struct d
 
 /* managed devm_k.alloc/kfree for device drivers */
 extern void *devm_kmalloc(struct device *dev, size_t size, gfp_t gfp);
-extern char *devm_kvasprintf(struct device *dev, gfp_t gfp, const char *fmt,
-			     va_list ap);
+extern __printf(3, 0)
+char *devm_kvasprintf(struct device *dev, gfp_t gfp, const char *fmt,
+		      va_list ap);
 extern __printf(3, 4)
 char *devm_kasprintf(struct device *dev, gfp_t gfp, const char *fmt, ...);
 static inline void *devm_kzalloc(struct device *dev, size_t size, gfp_t gfp)
@@ -1011,12 +1012,10 @@ extern int __must_check device_reprobe(s
 /*
  * Easy functions for dynamically creating devices on the fly
  */
-extern struct device *device_create_vargs(struct class *cls,
-					  struct device *parent,
-					  dev_t devt,
-					  void *drvdata,
-					  const char *fmt,
-					  va_list vargs);
+extern __printf(5, 0)
+struct device *device_create_vargs(struct class *cls, struct device *parent,
+				   dev_t devt, void *drvdata,
+				   const char *fmt, va_list vargs);
 extern __printf(5, 6)
 struct device *device_create(struct class *cls, struct device *parent,
 			     dev_t devt, void *drvdata,
diff -puN include/linux/iommu.h~include-lib-add-__printf-attributes-to-several-function-prototypes include/linux/iommu.h
--- a/include/linux/iommu.h~include-lib-add-__printf-attributes-to-several-function-prototypes
+++ a/include/linux/iommu.h
@@ -258,7 +258,7 @@ extern int iommu_domain_set_attr(struct
 				 void *data);
 struct device *iommu_device_create(struct device *parent, void *drvdata,
 				   const struct attribute_group **groups,
-				   const char *fmt, ...);
+				   const char *fmt, ...) __printf(4, 5);
 void iommu_device_destroy(struct device *dev);
 int iommu_device_link(struct device *dev, struct device *link);
 void iommu_device_unlink(struct device *dev, struct device *link);
diff -puN include/linux/kernel.h~include-lib-add-__printf-attributes-to-several-function-prototypes include/linux/kernel.h
--- a/include/linux/kernel.h~include-lib-add-__printf-attributes-to-several-function-prototypes
+++ a/include/linux/kernel.h
@@ -411,7 +411,8 @@ extern __printf(3, 0)
 int vscnprintf(char *buf, size_t size, const char *fmt, va_list args);
 extern __printf(2, 3)
 char *kasprintf(gfp_t gfp, const char *fmt, ...);
-extern char *kvasprintf(gfp_t gfp, const char *fmt, va_list args);
+extern __printf(2, 0)
+char *kvasprintf(gfp_t gfp, const char *fmt, va_list args);
 
 extern __scanf(2, 3)
 int sscanf(const char *, const char *, ...);
@@ -679,10 +680,10 @@ do {									\
 		__ftrace_vprintk(_THIS_IP_, fmt, vargs);		\
 } while (0)
 
-extern int
+extern __printf(2, 0) int
 __ftrace_vbprintk(unsigned long ip, const char *fmt, va_list ap);
 
-extern int
+extern __printf(2, 0) int
 __ftrace_vprintk(unsigned long ip, const char *fmt, va_list ap);
 
 extern void ftrace_dump(enum ftrace_dump_mode oops_dump_mode);
@@ -702,7 +703,7 @@ int trace_printk(const char *fmt, ...)
 {
 	return 0;
 }
-static inline int
+static __printf(1, 0) inline int
 ftrace_vprintk(const char *fmt, va_list ap)
 {
 	return 0;
diff -puN include/linux/kobject.h~include-lib-add-__printf-attributes-to-several-function-prototypes include/linux/kobject.h
--- a/include/linux/kobject.h~include-lib-add-__printf-attributes-to-several-function-prototypes
+++ a/include/linux/kobject.h
@@ -80,8 +80,9 @@ struct kobject {
 
 extern __printf(2, 3)
 int kobject_set_name(struct kobject *kobj, const char *name, ...);
-extern int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
-				  va_list vargs);
+extern __printf(2, 0)
+int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
+			   va_list vargs);
 
 static inline const char *kobject_name(const struct kobject *kobj)
 {
diff -puN include/linux/mmiotrace.h~include-lib-add-__printf-attributes-to-several-function-prototypes include/linux/mmiotrace.h
--- a/include/linux/mmiotrace.h~include-lib-add-__printf-attributes-to-several-function-prototypes
+++ a/include/linux/mmiotrace.h
@@ -106,6 +106,6 @@ extern void enable_mmiotrace(void);
 extern void disable_mmiotrace(void);
 extern void mmio_trace_rw(struct mmiotrace_rw *rw);
 extern void mmio_trace_mapping(struct mmiotrace_map *map);
-extern int mmio_trace_printk(const char *fmt, va_list args);
+extern __printf(1, 0) int mmio_trace_printk(const char *fmt, va_list args);
 
 #endif /* _LINUX_MMIOTRACE_H */
diff -puN include/linux/printk.h~include-lib-add-__printf-attributes-to-several-function-prototypes include/linux/printk.h
--- a/include/linux/printk.h~include-lib-add-__printf-attributes-to-several-function-prototypes
+++ a/include/linux/printk.h
@@ -122,7 +122,7 @@ static inline __printf(1, 2) __cold
 void early_printk(const char *s, ...) { }
 #endif
 
-typedef int(*printk_func_t)(const char *fmt, va_list args);
+typedef __printf(1, 0) int (*printk_func_t)(const char *fmt, va_list args);
 
 #ifdef CONFIG_PRINTK
 asmlinkage __printf(5, 0)
@@ -166,7 +166,7 @@ char *log_buf_addr_get(void);
 u32 log_buf_len_get(void);
 void log_buf_kexec_setup(void);
 void __init setup_log_buf(int early);
-void dump_stack_set_arch_desc(const char *fmt, ...);
+__printf(1, 2) void dump_stack_set_arch_desc(const char *fmt, ...);
 void dump_stack_print_info(const char *log_lvl);
 void show_regs_print_info(const char *log_lvl);
 #else
@@ -217,7 +217,7 @@ static inline void setup_log_buf(int ear
 {
 }
 
-static inline void dump_stack_set_arch_desc(const char *fmt, ...)
+static inline __printf(1, 2) void dump_stack_set_arch_desc(const char *fmt, ...)
 {
 }
 
diff -puN lib/kobject.c~include-lib-add-__printf-attributes-to-several-function-prototypes lib/kobject.c
--- a/lib/kobject.c~include-lib-add-__printf-attributes-to-several-function-prototypes
+++ a/lib/kobject.c
@@ -337,8 +337,9 @@ error:
 }
 EXPORT_SYMBOL(kobject_init);
 
-static int kobject_add_varg(struct kobject *kobj, struct kobject *parent,
-			    const char *fmt, va_list vargs)
+static __printf(3, 0) int kobject_add_varg(struct kobject *kobj,
+					   struct kobject *parent,
+					   const char *fmt, va_list vargs)
 {
 	int retval;
 
_

Patches currently in -mm which might be from nicolas.iooss_linux@m4x.org are

include-lib-add-__printf-attributes-to-several-function-prototypes.patch
configfs-fix-kernel-infoleak-through-user-controlled-format-string.patch
linux-next.patch

