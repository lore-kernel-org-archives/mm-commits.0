From: akpm@linux-foundation.org
Subject: - add-64-bit-capability-support-to-the-kernel.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:32:58 -0800
Message-ID: <200802052232.m15MWdZv012350@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56377 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762795AbYBEWob (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:44:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: morgan@kernel.org, casey@schaufler-ca.com, chrisw@sous-sol.org, ezk@cs.sunysb.edu, jmorris@namei.org, sds@tycho.nsa.gov, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Add 64-bit capability support to the kernel
has been removed from the -mm tree.  Its filename was
     add-64-bit-capability-support-to-the-kernel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add 64-bit capability support to the kernel
From: Andrew Morgan <morgan@kernel.org>

The patch supports legacy (32-bit) capability userspace, and where possible
translates 32-bit capabilities to/from userspace and the VFS to 64-bit
kernel space capabilities.  If a capability set cannot be compressed into
32-bits for consumption by user space, the system call fails, with -ERANGE.

FWIW libcap-2.00 supports this change (and earlier capability formats)

 http://www.kernel.org/pub/linux/libs/security/linux-privs/kernel-2.6/

[akpm@linux-foundation.org: coding-syle fixes]
[akpm@linux-foundation.org: use get_task_comm()]
[ezk@cs.sunysb.edu: build fix]
[akpm@linux-foundation.org: do not initialise statics to 0 or NULL]
[akpm@linux-foundation.org: unused var]
[serue@us.ibm.com: export __cap_ symbols]
Signed-off-by: Andrew G. Morgan <morgan@kernel.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: James Morris <jmorris@namei.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/auth.c             |   10 -
 fs/proc/array.c            |   21 ++-
 include/linux/capability.h |  219 ++++++++++++++++++++++++-----------
 kernel/capability.c        |  113 ++++++++++++++++--
 mm/oom_kill.c              |    5 
 security/commoncap.c       |   87 +++++++++----
 security/dummy.c           |   17 +-
 7 files changed, 348 insertions(+), 124 deletions(-)

diff -puN fs/nfsd/auth.c~add-64-bit-capability-support-to-the-kernel fs/nfsd/auth.c
--- a/fs/nfsd/auth.c~add-64-bit-capability-support-to-the-kernel
+++ a/fs/nfsd/auth.c
@@ -11,8 +11,6 @@
 #include <linux/nfsd/nfsd.h>
 #include <linux/nfsd/export.h>
 
-#define	CAP_NFSD_MASK (CAP_FS_MASK|CAP_TO_MASK(CAP_SYS_RESOURCE))
-
 int nfsexp_flags(struct svc_rqst *rqstp, struct svc_export *exp)
 {
 	struct exp_flavor_info *f;
@@ -69,10 +67,12 @@ int nfsd_setuser(struct svc_rqst *rqstp,
 	ret = set_current_groups(cred.cr_group_info);
 	put_group_info(cred.cr_group_info);
 	if ((cred.cr_uid)) {
-		cap_t(current->cap_effective) &= ~CAP_NFSD_MASK;
+		current->cap_effective =
+			cap_drop_nfsd_set(current->cap_effective);
 	} else {
-		cap_t(current->cap_effective) |= (CAP_NFSD_MASK &
-						  current->cap_permitted);
+		current->cap_effective =
+			cap_raise_nfsd_set(current->cap_effective,
+					   current->cap_permitted);
 	}
 	return ret;
 }
diff -puN fs/proc/array.c~add-64-bit-capability-support-to-the-kernel fs/proc/array.c
--- a/fs/proc/array.c~add-64-bit-capability-support-to-the-kernel
+++ a/fs/proc/array.c
@@ -281,14 +281,23 @@ static inline char *task_sig(struct task
 	return buffer;
 }
 
+static char *render_cap_t(const char *header, kernel_cap_t *a, char *buffer)
+{
+	unsigned __capi;
+
+	buffer += sprintf(buffer, "%s", header);
+	CAP_FOR_EACH_U32(__capi) {
+		buffer += sprintf(buffer, "%08x",
+				  a->cap[(_LINUX_CAPABILITY_U32S-1) - __capi]);
+	}
+	return buffer + sprintf(buffer, "\n");
+}
+
 static inline char *task_cap(struct task_struct *p, char *buffer)
 {
-    return buffer + sprintf(buffer, "CapInh:\t%016x\n"
-			    "CapPrm:\t%016x\n"
-			    "CapEff:\t%016x\n",
-			    cap_t(p->cap_inheritable),
-			    cap_t(p->cap_permitted),
-			    cap_t(p->cap_effective));
+	buffer = render_cap_t("CapInh:\t", &p->cap_inheritable, buffer);
+	buffer = render_cap_t("CapPrm:\t", &p->cap_permitted, buffer);
+	return render_cap_t("CapEff:\t", &p->cap_effective, buffer);
 }
 
 static inline char *task_context_switch_counts(struct task_struct *p,
diff -puN include/linux/capability.h~add-64-bit-capability-support-to-the-kernel include/linux/capability.h
--- a/include/linux/capability.h~add-64-bit-capability-support-to-the-kernel
+++ a/include/linux/capability.h
@@ -23,13 +23,20 @@ struct task_struct;
    kernel might be somewhat backwards compatible, but don't bet on
    it. */
 
-/* XXX - Note, cap_t, is defined by POSIX to be an "opaque" pointer to
+/* Note, cap_t, is defined by POSIX (draft) to be an "opaque" pointer to
    a set of three capability sets.  The transposition of 3*the
    following structure to such a composite is better handled in a user
    library since the draft standard requires the use of malloc/free
    etc.. */
 
-#define _LINUX_CAPABILITY_VERSION  0x19980330
+#define _LINUX_CAPABILITY_VERSION_1  0x19980330
+#define _LINUX_CAPABILITY_U32S_1     1
+
+#define _LINUX_CAPABILITY_VERSION_2  0x20071026
+#define _LINUX_CAPABILITY_U32S_2     2
+
+#define _LINUX_CAPABILITY_VERSION    _LINUX_CAPABILITY_VERSION_2
+#define _LINUX_CAPABILITY_U32S       _LINUX_CAPABILITY_U32S_2
 
 typedef struct __user_cap_header_struct {
 	__u32 version;
@@ -42,43 +49,42 @@ typedef struct __user_cap_data_struct {
         __u32 inheritable;
 } __user *cap_user_data_t;
 
+
 #define XATTR_CAPS_SUFFIX "capability"
 #define XATTR_NAME_CAPS XATTR_SECURITY_PREFIX XATTR_CAPS_SUFFIX
 
-#define XATTR_CAPS_SZ (3*sizeof(__le32))
 #define VFS_CAP_REVISION_MASK	0xFF000000
+#define VFS_CAP_FLAGS_MASK	~VFS_CAP_REVISION_MASK
+#define VFS_CAP_FLAGS_EFFECTIVE	0x000001
+
 #define VFS_CAP_REVISION_1	0x01000000
+#define VFS_CAP_U32_1           1
+#define XATTR_CAPS_SZ_1         (sizeof(__le32)*(1 + 2*VFS_CAP_U32_1))
 
-#define VFS_CAP_REVISION	VFS_CAP_REVISION_1
+#define VFS_CAP_REVISION_2	0x02000000
+#define VFS_CAP_U32_2           2
+#define XATTR_CAPS_SZ_2         (sizeof(__le32)*(1 + 2*VFS_CAP_U32_2))
+
+#define XATTR_CAPS_SZ           XATTR_CAPS_SZ_2
+#define VFS_CAP_U32             VFS_CAP_U32_2
+#define VFS_CAP_REVISION	VFS_CAP_REVISION_2
 
-#define VFS_CAP_FLAGS_MASK	~VFS_CAP_REVISION_MASK
-#define VFS_CAP_FLAGS_EFFECTIVE	0x000001
 
 struct vfs_cap_data {
-	__u32 magic_etc;  /* Little endian */
+	__le32 magic_etc;            /* Little endian */
 	struct {
-		__u32 permitted;    /* Little endian */
-		__u32 inheritable;  /* Little endian */
-	} data[1];
+		__le32 permitted;    /* Little endian */
+		__le32 inheritable;  /* Little endian */
+	} data[VFS_CAP_U32];
 };
 
 #ifdef __KERNEL__
 
-/* #define STRICT_CAP_T_TYPECHECKS */
-
-#ifdef STRICT_CAP_T_TYPECHECKS
-
 typedef struct kernel_cap_struct {
-	__u32 cap;
+	__u32 cap[_LINUX_CAPABILITY_U32S];
 } kernel_cap_t;
 
-#else
-
-typedef __u32 kernel_cap_t;
-
-#endif
-
-#define _USER_CAP_HEADER_SIZE  (2*sizeof(__u32))
+#define _USER_CAP_HEADER_SIZE  (sizeof(struct __user_cap_header_struct))
 #define _KERNEL_CAP_T_SIZE     (sizeof(kernel_cap_t))
 
 #endif
@@ -121,10 +127,6 @@ typedef __u32 kernel_cap_t;
 
 #define CAP_FSETID           4
 
-/* Used to decide between falling back on the old suser() or fsuser(). */
-
-#define CAP_FS_MASK          0x1f
-
 /* Overrides the restriction that the real or effective user ID of a
    process sending a signal must match the real or effective user ID
    of the process receiving the signal. */
@@ -147,8 +149,12 @@ typedef __u32 kernel_cap_t;
  ** Linux-specific capabilities
  **/
 
-/* Transfer any capability in your permitted set to any pid,
-   remove any capability in your permitted set from any pid */
+/* Without VFS support for capabilities:
+ *   Transfer any capability in your permitted set to any pid,
+ *   remove any capability in your permitted set from any pid
+ * With VFS support for capabilities (neither of above, but)
+ *   Add any capability to the current process' inheritable set
+ */
 
 #define CAP_SETPCAP          8
 
@@ -309,70 +315,153 @@ typedef __u32 kernel_cap_t;
 
 #define CAP_SETFCAP	     31
 
+/*
+ * Bit location of each capability (used by user-space library and kernel)
+ */
+
+#define CAP_TO_INDEX(x)     ((x) >> 5)        /* 1 << 5 == bits in __u32 */
+#define CAP_TO_MASK(x)      (1 << ((x) & 31)) /* mask for indexed __u32 */
+
 #ifdef __KERNEL__
 
 /*
  * Internal kernel functions only
  */
 
-#ifdef STRICT_CAP_T_TYPECHECKS
+#define CAP_FOR_EACH_U32(__capi)  \
+	for (__capi = 0; __capi < _LINUX_CAPABILITY_U32S; ++__capi)
 
-#define to_cap_t(x) { x }
-#define cap_t(x) (x).cap
+# define CAP_FS_MASK_B0     (CAP_TO_MASK(CAP_CHOWN)		\
+			    | CAP_TO_MASK(CAP_DAC_OVERRIDE)	\
+			    | CAP_TO_MASK(CAP_DAC_READ_SEARCH)	\
+			    | CAP_TO_MASK(CAP_FOWNER)		\
+			    | CAP_TO_MASK(CAP_FSETID))
+
+#if _LINUX_CAPABILITY_U32S != 2
+# error Fix up hand-coded capability macro initializers
+#else /* HAND-CODED capability initializers */
+
+# define CAP_EMPTY_SET    {{ 0, 0 }}
+# define CAP_FULL_SET     {{ ~0, ~0 }}
+# define CAP_INIT_EFF_SET {{ ~CAP_TO_MASK(CAP_SETPCAP), ~0 }}
+# define CAP_FS_SET       {{ CAP_FS_MASK_B0, 0 }}
+# define CAP_NFSD_SET     {{ CAP_FS_MASK_B0|CAP_TO_MASK(CAP_SYS_RESOURCE), 0 }}
+
+#endif /* _LINUX_CAPABILITY_U32S != 2 */
+
+#define CAP_INIT_INH_SET    CAP_EMPTY_SET
+
+# define cap_clear(c)         do { (c) = __cap_empty_set; } while (0)
+# define cap_set_full(c)      do { (c) = __cap_full_set; } while (0)
+# define cap_set_init_eff(c)  do { (c) = __cap_init_eff_set; } while (0)
+
+#define cap_raise(c, flag)  ((c).cap[CAP_TO_INDEX(flag)] |= CAP_TO_MASK(flag))
+#define cap_lower(c, flag)  ((c).cap[CAP_TO_INDEX(flag)] &= ~CAP_TO_MASK(flag))
+#define cap_raised(c, flag) ((c).cap[CAP_TO_INDEX(flag)] & CAP_TO_MASK(flag))
+
+#define CAP_BOP_ALL(c, a, b, OP)                                    \
+do {                                                                \
+	unsigned __capi;                                            \
+	CAP_FOR_EACH_U32(__capi) {                                  \
+		c.cap[__capi] = a.cap[__capi] OP b.cap[__capi];     \
+	}                                                           \
+} while (0)
+
+#define CAP_UOP_ALL(c, a, OP)                                       \
+do {                                                                \
+	unsigned __capi;                                            \
+	CAP_FOR_EACH_U32(__capi) {                                  \
+		c.cap[__capi] = OP a.cap[__capi];                   \
+	}                                                           \
+} while (0)
 
-#else
+static inline kernel_cap_t cap_combine(const kernel_cap_t a,
+				       const kernel_cap_t b)
+{
+	kernel_cap_t dest;
+	CAP_BOP_ALL(dest, a, b, |);
+	return dest;
+}
 
-#define to_cap_t(x) (x)
-#define cap_t(x) (x)
+static inline kernel_cap_t cap_intersect(const kernel_cap_t a,
+					 const kernel_cap_t b)
+{
+	kernel_cap_t dest;
+	CAP_BOP_ALL(dest, a, b, &);
+	return dest;
+}
 
-#endif
+static inline kernel_cap_t cap_drop(const kernel_cap_t a,
+				    const kernel_cap_t drop)
+{
+	kernel_cap_t dest;
+	CAP_BOP_ALL(dest, a, drop, &~);
+	return dest;
+}
 
-#define CAP_EMPTY_SET       to_cap_t(0)
-#define CAP_FULL_SET        to_cap_t(~0)
-#define CAP_INIT_EFF_SET    to_cap_t(~0 & ~CAP_TO_MASK(CAP_SETPCAP))
-#define CAP_INIT_INH_SET    to_cap_t(0)
+static inline kernel_cap_t cap_invert(const kernel_cap_t c)
+{
+	kernel_cap_t dest;
+	CAP_UOP_ALL(dest, c, ~);
+	return dest;
+}
 
-#define CAP_TO_MASK(x) (1 << (x))
-#define cap_raise(c, flag)   (cap_t(c) |=  CAP_TO_MASK(flag))
-#define cap_lower(c, flag)   (cap_t(c) &= ~CAP_TO_MASK(flag))
-#define cap_raised(c, flag)  (cap_t(c) & CAP_TO_MASK(flag))
+static inline int cap_isclear(const kernel_cap_t a)
+{
+	unsigned __capi;
+	CAP_FOR_EACH_U32(__capi) {
+		if (a.cap[__capi] != 0)
+			return 0;
+	}
+	return 1;
+}
 
-static inline kernel_cap_t cap_combine(kernel_cap_t a, kernel_cap_t b)
+static inline int cap_issubset(const kernel_cap_t a, const kernel_cap_t set)
 {
-     kernel_cap_t dest;
-     cap_t(dest) = cap_t(a) | cap_t(b);
-     return dest;
+	kernel_cap_t dest;
+	dest = cap_drop(a, set);
+	return cap_isclear(dest);
 }
 
-static inline kernel_cap_t cap_intersect(kernel_cap_t a, kernel_cap_t b)
+/* Used to decide between falling back on the old suser() or fsuser(). */
+
+static inline int cap_is_fs_cap(int cap)
 {
-     kernel_cap_t dest;
-     cap_t(dest) = cap_t(a) & cap_t(b);
-     return dest;
+	const kernel_cap_t __cap_fs_set = CAP_FS_SET;
+	return !!(CAP_TO_MASK(cap) & __cap_fs_set.cap[CAP_TO_INDEX(cap)]);
 }
 
-static inline kernel_cap_t cap_drop(kernel_cap_t a, kernel_cap_t drop)
+static inline kernel_cap_t cap_drop_fs_set(const kernel_cap_t a)
 {
-     kernel_cap_t dest;
-     cap_t(dest) = cap_t(a) & ~cap_t(drop);
-     return dest;
+	const kernel_cap_t __cap_fs_set = CAP_FS_SET;
+	return cap_drop(a, __cap_fs_set);
 }
 
-static inline kernel_cap_t cap_invert(kernel_cap_t c)
+static inline kernel_cap_t cap_raise_fs_set(const kernel_cap_t a,
+					    const kernel_cap_t permitted)
 {
-     kernel_cap_t dest;
-     cap_t(dest) = ~cap_t(c);
-     return dest;
+	const kernel_cap_t __cap_fs_set = CAP_FS_SET;
+	return cap_combine(a,
+			   cap_intersect(permitted, __cap_fs_set));
 }
 
-#define cap_isclear(c)       (!cap_t(c))
-#define cap_issubset(a,set)  (!(cap_t(a) & ~cap_t(set)))
+static inline kernel_cap_t cap_drop_nfsd_set(const kernel_cap_t a)
+{
+	const kernel_cap_t __cap_fs_set = CAP_NFSD_SET;
+	return cap_drop(a, __cap_fs_set);
+}
 
-#define cap_clear(c)         do { cap_t(c) =  0; } while(0)
-#define cap_set_full(c)      do { cap_t(c) = ~0; } while(0)
-#define cap_mask(c,mask)     do { cap_t(c) &= cap_t(mask); } while(0)
+static inline kernel_cap_t cap_raise_nfsd_set(const kernel_cap_t a,
+					      const kernel_cap_t permitted)
+{
+	const kernel_cap_t __cap_nfsd_set = CAP_NFSD_SET;
+	return cap_combine(a,
+			   cap_intersect(permitted, __cap_nfsd_set));
+}
 
-#define cap_is_fs_cap(c)     (CAP_TO_MASK(c) & CAP_FS_MASK)
+extern const kernel_cap_t __cap_empty_set;
+extern const kernel_cap_t __cap_full_set;
+extern const kernel_cap_t __cap_init_eff_set;
 
 int capable(int cap);
 int __capable(struct task_struct *t, int cap);
diff -puN kernel/capability.c~add-64-bit-capability-support-to-the-kernel kernel/capability.c
--- a/kernel/capability.c~add-64-bit-capability-support-to-the-kernel
+++ a/kernel/capability.c
@@ -22,6 +22,37 @@
 static DEFINE_SPINLOCK(task_capability_lock);
 
 /*
+ * Leveraged for setting/resetting capabilities
+ */
+
+const kernel_cap_t __cap_empty_set = CAP_EMPTY_SET;
+const kernel_cap_t __cap_full_set = CAP_FULL_SET;
+const kernel_cap_t __cap_init_eff_set = CAP_INIT_EFF_SET;
+
+EXPORT_SYMBOL(__cap_empty_set);
+EXPORT_SYMBOL(__cap_full_set);
+EXPORT_SYMBOL(__cap_init_eff_set);
+
+/*
+ * More recent versions of libcap are available from:
+ *
+ *   http://www.kernel.org/pub/linux/libs/security/linux-privs/
+ */
+
+static void warn_legacy_capability_use(void)
+{
+	static int warned;
+	if (!warned) {
+		char name[sizeof(current->comm)];
+
+		printk(KERN_INFO "warning: `%s' uses 32-bit capabilities"
+		       " (legacy support in use)\n",
+		       get_task_comm(name, current));
+		warned = 1;
+	}
+}
+
+/*
  * For sys_getproccap() and sys_setproccap(), any of the three
  * capability set pointers may be NULL -- indicating that that set is
  * uninteresting and/or not to be changed.
@@ -42,12 +73,21 @@ asmlinkage long sys_capget(cap_user_head
 	pid_t pid;
 	__u32 version;
 	struct task_struct *target;
-	struct __user_cap_data_struct data;
+	unsigned tocopy;
+	kernel_cap_t pE, pI, pP;
 
 	if (get_user(version, &header->version))
 		return -EFAULT;
 
-	if (version != _LINUX_CAPABILITY_VERSION) {
+	switch (version) {
+	case _LINUX_CAPABILITY_VERSION_1:
+		warn_legacy_capability_use();
+		tocopy = _LINUX_CAPABILITY_U32S_1;
+		break;
+	case _LINUX_CAPABILITY_VERSION_2:
+		tocopy = _LINUX_CAPABILITY_U32S_2;
+		break;
+	default:
 		if (put_user(_LINUX_CAPABILITY_VERSION, &header->version))
 			return -EFAULT;
 		return -EINVAL;
@@ -71,14 +111,47 @@ asmlinkage long sys_capget(cap_user_head
 	} else
 		target = current;
 
-	ret = security_capget(target, &data.effective, &data.inheritable, &data.permitted);
+	ret = security_capget(target, &pE, &pI, &pP);
 
 out:
 	read_unlock(&tasklist_lock);
 	spin_unlock(&task_capability_lock);
 
-	if (!ret && copy_to_user(dataptr, &data, sizeof data))
-		return -EFAULT;
+	if (!ret) {
+		struct __user_cap_data_struct kdata[_LINUX_CAPABILITY_U32S];
+		unsigned i;
+
+		for (i = 0; i < tocopy; i++) {
+			kdata[i].effective = pE.cap[i];
+			kdata[i].permitted = pP.cap[i];
+			kdata[i].inheritable = pI.cap[i];
+		}
+
+		/*
+		 * Note, in the case, tocopy < _LINUX_CAPABILITY_U32S,
+		 * we silently drop the upper capabilities here. This
+		 * has the effect of making older libcap
+		 * implementations implicitly drop upper capability
+		 * bits when they perform a: capget/modify/capset
+		 * sequence.
+		 *
+		 * This behavior is considered fail-safe
+		 * behavior. Upgrading the application to a newer
+		 * version of libcap will enable access to the newer
+		 * capabilities.
+		 *
+		 * An alternative would be to return an error here
+		 * (-ERANGE), but that causes legacy applications to
+		 * unexpectidly fail; the capget/modify/capset aborts
+		 * before modification is attempted and the application
+		 * fails.
+		 */
+
+		if (copy_to_user(dataptr, kdata, tocopy
+				 * sizeof(struct __user_cap_data_struct))) {
+			return -EFAULT;
+		}
+	}
 
 	return ret;
 }
@@ -167,6 +240,8 @@ static inline int cap_set_all(kernel_cap
  */
 asmlinkage long sys_capset(cap_user_header_t header, const cap_user_data_t data)
 {
+	struct __user_cap_data_struct kdata[_LINUX_CAPABILITY_U32S];
+	unsigned i, tocopy;
 	kernel_cap_t inheritable, permitted, effective;
 	__u32 version;
 	struct task_struct *target;
@@ -176,7 +251,15 @@ asmlinkage long sys_capset(cap_user_head
 	if (get_user(version, &header->version))
 		return -EFAULT;
 
-	if (version != _LINUX_CAPABILITY_VERSION) {
+	switch (version) {
+	case _LINUX_CAPABILITY_VERSION_1:
+		warn_legacy_capability_use();
+		tocopy = _LINUX_CAPABILITY_U32S_1;
+		break;
+	case _LINUX_CAPABILITY_VERSION_2:
+		tocopy = _LINUX_CAPABILITY_U32S_2;
+		break;
+	default:
 		if (put_user(_LINUX_CAPABILITY_VERSION, &header->version))
 			return -EFAULT;
 		return -EINVAL;
@@ -188,10 +271,22 @@ asmlinkage long sys_capset(cap_user_head
 	if (pid && pid != task_pid_vnr(current) && !capable(CAP_SETPCAP))
 		return -EPERM;
 
-	if (copy_from_user(&effective, &data->effective, sizeof(effective)) ||
-	    copy_from_user(&inheritable, &data->inheritable, sizeof(inheritable)) ||
-	    copy_from_user(&permitted, &data->permitted, sizeof(permitted)))
+	if (copy_from_user(&kdata, data, tocopy
+			   * sizeof(struct __user_cap_data_struct))) {
 		return -EFAULT;
+	}
+
+	for (i = 0; i < tocopy; i++) {
+		effective.cap[i] = kdata[i].effective;
+		permitted.cap[i] = kdata[i].permitted;
+		inheritable.cap[i] = kdata[i].inheritable;
+	}
+	while (i < _LINUX_CAPABILITY_U32S) {
+		effective.cap[i] = 0;
+		permitted.cap[i] = 0;
+		inheritable.cap[i] = 0;
+		i++;
+	}
 
 	spin_lock(&task_capability_lock);
 	read_lock(&tasklist_lock);
diff -puN mm/oom_kill.c~add-64-bit-capability-support-to-the-kernel mm/oom_kill.c
--- a/mm/oom_kill.c~add-64-bit-capability-support-to-the-kernel
+++ a/mm/oom_kill.c
@@ -125,8 +125,7 @@ unsigned long badness(struct task_struct
 	 * Superuser processes are usually more important, so we make it
 	 * less likely that we kill those.
 	 */
-	if (cap_t(p->cap_effective) & CAP_TO_MASK(CAP_SYS_ADMIN) ||
-				p->uid == 0 || p->euid == 0)
+	if (__capable(p, CAP_SYS_ADMIN) || p->uid == 0 || p->euid == 0)
 		points /= 4;
 
 	/*
@@ -135,7 +134,7 @@ unsigned long badness(struct task_struct
 	 * tend to only have this flag set on applications they think
 	 * of as important.
 	 */
-	if (cap_t(p->cap_effective) & CAP_TO_MASK(CAP_SYS_RAWIO))
+	if (__capable(p, CAP_SYS_RAWIO))
 		points /= 4;
 
 	/*
diff -puN security/commoncap.c~add-64-bit-capability-support-to-the-kernel security/commoncap.c
--- a/security/commoncap.c~add-64-bit-capability-support-to-the-kernel
+++ a/security/commoncap.c
@@ -1,4 +1,4 @@
-/* Common capabilities, needed by capability.o and root_plug.o 
+/* Common capabilities, needed by capability.o and root_plug.o
  *
  *	This program is free software; you can redistribute it and/or modify
  *	it under the terms of the GNU General Public License as published by
@@ -93,9 +93,9 @@ int cap_capget (struct task_struct *targ
 		kernel_cap_t *inheritable, kernel_cap_t *permitted)
 {
 	/* Derived from kernel/capability.c:sys_capget. */
-	*effective = cap_t (target->cap_effective);
-	*inheritable = cap_t (target->cap_inheritable);
-	*permitted = cap_t (target->cap_permitted);
+	*effective = target->cap_effective;
+	*inheritable = target->cap_inheritable;
+	*permitted = target->cap_permitted;
 	return 0;
 }
 
@@ -197,28 +197,51 @@ int cap_inode_killpriv(struct dentry *de
 	return inode->i_op->removexattr(dentry, XATTR_NAME_CAPS);
 }
 
-static inline int cap_from_disk(__le32 *caps, struct linux_binprm *bprm,
-				int size)
+static inline int cap_from_disk(struct vfs_cap_data *caps,
+				struct linux_binprm *bprm, unsigned size)
 {
 	__u32 magic_etc;
+	unsigned tocopy, i;
 
-	if (size != XATTR_CAPS_SZ)
+	if (size < sizeof(magic_etc))
 		return -EINVAL;
 
-	magic_etc = le32_to_cpu(caps[0]);
+	magic_etc = le32_to_cpu(caps->magic_etc);
 
 	switch ((magic_etc & VFS_CAP_REVISION_MASK)) {
-	case VFS_CAP_REVISION:
-		if (magic_etc & VFS_CAP_FLAGS_EFFECTIVE)
-			bprm->cap_effective = true;
-		else
-			bprm->cap_effective = false;
-		bprm->cap_permitted = to_cap_t(le32_to_cpu(caps[1]));
-		bprm->cap_inheritable = to_cap_t(le32_to_cpu(caps[2]));
-		return 0;
+	case VFS_CAP_REVISION_1:
+		if (size != XATTR_CAPS_SZ_1)
+			return -EINVAL;
+		tocopy = VFS_CAP_U32_1;
+		break;
+	case VFS_CAP_REVISION_2:
+		if (size != XATTR_CAPS_SZ_2)
+			return -EINVAL;
+		tocopy = VFS_CAP_U32_2;
+		break;
 	default:
 		return -EINVAL;
 	}
+
+	if (magic_etc & VFS_CAP_FLAGS_EFFECTIVE) {
+		bprm->cap_effective = true;
+	} else {
+		bprm->cap_effective = false;
+	}
+
+	for (i = 0; i < tocopy; ++i) {
+		bprm->cap_permitted.cap[i] =
+			le32_to_cpu(caps->data[i].permitted);
+		bprm->cap_inheritable.cap[i] =
+			le32_to_cpu(caps->data[i].inheritable);
+	}
+	while (i < VFS_CAP_U32) {
+		bprm->cap_permitted.cap[i] = 0;
+		bprm->cap_inheritable.cap[i] = 0;
+		i++;
+	}
+
+	return 0;
 }
 
 /* Locate any VFS capabilities: */
@@ -226,7 +249,7 @@ static int get_file_caps(struct linux_bi
 {
 	struct dentry *dentry;
 	int rc = 0;
-	__le32 v1caps[XATTR_CAPS_SZ];
+	struct vfs_cap_data vcaps;
 	struct inode *inode;
 
 	if (bprm->file->f_vfsmnt->mnt_flags & MNT_NOSUID) {
@@ -239,8 +262,8 @@ static int get_file_caps(struct linux_bi
 	if (!inode->i_op || !inode->i_op->getxattr)
 		goto out;
 
-	rc = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS, &v1caps,
-							XATTR_CAPS_SZ);
+	rc = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS, &vcaps,
+				   XATTR_CAPS_SZ);
 	if (rc == -ENODATA || rc == -EOPNOTSUPP) {
 		/* no data, that's ok */
 		rc = 0;
@@ -249,7 +272,7 @@ static int get_file_caps(struct linux_bi
 	if (rc < 0)
 		goto out;
 
-	rc = cap_from_disk(v1caps, bprm, rc);
+	rc = cap_from_disk(&vcaps, bprm, rc);
 	if (rc)
 		printk(KERN_NOTICE "%s: cap_from_disk returned %d for %s\n",
 			__FUNCTION__, rc, bprm->filename);
@@ -344,8 +367,10 @@ void cap_bprm_apply_creds (struct linux_
 	 * capability rules */
 	if (!is_global_init(current)) {
 		current->cap_permitted = new_permitted;
-		current->cap_effective = bprm->cap_effective ?
-				new_permitted : 0;
+		if (bprm->cap_effective)
+			current->cap_effective = new_permitted;
+		else
+			cap_clear(current->cap_effective);
 	}
 
 	/* AUD: Audit candidate if current->cap_effective is set */
@@ -467,13 +492,15 @@ int cap_task_post_setuid (uid_t old_ruid
 
 			if (!issecure (SECURE_NO_SETUID_FIXUP)) {
 				if (old_fsuid == 0 && current->fsuid != 0) {
-					cap_t (current->cap_effective) &=
-					    ~CAP_FS_MASK;
+					current->cap_effective =
+						cap_drop_fs_set(
+						    current->cap_effective);
 				}
 				if (old_fsuid != 0 && current->fsuid == 0) {
-					cap_t (current->cap_effective) |=
-					    (cap_t (current->cap_permitted) &
-					     CAP_FS_MASK);
+					current->cap_effective =
+						cap_raise_fs_set(
+						    current->cap_effective,
+						    current->cap_permitted);
 				}
 			}
 			break;
@@ -577,9 +604,9 @@ int cap_task_kill(struct task_struct *p,
 
 void cap_task_reparent_to_init (struct task_struct *p)
 {
-	p->cap_effective = CAP_INIT_EFF_SET;
-	p->cap_inheritable = CAP_INIT_INH_SET;
-	p->cap_permitted = CAP_FULL_SET;
+	cap_set_init_eff(p->cap_effective);
+	cap_clear(p->cap_inheritable);
+	cap_set_full(p->cap_permitted);
 	p->keep_capabilities = 0;
 	return;
 }
diff -puN security/dummy.c~add-64-bit-capability-support-to-the-kernel security/dummy.c
--- a/security/dummy.c~add-64-bit-capability-support-to-the-kernel
+++ a/security/dummy.c
@@ -36,14 +36,19 @@ static int dummy_ptrace (struct task_str
 static int dummy_capget (struct task_struct *target, kernel_cap_t * effective,
 			 kernel_cap_t * inheritable, kernel_cap_t * permitted)
 {
-	*effective = *inheritable = *permitted = 0;
 	if (target->euid == 0) {
-		*permitted |= (~0 & ~CAP_FS_MASK);
-		*effective |= (~0 & ~CAP_TO_MASK(CAP_SETPCAP) & ~CAP_FS_MASK);
+		cap_set_full(*permitted);
+		cap_set_init_eff(*effective);
+	} else {
+		cap_clear(*permitted);
+		cap_clear(*effective);
 	}
-	if (target->fsuid == 0) {
-		*permitted |= CAP_FS_MASK;
-		*effective |= CAP_FS_MASK;
+
+	cap_clear(*inheritable);
+
+	if (target->fsuid != 0) {
+		*permitted = cap_drop_fs_set(*permitted);
+		*effective = cap_drop_fs_set(*effective);
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from morgan@kernel.org are

origin.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-smack-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-nommu-fix.patch
