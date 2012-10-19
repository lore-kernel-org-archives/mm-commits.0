From: akpm@linux-foundation.org
Subject: [folded-dropped] pidns-remove-recursion-from-free_pid_ns-v5-fix.patch removed from -mm tree
Date: Fri, 19 Oct 2012 13:54:44 -0700
Message-ID: <20121019205444.9ADDE100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:34201 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab2JSUyq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Oct 2012 16:54:46 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so102765yhl.1
        for <mm-commits@vger.kernel.org>; Fri, 19 Oct 2012 13:54:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, avagin@openvz.org, ebiederm@xmission.com, gorcunov@openvz.org, greg@kroah.com, oleg@redhat.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pidns-remove-recursion-from-free_pid_ns-v5-fix
has been removed from the -mm tree.  Its filename was
     pidns-remove-recursion-from-free_pid_ns-v5-fix.patch

This patch was dropped because it was folded into pidns-remove-recursion-from-free_pid_ns-v5.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: pidns-remove-recursion-from-free_pid_ns-v5-fix

export put_pid_ns() to modules

i386 allmodconfig:
ERROR: "put_pid_ns" [net/ipv6/ipv6.ko] undefined!

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Vagin <avagin@openvz.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Greg KH <greg@kroah.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid_namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/pid_namespace.c~pidns-remove-recursion-from-free_pid_ns-v5-fix kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~pidns-remove-recursion-from-free_pid_ns-v5-fix
+++ a/kernel/pid_namespace.c
@@ -152,7 +152,7 @@ void put_pid_ns(struct pid_namespace *ns
 		ns = parent;
 	}
 }
-EXPORT_SYMBOL_GPL(free_pid_ns);
+EXPORT_SYMBOL_GPL(put_pid_ns);
 
 void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

pidns-remove-recursion-from-free_pid_ns-v5.patch
revert-epoll-support-for-disabling-items-and-a-self-test-app.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
mm.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
fat-exportfs-rebuild-inode-if-ilookup-fails-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

