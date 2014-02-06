From: akpm@linux-foundation.org
Subject: [to-be-updated]
 bcache-drop-l-suffix-when-comparing-ssize_t-with-0-fix.patch removed from
 -mm tree
Date: Thu, 06 Feb 2014 12:51:25 -0800
Message-ID: <52f3f5cd.KE/lOfCjkLME1Anm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48968 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbaBFUv0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Feb 2014 15:51:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, neilb@suse.de, kmo@daterainc.com, geert@linux-m68k.org, akpm@linux-foundation.org

Subject: [to-be-updated] bcache-drop-l-suffix-when-comparing-ssize_t-with-0-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,geert@linux-m68k.org,kmo@daterainc.com,neilb@suse.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 06 Feb 2014 12:51:25 -0800


The patch titled
     Subject: bcache-drop-l-suffix-when-comparing-ssize_t-with-0-fix
has been removed from the -mm tree.  Its filename was
     bcache-drop-l-suffix-when-comparing-ssize_t-with-0-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: bcache-drop-l-suffix-when-comparing-ssize_t-with-0-fix

fix sparse warning, make `ret' size_t

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/bcache/btree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/md/bcache/btree.c~bcache-drop-l-suffix-when-comparing-ssize_t-with-0-fix drivers/md/bcache/btree.c
--- a/drivers/md/bcache/btree.c~bcache-drop-l-suffix-when-comparing-ssize_t-with-0-fix
+++ a/drivers/md/bcache/btree.c
@@ -1805,7 +1805,7 @@ static bool btree_insert_key(struct btre
 
 static size_t insert_u64s_remaining(struct btree *b)
 {
-	ssize_t ret = bch_btree_keys_u64s_remaining(&b->keys);
+	size_t ret = bch_btree_keys_u64s_remaining(&b->keys);
 
 	/*
 	 * Might land in the middle of an existing extent and have to split it
@@ -1813,7 +1813,7 @@ static size_t insert_u64s_remaining(stru
 	if (b->keys.ops->is_extents)
 		ret -= KEY_MAX_U64S;
 
-	return max(ret, 0);
+	return max_t(size_t, ret, 0);
 }
 
 static bool bch_btree_insert_keys(struct btree *b, struct btree_op *op,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon.patch
numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug.patch
xen-properly-account-for-_page_numa-during-xen-pte-translations-fix.patch
ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

