Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AEE2E339D
	for <mm-commits@vger.kernel.org>; Thu,  3 Apr 2025 03:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743650231; cv=none; b=Qgn8tfK8sLoWVqHUyBZHqIjJkF+phfjyBpiD4HMgqcWaeA2oyeO1M7gKxTVyiEi2vvCIowPlexPYYbtEvtMjtCBQjMteYCg+5Yz6e6UFPqn2ReqIwCUjRb/7EAvxfDZkWMOdg0xc+UIxQsNrNjL+leM+jkgOSfJGqNECWqwrQHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743650231; c=relaxed/simple;
	bh=OdD87xdXZ9GxNmIo5OBPpLyidc/yl/iJL/4wFNVRXTc=;
	h=Date:To:From:Subject:Message-Id; b=IBwQinE/Sk2w5/dz7JzOImWdMYiP8LmvbD96I7rtaA6W0s/aGcfBR8C7CmLJqDQ7ZPiLOpGRrwdHYlPxJ+PQrS96lEP/h8XIsXeBfRbzXL05AafipHHZhNVyJD7sY9Yg7z/9NU80lqLp3NVFrTFU0A+wVzfvLX25Qo889G5Uc28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zyu2YqLO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zyu2YqLO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BC8CC4CEDD;
	Thu,  3 Apr 2025 03:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743650231;
	bh=OdD87xdXZ9GxNmIo5OBPpLyidc/yl/iJL/4wFNVRXTc=;
	h=Date:To:From:Subject:From;
	b=zyu2YqLOEmEgJpL7v54D2FzsnKbda8r0d3D3LVoh96TetS5G4EW/m72vwoafpVSJ/
	 PwOaKjAMXNAcBx5826dhCCyfvpNc5SE4anVVtJdRcT6kVIJ07Xw9PSZ1WTgEG2u3Vd
	 HMztg1xzdqzz+zNdNURwHrCRxXO4XHjNDtzFaP7w=
Date: Wed, 02 Apr 2025 20:17:09 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,kirill.shutemov@linux.intel.com,dyoung@redhat.com,bhe@redhat.com,zhiquan1.li@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crash-export-page_unaccepted_mapcount_value-to-vmcoreinfo.patch added to mm-nonmm-unstable branch
Message-Id: <20250403031711.2BC8CC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crash: export PAGE_UNACCEPTED_MAPCOUNT_VALUE to vmcoreinfo
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     crash-export-page_unaccepted_mapcount_value-to-vmcoreinfo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash-export-page_unaccepted_mapcount_value-to-vmcoreinfo.patch

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
From: Zhiquan Li <zhiquan1.li@intel.com>
Subject: crash: export PAGE_UNACCEPTED_MAPCOUNT_VALUE to vmcoreinfo
Date: Thu, 3 Apr 2025 11:08:01 +0800

On Intel TDX guest, unaccepted memory is unusable free memory which is not
managed by buddy, until it's accepted by guest.  Before that, it cannot be
accessed by the first kernel as well as the kexec'ed kernel.  The kexec'ed
kernel will skip these pages and fill in zero data for the reader of
vmcore.

A dump tool like makedumpfile creates a page descriptor (size 24 bytes)
for each non-free page, including zero data page, but it will not create
descriptor for free pages.  If it is not able to distinguish these
unaccepted pages with zero data pages, a certain amount of space will be
wasted in proportion (~1/170).  In fact, as a special kind of free page
the unaccepted pages should be excluded, like the real free pages.

Export the page type PAGE_UNACCEPTED_MAPCOUNT_VALUE to vmcoreinfo, so that
dump tool can identify whether a page is unaccepted.

Link: https://lore.kernel.org/all/20240809114854.3745464-5-kirill.shutemov@linux.intel.com/
Link: https://lkml.kernel.org/r/20250403030801.758687-1-zhiquan1.li@intel.com
Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Zhiquan Li <zhiquan1.li@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kdump/vmcoreinfo.rst |    2 +-
 kernel/vmcore_info.c                           |    4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/kdump/vmcoreinfo.rst~crash-export-page_unaccepted_mapcount_value-to-vmcoreinfo
+++ a/Documentation/admin-guide/kdump/vmcoreinfo.rst
@@ -331,7 +331,7 @@ PG_lru|PG_private|PG_swapcache|PG_swapba
 Page attributes. These flags are used to filter various unnecessary for
 dumping pages.
 
-PAGE_BUDDY_MAPCOUNT_VALUE(~PG_buddy)|PAGE_OFFLINE_MAPCOUNT_VALUE(~PG_offline)
+PAGE_BUDDY_MAPCOUNT_VALUE(~PG_buddy)|PAGE_OFFLINE_MAPCOUNT_VALUE(~PG_offline)|PAGE_OFFLINE_MAPCOUNT_VALUE(~PG_unaccepted)
 -----------------------------------------------------------------------------
 
 More page attributes. These flags are used to filter various unnecessary for
--- a/kernel/vmcore_info.c~crash-export-page_unaccepted_mapcount_value-to-vmcoreinfo
+++ a/kernel/vmcore_info.c
@@ -210,6 +210,10 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_NUMBER(PAGE_HUGETLB_MAPCOUNT_VALUE);
 #define PAGE_OFFLINE_MAPCOUNT_VALUE	(PGTY_offline << 24)
 	VMCOREINFO_NUMBER(PAGE_OFFLINE_MAPCOUNT_VALUE);
+#ifdef CONFIG_UNACCEPTED_MEMORY
+#define PAGE_UNACCEPTED_MAPCOUNT_VALUE	(PGTY_unaccepted << 24)
+	VMCOREINFO_NUMBER(PAGE_UNACCEPTED_MAPCOUNT_VALUE);
+#endif
 
 #ifdef CONFIG_KALLSYMS
 	VMCOREINFO_SYMBOL(kallsyms_names);
_

Patches currently in -mm which might be from zhiquan1.li@intel.com are

crash-export-page_unaccepted_mapcount_value-to-vmcoreinfo.patch

