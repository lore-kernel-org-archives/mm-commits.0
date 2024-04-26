Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E5978C8A
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103866; cv=none; b=M/Y+dRenYW6vg4mLZpwDdImdd3JAPpTpVtjSQVOhESXCr7pqBX+BtfjUyf/54bfmXn+HGS7bhsP60xLbsVH4a1L0wky4jhSq9xsdO6g6i3eskVFpzz5el3EYzcdEdDnnDAAmgODI3bnNYNe+il9WurvnxiD3X41gnN5gya5UdC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103866; c=relaxed/simple;
	bh=ruTN/JHpBzKr0bXgDZVdZHBfFvN/MGUCm2EThY4p+IM=;
	h=Date:To:From:Subject:Message-Id; b=Og4Os9Jkv5FGCAQljJGpAyarQqYmk3IdK/u3j1YhiGE9FuZ2i+3WaK6LD4AihQoAPeGL+r9TCcGcl1suCnKbxM/Bzr+xlLKgjYoBK32b4xHaVg550pGateOOQruyVQNNgLn2RFDrpNLeI/WI4mEkziJ7xb9zy55U3aLDH5/UQ4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z5t+dPvP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z5t+dPvP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C9FC113CD;
	Fri, 26 Apr 2024 03:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103865;
	bh=ruTN/JHpBzKr0bXgDZVdZHBfFvN/MGUCm2EThY4p+IM=;
	h=Date:To:From:Subject:From;
	b=z5t+dPvPV4ZcuCjJDfi/ZqIEJqa7EUi0UyzHPNbjUGbST/tolA8nVK9E3/Pu5Tke8
	 /SjSiiNAhi0NdSuewaVoMkT1J9gW3xdJPVwm1wqLOVNG0hElL9HwhOyE+K1MYrpI8z
	 ZYEr8v2mlEBXaBsG7yQrCPtEGknsO6NBkr5f7hwA=
Date: Thu, 25 Apr 2024 20:57:45 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,tglx@linutronix.de,shawnguo@kernel.org,rppt@kernel.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,nao.horiguchi@gmail.com,muchun.song@linux.dev,msalter@redhat.com,mpe@ellerman.id.au,mingo@redhat.com,l.stach@pengutronix.de,linux@armlinux.org.uk,krzysztof.kozlowski@linaro.org,konrad.dybcio@linaro.org,jgg@nvidia.com,festevam@denx.de,davem@davemloft.net,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,apopple@nvidia.com,aneesh.kumar@kernel.org,andreas@gaisler.com,andersson@kernel.org,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-document-pxd_leaf-api.patch removed from -mm tree
Message-Id: <20240426035745.79C9FC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: document pXd_leaf() API
has been removed from the -mm tree.  Its filename was
     mm-document-pxd_leaf-api.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm: document pXd_leaf() API
Date: Mon, 18 Mar 2024 16:04:04 -0400

There's one small section already, but since we're going to remove
pXd_huge(), that comment may start to obsolete.

Rewrite that section with more information, hopefully with that the API is
crystal clear on what it implies.

Link: https://lkml.kernel.org/r/20240318200404.448346-15-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Fabio Estevam <festevam@denx.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Mark Salter <msalter@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

--- a/include/linux/pgtable.h~mm-document-pxd_leaf-api
+++ a/include/linux/pgtable.h
@@ -1768,11 +1768,25 @@ typedef unsigned int pgtbl_mod_mask;
 #endif
 
 /*
- * p?d_leaf() - true if this entry is a final mapping to a physical address.
- * This differs from p?d_huge() by the fact that they are always available (if
- * the architecture supports large pages at the appropriate level) even
- * if CONFIG_HUGETLB_PAGE is not defined.
- * Only meaningful when called on a valid entry.
+ * pXd_leaf() is the API to check whether a pgtable entry is a huge page
+ * mapping.  It should work globally across all archs, without any
+ * dependency on CONFIG_* options.  For architectures that do not support
+ * huge mappings on specific levels, below fallbacks will be used.
+ *
+ * A leaf pgtable entry should always imply the following:
+ *
+ * - It is a "present" entry.  IOW, before using this API, please check it
+ *   with pXd_present() first. NOTE: it may not always mean the "present
+ *   bit" is set.  For example, PROT_NONE entries are always "present".
+ *
+ * - It should _never_ be a swap entry of any type.  Above "present" check
+ *   should have guarded this, but let's be crystal clear on this.
+ *
+ * - It should contain a huge PFN, which points to a huge page larger than
+ *   PAGE_SIZE of the platform.  The PFN format isn't important here.
+ *
+ * - It should cover all kinds of huge mappings (e.g., pXd_trans_huge(),
+ *   pXd_devmap(), or hugetlb mappings).
  */
 #ifndef pgd_leaf
 #define pgd_leaf(x)	false
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-userfaultfd-reset-ptes-when-close-for-wr-protected-ones.patch
mm-hugetlb-assert-hugetlb_lock-in-__hugetlb_cgroup_commit_charge.patch
mm-page_table_check-support-userfault-wr-protect-entries.patch

