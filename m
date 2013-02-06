From: akpm@linux-foundation.org
Subject: + fs-nfsd-change-type-of-max_delegations-nfsd_drc_max_mem-and-nfsd_drc_mem_used.patch added to -mm tree
Date: Wed, 06 Feb 2013 14:49:15 -0800
Message-ID: <20130206224916.40D615A4277@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:34678 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757593Ab3BFWtR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 17:49:17 -0500
Received: by mail-ve0-f202.google.com with SMTP id m1so210838ves.3
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 14:49:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhangyanfei@cn.fujitsu.com


The patch titled
     Subject: fs/nfsd: change type of max_delegations, nfsd_drc_max_mem and nfsd_drc_mem_used
has been added to the -mm tree.  Its filename is
     fs-nfsd-change-type-of-max_delegations-nfsd_drc_max_mem-and-nfsd_drc_mem_used.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-fix-return-type-for-functions-nr_free__pages.patch
ia64-use-%ld-to-print-pages-calculated-in-nr_free_buffer_pages.patch
fs-bufferc-change-type-of-max_buffer_heads-to-unsigned-long.patch
fs-nfsd-change-type-of-max_delegations-nfsd_drc_max_mem-and-nfsd_drc_mem_used.patch
vmscan-change-type-of-vm_total_pages-to-unsigned-long.patch
net-change-type-of-netns_ipvs-sysctl_sync_qlen_max.patch
net-change-type-of-virtio_chan-p9_max_pages.patch
binfmt_elf-remove-unused-argument-in-fill_elf_header.patch
kexec-get-rid-of-duplicate-check-for-hole_end.patch

