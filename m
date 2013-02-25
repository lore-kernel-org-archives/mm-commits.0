From: akpm@linux-foundation.org
Subject: [merged] fs-nfsd-change-type-of-max_delegations-nfsd_drc_max_mem-and-nfsd_drc_mem_used.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:55:22 -0800
Message-ID: <20130225205522.94C6331C26E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:49738 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759261Ab3BYUzX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:55:23 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so348118vea.0
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:55:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/nfsd: change type of max_delegations, nfsd_drc_max_mem and nfsd_drc_mem_used
has been removed from the -mm tree.  Its filename was
     fs-nfsd-change-type-of-max_delegations-nfsd_drc_max_mem-and-nfsd_drc_mem_used.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: fs/nfsd: change type of max_delegations, nfsd_drc_max_mem and nfsd_drc_mem_used

The three variables are calculated from nr_free_buffer_pages so
change their types to unsigned long in case of overflow.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4state.c |    6 +++---
 fs/nfsd/nfsd.h      |    6 +++---
 fs/nfsd/nfssvc.c    |    6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff -puN fs/nfsd/nfs4state.c~fs-nfsd-change-type-of-max_delegations-nfsd_drc_max_mem-and-nfsd_drc_mem_used fs/nfsd/nfs4state.c
--- a/fs/nfsd/nfs4state.c~fs-nfsd-change-type-of-max_delegations-nfsd_drc_max_mem-and-nfsd_drc_mem_used
+++ a/fs/nfsd/nfs4state.c
@@ -151,7 +151,7 @@ get_nfs4_file(struct nfs4_file *fi)
 }
 
 static int num_delegations;
-unsigned int max_delegations;
+unsigned long max_delegations;
 
 /*
  * Open owner state (share locks)
@@ -700,8 +700,8 @@ static int nfsd4_get_drc_mem(int slotsiz
 	num = min_t(u32, num, NFSD_MAX_SLOTS_PER_SESSION);
 
 	spin_lock(&nfsd_drc_lock);
-	avail = min_t(int, NFSD_MAX_MEM_PER_SESSION,
-			nfsd_drc_max_mem - nfsd_drc_mem_used);
+	avail = min((unsigned long)NFSD_MAX_MEM_PER_SESSION,
+		    nfsd_drc_max_mem - nfsd_drc_mem_used);
 	num = min_t(int, num, avail / slotsize);
 	nfsd_drc_mem_used += num * slotsize;
 	spin_unlock(&nfsd_drc_lock);
diff -puN fs/nfsd/nfsd.h~fs-nfsd-change-type-of-max_delegations-nfsd_drc_max_mem-and-nfsd_drc_mem_used fs/nfsd/nfsd.h
--- a/fs/nfsd/nfsd.h~fs-nfsd-change-type-of-max_delegations-nfsd_drc_max_mem-and-nfsd_drc_mem_used
+++ a/fs/nfsd/nfsd.h
@@ -56,8 +56,8 @@ extern struct svc_version	nfsd_version2,
 extern u32			nfsd_supported_minorversion;
 extern struct mutex		nfsd_mutex;
 extern spinlock_t		nfsd_drc_lock;
-extern unsigned int		nfsd_drc_max_mem;
-extern unsigned int		nfsd_drc_mem_used;
+extern unsigned long		nfsd_drc_max_mem;
+extern unsigned long		nfsd_drc_mem_used;
 
 extern const struct seq_operations nfs_exports_op;
 
@@ -106,7 +106,7 @@ static inline int nfsd_v4client(struct s
  * NFSv4 State
  */
 #ifdef CONFIG_NFSD_V4
-extern unsigned int max_delegations;
+extern unsigned long max_delegations;
 void nfs4_state_init(void);
 int nfsd4_init_slabs(void);
 void nfsd4_free_slabs(void);
diff -puN fs/nfsd/nfssvc.c~fs-nfsd-change-type-of-max_delegations-nfsd_drc_max_mem-and-nfsd_drc_mem_used fs/nfsd/nfssvc.c
--- a/fs/nfsd/nfssvc.c~fs-nfsd-change-type-of-max_delegations-nfsd_drc_max_mem-and-nfsd_drc_mem_used
+++ a/fs/nfsd/nfssvc.c
@@ -59,8 +59,8 @@ DEFINE_MUTEX(nfsd_mutex);
  * nfsd_drc_pages_used tracks the current version 4.1 DRC memory usage.
  */
 spinlock_t	nfsd_drc_lock;
-unsigned int	nfsd_drc_max_mem;
-unsigned int	nfsd_drc_mem_used;
+unsigned long	nfsd_drc_max_mem;
+unsigned long	nfsd_drc_mem_used;
 
 #if defined(CONFIG_NFSD_V2_ACL) || defined(CONFIG_NFSD_V3_ACL)
 static struct svc_stat	nfsd_acl_svcstats;
@@ -342,7 +342,7 @@ static void set_max_drc(void)
 					>> NFSD_DRC_SIZE_SHIFT) * PAGE_SIZE;
 	nfsd_drc_mem_used = 0;
 	spin_lock_init(&nfsd_drc_lock);
-	dprintk("%s nfsd_drc_max_mem %u \n", __func__, nfsd_drc_max_mem);
+	dprintk("%s nfsd_drc_max_mem %lu \n", __func__, nfsd_drc_max_mem);
 }
 
 static int nfsd_get_default_max_blksize(void)
_

Patches currently in -mm which might be from zhangyanfei@cn.fujitsu.com are

origin.patch
ipvs-change-type-of-netns_ipvs-sysctl_sync_qlen_max.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix-fix.patch
kexec-get-rid-of-duplicate-check-for-hole_end.patch
kexec-prevent-double-free-on-image-allocation-failure.patch
kexec-fix-memory-leak-in-function-kimage_normal_alloc.patch
kexec-avoid-freeing-null-pointer-in-function-kimage_crash_alloc.patch

