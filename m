From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Thu, 09 Nov 2017 11:50:52 -0800
Message-ID: <20171109195052.-Ikn93Lgn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60312 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751225AbdKITuz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Nov 2017 14:50:55 -0500
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


diff -puN net/sched/cls_u32.c~linux-next-git-rejects net/sched/cls_u32.c
--- a/net/sched/cls_u32.c~linux-next-git-rejects
+++ a/net/sched/cls_u32.c
@@ -591,15 +591,8 @@ static void u32_clear_hnode(struct tcf_p
 					 rtnl_dereference(n->next));
 			tcf_unbind_filter(tp, &n->res);
 			u32_remove_hw_knode(tp, n->handle);
-<<<<<<< HEAD
-			if (tcf_exts_get_net(&n->exts))
-				call_rcu(&n->rcu, u32_delete_key_freepf_rcu);
-			else
-				u32_destroy_key(n->tp, n, true);
-=======
 			idr_remove_ext(&ht->handle_idr, n->handle);
 			call_rcu(&n->rcu, u32_delete_key_freepf_rcu);
->>>>>>> linux-next/akpm-base
 		}
 	}
 }
diff -puN net/sched/cls_basic.c~linux-next-git-rejects net/sched/cls_basic.c
--- a/net/sched/cls_basic.c~linux-next-git-rejects
+++ a/net/sched/cls_basic.c
@@ -120,15 +120,8 @@ static void basic_destroy(struct tcf_pro
 	list_for_each_entry_safe(f, n, &head->flist, link) {
 		list_del_rcu(&f->link);
 		tcf_unbind_filter(tp, &f->res);
-<<<<<<< HEAD
-		if (tcf_exts_get_net(&f->exts))
-			call_rcu(&f->rcu, basic_delete_filter);
-		else
-			__basic_delete_filter(f);
-=======
 		idr_remove_ext(&head->handle_idr, f->handle);
 		call_rcu(&f->rcu, basic_delete_filter);
->>>>>>> linux-next/akpm-base
 	}
 	idr_destroy(&head->handle_idr);
 	kfree_rcu(head, rcu);
@@ -141,11 +134,7 @@ static int basic_delete(struct tcf_proto
 
 	list_del_rcu(&f->link);
 	tcf_unbind_filter(tp, &f->res);
-<<<<<<< HEAD
-	tcf_exts_get_net(&f->exts);
-=======
 	idr_remove_ext(&head->handle_idr, f->handle);
->>>>>>> linux-next/akpm-base
 	call_rcu(&f->rcu, basic_delete_filter);
 	*last = list_empty(&head->flist);
 	return 0;
diff -puN arch/x86/mm/mem_encrypt.c~linux-next-git-rejects arch/x86/mm/mem_encrypt.c
--- a/arch/x86/mm/mem_encrypt.c~linux-next-git-rejects
+++ a/arch/x86/mm/mem_encrypt.c
@@ -42,15 +42,11 @@ static char sme_cmdline_off[] __initdata
  * section is later cleared.
  */
 u64 sme_me_mask __section(.data) = 0;
-<<<<<<< HEAD
-EXPORT_SYMBOL(sme_me_mask);
-=======
 EXPORT_SYMBOL_GPL(sme_me_mask);
 DEFINE_STATIC_KEY_FALSE(sev_enable_key);
 EXPORT_SYMBOL_GPL(sev_enable_key);
 
 static bool sev_enabled __section(.data);
->>>>>>> linux-next/akpm-base
 
 /* Buffer used for early in-place encryption by BSP, no locking needed */
 static char sme_early_buffer[PAGE_SIZE] __aligned(PAGE_SIZE);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
maintainers-update-tpm-driver-infrastructure-changes-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
slab-slub-slob-convert-slab_flags_t-to-32-bit-fix.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference-checkpatch-fixes.patch
mm-drop-migrate-type-checks-from-has_unmovable_pages-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch
f2fs-simplify-page-iteration-loops-fix.patch
mm-consolidate-page-table-accounting-fix-fix.patch
mm-stop-zeroing-memory-during-allocation-in-vmemmap-fix.patch
mm-batch-radix-tree-operations-when-truncating-pages-fix-fix.patch
support-resetting-warn_once-checkpatch-fixes.patch
support-resetting-warn_once-for-all-architectures-v2-fix.patch
support-resetting-warn_once-for-all-architectures-v2-fix-fix.patch
support-resetting-warn_once-for-all-architectures-v2-fix-fix-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
watchdog-core-make-use-of-devm_register_reboot_notifier-fix.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

