From: akpm@google.com
Subject: + revert-treewide-use-__printf-not-__attribute__formatprintf.patch added to -mm tree
Date: Tue, 11 Oct 2011 11:52:39 -0700
Message-ID: <201110111852.p9BIqdpm030874@hpaq11.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:8841 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638Ab1JKSwo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2011 14:52:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@google.com, joe@perches.com


The patch titled
     Subject: treewide-use-__printf-not-__attribute__formatprintf: revert arch bits
has been added to the -mm tree.  Its filename is
     revert-treewide-use-__printf-not-__attribute__formatprintf.patch

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
From: Andrew Morton <akpm@google.com>
Subject: treewide-use-__printf-not-__attribute__formatprintf: revert arch bits

Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 arch/alpha/boot/misc.c              |    3 ++-
 arch/alpha/include/asm/console.h    |    3 ++-
 arch/frv/include/asm/system.h       |    2 +-
 arch/ia64/include/asm/mca.h         |    3 ++-
 arch/m68k/include/asm/natfeat.h     |    3 ++-
 arch/mn10300/include/asm/gdb-stub.h |    5 +++--
 arch/powerpc/include/asm/udbg.h     |    3 ++-
 arch/s390/include/asm/debug.h       |   11 +++++++----
 arch/um/include/shared/user.h       |    8 +++++---
 9 files changed, 26 insertions(+), 15 deletions(-)

diff -puN arch/alpha/boot/misc.c~revert-treewide-use-__printf-not-__attribute__formatprintf arch/alpha/boot/misc.c
--- a/arch/alpha/boot/misc.c~revert-treewide-use-__printf-not-__attribute__formatprintf
+++ a/arch/alpha/boot/misc.c
@@ -25,7 +25,8 @@
 
 #define memzero(s,n)	memset ((s),0,(n))
 #define puts		srm_printk
-extern __printf(1, 2) long srm_printk(const char *, ...);
+extern long srm_printk(const char *, ...)
+     __attribute__ ((format (printf, 1, 2)));
 
 /*
  * gzip delarations
diff -puN arch/alpha/include/asm/console.h~revert-treewide-use-__printf-not-__attribute__formatprintf arch/alpha/include/asm/console.h
--- a/arch/alpha/include/asm/console.h~revert-treewide-use-__printf-not-__attribute__formatprintf
+++ a/arch/alpha/include/asm/console.h
@@ -62,7 +62,8 @@ extern long callback_save_env(void);
 extern int srm_fixup(unsigned long new_callback_addr,
 		     unsigned long new_hwrpb_addr);
 extern long srm_puts(const char *, long);
-extern __printf(1, 2) long srm_printk(const char *, ...);
+extern long srm_printk(const char *, ...)
+	__attribute__ ((format (printf, 1, 2)));
 
 struct crb_struct;
 struct hwrpb_struct;
diff -puN arch/frv/include/asm/system.h~revert-treewide-use-__printf-not-__attribute__formatprintf arch/frv/include/asm/system.h
--- a/arch/frv/include/asm/system.h~revert-treewide-use-__printf-not-__attribute__formatprintf
+++ a/arch/frv/include/asm/system.h
@@ -52,7 +52,7 @@ do {									\
 #define set_mb(var, value) \
 	do { var = (value); barrier(); } while (0)
 
-extern  __printf(1, 2) void die_if_kernel(const char *, ...);
+extern void die_if_kernel(const char *, ...) __attribute__((format(printf, 1, 2)));
 extern void free_initmem(void);
 
 #define arch_align_stack(x) (x)
diff -puN arch/ia64/include/asm/mca.h~revert-treewide-use-__printf-not-__attribute__formatprintf arch/ia64/include/asm/mca.h
--- a/arch/ia64/include/asm/mca.h~revert-treewide-use-__printf-not-__attribute__formatprintf
+++ a/arch/ia64/include/asm/mca.h
@@ -158,7 +158,8 @@ extern int  ia64_reg_MCA_extension(int (
 extern void ia64_unreg_MCA_extension(void);
 extern unsigned long ia64_get_rnat(unsigned long *);
 extern void ia64_set_psr_mc(void);
-extern __printf(1, 2) void ia64_mca_printk(const char *fmt, ...);
+extern void ia64_mca_printk(const char * fmt, ...)
+	 __attribute__ ((format (printf, 1, 2)));
 
 struct ia64_mca_notify_die {
 	struct ia64_sal_os_state *sos;
diff -puN arch/m68k/include/asm/natfeat.h~revert-treewide-use-__printf-not-__attribute__formatprintf arch/m68k/include/asm/natfeat.h
--- a/arch/m68k/include/asm/natfeat.h~revert-treewide-use-__printf-not-__attribute__formatprintf
+++ a/arch/m68k/include/asm/natfeat.h
@@ -16,6 +16,7 @@ long nf_call(long id, ...);
 void nf_init(void);
 void nf_shutdown(void);
 
-__printf(1, 2) void nfprint(const char *fmt, ...);
+void nfprint(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
 
 # endif /* _NATFEAT_H */
diff -puN arch/mn10300/include/asm/gdb-stub.h~revert-treewide-use-__printf-not-__attribute__formatprintf arch/mn10300/include/asm/gdb-stub.h
--- a/arch/mn10300/include/asm/gdb-stub.h~revert-treewide-use-__printf-not-__attribute__formatprintf
+++ a/arch/mn10300/include/asm/gdb-stub.h
@@ -145,9 +145,10 @@ extern u8	gdbstub_busy;
 extern u8	gdbstub_rx_unget;
 
 #ifdef CONFIG_GDBSTUB_DEBUGGING
-extern __printf(1, 2) void gdbstub_printk(const char *fmt, ...);
+extern void gdbstub_printk(const char *fmt, ...)
+	__attribute__((format(printf, 1, 2)));
 #else
-static inline __printf(1, 2)
+static inline __attribute__((format(printf, 1, 2)))
 void gdbstub_printk(const char *fmt, ...)
 {
 }
diff -puN arch/powerpc/include/asm/udbg.h~revert-treewide-use-__printf-not-__attribute__formatprintf arch/powerpc/include/asm/udbg.h
--- a/arch/powerpc/include/asm/udbg.h~revert-treewide-use-__printf-not-__attribute__formatprintf
+++ a/arch/powerpc/include/asm/udbg.h
@@ -24,7 +24,8 @@ extern int udbg_write(const char *s, int
 extern int udbg_read(char *buf, int buflen);
 
 extern void register_early_udbg_console(void);
-extern __printf(1, 2) void udbg_printf(const char *fmt, ...);
+extern void udbg_printf(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
 extern void udbg_progress(char *s, unsigned short hex);
 
 extern void udbg_init_uart(void __iomem *comport, unsigned int speed,
diff -puN arch/s390/include/asm/debug.h~revert-treewide-use-__printf-not-__attribute__formatprintf arch/s390/include/asm/debug.h
--- a/arch/s390/include/asm/debug.h~revert-treewide-use-__printf-not-__attribute__formatprintf
+++ a/arch/s390/include/asm/debug.h
@@ -171,8 +171,10 @@ debug_text_event(debug_info_t* id, int l
  * IMPORTANT: Use "%s" in sprintf format strings with care! Only pointers are
  * stored in the s390dbf. See Documentation/s390/s390dbf.txt for more details!
  */
-extern __printf(3, 4) debug_entry_t *
-debug_sprintf_event(debug_info_t *id, int level, char *string, ...);
+extern debug_entry_t *
+debug_sprintf_event(debug_info_t* id,int level,char *string,...)
+	__attribute__ ((format(printf, 3, 4)));
+
 
 static inline debug_entry_t*
 debug_exception(debug_info_t* id, int level, void* data, int length)
@@ -212,8 +214,9 @@ debug_text_exception(debug_info_t* id, i
  * IMPORTANT: Use "%s" in sprintf format strings with care! Only pointers are
  * stored in the s390dbf. See Documentation/s390/s390dbf.txt for more details!
  */
-extern __printf(3, 4) debug_entry_t *
-debug_sprintf_exception(debug_info_t *id, int level, char *string, ...);
+extern debug_entry_t *
+debug_sprintf_exception(debug_info_t* id,int level,char *string,...)
+	__attribute__ ((format(printf, 3, 4)));
 
 int debug_register_view(debug_info_t* id, struct debug_view* view);
 int debug_unregister_view(debug_info_t* id, struct debug_view* view);
diff -puN arch/um/include/shared/user.h~revert-treewide-use-__printf-not-__attribute__formatprintf arch/um/include/shared/user.h
--- a/arch/um/include/shared/user.h~revert-treewide-use-__printf-not-__attribute__formatprintf
+++ a/arch/um/include/shared/user.h
@@ -23,12 +23,14 @@
 #include <stddef.h>
 #endif
 
-extern __printf(1, 2) void panic(const char *fmt, ...);
+extern void panic(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
 
 #ifdef UML_CONFIG_PRINTK
-extern __printf(1, 2) int printk(const char *fmt, ...);
+extern int printk(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
 #else
-static inline __printf(1, 2) int printk(const char *fmt, ...)
+static inline int printk(const char *fmt, ...)
 {
 	return 0;
 }
_
Subject: Subject: treewide-use-__printf-not-__attribute__formatprintf: revert arch bits

Patches currently in -mm which might be from akpm@google.com are

origin.patch
linux-next.patch
drivers-net-ethernet-i825xx-3c505c-fix-build-with-dynamic-debug.patch
brlocks-lglocks-clean-up-code-checkpatch-fixes.patch
ipc-mqueue-update-maximums-for-the-mqueue-subsystem-checkpatch-fixes.patch
loop-cleanup-set_status-interface-checkpatch-fixes.patch
revert-treewide-use-__printf-not-__attribute__formatprintf.patch
leds-leds-lp5521-avoid-writing-uninitialized-value-to-lp5521_reg_op_mode-register-fix.patch

