From: akpm@linux-foundation.org
Subject: + pidns-limit-the-nesting-depth-of-pid-namespaces-fix.patch added to -mm tree
Date: Tue, 23 Oct 2012 16:57:05 -0700
Message-ID: <20121023235706.233AB1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:59883 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934107Ab2JWX5H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 19:57:07 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so557691ggm.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 16:57:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, avagin@openvz.org, ebiederm@xmission.com, gorcunov@openvz.org, oleg@redhat.com, xemul@parallels.com


The patch titled
     Subject: pidns-limit-the-nesting-depth-of-pid-namespaces-fix
has been added to the -mm tree.  Its filename is
     pidns-limit-the-nesting-depth-of-pid-namespaces-fix.patch

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

pidns-limit-the-nesting-depth-of-pid-namespaces-fix.patch
revert-tools-testing-selftests-epoll-test_epollc-fix-build.patch
revert-epoll-support-for-disabling-items-and-a-self-test-app.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
mm.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
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
procfs-add-vmflags-field-in-smaps-output-v3-fix.patch
random-fix-debug-format-strings-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

