From: akpm@linux-foundation.org
Subject: [folded-dropped] pidns-limit-the-nesting-depth-of-pid-namespaces-fix.patch removed from -mm tree
Date: Thu, 25 Oct 2012 13:25:45 -0700
Message-ID: <20121025202547.3F4FE1E1A73@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:43056 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935274Ab2JYUZs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 25 Oct 2012 16:25:48 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so252152vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 25 Oct 2012 13:25:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, avagin@openvz.org, ebiederm@xmission.com, gorcunov@openvz.org, oleg@redhat.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pidns-limit-the-nesting-depth-of-pid-namespaces-fix
has been removed from the -mm tree.  Its filename was
     pidns-limit-the-nesting-depth-of-pid-namespaces-fix.patch

This patch was dropped because it was folded into pidns-limit-the-nesting-depth-of-pid-namespaces.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: pidns-limit-the-nesting-depth-of-pid-namespaces-fix

return -EINVAL in response to excessive nesting, not -ENOMEM

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Vagin <avagin@openvz.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid_namespace.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN kernel/pid_namespace.c~pidns-limit-the-nesting-depth-of-pid-namespaces-fix kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~pidns-limit-the-nesting-depth-of-pid-namespaces-fix
+++ a/kernel/pid_namespace.c
@@ -78,11 +78,15 @@ static struct pid_namespace *create_pid_
 {
 	struct pid_namespace *ns;
 	unsigned int level = parent_pid_ns->level + 1;
-	int i, err = -ENOMEM;
+	int i;
+	int err;
 
-	if (level > MAX_PID_NS_LEVEL)
+	if (level > MAX_PID_NS_LEVEL) {
+		err = -EINVAL;
 		goto out;
+	}
 
+	err = -ENOMEM;
 	ns = kmem_cache_zalloc(pid_ns_cachep, GFP_KERNEL);
 	if (ns == NULL)
 		goto out;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
pidns-limit-the-nesting-depth-of-pid-namespaces.patch
revert-tools-testing-selftests-epoll-test_epollc-fix-build.patch
revert-epoll-support-for-disabling-items-and-a-self-test-app.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
include-linux-tickh-fix-warning.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
mm.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
drivers-edac-amd64_edacc-__amd64_set_scrub_rate-avoid-overindexing-scrubrates.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
fat-exportfs-rebuild-inode-if-ilookup-fails-fix.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
selftests-ipc-message-queue-copy-feature-test-checkpatch-fixes.patch
random-make-it-possible-to-enable-debugging-without-rebuild-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

