Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8AC1C6FE1
	for <mm-commits@vger.kernel.org>; Sat,  8 Nov 2025 16:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762620194; cv=none; b=tafIVtcPFJewTUATpJ0kOwECbXbt6i26YkWR1qeIndiICLSwqtPkdylnvXiQPucAvLQUl/puK61LYmTelA/KdB6ZyfEUBzytPPJP5Xm6gJRrmUbZzWJ+7Ydz5ObWhkKVW7rtmcIPtRzKeAL6tgX2G0Xw8vUQ74ShDDXxMk35WYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762620194; c=relaxed/simple;
	bh=jBSvDXUHFkRFUS0QxuWrBgCUAsZRkOG0JOiD53NLM68=;
	h=Date:To:From:Subject:Message-Id; b=oOe6rWcooP5efIUn7+Wp25AQSWF0XALYumoAVWId90+Omoo2iDX7s6JuA6Onn+v14R+wbvsF/98kaV8rgTZKGi2o+vAxwckNZyPpMN54jqgB2LrqCnWDlMWh28BYQDpAS6E+WR646D3WCBFbmnEbrgn2OqyzX8d2gWn9epPH6rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DeFD9ttE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DeFD9ttE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50F5C19421;
	Sat,  8 Nov 2025 16:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762620193;
	bh=jBSvDXUHFkRFUS0QxuWrBgCUAsZRkOG0JOiD53NLM68=;
	h=Date:To:From:Subject:From;
	b=DeFD9ttEy90CxxjhAxBMfm3FhVlFYvlNXoDclRerlWqa+KfBy86L1rlNQ7AwpQ0Z4
	 dZbA9rMyW+oVCsadb83THAwgAj3hmWC7JVji6iNt8XzZ+9ctjHfrJkbaY0cHeyawRV
	 AGckVsCp8oCYslTWtRH6BFirBLg+AsAo/fQUxDP4=
Date: Sat, 08 Nov 2025 08:43:13 -0800
To: mm-commits@vger.kernel.org,ptyadav@amazon.de,pasha.tatashin@soleen.com,lkp@intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-use-shmem_f_-flags-instead-of-vm_-flags-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20251108164313.B50F5C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-shmem-use-shmem_f_-flags-instead-of-vm_-flags-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mm-shmem-use-shmem_f_-flags-instead-of-vm_-flags-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-use-shmem_f_-flags-instead-of-vm_-flags-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-shmem-use-shmem_f_-flags-instead-of-vm_-flags-fix
Date: Sat Nov  8 08:36:51 AM PST 2025

fiw warnings by making shmem_acct_size/shmem_unacct_size inlined C

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202511081101.9sXNBrzT-lkp@intel.com/
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <ptyadav@amazon.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/mm/shmem.c~mm-shmem-use-shmem_f_-flags-instead-of-vm_-flags-fix
+++ a/mm/shmem.c
@@ -5818,8 +5818,15 @@ EXPORT_SYMBOL_GPL(shmem_truncate_range);
 #define shmem_vm_ops				generic_file_vm_ops
 #define shmem_anon_vm_ops			generic_file_vm_ops
 #define shmem_file_operations			ramfs_file_operations
-#define shmem_acct_size(flags, size)		0
-#define shmem_unacct_size(flags, size)		do {} while (0)
+
+static inline int shmem_acct_size(unsigned long flags, loff_t size)
+{
+	return 0;
+}
+
+static inline void shmem_unacct_size(unsigned long flags, loff_t size)
+{
+}
 
 static inline struct inode *shmem_get_inode(struct mnt_idmap *idmap,
 				struct super_block *sb, struct inode *dir,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch
drivers-base-node-fold-register_node-into-register_one_node-fix.patch
mm-vmstat-fix-indentation-in-fold_diff-function-fix.patch
memcg-manually-uninline-__memcg_memory_event-fix.patch
mm-change-type-of-state-in-struct-memory_block-fix.patch
mm-introduce-leaf-entry-type-and-use-to-simplify-leaf-entry-logic-fix-fix.patch
mm-huge_memory-introduce-enum-split_type-for-clarity-fix.patch
init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-fix.patch
panic-sys_info-factor-out-read-and-write-handlers-checkpatch-fixes.patch
memblock-unpreserve-memory-in-case-of-error-fix.patch
mm-shmem-use-shmem_f_-flags-instead-of-vm_-flags-fix.patch

