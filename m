From: akpm@linux-foundation.org
Subject: [patch 126/127] cred: simpler, 1D supplementary groups
Date: Fri, 07 Oct 2016 17:03:12 -0700
Message-ID: <57f837c0.C+jYJlM+Y0nl+pTw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39713 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753618AbcJHADN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 20:03:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, adobriyan@gmail.com, segoon@openwall.com

From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: cred: simpler, 1D supplementary groups

Current supplementary groups code can massively overallocate memory and is
implemented in a way so that access to individual gid is done via 2D
array.

If number of gids is <= 32, memory allocation is more or less tolerable
(140/148 bytes).  But if it is not, code allocates full page (!)
regardless and, what's even more fun, doesn't reuse small 32-entry array.

2D array means dependent shifts, loads and LEAs without possibility to
optimize them (gid is never known at compile time).

All of the above is unnecessary.  Switch to the usual
trailing-zero-len-array scheme.  Memory is allocated with
kmalloc/vmalloc() and only as much as needed.  Accesses become simpler
(LEA 8(gi,idx,4) or even without displacement).

Maximum number of gids is 65536 which translates to 256KB+8 bytes.  I
think kernel can handle such allocation.

On my usual desktop system with whole 9 (nine) aux groups,
struct group_info shrinks from 148 bytes to 44 bytes, yay!

Nice side effects:
* "gi->gid[i]" is shorter than "GROUP_AT(gi, i)", less typing,

* fix little mess in net/ipv4/ping.c
  should have been using GROUP_AT macro but this point becomes moot,

* aux group allocation is persistent and should be accounted as such.

Link: http://lkml.kernel.org/r/20160817201927.GA2096@p183.telecom.by
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Vasily Kulikov <segoon@openwall.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/compat_linux.c            |    4 -
 drivers/staging/lustre/lustre/ptlrpc/sec.c |    2 
 fs/nfsd/auth.c                             |    6 -
 fs/nfsd/nfs4state.c                        |    2 
 fs/proc/array.c                            |    2 
 include/linux/cred.h                       |   11 ---
 kernel/groups.c                            |   65 +++++--------------
 kernel/uid16.c                             |    4 -
 net/ipv4/ping.c                            |   15 +---
 net/sunrpc/auth_generic.c                  |    4 -
 net/sunrpc/auth_gss/gss_rpc_xdr.c          |    2 
 net/sunrpc/auth_gss/svcauth_gss.c          |    2 
 net/sunrpc/auth_unix.c                     |    4 -
 net/sunrpc/svcauth_unix.c                  |    6 -
 14 files changed, 45 insertions(+), 84 deletions(-)

diff -puN arch/s390/kernel/compat_linux.c~cred-simpler-1d-supplementary-groups arch/s390/kernel/compat_linux.c
--- a/arch/s390/kernel/compat_linux.c~cred-simpler-1d-supplementary-groups
+++ a/arch/s390/kernel/compat_linux.c
@@ -189,7 +189,7 @@ static int groups16_to_user(u16 __user *
 	kgid_t kgid;
 
 	for (i = 0; i < group_info->ngroups; i++) {
-		kgid = GROUP_AT(group_info, i);
+		kgid = group_info->gid[i];
 		group = (u16)from_kgid_munged(user_ns, kgid);
 		if (put_user(group, grouplist+i))
 			return -EFAULT;
@@ -213,7 +213,7 @@ static int groups16_from_user(struct gro
 		if (!gid_valid(kgid))
 			return -EINVAL;
 
-		GROUP_AT(group_info, i) = kgid;
+		group_info->gid[i] = kgid;
 	}
 
 	return 0;
diff -puN drivers/staging/lustre/lustre/ptlrpc/sec.c~cred-simpler-1d-supplementary-groups drivers/staging/lustre/lustre/ptlrpc/sec.c
--- a/drivers/staging/lustre/lustre/ptlrpc/sec.c~cred-simpler-1d-supplementary-groups
+++ a/drivers/staging/lustre/lustre/ptlrpc/sec.c
@@ -2220,7 +2220,7 @@ int sptlrpc_pack_user_desc(struct lustre
 	task_lock(current);
 	if (pud->pud_ngroups > current_ngroups)
 		pud->pud_ngroups = current_ngroups;
-	memcpy(pud->pud_groups, current_cred()->group_info->blocks[0],
+	memcpy(pud->pud_groups, current_cred()->group_info->gid,
 	       pud->pud_ngroups * sizeof(__u32));
 	task_unlock(current);
 
diff -puN fs/nfsd/auth.c~cred-simpler-1d-supplementary-groups fs/nfsd/auth.c
--- a/fs/nfsd/auth.c~cred-simpler-1d-supplementary-groups
+++ a/fs/nfsd/auth.c
@@ -55,10 +55,10 @@ int nfsd_setuser(struct svc_rqst *rqstp,
 			goto oom;
 
 		for (i = 0; i < rqgi->ngroups; i++) {
-			if (gid_eq(GLOBAL_ROOT_GID, GROUP_AT(rqgi, i)))
-				GROUP_AT(gi, i) = exp->ex_anon_gid;
+			if (gid_eq(GLOBAL_ROOT_GID, rqgi->gid[i]))
+				gi->gid[i] = exp->ex_anon_gid;
 			else
-				GROUP_AT(gi, i) = GROUP_AT(rqgi, i);
+				gi->gid[i] = rqgi->gid[i];
 		}
 	} else {
 		gi = get_group_info(rqgi);
diff -puN fs/nfsd/nfs4state.c~cred-simpler-1d-supplementary-groups fs/nfsd/nfs4state.c
--- a/fs/nfsd/nfs4state.c~cred-simpler-1d-supplementary-groups
+++ a/fs/nfsd/nfs4state.c
@@ -1903,7 +1903,7 @@ static bool groups_equal(struct group_in
 	if (g1->ngroups != g2->ngroups)
 		return false;
 	for (i=0; i<g1->ngroups; i++)
-		if (!gid_eq(GROUP_AT(g1, i), GROUP_AT(g2, i)))
+		if (!gid_eq(g1->gid[i], g2->gid[i]))
 			return false;
 	return true;
 }
diff -puN fs/proc/array.c~cred-simpler-1d-supplementary-groups fs/proc/array.c
--- a/fs/proc/array.c~cred-simpler-1d-supplementary-groups
+++ a/fs/proc/array.c
@@ -207,7 +207,7 @@ static inline void task_state(struct seq
 	group_info = cred->group_info;
 	for (g = 0; g < group_info->ngroups; g++)
 		seq_put_decimal_ull(m, g ? " " : "",
-				    from_kgid_munged(user_ns, GROUP_AT(group_info, g)));
+				from_kgid_munged(user_ns, group_info->gid[g]));
 	put_cred(cred);
 	/* Trailing space shouldn't have been added in the first place. */
 	seq_putc(m, ' ');
diff -puN include/linux/cred.h~cred-simpler-1d-supplementary-groups include/linux/cred.h
--- a/include/linux/cred.h~cred-simpler-1d-supplementary-groups
+++ a/include/linux/cred.h
@@ -26,15 +26,10 @@ struct inode;
 /*
  * COW Supplementary groups list
  */
-#define NGROUPS_SMALL		32
-#define NGROUPS_PER_BLOCK	((unsigned int)(PAGE_SIZE / sizeof(kgid_t)))
-
 struct group_info {
 	atomic_t	usage;
 	int		ngroups;
-	int		nblocks;
-	kgid_t		small_block[NGROUPS_SMALL];
-	kgid_t		*blocks[0];
+	kgid_t		gid[0];
 };
 
 /**
@@ -88,10 +83,6 @@ extern void set_groups(struct cred *, st
 extern int groups_search(const struct group_info *, kgid_t);
 extern bool may_setgroups(void);
 
-/* access the groups "array" with this macro */
-#define GROUP_AT(gi, i) \
-	((gi)->blocks[(i) / NGROUPS_PER_BLOCK][(i) % NGROUPS_PER_BLOCK])
-
 /*
  * The security context of a task
  *
diff -puN kernel/groups.c~cred-simpler-1d-supplementary-groups kernel/groups.c
--- a/kernel/groups.c~cred-simpler-1d-supplementary-groups
+++ a/kernel/groups.c
@@ -7,55 +7,31 @@
 #include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/user_namespace.h>
+#include <linux/vmalloc.h>
 #include <asm/uaccess.h>
 
 struct group_info *groups_alloc(int gidsetsize)
 {
-	struct group_info *group_info;
-	int nblocks;
-	int i;
+	struct group_info *gi;
+	unsigned int len;
 
-	nblocks = (gidsetsize + NGROUPS_PER_BLOCK - 1) / NGROUPS_PER_BLOCK;
-	/* Make sure we always allocate at least one indirect block pointer */
-	nblocks = nblocks ? : 1;
-	group_info = kmalloc(sizeof(*group_info) + nblocks*sizeof(gid_t *), GFP_USER);
-	if (!group_info)
+	len = sizeof(struct group_info) + sizeof(kgid_t) * gidsetsize;
+	gi = kmalloc(len, GFP_KERNEL_ACCOUNT|__GFP_NOWARN|__GFP_NORETRY);
+	if (!gi)
+		gi = __vmalloc(len, GFP_KERNEL_ACCOUNT|__GFP_HIGHMEM, PAGE_KERNEL);
+	if (!gi)
 		return NULL;
-	group_info->ngroups = gidsetsize;
-	group_info->nblocks = nblocks;
-	atomic_set(&group_info->usage, 1);
-
-	if (gidsetsize <= NGROUPS_SMALL)
-		group_info->blocks[0] = group_info->small_block;
-	else {
-		for (i = 0; i < nblocks; i++) {
-			kgid_t *b;
-			b = (void *)__get_free_page(GFP_USER);
-			if (!b)
-				goto out_undo_partial_alloc;
-			group_info->blocks[i] = b;
-		}
-	}
-	return group_info;
 
-out_undo_partial_alloc:
-	while (--i >= 0) {
-		free_page((unsigned long)group_info->blocks[i]);
-	}
-	kfree(group_info);
-	return NULL;
+	atomic_set(&gi->usage, 1);
+	gi->ngroups = gidsetsize;
+	return gi;
 }
 
 EXPORT_SYMBOL(groups_alloc);
 
 void groups_free(struct group_info *group_info)
 {
-	if (group_info->blocks[0] != group_info->small_block) {
-		int i;
-		for (i = 0; i < group_info->nblocks; i++)
-			free_page((unsigned long)group_info->blocks[i]);
-	}
-	kfree(group_info);
+	kvfree(group_info);
 }
 
 EXPORT_SYMBOL(groups_free);
@@ -70,7 +46,7 @@ static int groups_to_user(gid_t __user *
 
 	for (i = 0; i < count; i++) {
 		gid_t gid;
-		gid = from_kgid_munged(user_ns, GROUP_AT(group_info, i));
+		gid = from_kgid_munged(user_ns, group_info->gid[i]);
 		if (put_user(gid, grouplist+i))
 			return -EFAULT;
 	}
@@ -95,7 +71,7 @@ static int groups_from_user(struct group
 		if (!gid_valid(kgid))
 			return -EINVAL;
 
-		GROUP_AT(group_info, i) = kgid;
+		group_info->gid[i] = kgid;
 	}
 	return 0;
 }
@@ -115,15 +91,14 @@ static void groups_sort(struct group_inf
 		for (base = 0; base < max; base++) {
 			int left = base;
 			int right = left + stride;
-			kgid_t tmp = GROUP_AT(group_info, right);
+			kgid_t tmp = group_info->gid[right];
 
-			while (left >= 0 && gid_gt(GROUP_AT(group_info, left), tmp)) {
-				GROUP_AT(group_info, right) =
-				    GROUP_AT(group_info, left);
+			while (left >= 0 && gid_gt(group_info->gid[left], tmp)) {
+				group_info->gid[right] = group_info->gid[left];
 				right = left;
 				left -= stride;
 			}
-			GROUP_AT(group_info, right) = tmp;
+			group_info->gid[right] = tmp;
 		}
 		stride /= 3;
 	}
@@ -141,9 +116,9 @@ int groups_search(const struct group_inf
 	right = group_info->ngroups;
 	while (left < right) {
 		unsigned int mid = (left+right)/2;
-		if (gid_gt(grp, GROUP_AT(group_info, mid)))
+		if (gid_gt(grp, group_info->gid[mid]))
 			left = mid + 1;
-		else if (gid_lt(grp, GROUP_AT(group_info, mid)))
+		else if (gid_lt(grp, group_info->gid[mid]))
 			right = mid;
 		else
 			return 1;
diff -puN kernel/uid16.c~cred-simpler-1d-supplementary-groups kernel/uid16.c
--- a/kernel/uid16.c~cred-simpler-1d-supplementary-groups
+++ a/kernel/uid16.c
@@ -117,7 +117,7 @@ static int groups16_to_user(old_gid_t __
 	kgid_t kgid;
 
 	for (i = 0; i < group_info->ngroups; i++) {
-		kgid = GROUP_AT(group_info, i);
+		kgid = group_info->gid[i];
 		group = high2lowgid(from_kgid_munged(user_ns, kgid));
 		if (put_user(group, grouplist+i))
 			return -EFAULT;
@@ -142,7 +142,7 @@ static int groups16_from_user(struct gro
 		if (!gid_valid(kgid))
 			return -EINVAL;
 
-		GROUP_AT(group_info, i) = kgid;
+		group_info->gid[i] = kgid;
 	}
 
 	return 0;
diff -puN net/ipv4/ping.c~cred-simpler-1d-supplementary-groups net/ipv4/ping.c
--- a/net/ipv4/ping.c~cred-simpler-1d-supplementary-groups
+++ a/net/ipv4/ping.c
@@ -258,7 +258,7 @@ int ping_init_sock(struct sock *sk)
 	struct net *net = sock_net(sk);
 	kgid_t group = current_egid();
 	struct group_info *group_info;
-	int i, j, count;
+	int i;
 	kgid_t low, high;
 	int ret = 0;
 
@@ -270,16 +270,11 @@ int ping_init_sock(struct sock *sk)
 		return 0;
 
 	group_info = get_current_groups();
-	count = group_info->ngroups;
-	for (i = 0; i < group_info->nblocks; i++) {
-		int cp_count = min_t(int, NGROUPS_PER_BLOCK, count);
-		for (j = 0; j < cp_count; j++) {
-			kgid_t gid = group_info->blocks[i][j];
-			if (gid_lte(low, gid) && gid_lte(gid, high))
-				goto out_release_group;
-		}
+	for (i = 0; i < group_info->ngroups; i++) {
+		kgid_t gid = group_info->gid[i];
 
-		count -= cp_count;
+		if (gid_lte(low, gid) && gid_lte(gid, high))
+			goto out_release_group;
 	}
 
 	ret = -EACCES;
diff -puN net/sunrpc/auth_generic.c~cred-simpler-1d-supplementary-groups net/sunrpc/auth_generic.c
--- a/net/sunrpc/auth_generic.c~cred-simpler-1d-supplementary-groups
+++ a/net/sunrpc/auth_generic.c
@@ -176,8 +176,8 @@ generic_match(struct auth_cred *acred, s
 	if (gcred->acred.group_info->ngroups != acred->group_info->ngroups)
 		goto out_nomatch;
 	for (i = 0; i < gcred->acred.group_info->ngroups; i++) {
-		if (!gid_eq(GROUP_AT(gcred->acred.group_info, i),
-				GROUP_AT(acred->group_info, i)))
+		if (!gid_eq(gcred->acred.group_info->gid[i],
+				acred->group_info->gid[i]))
 			goto out_nomatch;
 	}
 out_match:
diff -puN net/sunrpc/auth_gss/gss_rpc_xdr.c~cred-simpler-1d-supplementary-groups net/sunrpc/auth_gss/gss_rpc_xdr.c
--- a/net/sunrpc/auth_gss/gss_rpc_xdr.c~cred-simpler-1d-supplementary-groups
+++ a/net/sunrpc/auth_gss/gss_rpc_xdr.c
@@ -229,7 +229,7 @@ static int gssx_dec_linux_creds(struct x
 		kgid = make_kgid(&init_user_ns, tmp);
 		if (!gid_valid(kgid))
 			goto out_free_groups;
-		GROUP_AT(creds->cr_group_info, i) = kgid;
+		creds->cr_group_info->gid[i] = kgid;
 	}
 
 	return 0;
diff -puN net/sunrpc/auth_gss/svcauth_gss.c~cred-simpler-1d-supplementary-groups net/sunrpc/auth_gss/svcauth_gss.c
--- a/net/sunrpc/auth_gss/svcauth_gss.c~cred-simpler-1d-supplementary-groups
+++ a/net/sunrpc/auth_gss/svcauth_gss.c
@@ -479,7 +479,7 @@ static int rsc_parse(struct cache_detail
 			kgid = make_kgid(&init_user_ns, id);
 			if (!gid_valid(kgid))
 				goto out;
-			GROUP_AT(rsci.cred.cr_group_info, i) = kgid;
+			rsci.cred.cr_group_info->gid[i] = kgid;
 		}
 
 		/* mech name */
diff -puN net/sunrpc/auth_unix.c~cred-simpler-1d-supplementary-groups net/sunrpc/auth_unix.c
--- a/net/sunrpc/auth_unix.c~cred-simpler-1d-supplementary-groups
+++ a/net/sunrpc/auth_unix.c
@@ -79,7 +79,7 @@ unx_create_cred(struct rpc_auth *auth, s
 
 	cred->uc_gid = acred->gid;
 	for (i = 0; i < groups; i++)
-		cred->uc_gids[i] = GROUP_AT(acred->group_info, i);
+		cred->uc_gids[i] = acred->group_info->gid[i];
 	if (i < NFS_NGROUPS)
 		cred->uc_gids[i] = INVALID_GID;
 
@@ -127,7 +127,7 @@ unx_match(struct auth_cred *acred, struc
 	if (groups > NFS_NGROUPS)
 		groups = NFS_NGROUPS;
 	for (i = 0; i < groups ; i++)
-		if (!gid_eq(cred->uc_gids[i], GROUP_AT(acred->group_info, i)))
+		if (!gid_eq(cred->uc_gids[i], acred->group_info->gid[i]))
 			return 0;
 	if (groups < NFS_NGROUPS && gid_valid(cred->uc_gids[groups]))
 		return 0;
diff -puN net/sunrpc/svcauth_unix.c~cred-simpler-1d-supplementary-groups net/sunrpc/svcauth_unix.c
--- a/net/sunrpc/svcauth_unix.c~cred-simpler-1d-supplementary-groups
+++ a/net/sunrpc/svcauth_unix.c
@@ -517,7 +517,7 @@ static int unix_gid_parse(struct cache_d
 		kgid = make_kgid(&init_user_ns, gid);
 		if (!gid_valid(kgid))
 			goto out;
-		GROUP_AT(ug.gi, i) = kgid;
+		ug.gi->gid[i] = kgid;
 	}
 
 	ugp = unix_gid_lookup(cd, uid);
@@ -564,7 +564,7 @@ static int unix_gid_show(struct seq_file
 
 	seq_printf(m, "%u %d:", from_kuid_munged(user_ns, ug->uid), glen);
 	for (i = 0; i < glen; i++)
-		seq_printf(m, " %d", from_kgid_munged(user_ns, GROUP_AT(ug->gi, i)));
+		seq_printf(m, " %d", from_kgid_munged(user_ns, ug->gi->gid[i]));
 	seq_printf(m, "\n");
 	return 0;
 }
@@ -817,7 +817,7 @@ svcauth_unix_accept(struct svc_rqst *rqs
 		return SVC_CLOSE;
 	for (i = 0; i < slen; i++) {
 		kgid_t kgid = make_kgid(&init_user_ns, svc_getnl(argv));
-		GROUP_AT(cred->cr_group_info, i) = kgid;
+		cred->cr_group_info->gid[i] = kgid;
 	}
 	if (svc_getu32(argv) != htonl(RPC_AUTH_NULL) || svc_getu32(argv) != 0) {
 		*authp = rpc_autherr_badverf;
_
