From: akpm@linux-foundation.org
Subject: + fs-use-mapping_set_error-instead-of-opencoded-set_bit-fix.patch added to -mm tree
Date: Mon, 12 Sep 2016 15:18:39 -0700
Message-ID: <57d729bf.sJH9WWPOXiMTnzgG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51223 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756044AbcILWSp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2016 18:18:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-use-mapping_set_error-instead-of-opencoded-set_bit-fix
has been added to the -mm tree.  Its filename is
     fs-use-mapping_set_error-instead-of-opencoded-set_bit-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-use-mapping_set_error-instead-of-opencoded-set_bit-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-use-mapping_set_error-instead-of-opencoded-set_bit-fix.patch

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
Subject: fs-use-mapping_set_error-instead-of-opencoded-set_bit-fix

Be honest about afs_write_back_from_locked_page()'s conversion from -ENXIO
to -EIO.

Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/write.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/afs/write.c~fs-use-mapping_set_error-instead-of-opencoded-set_bit-fix fs/afs/write.c
--- a/fs/afs/write.c~fs-use-mapping_set_error-instead-of-opencoded-set_bit-fix
+++ a/fs/afs/write.c
@@ -408,7 +408,7 @@ no_more:
 		case -ENOMEDIUM:
 		case -ENXIO:
 			afs_kill_pages(wb->vnode, true, first, last);
-			mapping_set_error(wb->vnode->vfs_inode.i_mapping, -ENXIO);
+			mapping_set_error(wb->vnode->vfs_inode.i_mapping, -EIO);
 			break;
 		case -EACCES:
 		case -EPERM:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
drivers-rapidio-rio_cmc-avoid-gfp_kernel-in-atomic-context.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-vmalloc-fix-align-value-calculation-error-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix.patch
mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions-checkpatch-fixes.patch
mm-swap-add-swap_cluster_list-checkpatch-fixes.patch
mm-mlock-check-against-vma-for-actual-mlock-size-fix.patch
mm-page_ioc-replace-some-bug_ons-with-vm_bug_on_page.patch
fs-use-mapping_set_error-instead-of-opencoded-set_bit-fix.patch
mm-check-that-we-havent-used-more-than-32-bits-in-address_spaceflags.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch
relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-checkpatch-fixes.patch
ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-mlx5-deviceh-kill-build_bug_ons.patch
hung_task-allow-hung_task_panic-when-hung_task_warnings-is-0-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

