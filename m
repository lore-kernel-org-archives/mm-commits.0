Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F672EB10
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011342; cv=none; b=Kzp1plnmJsmm2gN4zU9R4AEXkzg9K693542lxSyN3BbNOUduK90E7BihMB+TKy3Mlt7AFJQyrW+9bE0rsgG1iRNKtd68dTrKhtlaebNB6AeSbIfWNRX3/iLzuzzFFmZIzl8R8DE3Pm5D6rbDjtVzxEWi8DKFkyZUPR3ov49T84I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011342; c=relaxed/simple;
	bh=UmrfJ8oIANy/jXoXruyAnIhR/oCM+YrEoZZAwOhYi6I=;
	h=Date:To:From:Subject:Message-Id; b=C9lQU3nOj7BLksMJV8tJPFx7r+zv6ZWDsQAzKkXewRg0l3AP0vtQmmVDESpiN/c/lnDMyyD3RQew7fDGJt6nZtnyBod68qMHc602TezaWEJ12XA+ICfd7CG8k6pC7A5iDS1IQze9M6q3V6czgtR1jVvqHtwkPsGdYm9y2R6VwoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j5yj2P2y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j5yj2P2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC283C4CEF0;
	Mon, 12 May 2025 00:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011340;
	bh=UmrfJ8oIANy/jXoXruyAnIhR/oCM+YrEoZZAwOhYi6I=;
	h=Date:To:From:Subject:From;
	b=j5yj2P2ynyaf/GiG8ddHnYthZinnXSlnRh7LQO1i8KNNsFQnVWHttnuDrR+y7PbMl
	 XWstY5qbOCgMhOQH9hC4jn2ldsF7HTlD7Fqc9M0HCq1CJyluGWIYj3l2FFPVKcaA+2
	 Xcp6fuFP2Ogy3hDagLoVLuALnFWjSdKch42F8lT0=
Date: Sun, 11 May 2025 17:55:40 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,kirill.shutemov@linux.intel.com,dyoung@redhat.com,bhe@redhat.com,zhiquan1.li@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] crash-export-page_unaccepted_mapcount_value-to-vmcoreinfo.patch removed from -mm tree
Message-Id: <20250512005540.DC283C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: crash: export PAGE_UNACCEPTED_MAPCOUNT_VALUE to vmcoreinfo
has been removed from the -mm tree.  Its filename was
     crash-export-page_unaccepted_mapcount_value-to-vmcoreinfo.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhiquan Li <zhiquan1.li@intel.com>
Subject: crash: export PAGE_UNACCEPTED_MAPCOUNT_VALUE to vmcoreinfo
Date: Thu, 3 Apr 2025 11:08:01 +0800

On Intel TDX guest, unaccepted memory is unusable free memory which is not
managed by buddy, until it's accepted by guest.  Before that, it cannot be
accessed by the first kernel as well as the kexec'ed kernel.  The kexec'ed
kernel will skip these pages and fill in zero data for the reader of
vmcore.

The dump tool like makedumpfile creates a page descriptor (size 24 bytes)
for each non-free page, including zero data page, but it will not create
descriptor for free pages.  If it is not able to distinguish these
unaccepted pages with zero data pages, a certain amount of space will be
wasted in proportion (~1/170).  In fact, as a special kind of free page
the unaccepted pages should be excluded, like the real free pages.

Export the page type PAGE_UNACCEPTED_MAPCOUNT_VALUE to vmcoreinfo, so that
dump tool can identify whether a page is unaccepted.

[zhiquan1.li@intel.com: fix docs: "Title underline too short" warning]
  Link: https://lore.kernel.org/all/20240809114854.3745464-5-kirill.shutemov@linux.intel.com/
  Link: https://lkml.kernel.org/r/20250405060610.860465-1-zhiquan1.li@intel.com
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

 Documentation/admin-guide/kdump/vmcoreinfo.rst |    4 ++--
 kernel/vmcore_info.c                           |    4 ++++
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/kdump/vmcoreinfo.rst~crash-export-page_unaccepted_mapcount_value-to-vmcoreinfo
+++ a/Documentation/admin-guide/kdump/vmcoreinfo.rst
@@ -331,8 +331,8 @@ PG_lru|PG_private|PG_swapcache|PG_swapba
 Page attributes. These flags are used to filter various unnecessary for
 dumping pages.
 
-PAGE_BUDDY_MAPCOUNT_VALUE(~PG_buddy)|PAGE_OFFLINE_MAPCOUNT_VALUE(~PG_offline)
------------------------------------------------------------------------------
+PAGE_BUDDY_MAPCOUNT_VALUE(~PG_buddy)|PAGE_OFFLINE_MAPCOUNT_VALUE(~PG_offline)|PAGE_OFFLINE_MAPCOUNT_VALUE(~PG_unaccepted)
+-------------------------------------------------------------------------------------------------------------------------
 
 More page attributes. These flags are used to filter various unnecessary for
 dumping pages.
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


