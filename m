From: akpm@linux-foundation.org
Subject: + hlist-drop-the-node-parameter-from-iterators-redo-kvm.patch added to -mm tree
Date: Thu, 07 Feb 2013 13:15:32 -0800
Message-ID: <20130207211534.0DDF91CA1CE@corp2gmr1-1.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f73.google.com ([74.125.83.73]:51949 "EHLO
	mail-ee0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758877Ab3BGVPi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Feb 2013 16:15:38 -0500
Received: by mail-ee0-f73.google.com with SMTP id c41so207118eek.0
        for <mm-commits@vger.kernel.org>; Thu, 07 Feb 2013 13:15:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foudnation.org, gleb@redhat.com, mtosatti@redhat.com, sasha.levin@oracle.com


The patch titled
     Subject: hlist-drop-the-node-parameter-from-iterators-redo-kvm
has been added to the -mm tree.  Its filename is
     hlist-drop-the-node-parameter-from-iterators-redo-kvm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foudnation.org>
Subject: hlist-drop-the-node-parameter-from-iterators-redo-kvm

Redo intrusive kvm changes

Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kvm/mmu.c |   26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff -puN arch/x86/kvm/mmu.c~hlist-drop-the-node-parameter-from-iterators-redo-kvm arch/x86/kvm/mmu.c
--- a/arch/x86/kvm/mmu.c~hlist-drop-the-node-parameter-from-iterators-redo-kvm
+++ a/arch/x86/kvm/mmu.c
@@ -1658,13 +1658,13 @@ static int kvm_mmu_prepare_zap_page(stru
 static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 				    struct list_head *invalid_list);
 
-#define for_each_gfn_sp(kvm, sp, gfn, pos)				\
-  hlist_for_each_entry(sp, pos,						\
+#define for_each_gfn_sp(kvm, sp, gfn)					\
+  hlist_for_each_entry(sp,						\
    &(kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)], hash_link)	\
 	if ((sp)->gfn != (gfn)) {} else
 
-#define for_each_gfn_indirect_valid_sp(kvm, sp, gfn, pos)		\
-  hlist_for_each_entry(sp, pos,						\
+#define for_each_gfn_indirect_valid_sp(kvm, sp, gfn)			\
+  hlist_for_each_entry(sp,						\
    &(kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)], hash_link)	\
 		if ((sp)->gfn != (gfn) || (sp)->role.direct ||		\
 			(sp)->role.invalid) {} else
@@ -1720,11 +1720,10 @@ static int kvm_sync_page(struct kvm_vcpu
 static void kvm_sync_pages(struct kvm_vcpu *vcpu,  gfn_t gfn)
 {
 	struct kvm_mmu_page *s;
-	struct hlist_node *node;
 	LIST_HEAD(invalid_list);
 	bool flush = false;
 
-	for_each_gfn_indirect_valid_sp(vcpu->kvm, s, gfn, node) {
+	for_each_gfn_indirect_valid_sp(vcpu->kvm, s, gfn) {
 		if (!s->unsync)
 			continue;
 
@@ -1862,7 +1861,6 @@ static struct kvm_mmu_page *kvm_mmu_get_
 	union kvm_mmu_page_role role;
 	unsigned quadrant;
 	struct kvm_mmu_page *sp;
-	struct hlist_node *node;
 	bool need_sync = false;
 
 	role = vcpu->arch.mmu.base_role;
@@ -1877,7 +1875,7 @@ static struct kvm_mmu_page *kvm_mmu_get_
 		quadrant &= (1 << ((PT32_PT_BITS - PT64_PT_BITS) * level)) - 1;
 		role.quadrant = quadrant;
 	}
-	for_each_gfn_sp(vcpu->kvm, sp, gfn, node) {
+	for_each_gfn_sp(vcpu->kvm, sp, gfn) {
 		if (!need_sync && sp->unsync)
 			need_sync = true;
 
@@ -2166,14 +2164,13 @@ void kvm_mmu_change_mmu_pages(struct kvm
 int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 {
 	struct kvm_mmu_page *sp;
-	struct hlist_node *node;
 	LIST_HEAD(invalid_list);
 	int r;
 
 	pgprintk("%s: looking for gfn %llx\n", __func__, gfn);
 	r = 0;
 	spin_lock(&kvm->mmu_lock);
-	for_each_gfn_indirect_valid_sp(kvm, sp, gfn, node) {
+	for_each_gfn_indirect_valid_sp(kvm, sp, gfn) {
 		pgprintk("%s: gfn %llx role %x\n", __func__, gfn,
 			 sp->role.word);
 		r = 1;
@@ -2303,9 +2300,8 @@ static void __kvm_unsync_page(struct kvm
 static void kvm_unsync_pages(struct kvm_vcpu *vcpu,  gfn_t gfn)
 {
 	struct kvm_mmu_page *s;
-	struct hlist_node *node;
 
-	for_each_gfn_indirect_valid_sp(vcpu->kvm, s, gfn, node) {
+	for_each_gfn_indirect_valid_sp(vcpu->kvm, s, gfn) {
 		if (s->unsync)
 			continue;
 		WARN_ON(s->role.level != PT_PAGE_TABLE_LEVEL);
@@ -2317,10 +2313,9 @@ static int mmu_need_write_protect(struct
 				  bool can_unsync)
 {
 	struct kvm_mmu_page *s;
-	struct hlist_node *node;
 	bool need_unsync = false;
 
-	for_each_gfn_indirect_valid_sp(vcpu->kvm, s, gfn, node) {
+	for_each_gfn_indirect_valid_sp(vcpu->kvm, s, gfn) {
 		if (!can_unsync)
 			return 1;
 
@@ -3955,7 +3950,6 @@ void kvm_mmu_pte_write(struct kvm_vcpu *
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	union kvm_mmu_page_role mask = { .word = 0 };
 	struct kvm_mmu_page *sp;
-	struct hlist_node *node;
 	LIST_HEAD(invalid_list);
 	u64 entry, gentry, *spte;
 	int npte;
@@ -3986,7 +3980,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *
 	kvm_mmu_audit(vcpu, AUDIT_PRE_PTE_WRITE);
 
 	mask.cr0_wp = mask.cr4_pae = mask.nxe = 1;
-	for_each_gfn_indirect_valid_sp(vcpu->kvm, sp, gfn, node) {
+	for_each_gfn_indirect_valid_sp(vcpu->kvm, sp, gfn) {
 		if (detect_write_misaligned(sp, gpa, bytes) ||
 		      detect_write_flooding(sp)) {
 			zap_page |= !!kvm_mmu_prepare_zap_page(vcpu->kvm, sp,
_

Patches currently in -mm which might be from akpm@linux-foudnation.org are

hlist-drop-the-node-parameter-from-iterators-redo-kvm.patch

