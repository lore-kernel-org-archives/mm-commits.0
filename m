From: akpm@linux-foundation.org
Subject: + audith-replace-defines-with-c-stubs.patch added to -mm tree
Date: Tue, 14 Aug 2012 16:34:01 -0700
Message-ID: <20120814233401.B32C31E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:56106 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab2HNXeD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Aug 2012 19:34:03 -0400
Received: by obbwc20 with SMTP id wc20so744452obb.1
        for <mm-commits@vger.kernel.org>; Tue, 14 Aug 2012 16:34:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: keescook@chromium.org, akpm@linux-foundation.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: audit.h: replace defines with C stubs
has been added to the -mm tree.  Its filename is
     audith-replace-defines-with-c-stubs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: audit.h: replace defines with C stubs

Replace the #defines used when CONFIG_AUDIT or CONFIG_AUDIT_SYSCALLS are
disabled so we get type checking during those builds.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/audit.h |  177 +++++++++++++++++++++++++++++-----------
 1 file changed, 130 insertions(+), 47 deletions(-)

diff -puN include/linux/audit.h~audith-replace-defines-with-c-stubs include/linux/audit.h
--- a/include/linux/audit.h~audith-replace-defines-with-c-stubs
+++ a/include/linux/audit.h
@@ -623,37 +623,92 @@ static inline void audit_mmap_fd(int fd,
 extern int audit_n_rules;
 extern int audit_signals;
 #else /* CONFIG_AUDITSYSCALL */
-#define audit_alloc(t) ({ 0; })
-#define audit_free(t) do { ; } while (0)
-#define audit_syscall_entry(ta,a,b,c,d,e) do { ; } while (0)
-#define audit_syscall_exit(r) do { ; } while (0)
-#define audit_dummy_context() 1
-#define audit_getname(n) do { ; } while (0)
-#define audit_putname(n) do { ; } while (0)
-#define __audit_inode(n,d) do { ; } while (0)
-#define __audit_inode_child(i,p) do { ; } while (0)
-#define audit_inode(n,d) do { (void)(d); } while (0)
-#define audit_inode_child(i,p) do { ; } while (0)
-#define audit_core_dumps(i) do { ; } while (0)
-#define audit_seccomp(i,s,c) do { ; } while (0)
-#define auditsc_get_stamp(c,t,s) (0)
+static inline int  audit_alloc(struct task_struct *task)
+{
+	return 0;
+}
+static inline void audit_free(struct task_struct *task)
+{ }
+static inline void audit_syscall_entry(int arch, int major, unsigned long a0,
+				       unsigned long a1, unsigned long a2,
+				       unsigned long a3)
+{ }
+static inline void audit_syscall_exit(void *pt_regs)
+{ }
+static inline int audit_dummy_context(void)
+{
+	return 1;
+}
+static inline void audit_getname(const char *name)
+{ }
+static inline void audit_putname(const char *name)
+{ }
+static inline void __audit_inode(const char *name, const struct dentry *dentry)
+{ }
+static inline void __audit_inode_child(const struct dentry *dentry,
+					const struct inode *parent)
+{ }
+static inline void audit_inode(const char *name, const struct dentry *dentry)
+{ }
+static inline void audit_inode_child(const struct dentry *dentry,
+				     const struct inode *parent)
+{ }
+static inline void audit_core_dumps(long signr)
+{ }
+static inline void __audit_seccomp(unsigned long syscall, long signr, int code)
+{ }
+static inline void audit_seccomp(unsigned long syscall, long signr, int code)
+{ }
+static inline int auditsc_get_stamp(struct audit_context *ctx,
+			      struct timespec *t, unsigned int *serial)
+{
+	return 0;
+}
 #define audit_get_loginuid(t) (-1)
 #define audit_get_sessionid(t) (-1)
-#define audit_log_task_context(b) do { ; } while (0)
-#define audit_ipc_obj(i) ((void)0)
-#define audit_ipc_set_perm(q,u,g,m) ((void)0)
-#define audit_bprm(p) ({ 0; })
-#define audit_socketcall(n,a) ((void)0)
-#define audit_fd_pair(n,a) ((void)0)
-#define audit_sockaddr(len, addr) ({ 0; })
-#define audit_mq_open(o,m,a) ((void)0)
-#define audit_mq_sendrecv(d,l,p,t) ((void)0)
-#define audit_mq_notify(d,n) ((void)0)
-#define audit_mq_getsetattr(d,s) ((void)0)
-#define audit_log_bprm_fcaps(b, ncr, ocr) ({ 0; })
-#define audit_log_capset(pid, ncr, ocr) ((void)0)
-#define audit_mmap_fd(fd, flags) ((void)0)
-#define audit_ptrace(t) ((void)0)
+static inline void audit_log_task_context(struct audit_buffer *ab)
+{ }
+static inline void audit_ipc_obj(struct kern_ipc_perm *ipcp)
+{ }
+static inline void audit_ipc_set_perm(unsigned long qbytes, uid_t uid,
+					gid_t gid, umode_t mode)
+{ }
+static inline int audit_bprm(struct linux_binprm *bprm)
+{
+	return 0;
+}
+static inline void audit_socketcall(int nargs, unsigned long *args)
+{ }
+static inline void audit_fd_pair(int fd1, int fd2)
+{ }
+static inline int audit_sockaddr(int len, void *addr)
+{
+	return 0;
+}
+static inline void audit_mq_open(int oflag, umode_t mode, struct mq_attr *attr)
+{ }
+static inline void audit_mq_sendrecv(mqd_t mqdes, size_t msg_len,
+				     unsigned int msg_prio,
+				     const struct timespec *abs_timeout)
+{ }
+static inline void audit_mq_notify(mqd_t mqdes,
+				   const struct sigevent *notification)
+{ }
+static inline void audit_mq_getsetattr(mqd_t mqdes, struct mq_attr *mqstat)
+{ }
+static inline int audit_log_bprm_fcaps(struct linux_binprm *bprm,
+				       const struct cred *new,
+				       const struct cred *old)
+{
+	return 0;
+}
+static inline void audit_log_capset(pid_t pid, const struct cred *new,
+				   const struct cred *old)
+{ }
+static inline void audit_mmap_fd(int fd, int flags)
+{ }
+static inline void audit_ptrace(struct task_struct *t)
+{ }
 #define audit_n_rules 0
 #define audit_signals 0
 #endif /* CONFIG_AUDITSYSCALL */
@@ -677,7 +732,6 @@ extern void		    audit_log_n_hex(struct 
 extern void		    audit_log_n_string(struct audit_buffer *ab,
 					       const char *buf,
 					       size_t n);
-#define audit_log_string(a,b) audit_log_n_string(a, b, strlen(b));
 extern void		    audit_log_n_untrustedstring(struct audit_buffer *ab,
 							const char *string,
 							size_t n);
@@ -694,7 +748,8 @@ extern void		    audit_log_lost(const ch
 #ifdef CONFIG_SECURITY
 extern void 		    audit_log_secctx(struct audit_buffer *ab, u32 secid);
 #else
-#define audit_log_secctx(b,s) do { ; } while (0)
+static inline void	    audit_log_secctx(struct audit_buffer *ab, u32 secid)
+{ }
 #endif
 
 extern int		    audit_update_lsm_rules(void);
@@ -706,22 +761,50 @@ extern int  audit_receive_filter(int typ
 				void *data, size_t datasz, uid_t loginuid,
 				u32 sessionid, u32 sid);
 extern int audit_enabled;
-#else
-#define audit_log(c,g,t,f,...) do { ; } while (0)
-#define audit_log_start(c,g,t) ({ NULL; })
-#define audit_log_vformat(b,f,a) do { ; } while (0)
-#define audit_log_format(b,f,...) do { ; } while (0)
-#define audit_log_end(b) do { ; } while (0)
-#define audit_log_n_hex(a,b,l) do { ; } while (0)
-#define audit_log_n_string(a,c,l) do { ; } while (0)
-#define audit_log_string(a,c) do { ; } while (0)
-#define audit_log_n_untrustedstring(a,n,s) do { ; } while (0)
-#define audit_log_untrustedstring(a,s) do { ; } while (0)
-#define audit_log_d_path(b, p, d) do { ; } while (0)
-#define audit_log_key(b, k) do { ; } while (0)
-#define audit_log_link_denied(o, l) do { ; } while (0)
-#define audit_log_secctx(b,s) do { ; } while (0)
+#else /* CONFIG_AUDIT */
+static inline __printf(4, 5)
+void audit_log(struct audit_context *ctx, gfp_t gfp_mask, int type,
+	       const char *fmt, ...)
+{ }
+static inline struct audit_buffer *audit_log_start(struct audit_context *ctx,
+						   gfp_t gfp_mask, int type)
+{
+	return NULL;
+}
+static inline __printf(2, 3)
+void audit_log_format(struct audit_buffer *ab, const char *fmt, ...)
+{ }
+static inline void audit_log_end(struct audit_buffer *ab)
+{ }
+static inline void audit_log_n_hex(struct audit_buffer *ab,
+				   const unsigned char *buf, size_t len)
+{ }
+static inline void audit_log_n_string(struct audit_buffer *ab,
+				      const char *buf, size_t n)
+{ }
+static inline void  audit_log_n_untrustedstring(struct audit_buffer *ab,
+						const char *string, size_t n)
+{ }
+static inline void audit_log_untrustedstring(struct audit_buffer *ab,
+					     const char *string)
+{ }
+static inline void audit_log_d_path(struct audit_buffer *ab,
+				    const char *prefix,
+				    const struct path *path)
+{ }
+static inline void audit_log_key(struct audit_buffer *ab, char *key)
+{ }
+static inline void audit_log_link_denied(const char *string,
+					 const struct path *link)
+{ }
+static inline void audit_log_secctx(struct audit_buffer *ab, u32 secid)
+{ }
 #define audit_enabled 0
-#endif
+#endif /* CONFIG_AUDIT */
+static inline void audit_log_string(struct audit_buffer *ab, const char *buf)
+{
+	audit_log_n_string(ab, buf, strlen(buf));
+}
+
 #endif
 #endif
_

Patches currently in -mm which might be from keescook@chromium.org are

origin.patch
linux-next.patch
audith-replace-defines-with-c-stubs.patch

