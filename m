Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044912B9BF
	for <mm-commits@vger.kernel.org>; Sun, 11 May 2025 04:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746938363; cv=none; b=Y/6qUYs2+peIBfbF4tGUV27YeADJm1S03Kbsjd1joAsQ/CWBdisQsVREPHjTDmZIh2LZsjOfa3A9zIGDBBo3rVcuwDjMC5tJyQZwzwtycpmFpdbG6oEMIFuau5P7EM+OMU6w9tYxBnMbnS+NUraAgZWFNEdP6RuiyXWHSyYOgx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746938363; c=relaxed/simple;
	bh=ydoKpj5x6GwsMb9anvhQTf+7iLYXzis4ibMOhuI9pj0=;
	h=Date:To:From:Subject:Message-Id; b=oDOOTcRkQ26I9O/s5jsh6rbuHWadsnZ6qcYxQshj8woNYwtprGS/1eOgBd4KdNS59aAJR3YPFnpjnENAmsQfUCAHz8w6GMuiulodoF+lpREkEMLafQrGYy4h13layVeiF1O+SDpklBBrV8dd4qO5uftyBzAyhxWBao9OZGL4bKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IzS84OsN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IzS84OsN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5295CC4CEE4;
	Sun, 11 May 2025 04:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746938362;
	bh=ydoKpj5x6GwsMb9anvhQTf+7iLYXzis4ibMOhuI9pj0=;
	h=Date:To:From:Subject:From;
	b=IzS84OsN3R6T6VLNE+Mk9nmGjGJZxVVQnDhaT8gnUCGA6C3fHsdVaoF1CdItAR8IP
	 r9HWuI0zghAO1VYVXX5g/k062Nmi1pozvIzkLQOxxWmu+rU79z60IFN7Q31ZzUMaoP
	 hun4WAQRQ+d6FXevE5xmaXuyh1JXApSrrwYjU7io=
Date: Sat, 10 May 2025 21:39:21 -0700
To: mm-commits@vger.kernel.org,kirill.shutemov@linux.intel.com,bhe@redhat.com,zhiquan1.li@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] crash-export-page_unaccepted_mapcount_value-to-vmcoreinfo-v3.patch removed from -mm tree
Message-Id: <20250511043922.5295CC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: crash: export PAGE_UNACCEPTED_MAPCOUNT_VALUE to vmcoreinfo
has been removed from the -mm tree.  Its filename was
     crash-export-page_unaccepted_mapcount_value-to-vmcoreinfo-v3.patch

This patch was dropped because it was folded into crash-export-page_unaccepted_mapcount_value-to-vmcoreinfo.patch

------------------------------------------------------
From: Zhiquan Li <zhiquan1.li@intel.com>
Subject: crash: export PAGE_UNACCEPTED_MAPCOUNT_VALUE to vmcoreinfo
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

