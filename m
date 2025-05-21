Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1792822F15E
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 17:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747849736; cv=none; b=uaTixP9U6D2i0htl69XUrsFpuc6GDdEBRZY6nCavSFP23nB2YRYg5cmC6Vv6XhX9x6FddJ1qVOOZezGM1uc2sBe4wghw+TZ1WoYTgTCY2FUYrxJbjYroKERKrFIcoSryIy6NwkNO9iWc7MoXPvzyhMkVkOFcBhwNNK788tXSGys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747849736; c=relaxed/simple;
	bh=4GnSWagvf1hIwrek1FUsaf5g9OB9kN79XzTMfZl9/XI=;
	h=Date:To:From:Subject:Message-Id; b=tT2FwB296rGEDZhG1t/B45Bi//PwhOmLY0sszTOZXMecP6cLQzK8yV3gy9xR75cvSIluCeKxYCDTNgwBD6/DalGVtD3GIxlrJXLJTfuXkq4Xw0/YgOqW0H0H7nLfD4Te7vPc9r4aB+BZdUV5lDuuqVMmpj/vCTKMYLnBq+jir8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eA2Hz+PN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eA2Hz+PN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD6FAC4CEE4;
	Wed, 21 May 2025 17:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747849735;
	bh=4GnSWagvf1hIwrek1FUsaf5g9OB9kN79XzTMfZl9/XI=;
	h=Date:To:From:Subject:From;
	b=eA2Hz+PNQ2gZDei8njChNO7rZo3Xn5zQIMQn5Ec0AIQxjzRpBClXoRIh4rlpcxJJ8
	 TSFuQJ6QX/PEBnMq3TGOLBOufg2DSizeVPv19hsIxE6osxWizX0o7KDyJOIi82hCm5
	 0Gn3j3/6PYH/2dMWw13Dps7wSjpT0jVc/EP9FjZY=
Date: Wed, 21 May 2025 10:48:55 -0700
To: mm-commits@vger.kernel.org,vkuznets@redhat.com,okozina@redhat.com,kernelfans@gmail.com,jpazdziora@redhat.com,gmazyland@gmail.com,dyoung@redhat.com,dave.hansen@intel.com,bhe@redhat.com,berrange@redhat.com,coxu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] revert-x86-mm-remove-unused-__set_memory_prot.patch removed from -mm tree
Message-Id: <20250521174855.DD6FAC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Revert "x86/mm: Remove unused __set_memory_prot()"
has been removed from the -mm tree.  Its filename was
     revert-x86-mm-remove-unused-__set_memory_prot.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Coiby Xu <coxu@redhat.com>
Subject: Revert "x86/mm: Remove unused __set_memory_prot()"
Date: Fri, 2 May 2025 09:12:40 +0800

This reverts commit 693bbf2a50447353c6a47961e6a7240a823ace02 as kdump LUKS
support (CONFIG_CRASH_DM_CRYPT) depends on __set_memory_prot.

[akpm@linux-foundation.org: x86 set_memory.h needs pgtable_types.h]
Link: https://lkml.kernel.org/r/20250502011246.99238-7-coxu@redhat.com
Signed-off-by: Coiby Xu <coxu@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: "Daniel P. Berrange" <berrange@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Jan Pazdziora <jpazdziora@redhat.com>
Cc: Liu Pingfan <kernelfans@gmail.com>
Cc: Milan Broz <gmazyland@gmail.com>
Cc: Ondrej Kozina <okozina@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/set_memory.h |    2 ++
 arch/x86/mm/pat/set_memory.c      |   13 +++++++++++++
 2 files changed, 15 insertions(+)

--- a/arch/x86/include/asm/set_memory.h~revert-x86-mm-remove-unused-__set_memory_prot
+++ a/arch/x86/include/asm/set_memory.h
@@ -4,6 +4,7 @@
 
 #include <asm/page.h>
 #include <asm-generic/set_memory.h>
+#include <asm/pgtable.h>
 
 #define set_memory_rox set_memory_rox
 int set_memory_rox(unsigned long addr, int numpages);
@@ -37,6 +38,7 @@ int set_memory_rox(unsigned long addr, i
  * The caller is required to take care of these.
  */
 
+int __set_memory_prot(unsigned long addr, int numpages, pgprot_t prot);
 int _set_memory_uc(unsigned long addr, int numpages);
 int _set_memory_wc(unsigned long addr, int numpages);
 int _set_memory_wt(unsigned long addr, int numpages);
--- a/arch/x86/mm/pat/set_memory.c~revert-x86-mm-remove-unused-__set_memory_prot
+++ a/arch/x86/mm/pat/set_memory.c
@@ -2148,6 +2148,19 @@ static inline int cpa_clear_pages_array(
 		CPA_PAGES_ARRAY, pages);
 }
 
+/*
+ * __set_memory_prot is an internal helper for callers that have been passed
+ * a pgprot_t value from upper layers and a reservation has already been taken.
+ * If you want to set the pgprot to a specific page protocol, use the
+ * set_memory_xx() functions.
+ */
+int __set_memory_prot(unsigned long addr, int numpages, pgprot_t prot)
+{
+	return change_page_attr_set_clr(&addr, numpages, prot,
+					__pgprot(~pgprot_val(prot)), 0, 0,
+					NULL);
+}
+
 int _set_memory_uc(unsigned long addr, int numpages)
 {
 	/*
_

Patches currently in -mm which might be from coxu@redhat.com are


