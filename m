From: akpm@linux-foundation.org
Subject: [folded-merged] hlist-drop-the-node-parameter-from-iterators-fix.patch removed from -mm tree
Date: Wed, 27 Feb 2013 16:49:41 -0800
Message-ID: <20130228004942.276F75A408F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:36768 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab3B1Atn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 19:49:43 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so139341ghb.4
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 16:49:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hlist-drop-the-node-parameter-from-iterators-fix
has been removed from the -mm tree.  Its filename was
     hlist-drop-the-node-parameter-from-iterators-fix.patch

This patch was dropped because it was folded into hlist-drop-the-node-parameter-from-iterators.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hlist-drop-the-node-parameter-from-iterators-fix

Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/devinet.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN net/ipv4/devinet.c~hlist-drop-the-node-parameter-from-iterators-fix net/ipv4/devinet.c
--- a/net/ipv4/devinet.c~hlist-drop-the-node-parameter-from-iterators-fix
+++ a/net/ipv4/devinet.c
@@ -587,7 +587,6 @@ static void check_lifetime(struct work_s
 {
 	unsigned long now, next, next_sec, next_sched;
 	struct in_ifaddr *ifa;
-	struct hlist_node *node;
 	int i;
 
 	now = jiffies;
@@ -595,8 +594,7 @@ static void check_lifetime(struct work_s
 
 	rcu_read_lock();
 	for (i = 0; i < IN4_ADDR_HSIZE; i++) {
-		hlist_for_each_entry_rcu(ifa, node,
-					 &inet_addr_lst[i], hash) {
+		hlist_for_each_entry_rcu(ifa, &inet_addr_lst[i], hash) {
 			unsigned long age;
 
 			if (ifa->ifa_flags & IFA_F_PERMANENT)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-use-vm_unmapped_area-on-parisc-architecture.patch
backlight-add-new-lp8788-backlight-driver.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
fs-proc-clean-up-printks.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication.patch
lockdep-check-that-no-locks-held-at-freeze-time.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch
idr-remove-length-restriction-from-idr_layer-bitmap.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally.patch
ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
tools-testing-selftests-makefile-rearrange-targets.patch
selftests-add-a-simple-doc.patch
hlist-drop-the-node-parameter-from-iterators.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix-fix.patch

