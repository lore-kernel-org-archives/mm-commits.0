From: akpm@linux-foundation.org
Subject: - tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up.patch removed from -mm tree
Date: Mon, 30 Apr 2007 12:58:27 -0700
Message-ID: <200704301958.l3UJwRTI013540@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51834 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031582AbXD3T6e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 15:58:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, alan@lxorguk.ukuu.org.uk, hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     tty: in tiocsctty when we steal a tty hang it up.
has been removed from the -mm tree.  Its filename was
     tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: tty: in tiocsctty when we steal a tty hang it up.
From: Eric W. Biederman <ebiederm@xmission.com>

The linux implementation of TIOCSCTTY includes an extention that provides for
making a tty that is already the controlling tty of another session our
controlling tty.  To do this it must steal the tty away from the previous
group that used it as a controlling tty.

The way we are currently stealing the controlling tty away is weird.  In
general there is a well defined process for loosing the controlling tty.  TTY
hangup processing.  However the linux extension that steals the tty from
another process group does not invoke that.  And instead just forgets the
controlling tty of the processes that were part of the session.

I can not imagine how our current behaviour of stealling a tty is correct or
how a set of processes could deal with it reasonably.  So this patch modifies
the tty stealing to call tty_vhangup so we get full hanup processing when we
steal a tty.

I did a quick survey of user space the only application I found using this
extended behaviour is sysvinit.  I perform a limited amount of testing and
nothing appears to have broken with this change.  And I did see sysvinit pass
through this piece of code.

In terms of the tty leaks that started this patch series this fix should
remove the last path into proc_clear_tty that has a session or a process
group.

[hugh@veritas.com: init hangs on tty_mutex]
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 char/tty_io.c |    0 
 1 files changed

diff -puN drivers/char/tty_io.c~tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up drivers/char/tty_io.c
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
arm-ecard-convert-to-use-the-kthread-api.patch
iop13xx-msi-support-rev6.patch
macintosh-mediabay-convert-to-kthread-api.patch
macintosh-adb-convert-to-the-kthread-api.patch
macintosh-therm_pm72c-partially-convert-to-kthread-api.patch
powerpc-pseries-rtasd-convert-to-kthread-api.patch
powerpc-pseries-eeh-convert-to-kthread-api.patch
dvb_en_50221-convert-to-kthread-api.patch
mm-only-saa7134-tvaudio-convert-to-kthread-api.patch
ia64-sn-xpc-convert-to-use-kthread-api.patch
ia64-sn-xpc-convert-to-use-kthread-api-fix.patch
ia64-sn-xpc-convert-to-use-kthread-api-fix-2.patch
fix-i-oat-for-kexec.patch
cpqphp-partially-convert-to-use-the-kthread-api.patch
ibmphp-partially-convert-to-use-the-kthreads-api.patch
cpci_hotplug-partially-convert-to-use-the-kthread-api.patch
msi-fix-arm-compile.patch
s390-scsi-zfcp_erp-partially-convert-to-use-the-kthread-api.patch
s390-qeth-convert-to-use-the-kthread-api.patch
s390-net-lcs-convert-to-the-kthread-api.patch
sas_scsi_host-partially-convert-to-use-the-kthread-api.patch
sparc64-powerc-convert-to-use-the-kthread-api.patch
i386-irq-kill-irq-compression.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
i386-efi-fix-proc-iomem-type-for-kexec-tools.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
allow-access-to-proc-pid-fd-after-setuid.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
fix-race-between-proc_get_inode-and-remove_proc_entry.patch
fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-reorder-struct-pid_dentry-to-save-space-on-64bit-archs-and-constify-them.patch
tty-remove-unnecessary-export-of-proc_clear_tty.patch
tty-simplify-calling-of-put_pid.patch
tty-introduce-no_tty-and-use-it-in-selinux.patch
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
use-the-apic-to-determine-the-hardware-processor-id-i386.patch
use-the-apic-to-determine-the-hardware-processor-id-x86_64.patch
always-ask-the-hardware-to-obtain-hardware-processor-id-ia64.patch
proc-cleanup-use-seq_release_private-where-appropriate.patch
smbfs-remove-unnecessary-allow_signal.patch
pnpbios-conert-to-use-the-kthread-api.patch
kthread-dont-depend-on-work-queues-take-2.patch
kthread-dont-depend-on-work-queues-take-2-fix.patch
change-reparent_to_init-to-reparent_to_kthreadd.patch
wait_for_helper-remove-unneeded-do_sigaction.patch
worker_thread-dont-play-with-sigchld-and-numa-policy.patch
change-kernel-threads-to-ignore-signals-instead-of-blocking-them.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
fix-kthread_create-vs-freezer-theoretical-race-dont-be-obnoxious.patch
remvoe-kthread_bind-call-from-_cpu_down.patch
nfsd-nfs4state-remove-unnecessary-daemonize-call.patch
statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-and-sid-of-init-process.patch
use-struct-pid-parameter-in-copy_process.patch
use-task_pgrp-task_session-in-copy_process.patch
kill-unused-sesssion-and-group-values-in-rocket-driver.patch
fix-some-coding-style-errors-in-autofs.patch
replace-pid_t-in-autofs-with-struct-pid-reference.patch
dont-init-pgrp-and-__session-in-init_signals.patch
md-remove-broken-sigkill-support.patch
mutex-subsystem-synchro-test-module-convert-to-the-kthread-api.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
