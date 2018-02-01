From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Wed, 31 Jan 2018 16:31:29 -0800
Message-ID: <5a725fe1.3D2qHe83SpnCfANa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38204 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755844AbeBAAba (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:31:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb-core/dmxdev.c |    3 --
 drivers/media/rc/lirc_dev.c     |    7 ------
 fs/dcache.c                     |   12 -----------
 fs/f2fs/namei.c                 |   31 ------------------------------
 net/smc/smc_clc.c               |    4 ---
 net/tipc/socket.c               |    4 ---
 6 files changed, 61 deletions(-)

diff -puN drivers/media/dvb-core/dmxdev.c~linux-next-git-rejects drivers/media/dvb-core/dmxdev.c
--- a/drivers/media/dvb-core/dmxdev.c~linux-next-git-rejects
+++ a/drivers/media/dvb-core/dmxdev.c
@@ -1322,14 +1322,11 @@ static __poll_t dvb_dvr_poll(struct file
 	struct dvb_device *dvbdev = file->private_data;
 	struct dmxdev *dmxdev = dvbdev->priv;
 	__poll_t mask = 0;
-<<<<<<< HEAD
-=======
 #ifndef DVB_MMAP
 	bool need_ringbuffer = false;
 #else
 	const bool need_ringbuffer = true;
 #endif
->>>>>>> linux-next/akpm-base
 
 	dprintk("%s\n", __func__);
 
diff -puN drivers/media/rc/lirc_dev.c~linux-next-git-rejects drivers/media/rc/lirc_dev.c
--- a/drivers/media/rc/lirc_dev.c~linux-next-git-rejects
+++ a/drivers/media/rc/lirc_dev.c
@@ -321,18 +321,11 @@ static ssize_t ir_lirc_transmit_ir(struc
 			goto out_unlock;
 		}
 
-<<<<<<< HEAD
-__poll_t lirc_dev_fop_poll(struct file *file, poll_table *wait)
-{
-	struct lirc_dev *d = file->private_data;
-	__poll_t ret;
-=======
 		count = n / sizeof(unsigned int);
 		if (count > LIRCBUF_SIZE || count % 2 == 0) {
 			ret = -EINVAL;
 			goto out_unlock;
 		}
->>>>>>> linux-next/akpm-base
 
 		txbuf = memdup_user(buf, n);
 		if (IS_ERR(txbuf)) {
diff -puN fs/dcache.c~linux-next-git-rejects fs/dcache.c
--- a/fs/dcache.c~linux-next-git-rejects
+++ a/fs/dcache.c
@@ -1959,17 +1959,6 @@ static struct dentry *__d_instantiate_an
 	if (disconnected)
 		add_flags |= DCACHE_DISCONNECTED;
 
-<<<<<<< HEAD
-	spin_lock(&tmp->d_lock);
-	__d_set_inode_and_type(tmp, inode, add_flags);
-	hlist_add_head(&tmp->d_u.d_alias, &inode->i_dentry);
-	if (!disconnected) {
-		hlist_bl_lock(&tmp->d_sb->s_roots);
-		hlist_bl_add_head(&tmp->d_hash, &tmp->d_sb->s_roots);
-		hlist_bl_unlock(&tmp->d_sb->s_roots);
-	}
-	spin_unlock(&tmp->d_lock);
-=======
 	spin_lock(&dentry->d_lock);
 	__d_set_inode_and_type(dentry, inode, add_flags);
 	hlist_add_head(&dentry->d_u.d_alias, &inode->i_dentry);
@@ -1979,7 +1968,6 @@ static struct dentry *__d_instantiate_an
 		hlist_bl_unlock(&dentry->d_sb->s_roots);
 	}
 	spin_unlock(&dentry->d_lock);
->>>>>>> linux-next/akpm-base
 	spin_unlock(&inode->i_lock);
 
 	return dentry;
diff -puN fs/f2fs/namei.c~linux-next-git-rejects fs/f2fs/namei.c
--- a/fs/f2fs/namei.c~linux-next-git-rejects
+++ a/fs/f2fs/namei.c
@@ -519,40 +519,9 @@ static int f2fs_symlink(struct inode *di
 	f2fs_unlock_op(sbi);
 	alloc_nid_done(sbi, inode->i_ino);
 
-<<<<<<< HEAD
-	if (f2fs_encrypted_inode(inode)) {
-		struct qstr istr = QSTR_INIT(symname, len);
-		struct fscrypt_str ostr;
-
-		sd = f2fs_kzalloc(sbi, disk_link.len, GFP_NOFS);
-		if (!sd) {
-			err = -ENOMEM;
-			goto err_out;
-		}
-
-		err = fscrypt_get_encryption_info(inode);
-		if (err)
-			goto err_out;
-
-		if (!fscrypt_has_encryption_key(inode)) {
-			err = -ENOKEY;
-			goto err_out;
-		}
-
-		ostr.name = sd->encrypted_path;
-		ostr.len = disk_link.len;
-		err = fscrypt_fname_usr_to_disk(inode, &istr, &ostr);
-		if (err)
-			goto err_out;
-
-		sd->len = cpu_to_le16(ostr.len);
-		disk_link.name = (char *)sd;
-	}
-=======
 	err = fscrypt_encrypt_symlink(inode, symname, len, &disk_link);
 	if (err)
 		goto err_out;
->>>>>>> linux-next/akpm-base
 
 	err = page_symlink(inode, disk_link.name, disk_link.len);
 
diff -puN net/smc/smc_clc.c~linux-next-git-rejects net/smc/smc_clc.c
--- a/net/smc/smc_clc.c~linux-next-git-rejects
+++ a/net/smc/smc_clc.c
@@ -137,11 +137,7 @@ int smc_clc_wait_msg(struct smc_sock *sm
 	krflags = MSG_WAITALL;
 	smc->clcsock->sk->sk_rcvtimeo = CLC_WAIT_TIME;
 	len = sock_recvmsg(smc->clcsock, &msg, krflags);
-<<<<<<< HEAD
-	if (len < datlen) {
-=======
 	if (len < datlen || !smc_clc_msg_hdr_valid(clcm)) {
->>>>>>> linux-next/akpm-base
 		smc->sk.sk_err = EPROTO;
 		reason_code = -EPROTO;
 		goto out;
diff -puN net/tipc/socket.c~linux-next-git-rejects net/tipc/socket.c
--- a/net/tipc/socket.c~linux-next-git-rejects
+++ a/net/tipc/socket.c
@@ -716,10 +716,6 @@ static __poll_t tipc_poll(struct file *f
 {
 	struct sock *sk = sock->sk;
 	struct tipc_sock *tsk = tipc_sk(sk);
-<<<<<<< HEAD
-	struct tipc_group *grp = tsk->group;
-=======
->>>>>>> linux-next/akpm-base
 	__poll_t revents = 0;
 
 	sock_poll_wait(file, sk_sleep(sk), wait);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2-fix.patch
fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes.patch
mm-migrate-remove-reason-argument-from-new_page_t-fix-fix.patch
kasan-clean-up-kasan_shadow_scale_shift-usage-checkpatch-fixes.patch
lib-ubsanc-s-missaligned-misaligned.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
fs-crypto-hooksc-fix-build-with-gcc-444.patch
maintainers-update-arm-oxnas-platform-support-patterns-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

