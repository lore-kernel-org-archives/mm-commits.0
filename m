From: akpm@linux-foundation.org
Subject: - frv-make-nommu-mode-work-with-base-addresses-other-than-0xc0000000.patch removed from -mm tree
Date: Sat, 12 Apr 2008 19:39:27 -0700
Message-ID: <200804130239.m3D2dR5j032389@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56871 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755303AbYDMCjz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 Apr 2008 22:39:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     frv: make NOMMU-mode work with base addresses other than 0xC0000000
has been removed from the -mm tree.  Its filename was
     frv-make-nommu-mode-work-with-base-addresses-other-than-0xc0000000.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: frv: make NOMMU-mode work with base addresses other than 0xC0000000
From: David Howells <dhowells@redhat.com>

Make NOMMU-mode work with base addresses other than 0xC0000000 by:

 (1) Giving the code that sets up the protection registers the right address
     in __sdram_base.  Rather than being hard coded to 0xC0000000, the value
     of __page_offset is obtained from the linker script.

 (2) Eliminate the check in __switch_to() that verifies the current thread
     info is in the 0xCxxxxxxx region.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/kernel/head.inc    |    2 +-
 arch/frv/kernel/switch_to.S |    7 -------
 2 files changed, 1 insertion(+), 8 deletions(-)

diff -puN arch/frv/kernel/head.inc~frv-make-nommu-mode-work-with-base-addresses-other-than-0xc0000000 arch/frv/kernel/head.inc
--- a/arch/frv/kernel/head.inc~frv-make-nommu-mode-work-with-base-addresses-other-than-0xc0000000
+++ a/arch/frv/kernel/head.inc
@@ -46,5 +46,5 @@
 #ifdef CONFIG_MMU
 __sdram_base = 0x00000000		/* base address to which SDRAM relocated */
 #else
-__sdram_base = 0xc0000000		/* base address to which SDRAM relocated */
+__sdram_base = __page_offset		/* base address to which SDRAM relocated */
 #endif
diff -puN arch/frv/kernel/switch_to.S~frv-make-nommu-mode-work-with-base-addresses-other-than-0xc0000000 arch/frv/kernel/switch_to.S
--- a/arch/frv/kernel/switch_to.S~frv-make-nommu-mode-work-with-base-addresses-other-than-0xc0000000
+++ a/arch/frv/kernel/switch_to.S
@@ -102,13 +102,6 @@ __switch_to:
 	movgs		gr14,lr
 	bar
 
-	srli		gr15,#28,gr5
-	subicc		gr5,#0xc,gr0,icc0
-	beq		icc0,#0,111f
-	break
-	nop
-111:
-
 	# jump to __switch_back or ret_from_fork as appropriate
 	# - move prev to GR8
 	movgs		gr4,psr
_

Patches currently in -mm which might be from dhowells@redhat.com are

git-unionfs.patch
remove-the-macro-get_personality.patch
xattr-add-missing-consts-to-function-arguments.patch
keys-increase-the-payload-size-when-instantiating-a-key.patch
keys-check-starting-keyring-as-part-of-search.patch
keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string.patch
keys-add-keyctl-function-to-get-a-security-label.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
keys-switch-to-proc_create.patch
keys-allow-clients-to-set-key-perms-in-key_create_or_update.patch
keys-dont-generate-user-and-user-session-keyrings-unless-theyre-accessed.patch
keys-make-the-keyring-quotas-controllable-through-proc-sys.patch
keys-make-the-keyring-quotas-controllable-through-proc-sys-fix.patch
keys-explicitly-include-required-slabh-header-file.patch
keys-make-key_serial-a-function-if-config_keys=y.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
alloc_uid-cleanup.patch
rename-div64_64-to-div64_u64.patch
afs-use-the-shorter-list_head-for-brevity.patch
afs-the-afs-rpc-op-cbgetcapabilities-is-actually-cbtellmeaboutyourself.patch
afs-the-afs-rpc-op-cbgetcapabilities-is-actually-cbtellmeaboutyourself-try-3.patch
mutex-subsystem-synchro-test-module.patch

