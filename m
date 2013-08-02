From: akpm@linux-foundation.org
Subject: + revert-selinux-do-not-handle-seclabel-as-a-special-flag.patch
 added to -mm tree
Date: Fri, 02 Aug 2013 16:09:20 -0700
Message-ID: <51fc3c20.RjsA+xyDacJ/QEOP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46560 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407Ab3HBXJV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Aug 2013 19:09:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, peter@hurleysoftware.com, greg@kroah.com, eparis@redhat.com, akpm@linux-foundation.org

Subject: + revert-selinux-do-not-handle-seclabel-as-a-special-flag.patch added to -mm tree
To: akpm@linux-foundation.org,eparis@redhat.com,greg@kroah.com,peter@hurleysoftware.com
From: akpm@linux-foundation.org
Date: Fri, 02 Aug 2013 16:09:20 -0700


The patch titled
     Subject: revert "SELinux: do not handle seclabel as a special flag"
has been added to the -mm tree.  Its filename is
     revert-selinux-do-not-handle-seclabel-as-a-special-flag.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/revert-selinux-do-not-handle-seclabel-as-a-special-flag.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/revert-selinux-do-not-handle-seclabel-as-a-special-flag.patch

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
Subject: revert "SELinux: do not handle seclabel as a special flag"

It breaks my FC6 test box.  /dev/pts is not mounted.  dmesg says

SELinux: mount invalid.  Same superblock, different security settings for (dev devpts, type devpts)

Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg KH <greg@kroah.com>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/selinux/hooks.c            |    3 +++
 security/selinux/include/security.h |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN security/selinux/hooks.c~revert-selinux-do-not-handle-seclabel-as-a-special-flag security/selinux/hooks.c
--- a/security/selinux/hooks.c~revert-selinux-do-not-handle-seclabel-as-a-special-flag
+++ a/security/selinux/hooks.c
@@ -502,6 +502,9 @@ static int selinux_get_mnt_opts(const st
 			opts->num_mnt_opts++;
 		tmp >>= 1;
 	}
+	/* Check if the Label support flag is set */
+	if (sbsec->flags & SBLABEL_MNT)
+		opts->num_mnt_opts++;
 
 	opts->mnt_opts = kcalloc(opts->num_mnt_opts, sizeof(char *), GFP_ATOMIC);
 	if (!opts->mnt_opts) {
diff -puN security/selinux/include/security.h~revert-selinux-do-not-handle-seclabel-as-a-special-flag security/selinux/include/security.h
--- a/security/selinux/include/security.h~revert-selinux-do-not-handle-seclabel-as-a-special-flag
+++ a/security/selinux/include/security.h
@@ -43,7 +43,7 @@
 #endif
 
 /* Mask for just the mount related flags */
-#define SE_MNTMASK	0x1f
+#define SE_MNTMASK	0x0f
 /* Super block security struct flags for mount options */
 /* BE CAREFUL, these need to be the low order bits for selinux_get_mnt_opts */
 #define CONTEXT_MNT	0x01
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page.patch
arch-x86-platform-ce4100-ce4100c-include-rebooth.patch
vmpressure-make-sure-there-are-no-events-queued-after-memcg-is-offlined.patch
revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm.patch
swap-warn-when-a-swap-area-overflows-the-maximum-size-fix.patch
mm-swapfilec-convert-to-pr_foo.patch
mm-vmstats-track-tlb-flush-stats-on-up-too-fix.patch
swap-make-swap-discard-async-checkpatch-fixes.patch
swap-make-cluster-allocation-per-cpu-checkpatch-fixes.patch
mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix.patch
memcg-trivial-cleanups.patch
lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
linux-next.patch
revert-selinux-do-not-handle-seclabel-as-a-special-flag.patch
shrinker-convert-superblock-shrinkers-to-new-api-fix.patch
xfs-convert-buftarg-lru-to-generic-code-fix.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
shrinker-kill-old-shrink-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

