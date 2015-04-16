From: akpm@linux-foundation.org
Subject: [merged]
 kernel-conditionally-support-non-root-users-groups-and-capabilities.patch
 removed from -mm tree
Date: Thu, 16 Apr 2015 09:54:21 -0700
Message-ID: <552fe93d.uhDcPzRZrY4bhECJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43055 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710AbbDPQsw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:48:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iulia.manda21@gmail.com, geert@linux-m68k.org, josh@joshtriplett.org, paulmck@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel: conditionally support non-root users, groups and capabilities
has been removed from the -mm tree.  Its filename was
     kernel-conditionally-support-non-root-users-groups-and-capabilities.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Iulia Manda <iulia.manda21@gmail.com>
Subject: kernel: conditionally support non-root users, groups and capabilities

There are a lot of embedded systems that run most or all of their
functionality in init, running as root:root.  For these systems,
supporting multiple users is not necessary.

This patch adds a new symbol, CONFIG_MULTIUSER, that makes support for
non-root users, non-root groups, and capabilities optional.  It is enabled
under CONFIG_EXPERT menu.

When this symbol is not defined, UID and GID are zero in any possible case
and processes always have all capabilities.

The following syscalls are compiled out: setuid, setregid, setgid,
setreuid, setresuid, getresuid, setresgid, getresgid, setgroups,
getgroups, setfsuid, setfsgid, capget, capset.

Also, groups.c is compiled out completely.

In kernel/capability.c, capable function was moved in order to avoid
adding two ifdef blocks.

This change saves about 25 KB on a defconfig build.  The most minimal
kernels have total text sizes in the high hundreds of kB rather than
low MB.  (The 25k goes down a bit with allnoconfig, but not that much.

The kernel was booted in Qemu.  All the common functionalities work. 
Adding users/groups is not possible, failing with -ENOSYS.

Bloat-o-meter output:
add/remove: 7/87 grow/shrink: 19/397 up/down: 1675/-26325 (-24650)

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Iulia Manda <iulia.manda21@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/Kconfig                     |    1 
 drivers/staging/lustre/lustre/Kconfig |    1 
 fs/nfs/Kconfig                        |    2 -
 fs/nfsd/Kconfig                       |    1 
 include/linux/capability.h            |   29 +++++++++++++++++++
 include/linux/cred.h                  |   23 +++++++++++++--
 include/linux/uidgid.h                |   12 ++++++++
 init/Kconfig                          |   19 ++++++++++++-
 kernel/Makefile                       |    4 ++
 kernel/capability.c                   |   35 +++++++++++++-----------
 kernel/cred.c                         |    3 ++
 kernel/groups.c                       |    3 --
 kernel/sys.c                          |    2 +
 kernel/sys_ni.c                       |   14 +++++++++
 net/sunrpc/Kconfig                    |    2 +
 security/Kconfig                      |    1 
 16 files changed, 126 insertions(+), 26 deletions(-)

diff -puN arch/s390/Kconfig~kernel-conditionally-support-non-root-users-groups-and-capabilities arch/s390/Kconfig
--- a/arch/s390/Kconfig~kernel-conditionally-support-non-root-users-groups-and-capabilities
+++ a/arch/s390/Kconfig
@@ -328,6 +328,7 @@ config COMPAT
 	select COMPAT_BINFMT_ELF if BINFMT_ELF
 	select ARCH_WANT_OLD_COMPAT_IPC
 	select COMPAT_OLD_SIGACTION
+	depends on MULTIUSER
 	help
 	  Select this option if you want to enable your system kernel to
 	  handle system-calls from ELF binaries for 31 bit ESA.  This option
diff -puN drivers/staging/lustre/lustre/Kconfig~kernel-conditionally-support-non-root-users-groups-and-capabilities drivers/staging/lustre/lustre/Kconfig
--- a/drivers/staging/lustre/lustre/Kconfig~kernel-conditionally-support-non-root-users-groups-and-capabilities
+++ a/drivers/staging/lustre/lustre/Kconfig
@@ -10,6 +10,7 @@ config LUSTRE_FS
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
+	depends on MULTIUSER
 	help
 	  This option enables Lustre file system client support. Choose Y
 	  here if you want to access a Lustre file system cluster. To compile
diff -puN fs/nfs/Kconfig~kernel-conditionally-support-non-root-users-groups-and-capabilities fs/nfs/Kconfig
--- a/fs/nfs/Kconfig~kernel-conditionally-support-non-root-users-groups-and-capabilities
+++ a/fs/nfs/Kconfig
@@ -1,6 +1,6 @@
 config NFS_FS
 	tristate "NFS client support"
-	depends on INET && FILE_LOCKING
+	depends on INET && FILE_LOCKING && MULTIUSER
 	select LOCKD
 	select SUNRPC
 	select NFS_ACL_SUPPORT if NFS_V3_ACL
diff -puN fs/nfsd/Kconfig~kernel-conditionally-support-non-root-users-groups-and-capabilities fs/nfsd/Kconfig
--- a/fs/nfsd/Kconfig~kernel-conditionally-support-non-root-users-groups-and-capabilities
+++ a/fs/nfsd/Kconfig
@@ -6,6 +6,7 @@ config NFSD
 	select SUNRPC
 	select EXPORTFS
 	select NFS_ACL_SUPPORT if NFSD_V2_ACL
+	depends on MULTIUSER
 	help
 	  Choose Y here if you want to allow other computers to access
 	  files residing on this system using Sun's Network File System
diff -puN include/linux/capability.h~kernel-conditionally-support-non-root-users-groups-and-capabilities include/linux/capability.h
--- a/include/linux/capability.h~kernel-conditionally-support-non-root-users-groups-and-capabilities
+++ a/include/linux/capability.h
@@ -205,6 +205,7 @@ static inline kernel_cap_t cap_raise_nfs
 			   cap_intersect(permitted, __cap_nfsd_set));
 }
 
+#ifdef CONFIG_MULTIUSER
 extern bool has_capability(struct task_struct *t, int cap);
 extern bool has_ns_capability(struct task_struct *t,
 			      struct user_namespace *ns, int cap);
@@ -213,6 +214,34 @@ extern bool has_ns_capability_noaudit(st
 				      struct user_namespace *ns, int cap);
 extern bool capable(int cap);
 extern bool ns_capable(struct user_namespace *ns, int cap);
+#else
+static inline bool has_capability(struct task_struct *t, int cap)
+{
+	return true;
+}
+static inline bool has_ns_capability(struct task_struct *t,
+			      struct user_namespace *ns, int cap)
+{
+	return true;
+}
+static inline bool has_capability_noaudit(struct task_struct *t, int cap)
+{
+	return true;
+}
+static inline bool has_ns_capability_noaudit(struct task_struct *t,
+				      struct user_namespace *ns, int cap)
+{
+	return true;
+}
+static inline bool capable(int cap)
+{
+	return true;
+}
+static inline bool ns_capable(struct user_namespace *ns, int cap)
+{
+	return true;
+}
+#endif /* CONFIG_MULTIUSER */
 extern bool capable_wrt_inode_uidgid(const struct inode *inode, int cap);
 extern bool file_ns_capable(const struct file *file, struct user_namespace *ns, int cap);
 
diff -puN include/linux/cred.h~kernel-conditionally-support-non-root-users-groups-and-capabilities include/linux/cred.h
--- a/include/linux/cred.h~kernel-conditionally-support-non-root-users-groups-and-capabilities
+++ a/include/linux/cred.h
@@ -62,9 +62,27 @@ do {							\
 		groups_free(group_info);		\
 } while (0)
 
-extern struct group_info *groups_alloc(int);
 extern struct group_info init_groups;
+#ifdef CONFIG_MULTIUSER
+extern struct group_info *groups_alloc(int);
 extern void groups_free(struct group_info *);
+
+extern int in_group_p(kgid_t);
+extern int in_egroup_p(kgid_t);
+#else
+static inline void groups_free(struct group_info *group_info)
+{
+}
+
+static inline int in_group_p(kgid_t grp)
+{
+        return 1;
+}
+static inline int in_egroup_p(kgid_t grp)
+{
+        return 1;
+}
+#endif
 extern int set_current_groups(struct group_info *);
 extern void set_groups(struct cred *, struct group_info *);
 extern int groups_search(const struct group_info *, kgid_t);
@@ -74,9 +92,6 @@ extern bool may_setgroups(void);
 #define GROUP_AT(gi, i) \
 	((gi)->blocks[(i) / NGROUPS_PER_BLOCK][(i) % NGROUPS_PER_BLOCK])
 
-extern int in_group_p(kgid_t);
-extern int in_egroup_p(kgid_t);
-
 /*
  * The security context of a task
  *
diff -puN include/linux/uidgid.h~kernel-conditionally-support-non-root-users-groups-and-capabilities include/linux/uidgid.h
--- a/include/linux/uidgid.h~kernel-conditionally-support-non-root-users-groups-and-capabilities
+++ a/include/linux/uidgid.h
@@ -29,6 +29,7 @@ typedef struct {
 #define KUIDT_INIT(value) (kuid_t){ value }
 #define KGIDT_INIT(value) (kgid_t){ value }
 
+#ifdef CONFIG_MULTIUSER
 static inline uid_t __kuid_val(kuid_t uid)
 {
 	return uid.val;
@@ -38,6 +39,17 @@ static inline gid_t __kgid_val(kgid_t gi
 {
 	return gid.val;
 }
+#else
+static inline uid_t __kuid_val(kuid_t uid)
+{
+	return 0;
+}
+
+static inline gid_t __kgid_val(kgid_t gid)
+{
+	return 0;
+}
+#endif
 
 #define GLOBAL_ROOT_UID KUIDT_INIT(0)
 #define GLOBAL_ROOT_GID KGIDT_INIT(0)
diff -puN init/Kconfig~kernel-conditionally-support-non-root-users-groups-and-capabilities init/Kconfig
--- a/init/Kconfig~kernel-conditionally-support-non-root-users-groups-and-capabilities
+++ a/init/Kconfig
@@ -394,6 +394,7 @@ endchoice
 
 config BSD_PROCESS_ACCT
 	bool "BSD Process Accounting"
+	depends on MULTIUSER
 	help
 	  If you say Y here, a user level program will be able to instruct the
 	  kernel (via a special system call) to write process accounting
@@ -420,6 +421,7 @@ config BSD_PROCESS_ACCT_V3
 config TASKSTATS
 	bool "Export task/process statistics through netlink"
 	depends on NET
+	depends on MULTIUSER
 	default n
 	help
 	  Export selected statistics for tasks/processes through the
@@ -1160,6 +1162,7 @@ config CHECKPOINT_RESTORE
 
 menuconfig NAMESPACES
 	bool "Namespaces support" if EXPERT
+	depends on MULTIUSER
 	default !EXPERT
 	help
 	  Provides the way to make tasks work with different objects using
@@ -1356,11 +1359,25 @@ menuconfig EXPERT
 
 config UID16
 	bool "Enable 16-bit UID system calls" if EXPERT
-	depends on HAVE_UID16
+	depends on HAVE_UID16 && MULTIUSER
 	default y
 	help
 	  This enables the legacy 16-bit UID syscall wrappers.
 
+config MULTIUSER
+	bool "Multiple users, groups and capabilities support" if EXPERT
+	default y
+	help
+	  This option enables support for non-root users, groups and
+	  capabilities.
+
+	  If you say N here, all processes will run with UID 0, GID 0, and all
+	  possible capabilities.  Saying N here also compiles out support for
+	  system calls related to UIDs, GIDs, and capabilities, such as setuid,
+	  setgid, and capset.
+
+	  If unsure, say Y here.
+
 config SGETMASK_SYSCALL
 	bool "sgetmask/ssetmask syscalls support" if EXPERT
 	def_bool PARISC || MN10300 || BLACKFIN || M68K || PPC || MIPS || X86 || SPARC || CRIS || MICROBLAZE || SUPERH
diff -puN kernel/Makefile~kernel-conditionally-support-non-root-users-groups-and-capabilities kernel/Makefile
--- a/kernel/Makefile~kernel-conditionally-support-non-root-users-groups-and-capabilities
+++ a/kernel/Makefile
@@ -9,7 +9,9 @@ obj-y     = fork.o exec_domain.o panic.o
 	    extable.o params.o \
 	    kthread.o sys_ni.o nsproxy.o \
 	    notifier.o ksysfs.o cred.o reboot.o \
-	    async.o range.o groups.o smpboot.o
+	    async.o range.o smpboot.o
+
+obj-$(CONFIG_MULTIUSER) += groups.o
 
 ifdef CONFIG_FUNCTION_TRACER
 # Do not trace debug files and internal ftrace files
diff -puN kernel/capability.c~kernel-conditionally-support-non-root-users-groups-and-capabilities kernel/capability.c
--- a/kernel/capability.c~kernel-conditionally-support-non-root-users-groups-and-capabilities
+++ a/kernel/capability.c
@@ -35,6 +35,7 @@ static int __init file_caps_disable(char
 }
 __setup("no_file_caps", file_caps_disable);
 
+#ifdef CONFIG_MULTIUSER
 /*
  * More recent versions of libcap are available from:
  *
@@ -386,6 +387,24 @@ bool ns_capable(struct user_namespace *n
 }
 EXPORT_SYMBOL(ns_capable);
 
+
+/**
+ * capable - Determine if the current task has a superior capability in effect
+ * @cap: The capability to be tested for
+ *
+ * Return true if the current task has the given superior capability currently
+ * available for use, false if not.
+ *
+ * This sets PF_SUPERPRIV on the task if the capability is available on the
+ * assumption that it's about to be used.
+ */
+bool capable(int cap)
+{
+	return ns_capable(&init_user_ns, cap);
+}
+EXPORT_SYMBOL(capable);
+#endif /* CONFIG_MULTIUSER */
+
 /**
  * file_ns_capable - Determine if the file's opener had a capability in effect
  * @file:  The file we want to check
@@ -412,22 +431,6 @@ bool file_ns_capable(const struct file *
 EXPORT_SYMBOL(file_ns_capable);
 
 /**
- * capable - Determine if the current task has a superior capability in effect
- * @cap: The capability to be tested for
- *
- * Return true if the current task has the given superior capability currently
- * available for use, false if not.
- *
- * This sets PF_SUPERPRIV on the task if the capability is available on the
- * assumption that it's about to be used.
- */
-bool capable(int cap)
-{
-	return ns_capable(&init_user_ns, cap);
-}
-EXPORT_SYMBOL(capable);
-
-/**
  * capable_wrt_inode_uidgid - Check nsown_capable and uid and gid mapped
  * @inode: The inode in question
  * @cap: The capability in question
diff -puN kernel/cred.c~kernel-conditionally-support-non-root-users-groups-and-capabilities kernel/cred.c
--- a/kernel/cred.c~kernel-conditionally-support-non-root-users-groups-and-capabilities
+++ a/kernel/cred.c
@@ -29,6 +29,9 @@
 
 static struct kmem_cache *cred_jar;
 
+/* init to 2 - one for init_task, one to ensure it is never freed */
+struct group_info init_groups = { .usage = ATOMIC_INIT(2) };
+
 /*
  * The initial credentials for the initial task
  */
diff -puN kernel/groups.c~kernel-conditionally-support-non-root-users-groups-and-capabilities kernel/groups.c
--- a/kernel/groups.c~kernel-conditionally-support-non-root-users-groups-and-capabilities
+++ a/kernel/groups.c
@@ -9,9 +9,6 @@
 #include <linux/user_namespace.h>
 #include <asm/uaccess.h>
 
-/* init to 2 - one for init_task, one to ensure it is never freed */
-struct group_info init_groups = { .usage = ATOMIC_INIT(2) };
-
 struct group_info *groups_alloc(int gidsetsize)
 {
 	struct group_info *group_info;
diff -puN kernel/sys.c~kernel-conditionally-support-non-root-users-groups-and-capabilities kernel/sys.c
--- a/kernel/sys.c~kernel-conditionally-support-non-root-users-groups-and-capabilities
+++ a/kernel/sys.c
@@ -325,6 +325,7 @@ out_unlock:
  * SMP: There are not races, the GIDs are checked only by filesystem
  *      operations (as far as semantic preservation is concerned).
  */
+#ifdef CONFIG_MULTIUSER
 SYSCALL_DEFINE2(setregid, gid_t, rgid, gid_t, egid)
 {
 	struct user_namespace *ns = current_user_ns();
@@ -815,6 +816,7 @@ change_okay:
 	commit_creds(new);
 	return old_fsgid;
 }
+#endif /* CONFIG_MULTIUSER */
 
 /**
  * sys_getpid - return the thread group id of the current process
diff -puN kernel/sys_ni.c~kernel-conditionally-support-non-root-users-groups-and-capabilities kernel/sys_ni.c
--- a/kernel/sys_ni.c~kernel-conditionally-support-non-root-users-groups-and-capabilities
+++ a/kernel/sys_ni.c
@@ -159,6 +159,20 @@ cond_syscall(sys_uselib);
 cond_syscall(sys_fadvise64);
 cond_syscall(sys_fadvise64_64);
 cond_syscall(sys_madvise);
+cond_syscall(sys_setuid);
+cond_syscall(sys_setregid);
+cond_syscall(sys_setgid);
+cond_syscall(sys_setreuid);
+cond_syscall(sys_setresuid);
+cond_syscall(sys_getresuid);
+cond_syscall(sys_setresgid);
+cond_syscall(sys_getresgid);
+cond_syscall(sys_setgroups);
+cond_syscall(sys_getgroups);
+cond_syscall(sys_setfsuid);
+cond_syscall(sys_setfsgid);
+cond_syscall(sys_capget);
+cond_syscall(sys_capset);
 
 /* arch-specific weak syscall entries */
 cond_syscall(sys_pciconfig_read);
diff -puN net/sunrpc/Kconfig~kernel-conditionally-support-non-root-users-groups-and-capabilities net/sunrpc/Kconfig
--- a/net/sunrpc/Kconfig~kernel-conditionally-support-non-root-users-groups-and-capabilities
+++ a/net/sunrpc/Kconfig
@@ -1,9 +1,11 @@
 config SUNRPC
 	tristate
+	depends on MULTIUSER
 
 config SUNRPC_GSS
 	tristate
 	select OID_REGISTRY
+	depends on MULTIUSER
 
 config SUNRPC_BACKCHANNEL
 	bool
diff -puN security/Kconfig~kernel-conditionally-support-non-root-users-groups-and-capabilities security/Kconfig
--- a/security/Kconfig~kernel-conditionally-support-non-root-users-groups-and-capabilities
+++ a/security/Kconfig
@@ -21,6 +21,7 @@ config SECURITY_DMESG_RESTRICT
 config SECURITY
 	bool "Enable different security models"
 	depends on SYSFS
+	depends on MULTIUSER
 	help
 	  This allows you to choose different security modules to be
 	  configured into your kernel.
_

Patches currently in -mm which might be from iulia.manda21@gmail.com are

origin.patch

