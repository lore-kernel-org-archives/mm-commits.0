From: akpm@linux-foundation.org
Subject: - sysctl-fix-the-selinux_sysctl_get_sid.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:50:51 -0800
Message-ID: <200702150850.l1F8opqM025257@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40242 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965516AbXBOIuy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:50:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, sds@tycho.nsa.gov, mm-commits@vger.kernel.org


The patch titled
     sysctl: fix the selinux_sysctl_get_sid
has been removed from the -mm tree.  Its filename was
     sysctl-fix-the-selinux_sysctl_get_sid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: fix the selinux_sysctl_get_sid
From: Eric W. Biederman <ebiederm@xmission.com>

I goofed and when reenabling the fine grained selinux labels for
sysctls and forgot to add the "/sys" prefix before consulting
the policy database.  When computing the same path using
proc_dir_entries we got the "/sys" for free as it was part
of the tree, but it isn't true for clt_table trees.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/selinux/hooks.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN security/selinux/hooks.c~sysctl-fix-the-selinux_sysctl_get_sid security/selinux/hooks.c
--- a/security/selinux/hooks.c~sysctl-fix-the-selinux_sysctl_get_sid
+++ a/security/selinux/hooks.c
@@ -1451,6 +1451,12 @@ static int selinux_sysctl_get_sid(ctl_ta
 		path = end;
 		table = table->parent;
 	}
+	buflen -= 4;
+	if (buflen < 0)
+		goto out_free;
+	end -= 4;
+	memcpy(end, "/sys", 4);
+	path = end;
 	rc = security_genfs_sid("proc", path, tclass, sid);
 out_free:
 	free_page((unsigned long)buffer);
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
powerpc-rtas-msi-support.patch
fix-i-oat-for-kexec.patch
git-v9fs.patch
x86_64-irq-simplfy-__assign_irq_vector.patch
x86_64-irq-handle-irqs-pending-in-irr-during-irq-migration.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
allow-access-to-proc-pid-fd-after-setuid-update-2.patch
shm-make-sysv-ipc-shared-memory-use-stacked-files.patch
i386-apic-clean-up-the-apic-code.patch
i386-rework-local-apic-timer-calibration.patch
i386-prepare-nmi-watchdog-for-dynticks.patch
edac-k8-driver-coding-tidy.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
sysctl-remove-insert_at_head-from-register_sysctl-fix.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
