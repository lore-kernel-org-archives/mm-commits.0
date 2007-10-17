From: akpm@linux-foundation.org
Subject: - security-convert-lsm-into-a-static-interface-fix.patch removed from -mm tree
Date: Tue, 16 Oct 2007 18:33:05 -0700
Message-ID: <200710170133.l9H1X5OU027756@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60418 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754439AbXJQBeU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 21:34:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arjan@infradead.org, chrisw@sous-sol.org, jmorris@namei.org, sds@tycho.nsa.gov, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     security-convert-lsm-into-a-static-interface-fix
has been removed from the -mm tree.  Its filename was
     security-convert-lsm-into-a-static-interface-fix.patch

This patch was dropped because it was folded into security-convert-lsm-into-a-static-interface.patch

------------------------------------------------------
Subject: security-convert-lsm-into-a-static-interface-fix
From: Andrew Morton <akpm@linux-foundation.org>

whee, slaughter.

Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: James Morris <jmorris@namei.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/security.h |  252 +++++++++---------
 security/security.c      |  506 ++++++++++++++++++-------------------
 2 files changed, 379 insertions(+), 379 deletions(-)

diff -puN include/linux/security.h~security-convert-lsm-into-a-static-interface-fix include/linux/security.h
--- a/include/linux/security.h~security-convert-lsm-into-a-static-interface-fix
+++ a/include/linux/security.h
@@ -1423,152 +1423,152 @@ extern void securityfs_remove(struct den
 
 
 /* Security operations */
-int security_ptrace (struct task_struct * parent, struct task_struct * child);
-int security_capget (struct task_struct *target,
+int security_ptrace(struct task_struct *parent, struct task_struct *child);
+int security_capget(struct task_struct *target,
 		     kernel_cap_t *effective,
 		     kernel_cap_t *inheritable,
 		     kernel_cap_t *permitted);
-int security_capset_check (struct task_struct *target,
+int security_capset_check(struct task_struct *target,
 			   kernel_cap_t *effective,
 			   kernel_cap_t *inheritable,
 			   kernel_cap_t *permitted);
-void security_capset_set (struct task_struct *target,
+void security_capset_set(struct task_struct *target,
 			  kernel_cap_t *effective,
 			  kernel_cap_t *inheritable,
 			  kernel_cap_t *permitted);
 int security_capable(struct task_struct *tsk, int cap);
-int security_acct (struct file *file);
+int security_acct(struct file *file);
 int security_sysctl(struct ctl_table *table, int op);
-int security_quotactl (int cmds, int type, int id, struct super_block *sb);
-int security_quota_on (struct dentry * dentry);
+int security_quotactl(int cmds, int type, int id, struct super_block *sb);
+int security_quota_on(struct dentry *dentry);
 int security_syslog(int type);
 int security_settime(struct timespec *ts, struct timezone *tz);
 int security_vm_enough_memory(long pages);
-int security_bprm_alloc (struct linux_binprm *bprm);
-void security_bprm_free (struct linux_binprm *bprm);
-void security_bprm_apply_creds (struct linux_binprm *bprm, int unsafe);
-void security_bprm_post_apply_creds (struct linux_binprm *bprm);
-int security_bprm_set (struct linux_binprm *bprm);
-int security_bprm_check (struct linux_binprm *bprm);
-int security_bprm_secureexec (struct linux_binprm *bprm);
-int security_sb_alloc (struct super_block *sb);
-void security_sb_free (struct super_block *sb);
-int security_sb_copy_data (struct file_system_type *type, void *orig, void *copy);
-int security_sb_kern_mount (struct super_block *sb, void *data);
-int security_sb_statfs (struct dentry *dentry);
-int security_sb_mount (char *dev_name, struct nameidata *nd,
+int security_bprm_alloc(struct linux_binprm *bprm);
+void security_bprm_free(struct linux_binprm *bprm);
+void security_bprm_apply_creds(struct linux_binprm *bprm, int unsafe);
+void security_bprm_post_apply_creds(struct linux_binprm *bprm);
+int security_bprm_set(struct linux_binprm *bprm);
+int security_bprm_check(struct linux_binprm *bprm);
+int security_bprm_secureexec(struct linux_binprm *bprm);
+int security_sb_alloc(struct super_block *sb);
+void security_sb_free(struct super_block *sb);
+int security_sb_copy_data(struct file_system_type *type, void *orig, void *copy);
+int security_sb_kern_mount(struct super_block *sb, void *data);
+int security_sb_statfs(struct dentry *dentry);
+int security_sb_mount(char *dev_name, struct nameidata *nd,
                        char *type, unsigned long flags, void *data);
-int security_sb_check_sb (struct vfsmount *mnt, struct nameidata *nd);
-int security_sb_umount (struct vfsmount *mnt, int flags);
-void security_sb_umount_close (struct vfsmount *mnt);
-void security_sb_umount_busy (struct vfsmount *mnt);
-void security_sb_post_remount (struct vfsmount *mnt, unsigned long flags, void *data);
-void security_sb_post_mountroot (void);
-void security_sb_post_addmount (struct vfsmount *mnt, struct nameidata *mountpoint_nd);
-int security_sb_pivotroot (struct nameidata *old_nd, struct nameidata *new_nd);
-void security_sb_post_pivotroot (struct nameidata *old_nd, struct nameidata *new_nd);
-int security_inode_alloc (struct inode *inode);
-void security_inode_free (struct inode *inode);
-int security_inode_init_security (struct inode *inode, struct inode *dir,
+int security_sb_check_sb(struct vfsmount *mnt, struct nameidata *nd);
+int security_sb_umount(struct vfsmount *mnt, int flags);
+void security_sb_umount_close(struct vfsmount *mnt);
+void security_sb_umount_busy(struct vfsmount *mnt);
+void security_sb_post_remount(struct vfsmount *mnt, unsigned long flags, void *data);
+void security_sb_post_mountroot(void);
+void security_sb_post_addmount(struct vfsmount *mnt, struct nameidata *mountpoint_nd);
+int security_sb_pivotroot(struct nameidata *old_nd, struct nameidata *new_nd);
+void security_sb_post_pivotroot(struct nameidata *old_nd, struct nameidata *new_nd);
+int security_inode_alloc(struct inode *inode);
+void security_inode_free(struct inode *inode);
+int security_inode_init_security(struct inode *inode, struct inode *dir,
 				  char **name, void **value, size_t *len);
-int security_inode_create (struct inode *dir, struct dentry *dentry, int mode);
-int security_inode_link (struct dentry *old_dentry, struct inode *dir,
+int security_inode_create(struct inode *dir, struct dentry *dentry, int mode);
+int security_inode_link(struct dentry *old_dentry, struct inode *dir,
 			 struct dentry *new_dentry);
-int security_inode_unlink (struct inode *dir, struct dentry *dentry);
-int security_inode_symlink (struct inode *dir, struct dentry *dentry,
+int security_inode_unlink(struct inode *dir, struct dentry *dentry);
+int security_inode_symlink(struct inode *dir, struct dentry *dentry,
 			    const char *old_name);
-int security_inode_mkdir (struct inode *dir, struct dentry *dentry, int mode);
-int security_inode_rmdir (struct inode *dir, struct dentry *dentry);
-int security_inode_mknod (struct inode *dir, struct dentry *dentry, int mode, dev_t dev);
-int security_inode_rename (struct inode *old_dir, struct dentry *old_dentry,
+int security_inode_mkdir(struct inode *dir, struct dentry *dentry, int mode);
+int security_inode_rmdir(struct inode *dir, struct dentry *dentry);
+int security_inode_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev);
+int security_inode_rename(struct inode *old_dir, struct dentry *old_dentry,
 			   struct inode *new_dir, struct dentry *new_dentry);
-int security_inode_readlink (struct dentry *dentry);
-int security_inode_follow_link (struct dentry *dentry, struct nameidata *nd);
-int security_inode_permission (struct inode *inode, int mask, struct nameidata *nd);
-int security_inode_setattr (struct dentry *dentry, struct iattr *attr);
-int security_inode_getattr (struct vfsmount *mnt, struct dentry *dentry);
-void security_inode_delete (struct inode *inode);
-int security_inode_setxattr (struct dentry *dentry, char *name,
+int security_inode_readlink(struct dentry *dentry);
+int security_inode_follow_link(struct dentry *dentry, struct nameidata *nd);
+int security_inode_permission(struct inode *inode, int mask, struct nameidata *nd);
+int security_inode_setattr(struct dentry *dentry, struct iattr *attr);
+int security_inode_getattr(struct vfsmount *mnt, struct dentry *dentry);
+void security_inode_delete(struct inode *inode);
+int security_inode_setxattr(struct dentry *dentry, char *name,
 			     void *value, size_t size, int flags);
-void security_inode_post_setxattr (struct dentry *dentry, char *name,
+void security_inode_post_setxattr(struct dentry *dentry, char *name,
 				   void *value, size_t size, int flags);
-int security_inode_getxattr (struct dentry *dentry, char *name);
-int security_inode_listxattr (struct dentry *dentry);
-int security_inode_removexattr (struct dentry *dentry, char *name);
+int security_inode_getxattr(struct dentry *dentry, char *name);
+int security_inode_listxattr(struct dentry *dentry);
+int security_inode_removexattr(struct dentry *dentry, char *name);
 const char *security_inode_xattr_getsuffix(void);
 int security_inode_getsecurity(const struct inode *inode, const char *name, void *buffer, size_t size, int err);
 int security_inode_setsecurity(struct inode *inode, const char *name, const void *value, size_t size, int flags);
 int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer_size);
-int security_file_permission (struct file *file, int mask);
-int security_file_alloc (struct file *file);
-void security_file_free (struct file *file);
-int security_file_ioctl (struct file *file, unsigned int cmd, unsigned long arg);
-int security_file_mmap (struct file *file, unsigned long reqprot,
+int security_file_permission(struct file *file, int mask);
+int security_file_alloc(struct file *file);
+void security_file_free(struct file *file);
+int security_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
+int security_file_mmap(struct file *file, unsigned long reqprot,
 			unsigned long prot, unsigned long flags,
 			unsigned long addr, unsigned long addr_only);
-int security_file_mprotect (struct vm_area_struct *vma, unsigned long reqprot,
+int security_file_mprotect(struct vm_area_struct *vma, unsigned long reqprot,
 			    unsigned long prot);
-int security_file_lock (struct file *file, unsigned int cmd);
-int security_file_fcntl (struct file *file, unsigned int cmd, unsigned long arg);
-int security_file_set_fowner (struct file *file);
-int security_file_send_sigiotask (struct task_struct *tsk,
+int security_file_lock(struct file *file, unsigned int cmd);
+int security_file_fcntl(struct file *file, unsigned int cmd, unsigned long arg);
+int security_file_set_fowner(struct file *file);
+int security_file_send_sigiotask(struct task_struct *tsk,
 				  struct fown_struct *fown, int sig);
-int security_file_receive (struct file *file);
+int security_file_receive(struct file *file);
 int security_dentry_open(struct file *file);
-int security_task_create (unsigned long clone_flags);
-int security_task_alloc (struct task_struct *p);
-void security_task_free (struct task_struct *p);
-int security_task_setuid (uid_t id0, uid_t id1, uid_t id2, int flags);
-int security_task_post_setuid (uid_t old_ruid, uid_t old_euid,
+int security_task_create(unsigned long clone_flags);
+int security_task_alloc(struct task_struct *p);
+void security_task_free(struct task_struct *p);
+int security_task_setuid(uid_t id0, uid_t id1, uid_t id2, int flags);
+int security_task_post_setuid(uid_t old_ruid, uid_t old_euid,
 			       uid_t old_suid, int flags);
-int security_task_setgid (gid_t id0, gid_t id1, gid_t id2, int flags);
-int security_task_setpgid (struct task_struct *p, pid_t pgid);
-int security_task_getpgid (struct task_struct *p);
-int security_task_getsid (struct task_struct *p);
-void security_task_getsecid (struct task_struct *p, u32 *secid);
-int security_task_setgroups (struct group_info *group_info);
-int security_task_setnice (struct task_struct *p, int nice);
-int security_task_setioprio (struct task_struct *p, int ioprio);
-int security_task_getioprio (struct task_struct *p);
-int security_task_setrlimit (unsigned int resource, struct rlimit *new_rlim);
-int security_task_setscheduler (struct task_struct *p,
+int security_task_setgid(gid_t id0, gid_t id1, gid_t id2, int flags);
+int security_task_setpgid(struct task_struct *p, pid_t pgid);
+int security_task_getpgid(struct task_struct *p);
+int security_task_getsid(struct task_struct *p);
+void security_task_getsecid(struct task_struct *p, u32 *secid);
+int security_task_setgroups(struct group_info *group_info);
+int security_task_setnice(struct task_struct *p, int nice);
+int security_task_setioprio(struct task_struct *p, int ioprio);
+int security_task_getioprio(struct task_struct *p);
+int security_task_setrlimit(unsigned int resource, struct rlimit *new_rlim);
+int security_task_setscheduler(struct task_struct *p,
 				int policy, struct sched_param *lp);
-int security_task_getscheduler (struct task_struct *p);
-int security_task_movememory (struct task_struct *p);
-int security_task_kill (struct task_struct *p, struct siginfo *info,
+int security_task_getscheduler(struct task_struct *p);
+int security_task_movememory(struct task_struct *p);
+int security_task_kill(struct task_struct *p, struct siginfo *info,
 			int sig, u32 secid);
-int security_task_wait (struct task_struct *p);
-int security_task_prctl (int option, unsigned long arg2, unsigned long arg3,
+int security_task_wait(struct task_struct *p);
+int security_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			 unsigned long arg4, unsigned long arg5);
-void security_task_reparent_to_init (struct task_struct *p);
+void security_task_reparent_to_init(struct task_struct *p);
 void security_task_to_inode(struct task_struct *p, struct inode *inode);
-int security_ipc_permission (struct kern_ipc_perm *ipcp, short flag);
-int security_msg_msg_alloc (struct msg_msg * msg);
-void security_msg_msg_free (struct msg_msg * msg);
-int security_msg_queue_alloc (struct msg_queue *msq);
-void security_msg_queue_free (struct msg_queue *msq);
-int security_msg_queue_associate (struct msg_queue * msq, int msqflg);
-int security_msg_queue_msgctl (struct msg_queue * msq, int cmd);
-int security_msg_queue_msgsnd (struct msg_queue * msq,
-			       struct msg_msg * msg, int msqflg);
-int security_msg_queue_msgrcv (struct msg_queue * msq, struct msg_msg * msg,
-			       struct task_struct * target, long type, int mode);
-int security_shm_alloc (struct shmid_kernel *shp);
-void security_shm_free (struct shmid_kernel *shp);
-int security_shm_associate (struct shmid_kernel * shp, int shmflg);
-int security_shm_shmctl (struct shmid_kernel * shp, int cmd);
-int security_shm_shmat (struct shmid_kernel * shp, char __user *shmaddr, int shmflg);
-int security_sem_alloc (struct sem_array *sma);
-void security_sem_free (struct sem_array *sma);
-int security_sem_associate (struct sem_array * sma, int semflg);
-int security_sem_semctl (struct sem_array * sma, int cmd);
-int security_sem_semop (struct sem_array * sma, struct sembuf * sops,
+int security_ipc_permission(struct kern_ipc_perm *ipcp, short flag);
+int security_msg_msg_alloc(struct msg_msg *msg);
+void security_msg_msg_free(struct msg_msg *msg);
+int security_msg_queue_alloc(struct msg_queue *msq);
+void security_msg_queue_free(struct msg_queue *msq);
+int security_msg_queue_associate(struct msg_queue *msq, int msqflg);
+int security_msg_queue_msgctl(struct msg_queue *msq, int cmd);
+int security_msg_queue_msgsnd(struct msg_queue *msq,
+			       struct msg_msg *msg, int msqflg);
+int security_msg_queue_msgrcv(struct msg_queue *msq, struct msg_msg *msg,
+			       struct task_struct *target, long type, int mode);
+int security_shm_alloc(struct shmid_kernel *shp);
+void security_shm_free(struct shmid_kernel *shp);
+int security_shm_associate(struct shmid_kernel *shp, int shmflg);
+int security_shm_shmctl(struct shmid_kernel *shp, int cmd);
+int security_shm_shmat(struct shmid_kernel *shp, char __user *shmaddr, int shmflg);
+int security_sem_alloc(struct sem_array *sma);
+void security_sem_free(struct sem_array *sma);
+int security_sem_associate(struct sem_array *sma, int semflg);
+int security_sem_semctl(struct sem_array *sma, int cmd);
+int security_sem_semop(struct sem_array *sma, struct sembuf *sops,
 			unsigned nsops, int alter);
 void security_d_instantiate (struct dentry *dentry, struct inode *inode);
 int security_getprocattr(struct task_struct *p, char *name, char **value);
 int security_setprocattr(struct task_struct *p, char *name, void *value, size_t size);
-int security_netlink_send(struct sock *sk, struct sk_buff * skb);
-int security_netlink_recv(struct sk_buff * skb, int cap);
+int security_netlink_send(struct sock *sk, struct sk_buff *skb);
+int security_netlink_recv(struct sk_buff *skb, int cap);
 int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
 void security_release_secctx(char *secdata, u32 seclen);
 
@@ -2249,26 +2249,26 @@ static inline void security_release_secc
 
 #ifdef CONFIG_SECURITY_NETWORK
 
-int security_unix_stream_connect(struct socket * sock, struct socket * other,
-				 struct sock * newsk);
-int security_unix_may_send(struct socket * sock,  struct socket * other);
-int security_socket_create (int family, int type, int protocol, int kern);
-int security_socket_post_create(struct socket * sock, int family,
+int security_unix_stream_connect(struct socket *sock, struct socket *other,
+				 struct sock *newsk);
+int security_unix_may_send(struct socket *sock,  struct socket *other);
+int security_socket_create(int family, int type, int protocol, int kern);
+int security_socket_post_create(struct socket *sock, int family,
 				int type, int protocol, int kern);
-int security_socket_bind(struct socket * sock, struct sockaddr * address, int addrlen);
-int security_socket_connect(struct socket * sock, struct sockaddr * address, int addrlen);
-int security_socket_listen(struct socket * sock, int backlog);
-int security_socket_accept(struct socket * sock, struct socket * newsock);
-void security_socket_post_accept(struct socket * sock, struct socket * newsock);
-int security_socket_sendmsg(struct socket * sock, struct msghdr * msg, int size);
-int security_socket_recvmsg(struct socket * sock, struct msghdr * msg,
+int security_socket_bind(struct socket *sock, struct sockaddr *address, int addrlen);
+int security_socket_connect(struct socket *sock, struct sockaddr *address, int addrlen);
+int security_socket_listen(struct socket *sock, int backlog);
+int security_socket_accept(struct socket *sock, struct socket *newsock);
+void security_socket_post_accept(struct socket *sock, struct socket *newsock);
+int security_socket_sendmsg(struct socket *sock, struct msghdr *msg, int size);
+int security_socket_recvmsg(struct socket *sock, struct msghdr *msg,
 			    int size, int flags);
-int security_socket_getsockname(struct socket * sock);
-int security_socket_getpeername(struct socket * sock);
-int security_socket_getsockopt(struct socket * sock, int level, int optname);
-int security_socket_setsockopt(struct socket * sock, int level, int optname);
-int security_socket_shutdown(struct socket * sock, int how);
-int security_sock_rcv_skb (struct sock * sk, struct sk_buff * skb);
+int security_socket_getsockname(struct socket *sock);
+int security_socket_getpeername(struct socket *sock);
+int security_socket_getsockopt(struct socket *sock, int level, int optname);
+int security_socket_setsockopt(struct socket *sock, int level, int optname);
+int security_socket_shutdown(struct socket *sock, int how);
+int security_sock_rcv_skb(struct sock *sk, struct sk_buff *skb);
 int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
 				      int __user *optlen, unsigned len);
 int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb, u32 *secid);
@@ -2277,7 +2277,7 @@ void security_sk_free(struct sock *sk);
 void security_sk_clone(const struct sock *sk, struct sock *newsk);
 void security_sk_classify_flow(struct sock *sk, struct flowi *fl);
 void security_req_classify_flow(const struct request_sock *req, struct flowi *fl);
-void security_sock_graft(struct sock* sk, struct socket *parent);
+void security_sock_graft(struct sock*sk, struct socket *parent);
 int security_inet_conn_request(struct sock *sk,
 			struct sk_buff *skb, struct request_sock *req);
 void security_inet_csk_clone(struct sock *newsk,
diff -puN security/security.c~security-convert-lsm-into-a-static-interface-fix security/security.c
--- a/security/security.c~security-convert-lsm-into-a-static-interface-fix
+++ a/security/security.c
@@ -173,33 +173,33 @@ int mod_unreg_security(const char *name,
 
 /* Security operations */
 
-int security_ptrace (struct task_struct * parent, struct task_struct * child)
+int security_ptrace(struct task_struct *parent, struct task_struct *child)
 {
-	return security_ops->ptrace (parent, child);
+	return security_ops->ptrace(parent, child);
 }
 
-int security_capget (struct task_struct *target,
+int security_capget(struct task_struct *target,
 		     kernel_cap_t *effective,
 		     kernel_cap_t *inheritable,
 		     kernel_cap_t *permitted)
 {
-	return security_ops->capget (target, effective, inheritable, permitted);
+	return security_ops->capget(target, effective, inheritable, permitted);
 }
 
-int security_capset_check (struct task_struct *target,
+int security_capset_check(struct task_struct *target,
 			   kernel_cap_t *effective,
 			   kernel_cap_t *inheritable,
 			   kernel_cap_t *permitted)
 {
-	return security_ops->capset_check (target, effective, inheritable, permitted);
+	return security_ops->capset_check(target, effective, inheritable, permitted);
 }
 
-void security_capset_set (struct task_struct *target,
+void security_capset_set(struct task_struct *target,
 			  kernel_cap_t *effective,
 			  kernel_cap_t *inheritable,
 			  kernel_cap_t *permitted)
 {
-	security_ops->capset_set (target, effective, inheritable, permitted);
+	security_ops->capset_set(target, effective, inheritable, permitted);
 }
 
 int security_capable(struct task_struct *tsk, int cap)
@@ -207,9 +207,9 @@ int security_capable(struct task_struct 
 	return security_ops->capable(tsk, cap);
 }
 
-int security_acct (struct file *file)
+int security_acct(struct file *file)
 {
-	return security_ops->acct (file);
+	return security_ops->acct(file);
 }
 
 int security_sysctl(struct ctl_table *table, int op)
@@ -217,14 +217,14 @@ int security_sysctl(struct ctl_table *ta
 	return security_ops->sysctl(table, op);
 }
 
-int security_quotactl (int cmds, int type, int id, struct super_block *sb)
+int security_quotactl(int cmds, int type, int id, struct super_block *sb)
 {
-	return security_ops->quotactl (cmds, type, id, sb);
+	return security_ops->quotactl(cmds, type, id, sb);
 }
 
-int security_quota_on (struct dentry * dentry)
+int security_quota_on(struct dentry *dentry)
 {
-	return security_ops->quota_on (dentry);
+	return security_ops->quota_on(dentry);
 }
 
 int security_syslog(int type)
@@ -243,275 +243,275 @@ int security_vm_enough_memory(long pages
 	return security_ops->vm_enough_memory(current->mm, pages);
 }
 
-int security_bprm_alloc (struct linux_binprm *bprm)
+int security_bprm_alloc(struct linux_binprm *bprm)
 {
-	return security_ops->bprm_alloc_security (bprm);
+	return security_ops->bprm_alloc_security(bprm);
 }
 
-void security_bprm_free (struct linux_binprm *bprm)
+void security_bprm_free(struct linux_binprm *bprm)
 {
-	security_ops->bprm_free_security (bprm);
+	security_ops->bprm_free_security(bprm);
 }
 
-void security_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
+void security_bprm_apply_creds(struct linux_binprm *bprm, int unsafe)
 {
-	security_ops->bprm_apply_creds (bprm, unsafe);
+	security_ops->bprm_apply_creds(bprm, unsafe);
 }
 
-void security_bprm_post_apply_creds (struct linux_binprm *bprm)
+void security_bprm_post_apply_creds(struct linux_binprm *bprm)
 {
-	security_ops->bprm_post_apply_creds (bprm);
+	security_ops->bprm_post_apply_creds(bprm);
 }
 
-int security_bprm_set (struct linux_binprm *bprm)
+int security_bprm_set(struct linux_binprm *bprm)
 {
-	return security_ops->bprm_set_security (bprm);
+	return security_ops->bprm_set_security(bprm);
 }
 
-int security_bprm_check (struct linux_binprm *bprm)
+int security_bprm_check(struct linux_binprm *bprm)
 {
-	return security_ops->bprm_check_security (bprm);
+	return security_ops->bprm_check_security(bprm);
 }
 
-int security_bprm_secureexec (struct linux_binprm *bprm)
+int security_bprm_secureexec(struct linux_binprm *bprm)
 {
-	return security_ops->bprm_secureexec (bprm);
+	return security_ops->bprm_secureexec(bprm);
 }
 
-int security_sb_alloc (struct super_block *sb)
+int security_sb_alloc(struct super_block *sb)
 {
-	return security_ops->sb_alloc_security (sb);
+	return security_ops->sb_alloc_security(sb);
 }
 
-void security_sb_free (struct super_block *sb)
+void security_sb_free(struct super_block *sb)
 {
-	security_ops->sb_free_security (sb);
+	security_ops->sb_free_security(sb);
 }
 
-int security_sb_copy_data (struct file_system_type *type, void *orig, void *copy)
+int security_sb_copy_data(struct file_system_type *type, void *orig, void *copy)
 {
-	return security_ops->sb_copy_data (type, orig, copy);
+	return security_ops->sb_copy_data(type, orig, copy);
 }
 
-int security_sb_kern_mount (struct super_block *sb, void *data)
+int security_sb_kern_mount(struct super_block *sb, void *data)
 {
-	return security_ops->sb_kern_mount (sb, data);
+	return security_ops->sb_kern_mount(sb, data);
 }
 
-int security_sb_statfs (struct dentry *dentry)
+int security_sb_statfs(struct dentry *dentry)
 {
-	return security_ops->sb_statfs (dentry);
+	return security_ops->sb_statfs(dentry);
 }
 
-int security_sb_mount (char *dev_name, struct nameidata *nd,
+int security_sb_mount(char *dev_name, struct nameidata *nd,
                        char *type, unsigned long flags, void *data)
 {
-	return security_ops->sb_mount (dev_name, nd, type, flags, data);
+	return security_ops->sb_mount(dev_name, nd, type, flags, data);
 }
 
-int security_sb_check_sb (struct vfsmount *mnt, struct nameidata *nd)
+int security_sb_check_sb(struct vfsmount *mnt, struct nameidata *nd)
 {
-	return security_ops->sb_check_sb (mnt, nd);
+	return security_ops->sb_check_sb(mnt, nd);
 }
 
-int security_sb_umount (struct vfsmount *mnt, int flags)
+int security_sb_umount(struct vfsmount *mnt, int flags)
 {
-	return security_ops->sb_umount (mnt, flags);
+	return security_ops->sb_umount(mnt, flags);
 }
 
-void security_sb_umount_close (struct vfsmount *mnt)
+void security_sb_umount_close(struct vfsmount *mnt)
 {
-	security_ops->sb_umount_close (mnt);
+	security_ops->sb_umount_close(mnt);
 }
 
-void security_sb_umount_busy (struct vfsmount *mnt)
+void security_sb_umount_busy(struct vfsmount *mnt)
 {
-	security_ops->sb_umount_busy (mnt);
+	security_ops->sb_umount_busy(mnt);
 }
 
-void security_sb_post_remount (struct vfsmount *mnt, unsigned long flags, void *data)
+void security_sb_post_remount(struct vfsmount *mnt, unsigned long flags, void *data)
 {
-	security_ops->sb_post_remount (mnt, flags, data);
+	security_ops->sb_post_remount(mnt, flags, data);
 }
 
-void security_sb_post_mountroot (void)
+void security_sb_post_mountroot(void)
 {
-	security_ops->sb_post_mountroot ();
+	security_ops->sb_post_mountroot();
 }
 
-void security_sb_post_addmount (struct vfsmount *mnt, struct nameidata *mountpoint_nd)
+void security_sb_post_addmount(struct vfsmount *mnt, struct nameidata *mountpoint_nd)
 {
-	security_ops->sb_post_addmount (mnt, mountpoint_nd);
+	security_ops->sb_post_addmount(mnt, mountpoint_nd);
 }
 
-int security_sb_pivotroot (struct nameidata *old_nd, struct nameidata *new_nd)
+int security_sb_pivotroot(struct nameidata *old_nd, struct nameidata *new_nd)
 {
-	return security_ops->sb_pivotroot (old_nd, new_nd);
+	return security_ops->sb_pivotroot(old_nd, new_nd);
 }
 
-void security_sb_post_pivotroot (struct nameidata *old_nd, struct nameidata *new_nd)
+void security_sb_post_pivotroot(struct nameidata *old_nd, struct nameidata *new_nd)
 {
-	security_ops->sb_post_pivotroot (old_nd, new_nd);
+	security_ops->sb_post_pivotroot(old_nd, new_nd);
 }
 
-int security_inode_alloc (struct inode *inode)
+int security_inode_alloc(struct inode *inode)
 {
 	inode->i_security = NULL;
-	return security_ops->inode_alloc_security (inode);
+	return security_ops->inode_alloc_security(inode);
 }
 
-void security_inode_free (struct inode *inode)
+void security_inode_free(struct inode *inode)
 {
-	security_ops->inode_free_security (inode);
+	security_ops->inode_free_security(inode);
 }
 
-int security_inode_init_security (struct inode *inode, struct inode *dir,
+int security_inode_init_security(struct inode *inode, struct inode *dir,
 				  char **name, void **value, size_t *len)
 {
-	if (unlikely (IS_PRIVATE (inode)))
+	if (unlikely(IS_PRIVATE(inode)))
 		return -EOPNOTSUPP;
-	return security_ops->inode_init_security (inode, dir, name, value, len);
+	return security_ops->inode_init_security(inode, dir, name, value, len);
 }
 EXPORT_SYMBOL(security_inode_init_security);
 
-int security_inode_create (struct inode *dir, struct dentry *dentry, int mode)
+int security_inode_create(struct inode *dir, struct dentry *dentry, int mode)
 {
-	if (unlikely (IS_PRIVATE (dir)))
+	if (unlikely(IS_PRIVATE(dir)))
 		return 0;
-	return security_ops->inode_create (dir, dentry, mode);
+	return security_ops->inode_create(dir, dentry, mode);
 }
 
-int security_inode_link (struct dentry *old_dentry, struct inode *dir,
+int security_inode_link(struct dentry *old_dentry, struct inode *dir,
 			 struct dentry *new_dentry)
 {
-	if (unlikely (IS_PRIVATE (old_dentry->d_inode)))
+	if (unlikely(IS_PRIVATE(old_dentry->d_inode)))
 		return 0;
-	return security_ops->inode_link (old_dentry, dir, new_dentry);
+	return security_ops->inode_link(old_dentry, dir, new_dentry);
 }
 
-int security_inode_unlink (struct inode *dir, struct dentry *dentry)
+int security_inode_unlink(struct inode *dir, struct dentry *dentry)
 {
-	if (unlikely (IS_PRIVATE (dentry->d_inode)))
+	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_unlink (dir, dentry);
+	return security_ops->inode_unlink(dir, dentry);
 }
 
-int security_inode_symlink (struct inode *dir, struct dentry *dentry,
+int security_inode_symlink(struct inode *dir, struct dentry *dentry,
 			    const char *old_name)
 {
-	if (unlikely (IS_PRIVATE (dir)))
+	if (unlikely(IS_PRIVATE(dir)))
 		return 0;
-	return security_ops->inode_symlink (dir, dentry, old_name);
+	return security_ops->inode_symlink(dir, dentry, old_name);
 }
 
-int security_inode_mkdir (struct inode *dir, struct dentry *dentry, int mode)
+int security_inode_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 {
-	if (unlikely (IS_PRIVATE (dir)))
+	if (unlikely(IS_PRIVATE(dir)))
 		return 0;
-	return security_ops->inode_mkdir (dir, dentry, mode);
+	return security_ops->inode_mkdir(dir, dentry, mode);
 }
 
-int security_inode_rmdir (struct inode *dir, struct dentry *dentry)
+int security_inode_rmdir(struct inode *dir, struct dentry *dentry)
 {
-	if (unlikely (IS_PRIVATE (dentry->d_inode)))
+	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_rmdir (dir, dentry);
+	return security_ops->inode_rmdir(dir, dentry);
 }
 
-int security_inode_mknod (struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
+int security_inode_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
 {
-	if (unlikely (IS_PRIVATE (dir)))
+	if (unlikely(IS_PRIVATE(dir)))
 		return 0;
-	return security_ops->inode_mknod (dir, dentry, mode, dev);
+	return security_ops->inode_mknod(dir, dentry, mode, dev);
 }
 
-int security_inode_rename (struct inode *old_dir, struct dentry *old_dentry,
+int security_inode_rename(struct inode *old_dir, struct dentry *old_dentry,
 			   struct inode *new_dir, struct dentry *new_dentry)
 {
-        if (unlikely (IS_PRIVATE (old_dentry->d_inode) ||
-            (new_dentry->d_inode && IS_PRIVATE (new_dentry->d_inode))))
+        if (unlikely(IS_PRIVATE(old_dentry->d_inode) ||
+            (new_dentry->d_inode && IS_PRIVATE(new_dentry->d_inode))))
 		return 0;
-	return security_ops->inode_rename (old_dir, old_dentry,
+	return security_ops->inode_rename(old_dir, old_dentry,
 					   new_dir, new_dentry);
 }
 
-int security_inode_readlink (struct dentry *dentry)
+int security_inode_readlink(struct dentry *dentry)
 {
-	if (unlikely (IS_PRIVATE (dentry->d_inode)))
+	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_readlink (dentry);
+	return security_ops->inode_readlink(dentry);
 }
 
-int security_inode_follow_link (struct dentry *dentry, struct nameidata *nd)
+int security_inode_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
-	if (unlikely (IS_PRIVATE (dentry->d_inode)))
+	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_follow_link (dentry, nd);
+	return security_ops->inode_follow_link(dentry, nd);
 }
 
-int security_inode_permission (struct inode *inode, int mask, struct nameidata *nd)
+int security_inode_permission(struct inode *inode, int mask, struct nameidata *nd)
 {
-	if (unlikely (IS_PRIVATE (inode)))
+	if (unlikely(IS_PRIVATE(inode)))
 		return 0;
-	return security_ops->inode_permission (inode, mask, nd);
+	return security_ops->inode_permission(inode, mask, nd);
 }
 
-int security_inode_setattr (struct dentry *dentry, struct iattr *attr)
+int security_inode_setattr(struct dentry *dentry, struct iattr *attr)
 {
-	if (unlikely (IS_PRIVATE (dentry->d_inode)))
+	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_setattr (dentry, attr);
+	return security_ops->inode_setattr(dentry, attr);
 }
 
-int security_inode_getattr (struct vfsmount *mnt, struct dentry *dentry)
+int security_inode_getattr(struct vfsmount *mnt, struct dentry *dentry)
 {
-	if (unlikely (IS_PRIVATE (dentry->d_inode)))
+	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_getattr (mnt, dentry);
+	return security_ops->inode_getattr(mnt, dentry);
 }
 
-void security_inode_delete (struct inode *inode)
+void security_inode_delete(struct inode *inode)
 {
-	if (unlikely (IS_PRIVATE (inode)))
+	if (unlikely(IS_PRIVATE(inode)))
 		return;
-	security_ops->inode_delete (inode);
+	security_ops->inode_delete(inode);
 }
 
-int security_inode_setxattr (struct dentry *dentry, char *name,
+int security_inode_setxattr(struct dentry *dentry, char *name,
 			     void *value, size_t size, int flags)
 {
-	if (unlikely (IS_PRIVATE (dentry->d_inode)))
+	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_setxattr (dentry, name, value, size, flags);
+	return security_ops->inode_setxattr(dentry, name, value, size, flags);
 }
 
-void security_inode_post_setxattr (struct dentry *dentry, char *name,
+void security_inode_post_setxattr(struct dentry *dentry, char *name,
 				   void *value, size_t size, int flags)
 {
-	if (unlikely (IS_PRIVATE (dentry->d_inode)))
+	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return;
-	security_ops->inode_post_setxattr (dentry, name, value, size, flags);
+	security_ops->inode_post_setxattr(dentry, name, value, size, flags);
 }
 
-int security_inode_getxattr (struct dentry *dentry, char *name)
+int security_inode_getxattr(struct dentry *dentry, char *name)
 {
-	if (unlikely (IS_PRIVATE (dentry->d_inode)))
+	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_getxattr (dentry, name);
+	return security_ops->inode_getxattr(dentry, name);
 }
 
-int security_inode_listxattr (struct dentry *dentry)
+int security_inode_listxattr(struct dentry *dentry)
 {
-	if (unlikely (IS_PRIVATE (dentry->d_inode)))
+	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_listxattr (dentry);
+	return security_ops->inode_listxattr(dentry);
 }
 
-int security_inode_removexattr (struct dentry *dentry, char *name)
+int security_inode_removexattr(struct dentry *dentry, char *name)
 {
-	if (unlikely (IS_PRIVATE (dentry->d_inode)))
+	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_removexattr (dentry, name);
+	return security_ops->inode_removexattr(dentry, name);
 }
 
 const char *security_inode_xattr_getsuffix(void)
@@ -521,202 +521,202 @@ const char *security_inode_xattr_getsuff
 
 int security_inode_getsecurity(const struct inode *inode, const char *name, void *buffer, size_t size, int err)
 {
-	if (unlikely (IS_PRIVATE (inode)))
+	if (unlikely(IS_PRIVATE(inode)))
 		return 0;
 	return security_ops->inode_getsecurity(inode, name, buffer, size, err);
 }
 
 int security_inode_setsecurity(struct inode *inode, const char *name, const void *value, size_t size, int flags)
 {
-	if (unlikely (IS_PRIVATE (inode)))
+	if (unlikely(IS_PRIVATE(inode)))
 		return 0;
 	return security_ops->inode_setsecurity(inode, name, value, size, flags);
 }
 
 int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer_size)
 {
-	if (unlikely (IS_PRIVATE (inode)))
+	if (unlikely(IS_PRIVATE(inode)))
 		return 0;
 	return security_ops->inode_listsecurity(inode, buffer, buffer_size);
 }
 
-int security_file_permission (struct file *file, int mask)
+int security_file_permission(struct file *file, int mask)
 {
-	return security_ops->file_permission (file, mask);
+	return security_ops->file_permission(file, mask);
 }
 
-int security_file_alloc (struct file *file)
+int security_file_alloc(struct file *file)
 {
-	return security_ops->file_alloc_security (file);
+	return security_ops->file_alloc_security(file);
 }
 
-void security_file_free (struct file *file)
+void security_file_free(struct file *file)
 {
-	security_ops->file_free_security (file);
+	security_ops->file_free_security(file);
 }
 
-int security_file_ioctl (struct file *file, unsigned int cmd, unsigned long arg)
+int security_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	return security_ops->file_ioctl (file, cmd, arg);
+	return security_ops->file_ioctl(file, cmd, arg);
 }
 
-int security_file_mmap (struct file *file, unsigned long reqprot,
+int security_file_mmap(struct file *file, unsigned long reqprot,
 			unsigned long prot, unsigned long flags,
 			unsigned long addr, unsigned long addr_only)
 {
-	return security_ops->file_mmap (file, reqprot, prot, flags, addr, addr_only);
+	return security_ops->file_mmap(file, reqprot, prot, flags, addr, addr_only);
 }
 
-int security_file_mprotect (struct vm_area_struct *vma, unsigned long reqprot,
+int security_file_mprotect(struct vm_area_struct *vma, unsigned long reqprot,
 			    unsigned long prot)
 {
-	return security_ops->file_mprotect (vma, reqprot, prot);
+	return security_ops->file_mprotect(vma, reqprot, prot);
 }
 
-int security_file_lock (struct file *file, unsigned int cmd)
+int security_file_lock(struct file *file, unsigned int cmd)
 {
-	return security_ops->file_lock (file, cmd);
+	return security_ops->file_lock(file, cmd);
 }
 
-int security_file_fcntl (struct file *file, unsigned int cmd, unsigned long arg)
+int security_file_fcntl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	return security_ops->file_fcntl (file, cmd, arg);
+	return security_ops->file_fcntl(file, cmd, arg);
 }
 
-int security_file_set_fowner (struct file *file)
+int security_file_set_fowner(struct file *file)
 {
-	return security_ops->file_set_fowner (file);
+	return security_ops->file_set_fowner(file);
 }
 
-int security_file_send_sigiotask (struct task_struct *tsk,
+int security_file_send_sigiotask(struct task_struct *tsk,
 				  struct fown_struct *fown, int sig)
 {
-	return security_ops->file_send_sigiotask (tsk, fown, sig);
+	return security_ops->file_send_sigiotask(tsk, fown, sig);
 }
 
-int security_file_receive (struct file *file)
+int security_file_receive(struct file *file)
 {
-	return security_ops->file_receive (file);
+	return security_ops->file_receive(file);
 }
 
-int security_dentry_open (struct file *file)
+int security_dentry_open(struct file *file)
 {
 	return security_ops->dentry_open(file);
 }
 
-int security_task_create (unsigned long clone_flags)
+int security_task_create(unsigned long clone_flags)
 {
-	return security_ops->task_create (clone_flags);
+	return security_ops->task_create(clone_flags);
 }
 
-int security_task_alloc (struct task_struct *p)
+int security_task_alloc(struct task_struct *p)
 {
-	return security_ops->task_alloc_security (p);
+	return security_ops->task_alloc_security(p);
 }
 
-void security_task_free (struct task_struct *p)
+void security_task_free(struct task_struct *p)
 {
-	security_ops->task_free_security (p);
+	security_ops->task_free_security(p);
 }
 
-int security_task_setuid (uid_t id0, uid_t id1, uid_t id2, int flags)
+int security_task_setuid(uid_t id0, uid_t id1, uid_t id2, int flags)
 {
-	return security_ops->task_setuid (id0, id1, id2, flags);
+	return security_ops->task_setuid(id0, id1, id2, flags);
 }
 
-int security_task_post_setuid (uid_t old_ruid, uid_t old_euid,
+int security_task_post_setuid(uid_t old_ruid, uid_t old_euid,
 			       uid_t old_suid, int flags)
 {
-	return security_ops->task_post_setuid (old_ruid, old_euid, old_suid, flags);
+	return security_ops->task_post_setuid(old_ruid, old_euid, old_suid, flags);
 }
 
-int security_task_setgid (gid_t id0, gid_t id1, gid_t id2, int flags)
+int security_task_setgid(gid_t id0, gid_t id1, gid_t id2, int flags)
 {
-	return security_ops->task_setgid (id0, id1, id2, flags);
+	return security_ops->task_setgid(id0, id1, id2, flags);
 }
 
-int security_task_setpgid (struct task_struct *p, pid_t pgid)
+int security_task_setpgid(struct task_struct *p, pid_t pgid)
 {
-	return security_ops->task_setpgid (p, pgid);
+	return security_ops->task_setpgid(p, pgid);
 }
 
-int security_task_getpgid (struct task_struct *p)
+int security_task_getpgid(struct task_struct *p)
 {
-	return security_ops->task_getpgid (p);
+	return security_ops->task_getpgid(p);
 }
 
-int security_task_getsid (struct task_struct *p)
+int security_task_getsid(struct task_struct *p)
 {
-	return security_ops->task_getsid (p);
+	return security_ops->task_getsid(p);
 }
 
-void security_task_getsecid (struct task_struct *p, u32 *secid)
+void security_task_getsecid(struct task_struct *p, u32 *secid)
 {
-	security_ops->task_getsecid (p, secid);
+	security_ops->task_getsecid(p, secid);
 }
 EXPORT_SYMBOL(security_task_getsecid);
 
-int security_task_setgroups (struct group_info *group_info)
+int security_task_setgroups(struct group_info *group_info)
 {
-	return security_ops->task_setgroups (group_info);
+	return security_ops->task_setgroups(group_info);
 }
 
-int security_task_setnice (struct task_struct *p, int nice)
+int security_task_setnice(struct task_struct *p, int nice)
 {
-	return security_ops->task_setnice (p, nice);
+	return security_ops->task_setnice(p, nice);
 }
 
-int security_task_setioprio (struct task_struct *p, int ioprio)
+int security_task_setioprio(struct task_struct *p, int ioprio)
 {
-	return security_ops->task_setioprio (p, ioprio);
+	return security_ops->task_setioprio(p, ioprio);
 }
 
-int security_task_getioprio (struct task_struct *p)
+int security_task_getioprio(struct task_struct *p)
 {
-	return security_ops->task_getioprio (p);
+	return security_ops->task_getioprio(p);
 }
 
-int security_task_setrlimit (unsigned int resource, struct rlimit *new_rlim)
+int security_task_setrlimit(unsigned int resource, struct rlimit *new_rlim)
 {
-	return security_ops->task_setrlimit (resource, new_rlim);
+	return security_ops->task_setrlimit(resource, new_rlim);
 }
 
-int security_task_setscheduler (struct task_struct *p,
+int security_task_setscheduler(struct task_struct *p,
 				int policy, struct sched_param *lp)
 {
-	return security_ops->task_setscheduler (p, policy, lp);
+	return security_ops->task_setscheduler(p, policy, lp);
 }
 
-int security_task_getscheduler (struct task_struct *p)
+int security_task_getscheduler(struct task_struct *p)
 {
-	return security_ops->task_getscheduler (p);
+	return security_ops->task_getscheduler(p);
 }
 
-int security_task_movememory (struct task_struct *p)
+int security_task_movememory(struct task_struct *p)
 {
-	return security_ops->task_movememory (p);
+	return security_ops->task_movememory(p);
 }
 
-int security_task_kill (struct task_struct *p, struct siginfo *info,
+int security_task_kill(struct task_struct *p, struct siginfo *info,
 			int sig, u32 secid)
 {
-	return security_ops->task_kill (p, info, sig, secid);
+	return security_ops->task_kill(p, info, sig, secid);
 }
 
-int security_task_wait (struct task_struct *p)
+int security_task_wait(struct task_struct *p)
 {
-	return security_ops->task_wait (p);
+	return security_ops->task_wait(p);
 }
 
-int security_task_prctl (int option, unsigned long arg2, unsigned long arg3,
+int security_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			 unsigned long arg4, unsigned long arg5)
 {
-	return security_ops->task_prctl (option, arg2, arg3, arg4, arg5);
+	return security_ops->task_prctl(option, arg2, arg3, arg4, arg5);
 }
 
-void security_task_reparent_to_init (struct task_struct *p)
+void security_task_reparent_to_init(struct task_struct *p)
 {
-	security_ops->task_reparent_to_init (p);
+	security_ops->task_reparent_to_init(p);
 }
 
 void security_task_to_inode(struct task_struct *p, struct inode *inode)
@@ -724,109 +724,109 @@ void security_task_to_inode(struct task_
 	security_ops->task_to_inode(p, inode);
 }
 
-int security_ipc_permission (struct kern_ipc_perm *ipcp, short flag)
+int security_ipc_permission(struct kern_ipc_perm *ipcp, short flag)
 {
-	return security_ops->ipc_permission (ipcp, flag);
+	return security_ops->ipc_permission(ipcp, flag);
 }
 
-int security_msg_msg_alloc (struct msg_msg * msg)
+int security_msg_msg_alloc(struct msg_msg *msg)
 {
-	return security_ops->msg_msg_alloc_security (msg);
+	return security_ops->msg_msg_alloc_security(msg);
 }
 
-void security_msg_msg_free (struct msg_msg * msg)
+void security_msg_msg_free(struct msg_msg *msg)
 {
 	security_ops->msg_msg_free_security(msg);
 }
 
-int security_msg_queue_alloc (struct msg_queue *msq)
+int security_msg_queue_alloc(struct msg_queue *msq)
 {
-	return security_ops->msg_queue_alloc_security (msq);
+	return security_ops->msg_queue_alloc_security(msq);
 }
 
-void security_msg_queue_free (struct msg_queue *msq)
+void security_msg_queue_free(struct msg_queue *msq)
 {
-	security_ops->msg_queue_free_security (msq);
+	security_ops->msg_queue_free_security(msq);
 }
 
-int security_msg_queue_associate (struct msg_queue * msq, int msqflg)
+int security_msg_queue_associate(struct msg_queue *msq, int msqflg)
 {
-	return security_ops->msg_queue_associate (msq, msqflg);
+	return security_ops->msg_queue_associate(msq, msqflg);
 }
 
-int security_msg_queue_msgctl (struct msg_queue * msq, int cmd)
+int security_msg_queue_msgctl(struct msg_queue *msq, int cmd)
 {
-	return security_ops->msg_queue_msgctl (msq, cmd);
+	return security_ops->msg_queue_msgctl(msq, cmd);
 }
 
-int security_msg_queue_msgsnd (struct msg_queue * msq,
-			       struct msg_msg * msg, int msqflg)
+int security_msg_queue_msgsnd(struct msg_queue *msq,
+			       struct msg_msg *msg, int msqflg)
 {
-	return security_ops->msg_queue_msgsnd (msq, msg, msqflg);
+	return security_ops->msg_queue_msgsnd(msq, msg, msqflg);
 }
 
-int security_msg_queue_msgrcv (struct msg_queue * msq, struct msg_msg * msg,
-			       struct task_struct * target, long type, int mode)
+int security_msg_queue_msgrcv(struct msg_queue *msq, struct msg_msg *msg,
+			       struct task_struct *target, long type, int mode)
 {
-	return security_ops->msg_queue_msgrcv (msq, msg, target, type, mode);
+	return security_ops->msg_queue_msgrcv(msq, msg, target, type, mode);
 }
 
-int security_shm_alloc (struct shmid_kernel *shp)
+int security_shm_alloc(struct shmid_kernel *shp)
 {
-	return security_ops->shm_alloc_security (shp);
+	return security_ops->shm_alloc_security(shp);
 }
 
-void security_shm_free (struct shmid_kernel *shp)
+void security_shm_free(struct shmid_kernel *shp)
 {
-	security_ops->shm_free_security (shp);
+	security_ops->shm_free_security(shp);
 }
 
-int security_shm_associate (struct shmid_kernel * shp, int shmflg)
+int security_shm_associate(struct shmid_kernel *shp, int shmflg)
 {
 	return security_ops->shm_associate(shp, shmflg);
 }
 
-int security_shm_shmctl (struct shmid_kernel * shp, int cmd)
+int security_shm_shmctl(struct shmid_kernel *shp, int cmd)
 {
-	return security_ops->shm_shmctl (shp, cmd);
+	return security_ops->shm_shmctl(shp, cmd);
 }
 
-int security_shm_shmat (struct shmid_kernel * shp, char __user *shmaddr, int shmflg)
+int security_shm_shmat(struct shmid_kernel *shp, char __user *shmaddr, int shmflg)
 {
 	return security_ops->shm_shmat(shp, shmaddr, shmflg);
 }
 
-int security_sem_alloc (struct sem_array *sma)
+int security_sem_alloc(struct sem_array *sma)
 {
-	return security_ops->sem_alloc_security (sma);
+	return security_ops->sem_alloc_security(sma);
 }
 
-void security_sem_free (struct sem_array *sma)
+void security_sem_free(struct sem_array *sma)
 {
-	security_ops->sem_free_security (sma);
+	security_ops->sem_free_security(sma);
 }
 
-int security_sem_associate (struct sem_array * sma, int semflg)
+int security_sem_associate(struct sem_array *sma, int semflg)
 {
-	return security_ops->sem_associate (sma, semflg);
+	return security_ops->sem_associate(sma, semflg);
 }
 
-int security_sem_semctl (struct sem_array * sma, int cmd)
+int security_sem_semctl(struct sem_array *sma, int cmd)
 {
 	return security_ops->sem_semctl(sma, cmd);
 }
 
-int security_sem_semop (struct sem_array * sma, struct sembuf * sops,
+int security_sem_semop(struct sem_array *sma, struct sembuf *sops,
 			unsigned nsops, int alter)
 {
 	return security_ops->sem_semop(sma, sops, nsops, alter);
 }
 
-void security_d_instantiate (struct dentry *dentry, struct inode *inode)
+void security_d_instantiate(struct dentry *dentry, struct inode *inode)
 {
-	if (unlikely (inode && IS_PRIVATE (inode)))
+	if (unlikely(inode && IS_PRIVATE(inode)))
 		return;
-	security_ops->d_instantiate (dentry, inode);
+	security_ops->d_instantiate(dentry, inode);
 }
 EXPORT_SYMBOL(security_d_instantiate);
 
@@ -840,13 +840,13 @@ int security_setprocattr(struct task_str
 	return security_ops->setprocattr(p, name, value, size);
 }
 
-int security_netlink_send(struct sock *sk, struct sk_buff * skb)
+int security_netlink_send(struct sock *sk, struct sk_buff *skb)
 {
 	return security_ops->netlink_send(sk, skb);
 }
 EXPORT_SYMBOL(security_netlink_send);
 
-int security_netlink_recv(struct sk_buff * skb, int cap)
+int security_netlink_recv(struct sk_buff *skb, int cap)
 {
 	return security_ops->netlink_recv(skb, cap);
 }
@@ -866,95 +866,95 @@ EXPORT_SYMBOL(security_release_secctx);
 
 #ifdef CONFIG_SECURITY_NETWORK
 
-int security_unix_stream_connect(struct socket * sock, struct socket * other,
-				 struct sock * newsk)
+int security_unix_stream_connect(struct socket *sock, struct socket *other,
+				 struct sock *newsk)
 {
 	return security_ops->unix_stream_connect(sock, other, newsk);
 }
 EXPORT_SYMBOL(security_unix_stream_connect);
 
-int security_unix_may_send(struct socket * sock,  struct socket * other)
+int security_unix_may_send(struct socket *sock,  struct socket *other)
 {
 	return security_ops->unix_may_send(sock, other);
 }
 EXPORT_SYMBOL(security_unix_may_send);
 
-int security_socket_create (int family, int type, int protocol, int kern)
+int security_socket_create(int family, int type, int protocol, int kern)
 {
 	return security_ops->socket_create(family, type, protocol, kern);
 }
 
-int security_socket_post_create(struct socket * sock, int family,
+int security_socket_post_create(struct socket *sock, int family,
 				int type, int protocol, int kern)
 {
 	return security_ops->socket_post_create(sock, family, type,
 						protocol, kern);
 }
 
-int security_socket_bind(struct socket * sock, struct sockaddr * address, int addrlen)
+int security_socket_bind(struct socket *sock, struct sockaddr *address, int addrlen)
 {
 	return security_ops->socket_bind(sock, address, addrlen);
 }
 
-int security_socket_connect(struct socket * sock, struct sockaddr * address, int addrlen)
+int security_socket_connect(struct socket *sock, struct sockaddr *address, int addrlen)
 {
 	return security_ops->socket_connect(sock, address, addrlen);
 }
 
-int security_socket_listen(struct socket * sock, int backlog)
+int security_socket_listen(struct socket *sock, int backlog)
 {
 	return security_ops->socket_listen(sock, backlog);
 }
 
-int security_socket_accept(struct socket * sock, struct socket * newsock)
+int security_socket_accept(struct socket *sock, struct socket *newsock)
 {
 	return security_ops->socket_accept(sock, newsock);
 }
 
-void security_socket_post_accept(struct socket * sock, struct socket * newsock)
+void security_socket_post_accept(struct socket *sock, struct socket *newsock)
 {
 	security_ops->socket_post_accept(sock, newsock);
 }
 
-int security_socket_sendmsg(struct socket * sock, struct msghdr * msg, int size)
+int security_socket_sendmsg(struct socket *sock, struct msghdr *msg, int size)
 {
 	return security_ops->socket_sendmsg(sock, msg, size);
 }
 
-int security_socket_recvmsg(struct socket * sock, struct msghdr * msg,
+int security_socket_recvmsg(struct socket *sock, struct msghdr *msg,
 			    int size, int flags)
 {
 	return security_ops->socket_recvmsg(sock, msg, size, flags);
 }
 
-int security_socket_getsockname(struct socket * sock)
+int security_socket_getsockname(struct socket *sock)
 {
 	return security_ops->socket_getsockname(sock);
 }
 
-int security_socket_getpeername(struct socket * sock)
+int security_socket_getpeername(struct socket *sock)
 {
 	return security_ops->socket_getpeername(sock);
 }
 
-int security_socket_getsockopt(struct socket * sock, int level, int optname)
+int security_socket_getsockopt(struct socket *sock, int level, int optname)
 {
 	return security_ops->socket_getsockopt(sock, level, optname);
 }
 
-int security_socket_setsockopt(struct socket * sock, int level, int optname)
+int security_socket_setsockopt(struct socket *sock, int level, int optname)
 {
 	return security_ops->socket_setsockopt(sock, level, optname);
 }
 
-int security_socket_shutdown(struct socket * sock, int how)
+int security_socket_shutdown(struct socket *sock, int how)
 {
 	return security_ops->socket_shutdown(sock, how);
 }
 
-int security_sock_rcv_skb (struct sock * sk, struct sk_buff * skb)
+int security_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
 {
-	return security_ops->socket_sock_rcv_skb (sk, skb);
+	return security_ops->socket_sock_rcv_skb(sk, skb);
 }
 EXPORT_SYMBOL(security_sock_rcv_skb);
 
@@ -997,7 +997,7 @@ void security_req_classify_flow(const st
 }
 EXPORT_SYMBOL(security_req_classify_flow);
 
-void security_sock_graft(struct sock* sk, struct socket *parent)
+void security_sock_graft(struct sock *sk, struct socket *parent)
 {
 	security_ops->sock_graft(sk, parent);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-bdi-init-hooks.patch
mm-per-device-dirty-threshold.patch
mm-dirty-balancing-for-tasks.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters.patch
oom-change-all_unreclaimable-zone-member-to-flags.patch
oom-do-not-take-callback_mutex.patch
writeback-dont-propagate-aop_writepage_activate.patch
softlockup-add-a-proc-tuning-parameter.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91.patch
do_sys_poll-simplify-playing-with-on-stack-data.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
add-in-sunos-41x-compatible-mode-for-ufs.patch
core_pattern-fix-up-a-few-miscellaneous-bugs.patch
printk-add-interfaces-for-external-access-to-the-log-buffer.patch
deprecate-aout-elf-interpreters.patch
ext2-ext3-ext4-add-block-bitmap-validation.patch
pie-executable-randomization.patch
binfmt_flat-warning-fixes.patch
i2o-fix-defined-but-not-used-build-warnings.patch
reiserfs-workaround-for-dead-loop-in-finish_unfinished.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios-right.patch
userc-ifdef-mq_bytes.patch
ext3-lighten-up-resize-transaction-requirements.patch
drivers-char-ip2-fix-used-uninitd-bug.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
writeback-fix-time-ordering-of-the-per-superblock-inode-lists-8.patch
md-software-raid-autodetect-dev-list-not-array.patch
pnp-use-dev_info-dev_err-etc-in-core.patch
security-convert-lsm-into-a-static-interface.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
git-acpi.patch
git-acpi-fixup.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
git-alsa-fixup.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-cifs.patch
console-keyboard-events-and-accessibility.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers.patch
git-jg-warning-fixes.patch
git-jg-misc-powernow-fix.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
ide-arm-hack.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
git-nfsd-fixup.patch
qla2xxx-printk-fixes.patch
sparc-support-for-new-termios.patch
git-unionfs.patch
git-nfs-vs-git-unionfs.patch
git-watchdog-fixup.patch
git-wireless.patch
revert-x86_64-mm-cpa-einval.patch
fix-x86_64-mm-sched-clock-share.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
asm-i386-ioh-fix-constness.patch
x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron.patch
git-xfs.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
pm-rework-struct-platform_suspend_ops-fixup-checkpatch-fixes.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
pm-qos-infrastructure-and-interface-fix.patch
pm-qos-infrastructure-and-interface-vs-git-acpi.patch
pm-qos-infrastructure-and-interface-vs-git-acpi-2.patch
add-kernel-notifierc-fix.patch
add-kernel-notifierc-fix-2-fix-3.patch
console-events-and-accessibility-fix.patch
procfs-detect-duplicate-names-fix.patch
procfs-detect-duplicate-names-fix-fix-2.patch
stop-using-dma_xxbit_mask.patch
stop-using-dma_xxbit_mask-fix.patch
kernel-printkc-concerns-about-the-console-handover.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
jbd-config_jbd_debug-cannot-create-proc-entry-fix.patch
peterz-vs-ext4-mballoc-core.patch
64-bit-i_version-afs-fixes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
task-containersv11-basic-task-container-framework-fix.patch
task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
lockdep-fix-mismatched-lockdep_depth-curr_chain_hash-checkpatch-fixes.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
cpuset-sched_load_balance-flag-fix.patch
cpusets-decrustify-cpuset-mask-update-code-checkpatch-fixes.patch
memory-controller-memory-accounting-v7-fix.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch
remove-bits_to_type-macro-fix.patch
use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified-checkpatch-fixes.patch
powerpc-lock-bitops-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix-2.patch
use-extended-crashkernel-command-line-on-i386.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes.patch
hook-up-group-scheduler-with-control-groups-fix.patch
linux-kernel-markers-checkpatch-fixes.patch
linux-kernel-markers-samples-checkpatch-fixes.patch
uninline-forkc-exitc-checkpatch-fixes.patch
fuse-fix-race-between-getattr-and-write-checkpatch-fixes.patch
fuse-add-file-handle-to-getattr-operation-checkpatch-fixes.patch
sparse-pointer-use-of-zero-as-null-checkpatch-fixes.patch
reiser4.patch
git-block-vs-reiser4.patch
git-nfsd-broke-reiser4.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
profile-likely-unlikely-macros-fix.patch
getblk-handle-2tb-devices.patch
w1-build-fix.patch
