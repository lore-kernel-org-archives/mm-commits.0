From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Tue, 16 Jan 2018 11:29:40 -0800
Message-ID: <20180116192940.j-3jJKoK9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41504 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750811AbeAPT3l (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 Jan 2018 14:29:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/bpf/arraymap.c |   13 -------------
 kernel/bpf/verifier.c |    4 ----
 net/sctp/socket.c     |    4 ----
 3 files changed, 21 deletions(-)

diff -puN kernel/bpf/arraymap.c~linux-next-git-rejects kernel/bpf/arraymap.c
--- a/kernel/bpf/arraymap.c~linux-next-git-rejects
+++ a/kernel/bpf/arraymap.c
@@ -56,11 +56,7 @@ static struct bpf_map *array_map_alloc(u
 	u32 elem_size, index_mask, max_entries;
 	bool unpriv = !capable(CAP_SYS_ADMIN);
 	struct bpf_array *array;
-<<<<<<< HEAD
-	u64 array_size;
-=======
 	u64 array_size, mask64;
->>>>>>> linux-next/akpm-base
 
 	/* check sanity of attributes */
 	if (attr->max_entries == 0 || attr->key_size != 4 ||
@@ -78,11 +74,6 @@ static struct bpf_map *array_map_alloc(u
 	elem_size = round_up(attr->value_size, 8);
 
 	max_entries = attr->max_entries;
-<<<<<<< HEAD
-	index_mask = roundup_pow_of_two(max_entries) - 1;
-
-	if (unpriv)
-=======
 
 	/* On 32 bit archs roundup_pow_of_two() with max_entries that has
 	 * upper most bit set in u32 space is undefined behavior due to
@@ -94,18 +85,14 @@ static struct bpf_map *array_map_alloc(u
 
 	index_mask = mask64;
 	if (unpriv) {
->>>>>>> linux-next/akpm-base
 		/* round up array size to nearest power of 2,
 		 * since cpu will speculate within index_mask limits
 		 */
 		max_entries = index_mask + 1;
-<<<<<<< HEAD
-=======
 		/* Check for overflows. */
 		if (max_entries < attr->max_entries)
 			return ERR_PTR(-E2BIG);
 	}
->>>>>>> linux-next/akpm-base
 
 	array_size = sizeof(*array);
 	if (percpu)
diff -puN kernel/bpf/verifier.c~linux-next-git-rejects kernel/bpf/verifier.c
--- a/kernel/bpf/verifier.c~linux-next-git-rejects
+++ a/kernel/bpf/verifier.c
@@ -5349,11 +5349,7 @@ static int fixup_bpf_calls(struct bpf_ve
 			 */
 			map_ptr = env->insn_aux_data[i + delta].map_ptr;
 			if (map_ptr == BPF_MAP_PTR_POISON) {
-<<<<<<< HEAD
-				verbose(env, "tail_call obusing map_ptr\n");
-=======
 				verbose(env, "tail_call abusing map_ptr\n");
->>>>>>> linux-next/akpm-base
 				return -EINVAL;
 			}
 			if (!map_ptr->unpriv_array)
diff -puN net/sctp/socket.c~linux-next-git-rejects net/sctp/socket.c
--- a/net/sctp/socket.c~linux-next-git-rejects
+++ a/net/sctp/socket.c
@@ -5085,11 +5085,7 @@ static int sctp_getsockopt_autoclose(str
 	len = sizeof(int);
 	if (put_user(len, optlen))
 		return -EFAULT;
-<<<<<<< HEAD
-	if (copy_to_user(optval, &sctp_sk(sk)->autoclose, len))
-=======
 	if (put_user(sctp_sk(sk)->autoclose, (int __user *)optval))
->>>>>>> linux-next/akpm-base
 		return -EFAULT;
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-terminate-shrink_slab-loop-if-signal-is-pending-fix.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix.patch
mm-do-not-stall-register_shrinker-fix.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
sparc64-update-pmdp_invalidate-to-return-old-pmd-value-fix.patch
x86-mm-provide-pmdp_establish-helper-fix.patch
fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix-checkpatch-fixes.patch
mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix.patch
mm-zsmalloc-simplify-shrinker-init-destroy-fix.patch
mm-fadvise-discard-partial-page-if-endbyte-is-also-eof-fix.patch
mm-migrate-remove-reason-argument-from-new_page_t-fix-fix.patch
lib-ubsanc-s-missaligned-misaligned.patch
linux-next-rejects.patch
net-ipv6-routec-work-around-gcc-444-anon-union-initializer-issue.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

