From: akpm@osdl.org
Subject: + kprobes-replace-magic-numbers-with-enum.patch added to -mm tree
Date: Thu, 25 Jan 2007 15:17:49 -0800
Message-ID: <200701252317.l0PNHnk9001418@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34974 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030493AbXAYXSA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 18:18:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: masami.hiramatsu.pt@hitachi.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, prasanna@in.ibm.com


The patch titled
     kprobe: replace magic numbers with enum
has been added to the -mm tree.  Its filename is
     kprobes-replace-magic-numbers-with-enum.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kprobe: replace magic numbers with enum
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Replace the magic numbers with an enum, and gets rid of a warning on the
specific architectures (ex.  powerpc) on which the compiler considers
'char' as 'unsigned char'.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/kprobes.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff -puN kernel/kprobes.c~kprobes-replace-magic-numbers-with-enum kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-replace-magic-numbers-with-enum
+++ a/kernel/kprobes.c
@@ -87,6 +87,12 @@ struct kprobe_insn_page {
 	int ngarbage;
 };
 
+enum kprobe_slot_state {
+	SLOT_CLEAN = 0,
+	SLOT_DIRTY = 1,
+	SLOT_USED = 2,
+};
+
 static struct hlist_head kprobe_insn_pages;
 static int kprobe_garbage_slots;
 static int collect_garbage_slots(void);
@@ -130,8 +136,8 @@ kprobe_opcode_t __kprobes *get_insn_slot
 		if (kip->nused < INSNS_PER_PAGE) {
 			int i;
 			for (i = 0; i < INSNS_PER_PAGE; i++) {
-				if (!kip->slot_used[i]) {
-					kip->slot_used[i] = 1;
+				if (kip->slot_used[i] == SLOT_CLEAN) {
+					kip->slot_used[i] = SLOT_USED;
 					kip->nused++;
 					return kip->insns + (i * MAX_INSN_SIZE);
 				}
@@ -163,8 +169,8 @@ kprobe_opcode_t __kprobes *get_insn_slot
 	}
 	INIT_HLIST_NODE(&kip->hlist);
 	hlist_add_head(&kip->hlist, &kprobe_insn_pages);
-	memset(kip->slot_used, 0, INSNS_PER_PAGE);
-	kip->slot_used[0] = 1;
+	memset(kip->slot_used, SLOT_CLEAN, INSNS_PER_PAGE);
+	kip->slot_used[0] = SLOT_USED;
 	kip->nused = 1;
 	kip->ngarbage = 0;
 	return kip->insns;
@@ -173,7 +179,7 @@ kprobe_opcode_t __kprobes *get_insn_slot
 /* Return 1 if all garbages are collected, otherwise 0. */
 static int __kprobes collect_one_slot(struct kprobe_insn_page *kip, int idx)
 {
-	kip->slot_used[idx] = 0;
+	kip->slot_used[idx] = SLOT_CLEAN;
 	kip->nused--;
 	if (kip->nused == 0) {
 		/*
@@ -212,7 +218,7 @@ static int __kprobes collect_garbage_slo
 			continue;
 		kip->ngarbage = 0;	/* we will collect all garbages */
 		for (i = 0; i < INSNS_PER_PAGE; i++) {
-			if (kip->slot_used[i] == -1 &&
+			if (kip->slot_used[i] == SLOT_DIRTY &&
 			    collect_one_slot(kip, i))
 				break;
 		}
@@ -232,7 +238,7 @@ void __kprobes free_insn_slot(kprobe_opc
 		    slot < kip->insns + (INSNS_PER_PAGE * MAX_INSN_SIZE)) {
 			int i = (slot - kip->insns) / MAX_INSN_SIZE;
 			if (dirty) {
-				kip->slot_used[i] = -1;
+				kip->slot_used[i] = SLOT_DIRTY;
 				kip->ngarbage++;
 			} else {
 				collect_one_slot(kip, i);
_

Patches currently in -mm which might be from masami.hiramatsu.pt@hitachi.com are

kprobes-replace-magic-numbers-with-enum.patch
