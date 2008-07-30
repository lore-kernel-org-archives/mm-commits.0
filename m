From: akpm@linux-foundation.org
Subject: + include-replace-__function__-with-__func__.patch added to -mm tree
Date: Tue, 29 Jul 2008 17:13:13 -0700
Message-ID: <200807300013.m6U0DElj029458@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34589 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752942AbYG3ANQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 20:13:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     include: replace __FUNCTION__ with __func__
has been added to the -mm tree.  Its filename is
     include-replace-__function__-with-__func__.patch

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
Subject: include: replace __FUNCTION__ with __func__
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/acpi/acmacros.h                 |    6 +++---
 include/acpi/platform/acgcc.h           |    2 +-
 include/asm-arm/arch-iop13xx/time.h     |    4 ++--
 include/asm-arm/arch-pxa/zylonite.h     |    4 ++--
 include/asm-generic/bug.h               |    2 +-
 include/asm-powerpc/ptrace.h            |    2 +-
 include/asm-x86/mach-es7000/mach_apic.h |    2 +-
 include/asm-x86/mach-summit/mach_apic.h |    2 +-
 include/linux/ext2_fs.h                 |    2 +-
 include/linux/ext3_fs.h                 |    4 ++--
 include/linux/ext3_jbd.h                |   14 +++++++-------
 include/linux/jbd.h                     |    4 ++--
 include/linux/jbd2.h                    |    4 ++--
 include/linux/libata.h                  |    6 +++---
 include/linux/pm.h                      |    2 +-
 include/linux/reiserfs_fs.h             |    2 +-
 include/linux/rtmutex.h                 |    2 +-
 include/media/saa7146.h                 |    4 ++--
 include/net/9p/9p.h                     |    4 ++--
 include/net/bluetooth/bluetooth.h       |    4 ++--
 include/net/ieee80211.h                 |    2 +-
 include/net/ip_vs.h                     |    4 ++--
 include/net/irda/irda.h                 |    2 +-
 include/net/sctp/sctp.h                 |    2 +-
 include/video/cyblafb.h                 |    2 +-
 25 files changed, 44 insertions(+), 44 deletions(-)

diff -puN include/acpi/acmacros.h~include-replace-__function__-with-__func__ include/acpi/acmacros.h
--- a/include/acpi/acmacros.h~include-replace-__function__-with-__func__
+++ a/include/acpi/acmacros.h
@@ -467,7 +467,7 @@ struct acpi_integer_overlay {
 /*
  * If ACPI_GET_FUNCTION_NAME was not defined in the compiler-dependent header,
  * define it now. This is the case where there the compiler does not support
- * a __FUNCTION__ macro or equivalent.
+ * a __func__ macro or equivalent.
  */
 #ifndef ACPI_GET_FUNCTION_NAME
 #define ACPI_GET_FUNCTION_NAME          _acpi_function_name
@@ -475,12 +475,12 @@ struct acpi_integer_overlay {
  * The Name parameter should be the procedure name as a quoted string.
  * The function name is also used by the function exit macros below.
  * Note: (const char) is used to be compatible with the debug interfaces
- * and macros such as __FUNCTION__.
+ * and macros such as __func__.
  */
 #define ACPI_FUNCTION_NAME(name)	static const char _acpi_function_name[] = #name;
 
 #else
-/* Compiler supports __FUNCTION__ (or equivalent) -- Ignore this macro */
+/* Compiler supports __func__ (or equivalent) -- Ignore this macro */
 
 #define ACPI_FUNCTION_NAME(name)
 #endif
diff -puN include/acpi/platform/acgcc.h~include-replace-__function__-with-__func__ include/acpi/platform/acgcc.h
--- a/include/acpi/platform/acgcc.h~include-replace-__function__-with-__func__
+++ a/include/acpi/platform/acgcc.h
@@ -46,7 +46,7 @@
 
 /* Function name is used for debug output. Non-ANSI, compiler-dependent */
 
-#define ACPI_GET_FUNCTION_NAME          __FUNCTION__
+#define ACPI_GET_FUNCTION_NAME          __func__
 
 /*
  * This macro is used to tag functions as "printf-like" because
diff -puN include/asm-arm/arch-iop13xx/time.h~include-replace-__function__-with-__func__ include/asm-arm/arch-iop13xx/time.h
--- a/include/asm-arm/arch-iop13xx/time.h~include-replace-__function__-with-__func__
+++ a/include/asm-arm/arch-iop13xx/time.h
@@ -41,7 +41,7 @@ static inline unsigned long iop13xx_core
 		return 1200000000;
 	default:
 		printk("%s: warning unknown frequency, defaulting to 800Mhz\n",
-			__FUNCTION__);
+			__func__);
 	}
 
 	return 800000000;
@@ -60,7 +60,7 @@ static inline unsigned long iop13xx_xsi_
 		return 4;
 	default:
 		printk("%s: warning unknown ratio, defaulting to 2\n",
-			__FUNCTION__);
+			__func__);
 	}
 
 	return 2;
diff -puN include/asm-arm/arch-pxa/zylonite.h~include-replace-__function__-with-__func__ include/asm-arm/arch-pxa/zylonite.h
--- a/include/asm-arm/arch-pxa/zylonite.h~include-replace-__function__-with-__func__
+++ a/include/asm-arm/arch-pxa/zylonite.h
@@ -30,7 +30,7 @@ extern void zylonite_pxa300_init(void);
 static inline void zylonite_pxa300_init(void)
 {
 	if (cpu_is_pxa300() || cpu_is_pxa310())
-		panic("%s: PXA300/PXA310 not supported\n", __FUNCTION__);
+		panic("%s: PXA300/PXA310 not supported\n", __func__);
 }
 #endif
 
@@ -40,7 +40,7 @@ extern void zylonite_pxa320_init(void);
 static inline void zylonite_pxa320_init(void)
 {
 	if (cpu_is_pxa320())
-		panic("%s: PXA320 not supported\n", __FUNCTION__);
+		panic("%s: PXA320 not supported\n", __func__);
 }
 #endif
 
diff -puN include/asm-generic/bug.h~include-replace-__function__-with-__func__ include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~include-replace-__function__-with-__func__
+++ a/include/asm-generic/bug.h
@@ -22,7 +22,7 @@ struct bug_entry {
 
 #ifndef HAVE_ARCH_BUG
 #define BUG() do { \
-	printk("BUG: failure at %s:%d/%s()!\n", __FILE__, __LINE__, __FUNCTION__); \
+	printk("BUG: failure at %s:%d/%s()!\n", __FILE__, __LINE__, __func__); \
 	panic("BUG!"); \
 } while (0)
 #endif
diff -puN include/asm-powerpc/ptrace.h~include-replace-__function__-with-__func__ include/asm-powerpc/ptrace.h
--- a/include/asm-powerpc/ptrace.h~include-replace-__function__-with-__func__
+++ a/include/asm-powerpc/ptrace.h
@@ -129,7 +129,7 @@ extern int ptrace_put_reg(struct task_st
 #define CHECK_FULL_REGS(regs)						      \
 do {									      \
 	if ((regs)->trap & 1)						      \
-		printk(KERN_CRIT "%s: partial register set\n", __FUNCTION__); \
+		printk(KERN_CRIT "%s: partial register set\n", __func__); \
 } while (0)
 #endif /* __powerpc64__ */
 
diff -puN include/asm-x86/mach-es7000/mach_apic.h~include-replace-__function__-with-__func__ include/asm-x86/mach-es7000/mach_apic.h
--- a/include/asm-x86/mach-es7000/mach_apic.h~include-replace-__function__-with-__func__
+++ a/include/asm-x86/mach-es7000/mach_apic.h
@@ -171,7 +171,7 @@ static inline unsigned int cpu_mask_to_a
 			int new_apicid = cpu_to_logical_apicid(cpu);
 			if (apicid_cluster(apicid) != 
 					apicid_cluster(new_apicid)){
-				printk ("%s: Not a valid mask!\n",__FUNCTION__);
+				printk ("%s: Not a valid mask!\n",__func__);
 #if defined CONFIG_ES7000_CLUSTERED_APIC
 				return 0xFF;
 #else
diff -puN include/asm-x86/mach-summit/mach_apic.h~include-replace-__function__-with-__func__ include/asm-x86/mach-summit/mach_apic.h
--- a/include/asm-x86/mach-summit/mach_apic.h~include-replace-__function__-with-__func__
+++ a/include/asm-x86/mach-summit/mach_apic.h
@@ -160,7 +160,7 @@ static inline unsigned int cpu_mask_to_a
 			int new_apicid = cpu_to_logical_apicid(cpu);
 			if (apicid_cluster(apicid) != 
 					apicid_cluster(new_apicid)){
-				printk ("%s: Not a valid mask!\n",__FUNCTION__);
+				printk ("%s: Not a valid mask!\n",__func__);
 				return 0xFF;
 			}
 			apicid = apicid | new_apicid;
diff -puN include/linux/ext2_fs.h~include-replace-__function__-with-__func__ include/linux/ext2_fs.h
--- a/include/linux/ext2_fs.h~include-replace-__function__-with-__func__
+++ a/include/linux/ext2_fs.h
@@ -47,7 +47,7 @@
 #ifdef EXT2FS_DEBUG
 #	define ext2_debug(f, a...)	{ \
 					printk ("EXT2-fs DEBUG (%s, %d): %s:", \
-						__FILE__, __LINE__, __FUNCTION__); \
+						__FILE__, __LINE__, __func__); \
 				  	printk (f, ## a); \
 					}
 #else
diff -puN include/linux/ext3_fs.h~include-replace-__function__-with-__func__ include/linux/ext3_fs.h
--- a/include/linux/ext3_fs.h~include-replace-__function__-with-__func__
+++ a/include/linux/ext3_fs.h
@@ -43,7 +43,7 @@
 #define ext3_debug(f, a...)						\
 	do {								\
 		printk (KERN_DEBUG "EXT3-fs DEBUG (%s, %d): %s:",	\
-			__FILE__, __LINE__, __FUNCTION__);		\
+			__FILE__, __LINE__, __func__);		\
 		printk (KERN_DEBUG f, ## a);				\
 	} while (0)
 #else
@@ -869,7 +869,7 @@ extern void ext3_update_dynamic_rev (str
 #define ext3_std_error(sb, errno)				\
 do {								\
 	if ((errno))						\
-		__ext3_std_error((sb), __FUNCTION__, (errno));	\
+		__ext3_std_error((sb), __func__, (errno));	\
 } while (0)
 
 /*
diff -puN include/linux/ext3_jbd.h~include-replace-__function__-with-__func__ include/linux/ext3_jbd.h
--- a/include/linux/ext3_jbd.h~include-replace-__function__-with-__func__
+++ a/include/linux/ext3_jbd.h
@@ -137,17 +137,17 @@ int __ext3_journal_dirty_metadata(const 
 				handle_t *handle, struct buffer_head *bh);
 
 #define ext3_journal_get_undo_access(handle, bh) \
-	__ext3_journal_get_undo_access(__FUNCTION__, (handle), (bh))
+	__ext3_journal_get_undo_access(__func__, (handle), (bh))
 #define ext3_journal_get_write_access(handle, bh) \
-	__ext3_journal_get_write_access(__FUNCTION__, (handle), (bh))
+	__ext3_journal_get_write_access(__func__, (handle), (bh))
 #define ext3_journal_revoke(handle, blocknr, bh) \
-	__ext3_journal_revoke(__FUNCTION__, (handle), (blocknr), (bh))
+	__ext3_journal_revoke(__func__, (handle), (blocknr), (bh))
 #define ext3_journal_get_create_access(handle, bh) \
-	__ext3_journal_get_create_access(__FUNCTION__, (handle), (bh))
+	__ext3_journal_get_create_access(__func__, (handle), (bh))
 #define ext3_journal_dirty_metadata(handle, bh) \
-	__ext3_journal_dirty_metadata(__FUNCTION__, (handle), (bh))
+	__ext3_journal_dirty_metadata(__func__, (handle), (bh))
 #define ext3_journal_forget(handle, bh) \
-	__ext3_journal_forget(__FUNCTION__, (handle), (bh))
+	__ext3_journal_forget(__func__, (handle), (bh))
 
 int ext3_journal_dirty_data(handle_t *handle, struct buffer_head *bh);
 
@@ -160,7 +160,7 @@ static inline handle_t *ext3_journal_sta
 }
 
 #define ext3_journal_stop(handle) \
-	__ext3_journal_stop(__FUNCTION__, (handle))
+	__ext3_journal_stop(__func__, (handle))
 
 static inline handle_t *ext3_journal_current_handle(void)
 {
diff -puN include/linux/jbd.h~include-replace-__function__-with-__func__ include/linux/jbd.h
--- a/include/linux/jbd.h~include-replace-__function__-with-__func__
+++ a/include/linux/jbd.h
@@ -61,7 +61,7 @@ extern u8 journal_enable_debug;
 	do {								\
 		if ((n) <= journal_enable_debug) {			\
 			printk (KERN_DEBUG "(%s, %d): %s: ",		\
-				__FILE__, __LINE__, __FUNCTION__);	\
+				__FILE__, __LINE__, __func__);	\
 			printk (f, ## a);				\
 		}							\
 	} while (0)
@@ -984,7 +984,7 @@ extern int	cleanup_journal_tail(journal_
 
 #define jbd_ENOSYS() \
 do {								           \
-	printk (KERN_ERR "JBD unimplemented function %s\n", __FUNCTION__); \
+	printk (KERN_ERR "JBD unimplemented function %s\n", __func__); \
 	current->state = TASK_UNINTERRUPTIBLE;			           \
 	schedule();						           \
 } while (1)
diff -puN include/linux/jbd2.h~include-replace-__function__-with-__func__ include/linux/jbd2.h
--- a/include/linux/jbd2.h~include-replace-__function__-with-__func__
+++ a/include/linux/jbd2.h
@@ -61,7 +61,7 @@ extern u8 jbd2_journal_enable_debug;
 	do {								\
 		if ((n) <= jbd2_journal_enable_debug) {			\
 			printk (KERN_DEBUG "(%s, %d): %s: ",		\
-				__FILE__, __LINE__, __FUNCTION__);	\
+				__FILE__, __LINE__, __func__);	\
 			printk (f, ## a);				\
 		}							\
 	} while (0)
@@ -1139,7 +1139,7 @@ extern int	jbd2_cleanup_journal_tail(jou
 
 #define jbd_ENOSYS() \
 do {								           \
-	printk (KERN_ERR "JBD unimplemented function %s\n", __FUNCTION__); \
+	printk (KERN_ERR "JBD unimplemented function %s\n", __func__); \
 	current->state = TASK_UNINTERRUPTIBLE;			           \
 	schedule();						           \
 } while (1)
diff -puN include/linux/libata.h~include-replace-__function__-with-__func__ include/linux/libata.h
--- a/include/linux/libata.h~include-replace-__function__-with-__func__
+++ a/include/linux/libata.h
@@ -60,9 +60,9 @@
 
 /* note: prints function name for you */
 #ifdef ATA_DEBUG
-#define DPRINTK(fmt, args...) printk(KERN_ERR "%s: " fmt, __FUNCTION__, ## args)
+#define DPRINTK(fmt, args...) printk(KERN_ERR "%s: " fmt, __func__, ## args)
 #ifdef ATA_VERBOSE_DEBUG
-#define VPRINTK(fmt, args...) printk(KERN_ERR "%s: " fmt, __FUNCTION__, ## args)
+#define VPRINTK(fmt, args...) printk(KERN_ERR "%s: " fmt, __func__, ## args)
 #else
 #define VPRINTK(fmt, args...)
 #endif	/* ATA_VERBOSE_DEBUG */
@@ -71,7 +71,7 @@
 #define VPRINTK(fmt, args...)
 #endif	/* ATA_DEBUG */
 
-#define BPRINTK(fmt, args...) if (ap->flags & ATA_FLAG_DEBUGMSG) printk(KERN_ERR "%s: " fmt, __FUNCTION__, ## args)
+#define BPRINTK(fmt, args...) if (ap->flags & ATA_FLAG_DEBUGMSG) printk(KERN_ERR "%s: " fmt, __func__, ## args)
 
 /* NEW: debug levels */
 #define HAVE_LIBATA_MSG 1
diff -puN include/linux/pm.h~include-replace-__function__-with-__func__ include/linux/pm.h
--- a/include/linux/pm.h~include-replace-__function__-with-__func__
+++ a/include/linux/pm.h
@@ -419,7 +419,7 @@ extern void __suspend_report_result(cons
 
 #define suspend_report_result(fn, ret)					\
 	do {								\
-		__suspend_report_result(__FUNCTION__, fn, ret);		\
+		__suspend_report_result(__func__, fn, ret);		\
 	} while (0)
 
 #else /* !CONFIG_PM_SLEEP */
diff -puN include/linux/reiserfs_fs.h~include-replace-__function__-with-__func__ include/linux/reiserfs_fs.h
--- a/include/linux/reiserfs_fs.h~include-replace-__function__-with-__func__
+++ a/include/linux/reiserfs_fs.h
@@ -87,7 +87,7 @@ void reiserfs_warning(struct super_block
 if( !( cond ) ) 								\
   reiserfs_panic( NULL, "reiserfs[%i]: assertion " scond " failed at "	\
 		  __FILE__ ":%i:%s: " format "\n",		\
-		  in_interrupt() ? -1 : task_pid_nr(current), __LINE__ , __FUNCTION__ , ##args )
+		  in_interrupt() ? -1 : task_pid_nr(current), __LINE__ , __func__ , ##args )
 
 #define RASSERT(cond, format, args...) __RASSERT(cond, #cond, format, ##args)
 
diff -puN include/linux/rtmutex.h~include-replace-__function__-with-__func__ include/linux/rtmutex.h
--- a/include/linux/rtmutex.h~include-replace-__function__-with-__func__
+++ a/include/linux/rtmutex.h
@@ -54,7 +54,7 @@ struct hrtimer_sleeper;
 #ifdef CONFIG_DEBUG_RT_MUTEXES
 # define __DEBUG_RT_MUTEX_INITIALIZER(mutexname) \
 	, .name = #mutexname, .file = __FILE__, .line = __LINE__
-# define rt_mutex_init(mutex)			__rt_mutex_init(mutex, __FUNCTION__)
+# define rt_mutex_init(mutex)			__rt_mutex_init(mutex, __func__)
  extern void rt_mutex_debug_task_free(struct task_struct *tsk);
 #else
 # define __DEBUG_RT_MUTEX_INITIALIZER(mutexname)
diff -puN include/media/saa7146.h~include-replace-__function__-with-__func__ include/media/saa7146.h
--- a/include/media/saa7146.h~include-replace-__function__-with-__func__
+++ a/include/media/saa7146.h
@@ -24,13 +24,13 @@
 
 extern unsigned int saa7146_debug;
 
-//#define DEBUG_PROLOG printk("(0x%08x)(0x%08x) %s: %s(): ",(dev==0?-1:(dev->mem==0?-1:saa7146_read(dev,RPS_ADDR0))),(dev==0?-1:(dev->mem==0?-1:saa7146_read(dev,IER))),KBUILD_MODNAME,__FUNCTION__)
+//#define DEBUG_PROLOG printk("(0x%08x)(0x%08x) %s: %s(): ",(dev==0?-1:(dev->mem==0?-1:saa7146_read(dev,RPS_ADDR0))),(dev==0?-1:(dev->mem==0?-1:saa7146_read(dev,IER))),KBUILD_MODNAME,__func__)
 
 #ifndef DEBUG_VARIABLE
 	#define DEBUG_VARIABLE saa7146_debug
 #endif
 
-#define DEBUG_PROLOG printk("%s: %s(): ",KBUILD_MODNAME,__FUNCTION__)
+#define DEBUG_PROLOG printk("%s: %s(): ",KBUILD_MODNAME,__func__)
 #define INFO(x) { printk("%s: ",KBUILD_MODNAME); printk x; }
 
 #define ERR(x) { DEBUG_PROLOG; printk x; }
diff -puN include/net/9p/9p.h~include-replace-__function__-with-__func__ include/net/9p/9p.h
--- a/include/net/9p/9p.h~include-replace-__function__-with-__func__
+++ a/include/net/9p/9p.h
@@ -61,7 +61,7 @@ extern unsigned int p9_debug_level;
 do {  \
 	if ((p9_debug_level & level) == level) \
 		printk(KERN_NOTICE "-- %s (%d): " \
-		format , __FUNCTION__, task_pid_nr(current) , ## arg); \
+		format , __func__, task_pid_nr(current) , ## arg); \
 } while (0)
 
 #define PRINT_FCALL_ERROR(s, fcall) P9_DPRINTK(P9_DEBUG_ERROR,   \
@@ -76,7 +76,7 @@ do {  \
 #define P9_EPRINTK(level, format, arg...) \
 do { \
 	printk(level "9p: %s (%d): " \
-		format , __FUNCTION__, task_pid_nr(current), ## arg); \
+		format , __func__, task_pid_nr(current), ## arg); \
 } while (0)
 
 /**
diff -puN include/net/bluetooth/bluetooth.h~include-replace-__function__-with-__func__ include/net/bluetooth/bluetooth.h
--- a/include/net/bluetooth/bluetooth.h~include-replace-__function__-with-__func__
+++ a/include/net/bluetooth/bluetooth.h
@@ -54,8 +54,8 @@
 #define SOL_RFCOMM	18
 
 #define BT_INFO(fmt, arg...) printk(KERN_INFO "Bluetooth: " fmt "\n" , ## arg)
-#define BT_DBG(fmt, arg...)  printk(KERN_INFO "%s: " fmt "\n" , __FUNCTION__ , ## arg)
-#define BT_ERR(fmt, arg...)  printk(KERN_ERR  "%s: " fmt "\n" , __FUNCTION__ , ## arg)
+#define BT_DBG(fmt, arg...)  printk(KERN_INFO "%s: " fmt "\n" , __func__ , ## arg)
+#define BT_ERR(fmt, arg...)  printk(KERN_ERR  "%s: " fmt "\n" , __func__ , ## arg)
 
 /* Connection and socket states */
 enum {
diff -puN include/net/ieee80211.h~include-replace-__function__-with-__func__ include/net/ieee80211.h
--- a/include/net/ieee80211.h~include-replace-__function__-with-__func__
+++ a/include/net/ieee80211.h
@@ -114,7 +114,7 @@ extern u32 ieee80211_debug_level;
 #define IEEE80211_DEBUG(level, fmt, args...) \
 do { if (ieee80211_debug_level & (level)) \
   printk(KERN_DEBUG "ieee80211: %c %s " fmt, \
-         in_interrupt() ? 'I' : 'U', __FUNCTION__ , ## args); } while (0)
+         in_interrupt() ? 'I' : 'U', __func__ , ## args); } while (0)
 static inline bool ieee80211_ratelimit_debug(u32 level)
 {
 	return (ieee80211_debug_level & level) && net_ratelimit();
diff -puN include/net/ip_vs.h~include-replace-__function__-with-__func__ include/net/ip_vs.h
--- a/include/net/ip_vs.h~include-replace-__function__-with-__func__
+++ a/include/net/ip_vs.h
@@ -307,13 +307,13 @@ extern int ip_vs_get_debug_level(void);
     do {								\
 	    if (level <= ip_vs_get_debug_level())			\
 		    printk(KERN_DEBUG "Enter: %s, %s line %i\n",	\
-			   __FUNCTION__, __FILE__, __LINE__);		\
+			   __func__, __FILE__, __LINE__);		\
     } while (0)
 #define LeaveFunction(level)                                            \
     do {                                                                \
 	    if (level <= ip_vs_get_debug_level())                       \
 			printk(KERN_DEBUG "Leave: %s, %s line %i\n",    \
-			       __FUNCTION__, __FILE__, __LINE__);       \
+			       __func__, __FILE__, __LINE__);       \
     } while (0)
 #else
 #define EnterFunction(level)   do {} while (0)
diff -puN include/net/irda/irda.h~include-replace-__function__-with-__func__ include/net/irda/irda.h
--- a/include/net/irda/irda.h~include-replace-__function__-with-__func__
+++ a/include/net/irda/irda.h
@@ -72,7 +72,7 @@ do {	if (irda_debug >= (n)) \
 #define IRDA_ASSERT(expr, func) \
 do { if(!(expr)) { \
 	printk( "Assertion failed! %s:%s:%d %s\n", \
-		__FILE__,__FUNCTION__,__LINE__,(#expr) ); \
+		__FILE__,__func__,__LINE__,(#expr) ); \
 	func } } while (0)
 #define IRDA_ASSERT_LABEL(label)	label
 #else
diff -puN include/net/sctp/sctp.h~include-replace-__function__-with-__func__ include/net/sctp/sctp.h
--- a/include/net/sctp/sctp.h~include-replace-__function__-with-__func__
+++ a/include/net/sctp/sctp.h
@@ -303,7 +303,7 @@ extern int sctp_debug_flag;
 #define SCTP_ASSERT(expr, str, func) \
 	if (!(expr)) { \
 		SCTP_DEBUG_PRINTK("Assertion Failed: %s(%s) at %s:%s:%d\n", \
-			str, (#expr), __FILE__, __FUNCTION__, __LINE__); \
+			str, (#expr), __FILE__, __func__, __LINE__); \
 		func; \
 	}
 
diff -puN include/video/cyblafb.h~include-replace-__function__-with-__func__ include/video/cyblafb.h
--- a/include/video/cyblafb.h~include-replace-__function__-with-__func__
+++ a/include/video/cyblafb.h
@@ -4,7 +4,7 @@
 #endif
 
 #if CYBLAFB_DEBUG
-#define debug(f,a...)	printk("%s:" f,  __FUNCTION__ , ## a);
+#define debug(f,a...)	printk("%s:" f,  __func__ , ## a);
 #else
 #define debug(f,a...)
 #endif
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

omfs-sparse-annotations.patch
linux-next.patch
cifs-remove-global_extern-macro.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
powerpc-replace-__function__-with-__func__.patch
powerpc-replace-__function__-with-__func__-checkpatch-fixes.patch
v4l-drx397xdc-sparse-annotations.patch
v4l-drx397xdc-replace-__function__-occurrences.patch
input-ads7846c-sparse-lock-annotation.patch
mtd-diskonchipc-fix-sparse-endian-warnings.patch
net-use-the-common-ascii-hex-helpers.patch
irda-replace-__function__-with-__func__.patch
isdn-use-the-common-ascii-hex-helpers.patch
drivers-net-replace-__function__-with-__func__.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-gdthc-use-unaligned-access-helpers-checkpatch-fixes.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
wireless-replace-__function__-with-__func__.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
include-replace-__function__-with-__func__.patch
misc-replace-__function__-with-__func__.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch
byteorder-add-a-new-include-linux-swabh-to-define-byteswapping-functions.patch
byteorder-add-include-linux-byteorderh-to-define-endian-helpers.patch

