Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223C0D535
	for <mm-commits@vger.kernel.org>; Tue,  4 Jun 2024 23:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717545156; cv=none; b=Q1nf4ahrSSrxAfutjUxOdQuVF2YhphJrM7pwODjf8l4nhmNCfsKfZCFeLidb5hT1XQlDqj4tyraLAeys8D1pA1DK9SjeT/gdau/Fao/JLJ4Nt8NBdG55egRr8XVsAG1FOIPKhDn9BS7h3AJArq5TcMS2e3usTPWPNMm3tUAVKtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717545156; c=relaxed/simple;
	bh=GI43UbVRwcW0/+UROtjrZ8ZhvNu5rkhvb896ydBvjv4=;
	h=Date:To:From:Subject:Message-Id; b=rREhF1xqpyAhEK1SVHfIiStJxF2Q54Xju3gKx/WQIMajP3Jsym63RKKHm+amkAQbkEqUQb2eA0JNC+PikDYR1Va4jtcU1V8LB3NY2xSGRaKvvAc6PCF1HeZrp00IuJDWalaV00Ix7qt15rNIEwwnXqhEn4i7FDB6D0ZI3BQuDJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ONtMO0Mf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ONtMO0Mf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87DB7C2BBFC;
	Tue,  4 Jun 2024 23:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717545155;
	bh=GI43UbVRwcW0/+UROtjrZ8ZhvNu5rkhvb896ydBvjv4=;
	h=Date:To:From:Subject:From;
	b=ONtMO0Mfa9N0hISmHgoCKrexdaswPo14GmQMLoKrMQwDV/EiJKIjkSEa7obxa/nXF
	 5jcHPKTQLMyaEDYo3vgdwO6f9Xe0Pe8R8ptDCGOi4ssT2DlRnNiJR5ADp4ZADwkDBb
	 n2woEk48vze24Kt7Fdm19fne6eAiOFHCJ/JpqtzU=
Date: Tue, 04 Jun 2024 16:52:34 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-extend-finish_fault-to-support-large-folio-fix.patch added to mm-unstable branch
Message-Id: <20240604235235.87DB7C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-memory-extend-finish_fault-to-support-large-folio-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-extend-finish_fault-to-support-large-folio-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-extend-finish_fault-to-support-large-folio-fix.patch

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
Subject: mm-memory-extend-finish_fault-to-support-large-folio-fix
Date: Tue Jun  4 04:50:19 PM PDT 2024

remove unused local `i'.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202406042210.20LfqwNd-lkp@intel.com/
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-memory-extend-finish_fault-to-support-large-folio-fix
+++ a/mm/memory.c
@@ -4835,7 +4835,7 @@ vm_fault_t finish_fault(struct vm_fault
 	vm_fault_t ret;
 	bool is_cow = (vmf->flags & FAULT_FLAG_WRITE) &&
 		      !(vma->vm_flags & VM_SHARED);
-	int type, nr_pages, i;
+	int type, nr_pages;
 	unsigned long addr = vmf->address;
 
 	/* Did we COW the page? */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type-fix.patch
mm-memory-extend-finish_fault-to-support-large-folio-fix.patch

