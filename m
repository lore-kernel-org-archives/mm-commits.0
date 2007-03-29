From: akpm@linux-foundation.org
Subject: - cpuidle-unsigned-bitfield.patch removed from -mm tree
Date: Thu, 29 Mar 2007 00:42:52 -0700
Message-ID: <200703290742.l2T7gqcT030339@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46283 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965973AbXC2HoI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 03:44:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, lenb@kernel.org, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     cpuidle: unsigned bitfield
has been removed from the -mm tree.  Its filename was
     cpuidle-unsigned-bitfield.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cpuidle: unsigned bitfield
From: Randy Dunlap <randy.dunlap@oracle.com>

A 1-bit bitfield has no room for a sign bit.
drivers/cpuidle/governors/ladder.c:54:16: error: dubious bitfield without explicit `signed' or `unsigned'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpuidle/governors/ladder.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/cpuidle/governors/ladder.c~cpuidle-unsigned-bitfield drivers/cpuidle/governors/ladder.c
--- a/drivers/cpuidle/governors/ladder.c~cpuidle-unsigned-bitfield
+++ a/drivers/cpuidle/governors/ladder.c
@@ -51,7 +51,7 @@ struct ladder_device_state {
 
 struct ladder_device {
 	struct ladder_device_state states[CPUIDLE_STATE_MAX];
-	int bm_check:1;
+	unsigned int bm_check:1;
 	unsigned long bm_check_timestamp;
 	unsigned long bm_activity; /* FIXME: bm activity should be global */
 	int last_state_idx;
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-acpi.patch
git-drm.patch
romfs-printk-format-warnings.patch
git-netdev-all.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
i386-fix-gdts-number-of-quadwords-in.patch
scripts-kernel-doc-whitespace-cleanup.patch
reiserfs-proc-support-requires-proc_fs.patch
kprobes-fix-sparse-null-warning.patch
ext4-use-null-for-pointers.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
profile-likely-unlikely-macros.patch
