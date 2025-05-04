Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA5433E1
	for <mm-commits@vger.kernel.org>; Sun,  4 May 2025 05:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746335730; cv=none; b=S1Lgm/s+V4UHyH67NiSnbt+7anKdH/s583y0QMthTyNHC7AHwmOapiFOZbp36h5N+TbOYGpSmknKxfuWJGLnJd2brzsTN6mrJiWaFS1YXw21InlKmAabhD1mZ7g2gdQCcSKmZoCVqqBbArB088nZS6+zr8bnh8Bsm7pG5Hg2xBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746335730; c=relaxed/simple;
	bh=2Z3dACMKg59z2UzGeUnUSgLIm8NjibZPhuOBA7WC2NI=;
	h=Date:To:From:Subject:Message-Id; b=igBpmWI2s200ti8Lbkj3QwTl1eG41ibK2ZAXn3p4Jwt6DglDbGVDlmpBB/0SSjkAjjMCUjimX1BpnGkT16eX9YIC0tUwWgh0gCj6OwQVS+QrW+PsqaUoKeLfndrI23DG47xUBa+e8oWDZLqNWd+kOzTPSxiMrpqWF3YM9RqZjy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ro+t5Jga; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ro+t5Jga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED2CC4CEED;
	Sun,  4 May 2025 05:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746335730;
	bh=2Z3dACMKg59z2UzGeUnUSgLIm8NjibZPhuOBA7WC2NI=;
	h=Date:To:From:Subject:From;
	b=Ro+t5Jga0Hg3V7vRbOdiKBlXWjHbkft59J9TJNlGXuvYviV/6w4oPQxqOtqor+sXS
	 +Sz0rZ7sW+lGF5EUbDx7P0GeBZmsyJMG1AuqyLk7qqwXmy9KC28UXGLsTHTgtsM+i9
	 RJ+bE0LtBxZffCGpbqpMr0w2Ee834TLuTqlMLFDM=
Date: Sat, 03 May 2025 22:15:29 -0700
To: mm-commits@vger.kernel.org,vkuznets@redhat.com,okozina@redhat.com,kernelfans@gmail.com,jpazdziora@redhat.com,gmazyland@gmail.com,dyoung@redhat.com,dave.hansen@intel.com,bhe@redhat.com,berrange@redhat.com,coxu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-x86-mm-remove-unused-__set_memory_prot.patch added to mm-nonmm-unstable branch
Message-Id: <20250504051530.8ED2CC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Revert "x86/mm: Remove unused __set_memory_prot()"
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     revert-x86-mm-remove-unused-__set_memory_prot.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-x86-mm-remove-unused-__set_memory_prot.patch

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
From: Coiby Xu <coxu@redhat.com>
Subject: Revert "x86/mm: Remove unused __set_memory_prot()"
Date: Fri, 2 May 2025 09:12:40 +0800

This reverts commit 693bbf2a50447353c6a47961e6a7240a823ace02 as kdump LUKS
support (CONFIG_CRASH_DM_CRYPT) depends on __set_memory_prot.

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

 arch/x86/include/asm/set_memory.h |    1 +
 arch/x86/mm/pat/set_memory.c      |   13 +++++++++++++
 2 files changed, 14 insertions(+)

--- a/arch/x86/include/asm/set_memory.h~revert-x86-mm-remove-unused-__set_memory_prot
+++ a/arch/x86/include/asm/set_memory.h
@@ -37,6 +37,7 @@ int set_memory_rox(unsigned long addr, i
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

kexec_file-allow-to-place-kexec_buf-randomly.patch
crash_dump-make-dm-crypt-keys-persist-for-the-kdump-kernel.patch
crash_dump-store-dm-crypt-keys-in-kdump-reserved-memory.patch
crash_dump-reuse-saved-dm-crypt-keys-for-cpu-memory-hot-plugging.patch
crash_dump-retrieve-dm-crypt-keys-in-kdump-kernel.patch
revert-x86-mm-remove-unused-__set_memory_prot.patch
x86-crash-pass-dm-crypt-keys-to-kdump-kernel.patch
x86-crash-make-the-page-that-stores-the-dm-crypt-keys-inaccessible.patch

