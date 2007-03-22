From: akpm@linux-foundation.org
Subject: + cpuidle-unsigned-bitfield.patch added to -mm tree
Date: Wed, 21 Mar 2007 22:17:17 -0800
Message-ID: <200703220617.l2M6HHen013762@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40879 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbXCVGSd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2007 02:18:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, lenb@kernel.org, venkatesh.pallipadi@intel.com


The patch titled
     cpuidle: unsigned bitfield
has been added to the -mm tree.  Its filename is
     cpuidle-unsigned-bitfield.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-drm.patch
git-libata-all.patch
romfs-printk-format-warnings.patch
git-netdev-all.patch
fusion-kernel-doc-warning-fixes.patch
unionfs-sioq-not-__exit.patch
i386-fix-gdts-number-of-quadwords-in.patch
scripts-kernel-doc-whitespace-cleanup.patch
reiserfs-proc-support-requires-proc_fs.patch
kprobes-fix-sparse-null-warning.patch
ptrace-needs-proc_fs.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
profile-likely-unlikely-macros.patch
ipwireless-use-ansi-func-decl.patch
cpuidle-unsigned-bitfield.patch
acpi-dock-use-null-for-pointer.patch
ext4-use-null-for-pointers.patch
nozomi-use-null-for-pointers.patch
