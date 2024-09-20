Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0A955E48
	for <mm-commits@vger.kernel.org>; Fri, 20 Sep 2024 10:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726829534; cv=none; b=mZx9/mvgqqhR9cBMOYpeG0OwXivOLIZKrHkw0/DPyrz13dS4ogekY7tq1yCjquC2bOmogSKFlK1gau66arz/CQEjRj37YFhD5WiNYo6QEmnB0350kqpCIokbrDCk2DeSvhXO5OV/JGNAjVlXM/D4UdUIxzPiFf5utgG6FpUNZB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726829534; c=relaxed/simple;
	bh=irPhEu4/wj0uPAnMX2iAiYYklVyikvowaJql8zEPoY8=;
	h=Date:To:From:Subject:Message-Id; b=SE+3fQI21yBraNcyIAcxfLxVbHNOSQceft6otHsEfkPPbyTd1QBZLGau3tbaMoIBEPgE0145cSeq78uvq+aM1TJYQ5P8YOGux2s27DUAeTkvGPDcvkr6Zu6zY4am1Jf7V6+JNry5UYTQeVvk3xTC6yq1hghRmf11bWWl//XnPj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hzJZQx/s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hzJZQx/s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01CEC4CEC6;
	Fri, 20 Sep 2024 10:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726829533;
	bh=irPhEu4/wj0uPAnMX2iAiYYklVyikvowaJql8zEPoY8=;
	h=Date:To:From:Subject:From;
	b=hzJZQx/sukGEMLtAhV81vVbCpZ+9/ygHUpZIAQZrP01CM6+MSuPhDhpDCoEsGiKd9
	 +llIKefxCNDeOUwrLH55VCUd5o/NKn9IXN6216t9PNbAFEQhQfjEnNuuVg9GjdCmpK
	 ZI0v8q2gNh8UxdiqsR3qZqYr92fabkTr9H4bDbRY=
Date: Fri, 20 Sep 2024 03:52:13 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ryan.roberts@arm.com,lkp@intel.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-shmem-fix-khugepaged-activation-policy-for-shmem-fix.patch removed from -mm tree
Message-Id: <20240920105213.C01CEC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-shmem-fix-khugepaged-activation-policy-for-shmem-fix
has been removed from the -mm tree.  Its filename was
     mm-shmem-fix-khugepaged-activation-policy-for-shmem-fix.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-shmem-fix-khugepaged-activation-policy-for-shmem-fix
Date: Tue Sep 17 05:06:48 AM PDT 2024

fix build with CONFIG_SHMEM=n

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202409171905.9gqKNeeL-lkp@intel.com/
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/include/linux/shmem_fs.h~mm-shmem-fix-khugepaged-activation-policy-for-shmem-fix
+++ a/include/linux/shmem_fs.h
@@ -114,7 +114,6 @@ int shmem_unuse(unsigned int type);
 unsigned long shmem_allowable_huge_orders(struct inode *inode,
 				struct vm_area_struct *vma, pgoff_t index,
 				loff_t write_end, bool shmem_huge_force);
-bool shmem_hpage_pmd_enabled(void);
 #else
 static inline unsigned long shmem_allowable_huge_orders(struct inode *inode,
 				struct vm_area_struct *vma, pgoff_t index,
@@ -123,6 +122,11 @@ static inline unsigned long shmem_allowa
 	return 0;
 }
 
+#endif
+
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(SHMEM)
+bool shmem_hpage_pmd_enabled(void);
+#else
 static inline bool shmem_hpage_pmd_enabled(void)
 {
 	return false;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-khugepaged-activation-policy-for-shmem-fix-fix.patch

