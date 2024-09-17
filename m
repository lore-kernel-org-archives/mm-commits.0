Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B0243150
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 12:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726575124; cv=none; b=qfqRuS/izVtcXrfSFqQyABh7yybc5m7CHdoZxMpRFM2t6nVungBfOv0vNQn4/TKOmpG8BCwOs9lMKlFYrV0XWe2VkhayYz+5SVfI6718iBKwdJUOPk5FloUI2p0X1TXut8MwowWmv77EIOS8lBIdEfZsSJ2rS22g/HX5Tk827jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726575124; c=relaxed/simple;
	bh=0xN9xcKdIyoz2Pou739odN2NF603wThsw1V6OHR5x+4=;
	h=Date:To:From:Subject:Message-Id; b=lU8Y6l1wE0zZJxPSzE9vLQ3D8MjtJnWIlv9Gs3XlcQoWCB9uAPpWKUKKXGS186HlFvffpkSOQzugxQvmcSnSU51KCguNLoH0IAH8Gz1y+BzgXxVSALZ0KgfdzphcTQzP0LVkJt2eiE+3OkSw0PqjsWonfO8AY1q+ZqGm6shIeEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Mk7GDkKm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Mk7GDkKm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7DB3C4CEC5;
	Tue, 17 Sep 2024 12:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726575124;
	bh=0xN9xcKdIyoz2Pou739odN2NF603wThsw1V6OHR5x+4=;
	h=Date:To:From:Subject:From;
	b=Mk7GDkKmfg6SKrQlMLgwtnkJo29SdrhZ34ysMk3xIJbhq/Rt+SaLJ7Ezza5uxL6KN
	 zh+wJwvSQXIzvyd6YehiV/IerGVENnH5UZpChHG+/os+/G//mIBGIBxwdPO1gWgpvP
	 s6ghD+marm4rEVHtrRyJ/kWMEKWYfv5ONO5G8roU=
Date: Tue, 17 Sep 2024 05:12:01 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ryan.roberts@arm.com,lkp@intel.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-fix-khugepaged-activation-policy-for-shmem-fix.patch added to mm-unstable branch
Message-Id: <20240917121203.B7DB3C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-shmem-fix-khugepaged-activation-policy-for-shmem-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-fix-khugepaged-activation-policy-for-shmem-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-fix-khugepaged-activation-policy-for-shmem-fix.patch

This patch will later appear in the mm-unstable branch at
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

mm-shmem-fix-khugepaged-activation-policy-for-shmem-fix.patch

