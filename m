From: akpm@linux-foundation.org
Subject: - kprobes-use-hlist_for_each_entry.patch removed from -mm tree
Date: Tue, 08 May 2007 19:54:45 -0700
Message-ID: <200705090254.l492sjAF009836@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032282AbXEICzB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:55:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, prasanna@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     kprobes: use hlist_for_each_entry
has been removed from the -mm tree.  Its filename was
     kprobes-use-hlist_for_each_entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kprobes: use hlist_for_each_entry
From: Christoph Hellwig <hch@lst.de>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN kernel/kprobes.c~kprobes-use-hlist_for_each_entry kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-use-hlist_for_each_entry
+++ a/kernel/kprobes.c
@@ -134,8 +134,7 @@ kprobe_opcode_t __kprobes *get_insn_slot
 	struct hlist_node *pos;
 
       retry:
-	hlist_for_each(pos, &kprobe_insn_pages) {
-		kip = hlist_entry(pos, struct kprobe_insn_page, hlist);
+	hlist_for_each_entry(kip, pos, &kprobe_insn_pages, hlist) {
 		if (kip->nused < INSNS_PER_PAGE) {
 			int i;
 			for (i = 0; i < INSNS_PER_PAGE; i++) {
@@ -214,9 +213,8 @@ static int __kprobes collect_garbage_slo
 	if (check_safety() != 0)
 		return -EAGAIN;
 
-	hlist_for_each_safe(pos, next, &kprobe_insn_pages) {
+	hlist_for_each_entry_safe(kip, pos, next, &kprobe_insn_pages, hlist) {
 		int i;
-		kip = hlist_entry(pos, struct kprobe_insn_page, hlist);
 		if (kip->ngarbage == 0)
 			continue;
 		kip->ngarbage = 0;	/* we will collect all garbages */
@@ -235,8 +233,7 @@ void __kprobes free_insn_slot(kprobe_opc
 	struct kprobe_insn_page *kip;
 	struct hlist_node *pos;
 
-	hlist_for_each(pos, &kprobe_insn_pages) {
-		kip = hlist_entry(pos, struct kprobe_insn_page, hlist);
+	hlist_for_each_entry(kip, pos, &kprobe_insn_pages, hlist) {
 		if (kip->insns <= slot &&
 		    slot < kip->insns + (INSNS_PER_PAGE * MAX_INSN_SIZE)) {
 			int i = (slot - kip->insns) / MAX_INSN_SIZE;
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
dont-force-uclinux-mtd-map-to-be-root-dev.patch
git-scsi-misc.patch
knfsd-trivial-makefile-cleanup.patch
aio-is-unlikely.patch
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch
