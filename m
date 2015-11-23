From: akpm@linux-foundation.org
Subject: + fs-adfs-adfsh-tidy-up-comments.patch added to -mm tree
Date: Mon, 23 Nov 2015 14:33:24 -0800
Message-ID: <56539434./wug77HMHKbiJ999%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56230 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326AbbKWWdY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Nov 2015 17:33:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/adfs/adfs.h: tidy up comments
has been added to the -mm tree.  Its filename is
     fs-adfs-adfsh-tidy-up-comments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-adfs-adfsh-tidy-up-comments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-adfs-adfsh-tidy-up-comments.patch

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
Subject: fs/adfs/adfs.h: tidy up comments

Lots of needless 80-col overflows.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/adfs/adfs.h |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff -puN fs/adfs/adfs.h~fs-adfs-adfsh-tidy-up-comments fs/adfs/adfs.h
--- a/fs/adfs/adfs.h~fs-adfs-adfsh-tidy-up-comments
+++ a/fs/adfs/adfs.h
@@ -44,24 +44,24 @@ struct adfs_dir_ops;
  */
 struct adfs_sb_info {
 	union { struct {
-		struct adfs_discmap *s_map;	/* bh list containing map	 */
-		const struct adfs_dir_ops *s_dir; /* directory operations	 */
+		struct adfs_discmap *s_map;	/* bh list containing map */
+		const struct adfs_dir_ops *s_dir; /* directory operations */
 		};
-		struct rcu_head rcu;		/* used only at shutdown time	 */
+		struct rcu_head rcu;	/* used only at shutdown time	 */
 	};
-	kuid_t		s_uid;		/* owner uid				 */
-	kgid_t		s_gid;		/* owner gid				 */
-	umode_t		s_owner_mask;	/* ADFS owner perm -> unix perm		 */
-	umode_t		s_other_mask;	/* ADFS other perm -> unix perm		 */
+	kuid_t		s_uid;		/* owner uid */
+	kgid_t		s_gid;		/* owner gid */
+	umode_t		s_owner_mask;	/* ADFS owner perm -> unix perm */
+	umode_t		s_other_mask;	/* ADFS other perm -> unix perm	*/
 	int		s_ftsuffix;	/* ,xyz hex filetype suffix option */
 
-	__u32		s_ids_per_zone;	/* max. no ids in one zone		 */
-	__u32		s_idlen;	/* length of ID in map			 */
-	__u32		s_map_size;	/* sector size of a map			 */
-	unsigned long	s_size;		/* total size (in blocks) of this fs	 */
-	signed int	s_map2blk;	/* shift left by this for map->sector	 */
-	unsigned int	s_log2sharesize;/* log2 share size			 */
-	__le32		s_version;	/* disc format version			 */
+	__u32		s_ids_per_zone;	/* max. no ids in one zone */
+	__u32		s_idlen;	/* length of ID in map */
+	__u32		s_map_size;	/* sector size of a map	*/
+	unsigned long	s_size;		/* total size (in blocks) of this fs */
+	signed int	s_map2blk;	/* shift left by this for map->sector*/
+	unsigned int	s_log2sharesize;/* log2 share size */
+	__le32		s_version;	/* disc format version */
 	unsigned int	s_namelen;	/* maximum number of characters in name	 */
 };
 
diff -puN fs/adfs/dir.c~fs-adfs-adfsh-tidy-up-comments fs/adfs/dir.c
diff -puN fs/adfs/dir_f.c~fs-adfs-adfsh-tidy-up-comments fs/adfs/dir_f.c
diff -puN fs/adfs/dir_fplus.c~fs-adfs-adfsh-tidy-up-comments fs/adfs/dir_fplus.c
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm.patch
account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch
mm-mmapc-remove-redundant-local-variables-for-may_expand_vm-fix.patch
include-define-__phys_to_pfn-as-phys_pfn-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2.patch
mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes.patch
mm-zonelist-enumerate-zonelists-array-index-fix.patch
mm-get-rid-of-__alloc_pages_high_priority-checkpatch-fixes.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix.patch
fs-adfs-adfsh-tidy-up-comments.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

