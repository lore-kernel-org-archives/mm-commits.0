From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Thu, 01 Jun 2017 12:42:09 -0700
Message-ID: <20170601194209.CBqpWnglw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47428 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751097AbdFATmK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2017 15:42:10 -0400
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


diff -puN drivers/gpu/drm/i915/i915_gem_shrinker.c~linux-next-git-rejects drivers/gpu/drm/i915/i915_gem_shrinker.c
--- a/drivers/gpu/drm/i915/i915_gem_shrinker.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/i915_gem_shrinker.c
@@ -58,11 +58,7 @@ static void shrinker_unlock(struct drm_i
 	if (!unlock)
 		return;
 
-<<<<<<< HEAD
-	mutex_unlock(&dev->struct_mutex);
-=======
 	mutex_unlock(&dev_priv->drm.struct_mutex);
->>>>>>> linux-next/akpm-base
 }
 
 static bool any_vma_pinned(struct drm_i915_gem_object *obj)
diff -puN drivers/target/target_core_transport.c~linux-next-git-rejects drivers/target/target_core_transport.c
--- a/drivers/target/target_core_transport.c~linux-next-git-rejects
+++ a/drivers/target/target_core_transport.c
@@ -1166,14 +1166,6 @@ target_cmd_size_check(struct se_cmd *cmd
 				cmd->data_length, size, cmd->t_task_cdb[0]);
 
 		if (cmd->data_direction == DMA_TO_DEVICE) {
-<<<<<<< HEAD
-			if (cmd->se_cmd_flags & SCF_SCSI_DATA_CDB) {
-				pr_err_ratelimited("Rejecting underflow/overflow"
-						   " for WRITE data CDB\n");
-				return TCM_INVALID_CDB_FIELD;
-			}
-=======
->>>>>>> linux-next/akpm-base
 			/*
 			 * Some fabric drivers like iscsi-target still expect to
 			 * always reject overflow writes.  Reject this case until
@@ -1185,20 +1177,6 @@ target_cmd_size_check(struct se_cmd *cmd
 						   " WRITE control CDB\n");
 				return TCM_INVALID_CDB_FIELD;
 			}
-<<<<<<< HEAD
-		}
-		/*
-		 * Reject READ_* or WRITE_* with overflow/underflow for
-		 * type SCF_SCSI_DATA_CDB.
-		 */
-		if (dev->dev_attrib.block_size != 512)  {
-			pr_err("Failing OVERFLOW/UNDERFLOW for LBA op"
-				" CDB on non 512-byte sector setup subsystem"
-				" plugin: %s\n", dev->transport->name);
-			/* Returns CHECK_CONDITION + INVALID_CDB_FIELD */
-			return TCM_INVALID_CDB_FIELD;
-=======
->>>>>>> linux-next/akpm-base
 		}
 		/*
 		 * For the overflow case keep the existing fabric provided
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock-checkpatch-fixes.patch
mm-migrate-fix-ref-count-handling-when-hugepage_migration_supported-v2-fix.patch
mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix.patch
swap-add-block-io-poll-in-swapin-path-checkpatch-fixes.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix-fix.patch
mm-swap-sort-swap-entries-before-free-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

