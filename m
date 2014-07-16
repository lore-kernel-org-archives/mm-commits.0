From: akpm@linux-foundation.org
Subject: + simple_xattr-permit-0-size-extended-attributes.patch added to
 -mm tree
Date: Wed, 16 Jul 2014 13:41:34 -0700
Message-ID: <53c6e37e.9C0IyiQ5xMvrcvav%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f201.google.com ([209.85.213.201]:57815 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaGPUlf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Jul 2014 16:41:35 -0400
Received: by mail-ig0-f201.google.com with SMTP id h3so150756igd.4
        for <mm-commits@vger.kernel.org>; Wed, 16 Jul 2014 13:41:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aris@redhat.com, jlayton@poochiereds.net, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: simple_xattr: permit 0-size extended attributes
has been added to the -mm tree.  Its filename is
     simple_xattr-permit-0-size-extended-attributes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/simple_xattr-permit-0-size-extended-attributes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/simple_xattr-permit-0-size-extended-attributes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: simple_xattr: permit 0-size extended attributes

If a filesystem uses simple_xattr to support user extended attributes, LTP
setxattr01 and xfstests generic/062 fail with "Cannot allocate memory":
simple_xattr_alloc()'s wrap-around test mistakenly excludes values of zero
size.  Fix that off-by-one (but apparently no filesystem needs them yet).

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jeff Layton <jlayton@poochiereds.net>
Cc: Aristeu Rozanski <aris@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/xattr.c~simple_xattr-permit-0-size-extended-attributes fs/xattr.c
--- a/fs/xattr.c~simple_xattr-permit-0-size-extended-attributes
+++ a/fs/xattr.c
@@ -843,7 +843,7 @@ struct simple_xattr *simple_xattr_alloc(
 
 	/* wrap around? */
 	len = sizeof(*new_xattr) + size;
-	if (len <= sizeof(*new_xattr))
+	if (len < sizeof(*new_xattr))
 		return NULL;
 
 	new_xattr = kmalloc(len, GFP_KERNEL);
_

Patches currently in -mm which might be from hughd@google.com are

rmap-fix-pgoff-calculation-to-handle-hugepage-correctly.patch
mm-do-not-call-do_fault_around-for-non-linear-fault.patch
shmem-fix-faulting-into-a-hole-not-taking-i_mutex.patch
shmem-fix-splicing-from-a-hole-while-its-punched.patch
mm-fs-fix-pessimization-in-hole-punching-pagecache.patch
simple_xattr-permit-0-size-extended-attributes.patch
mm-memoryc-use-entry-=-access_oncepte-in-handle_pte_fault.patch
mm-memcontrol-fold-mem_cgroup_do_charge.patch
mm-memcontrol-rearrange-charging-fast-path.patch
mm-memcontrol-reclaim-at-least-once-for-__gfp_noretry.patch
mm-huge_memory-use-gfp_transhuge-when-charging-huge-pages.patch
mm-memcontrol-retry-reclaim-for-oom-disabled-and-__gfp_nofail-charges.patch
mm-memcontrol-remove-explicit-oom-parameter-in-charge-path.patch
mm-memcontrol-simplify-move-precharge-function.patch
mm-memcontrol-catch-root-bypass-in-move-precharge.patch
mm-memcontrol-use-root_mem_cgroup-res_counter.patch
mm-memcontrol-remove-ordering-between-pc-mem_cgroup-and-pagecgroupused.patch
mm-memcontrol-do-not-acquire-page_cgroup-lock-for-kmem-pages.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-rewrite-uncharge-api-fix-5.patch
mm-memcontrol-rewrite-charge-api-fix-shmem_unuse.patch
mm-memcontrol-rewrite-charge-api-fix-shmem_unuse-fix.patch
mm-memcontrol-rewrite-uncharge-api-fix-uncharge-from-irq-context.patch
mm-memcontrol-rewrite-uncharge-api-fix-double-migration.patch
mm-memcontrol-use-page-lists-for-uncharge-batching.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
include-linux-mmdebugh-add-vm_warn_once.patch
shmem-fix-double-uncharge-in-__shmem_file_setup.patch
shmem-update-memory-reservation-on-truncate.patch
mm-catch-memory-commitment-underflow.patch
mm-catch-memory-commitment-underflow-fix.patch
mm-export-nr_shmem-via-sysinfo2-si_meminfo-interfaces.patch
mm-replace-init_page_accessed-by-__setpagereferenced.patch
mm-zbud-zbud_alloc-minor-param-change.patch
mm-zbud-change-zbud_alloc-size-type-to-size_t.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc.patch
mm-zpool-zbud-zsmalloc-implement-zpool.patch
mm-zpool-update-zswap-to-use-zpool.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used.patch
list-use-argument-hlist_add_after-names-from-rcu-variant.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu.patch
klist-use-same-naming-scheme-as-hlist-for-klist_add_after.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

