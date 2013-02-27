From: akpm@linux-foundation.org
Subject: + hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix.patch added to -mm tree
Date: Wed, 27 Feb 2013 14:41:42 -0800
Message-ID: <20130227233356.2B96A31C107@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:62241 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab3B0Xd5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 18:33:57 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so132392vch.0
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 15:33:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, sasha.levin@oracle.com


The patch titled
     Subject: hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix
has been added to the -mm tree.  Its filename is
     hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix

Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/net-procfs.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/net/ethernet/mellanox/mlx4/en_rx.c~hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix drivers/net/ethernet/mellanox/mlx4/en_rx.c
diff -puN net/core/net-procfs.c~hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix net/core/net-procfs.c
--- a/net/core/net-procfs.c~hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix
+++ a/net/core/net-procfs.c
@@ -16,12 +16,11 @@ static inline struct net_device *dev_fro
 {
 	struct net *net = seq_file_net(seq);
 	struct net_device *dev;
-	struct hlist_node *p;
 	struct hlist_head *h;
 	unsigned int count = 0, offset = get_offset(*pos);
 
 	h = &net->dev_name_head[get_bucket(*pos)];
-	hlist_for_each_entry_rcu(dev, p, h, name_hlist) {
+	hlist_for_each_entry_rcu(dev, h, name_hlist) {
 		if (++count == offset)
 			return dev;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-use-vm_unmapped_area-on-parisc-architecture-fix.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
signal-allow-to-send-any-siginfo-to-itself-fix.patch
fs-proc-clean-up-printks.patch
fs-proc-clean-up-printks-fix.patch
fs-proc-clean-up-printks-fix-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix-fix.patch
lockdep-check-that-no-locks-held-at-freeze-time-fix.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting-checkpatch-fixes.patch
idr-remove-length-restriction-from-idr_layer-bitmap-checkpatch-fixes.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
selftests-add-tests-for-efivarfs-fix.patch
selftests-add-tests-for-efivarfs-fix-fix.patch
tools-testing-selftests-makefile-rearrange-targets.patch
selftests-add-a-simple-doc-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes.patch
hlist-drop-the-node-parameter-from-iterators-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix.patch

