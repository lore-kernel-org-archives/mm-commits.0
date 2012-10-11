From: akpm@linux-foundation.org
Subject: + pidns-remove-recursion-from-free_pid_ns-v5-fix.patch added to -mm tree
Date: Thu, 11 Oct 2012 15:14:32 -0700
Message-ID: <20121011230325.3FB6520004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:64583 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932327Ab2JKXD2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Oct 2012 19:03:28 -0400
Received: by mail-lb0-f202.google.com with SMTP id l12so147331lbo.1
        for <mm-commits@vger.kernel.org>; Thu, 11 Oct 2012 16:03:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, avagin@openvz.org, ebiederm@xmission.com, gorcunov@openvz.org, greg@kroah.com, oleg@redhat.com, xemul@parallels.com


The patch titled
     Subject: pidns-remove-recursion-from-free_pid_ns-v5-fix
has been added to the -mm tree.  Its filename is
     pidns-remove-recursion-from-free_pid_ns-v5-fix.patch

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

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
pidns-remove-recursion-from-free_pid_ns-v5-fix.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
mm.patch
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

