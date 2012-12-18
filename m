From: akpm@linux-foundation.org
Subject: [folded-dropped] core_pattern-set-core-helpers-root-and-namespace-to-crashing-process-fix.patch removed from -mm tree
Date: Tue, 18 Dec 2012 14:06:26 -0800
Message-ID: <20121218220626.B4D5B82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:46366 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab2LRWG1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 17:06:27 -0500
Received: by mail-yh0-f74.google.com with SMTP id 10so143791yhl.3
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 14:06:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, berrange@redhat.com, ebiederm@xmission.com, nhorman@tuxdriver.com, serge.hallyn@canonical.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: core_pattern-set-core-helpers-root-and-namespace-to-crashing-process-fix
has been removed from the -mm tree.  Its filename was
     core_pattern-set-core-helpers-root-and-namespace-to-crashing-process-fix.patch

This patch was dropped because it was folded into core_pattern-set-core-helpers-root-and-namespace-to-crashing-process.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: core_pattern-set-core-helpers-root-and-namespace-to-crashing-process-fix

fix doc typo, simplify format_corename()

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Daniel Berrange <berrange@redhat.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |    2 +-
 fs/coredump.c                   |   10 ++++------
 2 files changed, 5 insertions(+), 7 deletions(-)

diff -puN Documentation/sysctl/kernel.txt~core_pattern-set-core-helpers-root-and-namespace-to-crashing-process-fix Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~core_pattern-set-core-helpers-root-and-namespace-to-crashing-process-fix
+++ a/Documentation/sysctl/kernel.txt
@@ -194,7 +194,7 @@ core_pattern is used to specify a core d
   written to the standard input of that program instead of to a file.  Note that
   when using |, the core pipe reader that is executed will be run in the global
   namespace and root filesystem.  If two | tokens (i.e. ||) are supplied as the
-  first two characters of the core_pattern sysctl, the kernel will preform the
+  first two characters of the core_pattern sysctl, the kernel will perform the
   same pipe operation, but the core pipe reader will be executed using the
   namespace and root fs of the crashing process.
 
diff -puN fs/coredump.c~core_pattern-set-core-helpers-root-and-namespace-to-crashing-process-fix fs/coredump.c
--- a/fs/coredump.c~core_pattern-set-core-helpers-root-and-namespace-to-crashing-process-fix
+++ a/fs/coredump.c
@@ -164,16 +164,14 @@ static int format_corename(struct core_n
 	if (!cn->corename)
 		return -ENOMEM;
 
-	if (ispipe) {
+	if (ispipe && pat_ptr[1] == '|') {
 		/*
- 		 * If we have 2 | tokens at the head of core_pattern, it
+ 		 * We have 2 | tokens at the head of core_pattern which
  		 * indicates we are a pipe and the reader should inherit the
  		 * namespaces of the crashing process
  		 */
-		cprm->switch_ns = (*(pat_ptr+1) == '|') ? true : false;
-		if (cprm->switch_ns)
-			/* Advance pat_ptr so as not to mess up corename */
-			pat_ptr++;
+		cprm->switch_ns = true;
+		pat_ptr++;
 	}
 
 	/* Repeat as long as we have more pattern to process and more output
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
irq-tsk-comm-is-an-array.patch
memory-hotplug-document-and-enable-config_movable_node-fix.patch
memcg-kmem-accounting-basic-infrastructure-fix.patch
slub-slub-specific-propagation-changes-fix.patch
mm-mprotectc-coding-style-cleanups.patch
mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix.patch
mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix-2.patch
mm-avoid-possible-deadlock-caused-by-too_many_isolated-fix.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
make-my-i386-build-work.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
sgi-xp-handle-non-fatal-traps-fix.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
block-remove-deadlock-in-disk_clear_events.patch
block-prevent-race-cleanup.patch
mm.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes-checkpatch-fixes.patch
hfsplus-rework-processing-of-hfs_btree_write-returned-error-fix.patch
core_pattern-set-core-helpers-root-and-namespace-to-crashing-process.patch
core_pattern-set-core-helpers-root-and-namespace-to-crashing-process-fix-checkpatch-fixes.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
ipc-convert-prepare_copy-from-macro-to-function-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
fs-notify-add-procfs-fdinfo-helper-v7-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

