Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F033009E4
	for <mm-commits@vger.kernel.org>; Tue,  9 Dec 2025 19:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765308814; cv=none; b=RLB1C2trffXu2wwUvD23BO3V915ah7S3O+EdZVHwAs7iAVhSPzPMJ2X4dlqNNzQZym885Ad5cXNXVVrf8BwgH64lN92k89WXV8O4imP+NPAMUfuSl2QTC3juT8s4hO31KElSvroYCB2u5o8Fj453V9GuuxwT+gz6tvzBX3E/1Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765308814; c=relaxed/simple;
	bh=htUtbLmy2t1neLoysi3yDdd4mvmNqk4zWZ+bIlWBtkI=;
	h=Date:To:From:Subject:Message-Id; b=qFucg3QEcs+mGcyUH710LH4jzzFg5jHdCIFF/wZXa3W4CSri+PUySaYrXw31eYAGiHN46v101s1pz+f4Z5qnIW5Q4V1C6C3hDdWJQpsS4GCUQaoth8lgXo3/9kBTxoDNjeUVQSqKiCbtaLB0TLg6V3sxl/R0ufMmPkCWhvRww1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zlGvn+ON; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zlGvn+ON"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF8EC4CEF5;
	Tue,  9 Dec 2025 19:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765308814;
	bh=htUtbLmy2t1neLoysi3yDdd4mvmNqk4zWZ+bIlWBtkI=;
	h=Date:To:From:Subject:From;
	b=zlGvn+ONgMTv8/AeDjyvFnA871fgDyTNsg6OSfZlLAMaCGTYC9UsPLIKrIR9Oxr4C
	 BbOZK5XPAsYNluiSnzNuvEka7GmUWOZHYVG8u5LmToEQoI9ylNAVrO0YqGqq1FpY9q
	 lnKK2M8qR1Xec0QYhAe3MPX9CS/dWV6aEnMOCH3c=
Date: Tue, 09 Dec 2025 11:33:33 -0800
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,lorenzo.stoakes@oracle.com,kasong@tencent.com,hughd@google.com,guoweikang.kernel@gmail.com,david@kernel.org,brauner@kernel.org,baolin.wang@linux.alibaba.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mm-shmem-avoid-build-warning-for-config_shmem=n.patch removed from -mm tree
Message-Id: <20251209193334.0CF8EC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: avoid build warning for CONFIG_SHMEM=n
has been removed from the -mm tree.  Its filename was
     mm-shmem-avoid-build-warning-for-config_shmem=n.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm: shmem: avoid build warning for CONFIG_SHMEM=n
Date: Thu, 4 Dec 2025 11:28:59 +0100

The newly added 'flags' variable is unused and causes a warning if
CONFIG_SHMEM is disabled, since the shmem_acct_size() macro it is passed
into does nothing:

mm/shmem.c: In function '__shmem_file_setup':
mm/shmem.c:5816:23: error: unused variable 'flags' [-Werror=unused-variable]
 5816 |         unsigned long flags = (vm_flags & VM_NORESERVE) ? SHMEM_F_NORESERVE : 0;
      |                       ^~~~~

Replace the two macros with equivalent inline functions to get the
argument checking.

Link: https://lkml.kernel.org/r/20251204102905.1048000-1-arnd@kernel.org
Fixes: 6ff1610ced56 ("mm: shmem: use SHMEM_F_* flags instead of VM_* flags")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: guoweikang <guoweikang.kernel@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/mm/shmem.c~mm-shmem-avoid-build-warning-for-config_shmem=n
+++ a/mm/shmem.c
@@ -5799,8 +5799,15 @@ EXPORT_SYMBOL_GPL(shmem_truncate_range);
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

Patches currently in -mm which might be from arnd@arndb.de are


