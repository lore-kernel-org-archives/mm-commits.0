Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148B924397A
	for <mm-commits@vger.kernel.org>; Sat,  6 Dec 2025 22:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765058608; cv=none; b=cCo0AzNQu6BYUBM0UdkWzd84Zs7a8xsUIVpdKr7N2I9wVBBUt84pmM28Oqp/A8BQaUnxrD77BXmRt5Wx9MDIPFMdLF/WNGo9HmfEsDHOK2ng4Y2ij4WKrkroch8+fR7/virnjM8dbx9KYG/BdCNtG2M9Z+mZjHi/104fC1KYDfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765058608; c=relaxed/simple;
	bh=BsZCmWVH93jCYcFegelCrD8WdRXMlCMF4QIuf1MZXJc=;
	h=Date:To:From:Subject:Message-Id; b=i8X5KfsnTacJGQGYHozrlioMK+OBJUAHusPS+ABL6o7a2ClX7EMi+5clFIOQSKYEE68zoFBY0YsAJq3EMxtGuAk/9UCU8pUQQ1+kK33D9Sf/mVqMmqzgmaeaMEWhxnIM8weKzuekYgBF3bF07QcZAzVFGzXJWt06aE/lS34QoHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kz/HuEaX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kz/HuEaX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E98C4CEF5;
	Sat,  6 Dec 2025 22:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765058607;
	bh=BsZCmWVH93jCYcFegelCrD8WdRXMlCMF4QIuf1MZXJc=;
	h=Date:To:From:Subject:From;
	b=kz/HuEaX76GGfKTQycxnnBv5LEpRZQoWP6VD+/ais6gm1Wlr+CIeQUDrGY3LfSPVg
	 y+YZlet9t3mGb8JpQga5ZZM39XGfhy7oO0UUc/7minKKPinC9Q2ekrIkL9vVyWS7i2
	 0zQhImGTMmd48q6cumF7RSjVy3LIgKDC6iwUm29g=
Date: Sat, 06 Dec 2025 14:03:27 -0800
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,lorenzo.stoakes@oracle.com,kasong@tencent.com,hughd@google.com,guoweikang.kernel@gmail.com,david@kernel.org,brauner@kernel.org,baolin.wang@linux.alibaba.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-avoid-build-warning-for-config_shmem=n.patch added to mm-nonmm-unstable branch
Message-Id: <20251206220327.C0E98C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: avoid build warning for CONFIG_SHMEM=n
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mm-shmem-avoid-build-warning-for-config_shmem=n.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-avoid-build-warning-for-config_shmem=n.patch

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
@@ -5817,8 +5817,15 @@ EXPORT_SYMBOL_GPL(shmem_truncate_range);
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

mm-shmem-avoid-build-warning-for-config_shmem=n.patch

