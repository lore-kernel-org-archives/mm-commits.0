From: akpm@linux-foundation.org
Subject: - frv-correctly-determine-the-address-of-an-illegal-instruction.patch removed from -mm tree
Date: Tue, 15 Apr 2008 02:10:14 -0700
Message-ID: <200804150910.m3F9AE3g020601@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57598 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756080AbYDOJLK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 05:11:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     frv: correctly determine the address of an illegal instruction
has been removed from the -mm tree.  Its filename was
     frv-correctly-determine-the-address-of-an-illegal-instruction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: frv: correctly determine the address of an illegal instruction
From: David Howells <dhowells@redhat.com>

Correctly determine the address of an illegal instruction.  The EPCR0 register
holds this value (masked by EPCR0_PC) if the validity bit is set (masked by
EPCR0_V).  So the test as to whether the contents of the register are usable
should be involve checking the _V bit, not the _PC bits.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/kernel/traps.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/frv/kernel/traps.c~frv-correctly-determine-the-address-of-an-illegal-instruction arch/frv/kernel/traps.c
--- a/arch/frv/kernel/traps.c~frv-correctly-determine-the-address-of-an-illegal-instruction
+++ a/arch/frv/kernel/traps.c
@@ -73,7 +73,7 @@ asmlinkage void illegal_instruction(unsi
 		      epcr0, esr0, esfr1);
 
 	info.si_errno	= 0;
-	info.si_addr	= (void *) ((epcr0 & EPCR0_PC) ? (epcr0 & EPCR0_PC) : __frame->pc);
+	info.si_addr	= (void *) ((epcr0 & EPCR0_V) ? (epcr0 & EPCR0_PC) : __frame->pc);
 
 	switch (__frame->tbr & TBR_TT) {
 	case TBR_TT_ILLEGAL_INSTR:
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
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

