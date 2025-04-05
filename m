Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE6D1A3172
	for <mm-commits@vger.kernel.org>; Sat,  5 Apr 2025 22:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743892670; cv=none; b=i0SRN0PoPFz6Ux+WobTTEhnjUy9hAbsPdVtnW9MvIFT2m+xHWqZkQj+G5ktRXB3dKrIshCp8+atIgm6qbt0FInS1H1MGoEDV9sYVAdwA+EgxiySAEnmxQ8uBLM8sJ+CSWCaIwwc2jRfWJJp/uppkbbzUlksNlTXJ8bakJd6oTcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743892670; c=relaxed/simple;
	bh=zxWem8+val+uMOKrfC0Blbh4YjdZxZqetRoqHmr9IWA=;
	h=Date:To:From:Subject:Message-Id; b=ojN5inSt911uq3ukg9vymslkHtPX5nGMElfJMfm3l6p6382qph5vxLwQO7/J2INjql39AohaAttftOunIbRTpi2q2tkYAzIdhOm8ses7s0mvuKSdl6wZxi8Zaa1sVw99RzN3Wqzw0VpkZdtBxKY7BeL+ef/04yoM1VVKgjcvD8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wgwy+H2M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wgwy+H2M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3138BC4CEE4;
	Sat,  5 Apr 2025 22:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743892670;
	bh=zxWem8+val+uMOKrfC0Blbh4YjdZxZqetRoqHmr9IWA=;
	h=Date:To:From:Subject:From;
	b=wgwy+H2MXzFyeobAzSYMw9aWcpZi0rGHUOcoHaTUD4eENwQZuhfmnKdp/bCxZFgkn
	 07bbYttScY6VPTtU9vbD4L7b3zP00dpPlxN+YVfqY+csV1YWc6pUsYBwfEKkdReWtw
	 qEVXbMYJoTGbCcj3LHI2AGXZ90a/NEjL+QMLpiPs=
Date: Sat, 05 Apr 2025 15:37:49 -0700
To: mm-commits@vger.kernel.org,kirill.shutemov@linux.intel.com,bhe@redhat.com,zhiquan1.li@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crash-export-page_unaccepted_mapcount_value-to-vmcoreinfo-v3.patch added to mm-nonmm-unstable branch
Message-Id: <20250405223750.3138BC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crash: Export PAGE_UNACCEPTED_MAPCOUNT_VALUE to vmcoreinfo
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     crash-export-page_unaccepted_mapcount_value-to-vmcoreinfo-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash-export-page_unaccepted_mapcount_value-to-vmcoreinfo-v3.patch

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
Subject: crash: Export PAGE_UNACCEPTED_MAPCOUNT_VALUE to vmcoreinfo
Date: Sat, 5 Apr 2025 14:06:10 +0800

fix docs: "Title underline too short" warning

Link: https://lore.kernel.org/all/20240809114854.3745464-5-kirill.shutemov@linux.intel.com/
Link: https://lkml.kernel.org/r/20250405060610.860465-1-zhiquan1.li@intel.com
Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kdump/vmcoreinfo.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/kdump/vmcoreinfo.rst~crash-export-page_unaccepted_mapcount_value-to-vmcoreinfo-v3
+++ a/Documentation/admin-guide/kdump/vmcoreinfo.rst
@@ -332,7 +332,7 @@ Page attributes. These flags are used to
 dumping pages.
 
 PAGE_BUDDY_MAPCOUNT_VALUE(~PG_buddy)|PAGE_OFFLINE_MAPCOUNT_VALUE(~PG_offline)|PAGE_OFFLINE_MAPCOUNT_VALUE(~PG_unaccepted)
------------------------------------------------------------------------------
+-------------------------------------------------------------------------------------------------------------------------
 
 More page attributes. These flags are used to filter various unnecessary for
 dumping pages.
_

Patches currently in -mm which might be from zhiquan1.li@intel.com are

crash-export-page_unaccepted_mapcount_value-to-vmcoreinfo.patch
crash-export-page_unaccepted_mapcount_value-to-vmcoreinfo-v3.patch

