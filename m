From: akpm@linux-foundation.org
Subject: - frv-handle-update_mmu_cache-being-called-when-current-mm-is-null.patch removed from -mm tree
Date: Sat, 12 Apr 2008 19:39:20 -0700
Message-ID: <200804130239.m3D2dKEx032378@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58324 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753873AbYDMCjj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 Apr 2008 22:39:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     frv: handle update_mmu_cache() being called when current->mm is NULL
has been removed from the -mm tree.  Its filename was
     frv-handle-update_mmu_cache-being-called-when-current-mm-is-null.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: frv: handle update_mmu_cache() being called when current->mm is NULL
From: David Howells <dhowells@redhat.com>

Handle update_mmu_cache() being called when current->mm is NULL.

We cache static TLB mappings for the current page table in DAMPR4 and DAMPR5
on the theory that the next data lookup is likely to be in the same general
region, and thus is likely to be mapped by the same page table.  However, we
can't get this information if we can't access the appropriate mm_struct.

If current->mm is NULL, we just clear the cache in the knowledge that the TLB
miss handlers will load it.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-frv/pgtable.h |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff -puN include/asm-frv/pgtable.h~frv-handle-update_mmu_cache-being-called-when-current-mm-is-null include/asm-frv/pgtable.h
--- a/include/asm-frv/pgtable.h~frv-handle-update_mmu_cache-being-called-when-current-mm-is-null
+++ a/include/asm-frv/pgtable.h
@@ -507,13 +507,22 @@ static inline int pte_file(pte_t pte)
  */
 static inline void update_mmu_cache(struct vm_area_struct *vma, unsigned long address, pte_t pte)
 {
+	struct mm_struct *mm;
 	unsigned long ampr;
-	pgd_t *pge = pgd_offset(current->mm, address);
-	pud_t *pue = pud_offset(pge, address);
-	pmd_t *pme = pmd_offset(pue, address);
 
-	ampr = pme->ste[0] & 0xffffff00;
-	ampr |= xAMPRx_L | xAMPRx_SS_16Kb | xAMPRx_S | xAMPRx_C | xAMPRx_V;
+	mm = current->mm;
+	if (mm) {
+		pgd_t *pge = pgd_offset(mm, address);
+		pud_t *pue = pud_offset(pge, address);
+		pmd_t *pme = pmd_offset(pue, address);
+
+		ampr = pme->ste[0] & 0xffffff00;
+		ampr |= xAMPRx_L | xAMPRx_SS_16Kb | xAMPRx_S | xAMPRx_C |
+			xAMPRx_V;
+	} else {
+		address = ULONG_MAX;
+		ampr = 0;
+	}
 
 	asm volatile("movgs %0,scr0\n"
 		     "movgs %0,scr1\n"
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

