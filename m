Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69313FBF6
	for <mm-commits@vger.kernel.org>; Thu,  4 Jul 2024 05:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720071720; cv=none; b=Ro995TrAJY30llE+gbpeXuhSvNfQ2QOtI1vduPBIFhs2Wa4e3gyPU2gbEZW9Mq1Ra8bqEAjTHVloCImisRJ57AcC5nqiFGyef2hkizXj/EVfhHOgmfgav+dnFp5z80SjmWZ3I3ReUwgymk5R6fszzPheHstgMHOG7nzYZeauHGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720071720; c=relaxed/simple;
	bh=nW4cFEMkW+Jpu0Doe6CLqrJR8oYkoUyBSiRqUTXIKRw=;
	h=Date:To:From:Subject:Message-Id; b=WzqOcIMdTbysGkpnooBgqLcoIkyeowlfIzWK+pEgUs5zaVHoMp6B5X1LspWk+YRBFJlEVhhpJJh3DzUDqVwEVoNV9oPYDd4RMD2CVXw4nLCJoL9LxIG7m2hS3JozVMB4Gixo+OIyaXLvYU6+EMkj9femSK3lmTxEDJMMqteY3wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YFnAws9h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YFnAws9h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE7AC4AF0D;
	Thu,  4 Jul 2024 05:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720071720;
	bh=nW4cFEMkW+Jpu0Doe6CLqrJR8oYkoUyBSiRqUTXIKRw=;
	h=Date:To:From:Subject:From;
	b=YFnAws9hmVffvzsSbxKtS6K2JU1qsNwR1JwVJ7gsbd30I57TGTi1nGfghp1NMKoUt
	 ylMfwYL3smelQkQ4pq+Ras9AKIterzqKVfnnCyS+XEJVxcgBB8W5PXZVvNCpSMQAJE
	 5QcT/HB765XZiMEWDY4zxZAq2GXplF0t001N8Hws=
Date: Wed, 03 Jul 2024 22:41:59 -0700
To: mm-commits@vger.kernel.org,quic_charante@quicinc.com,longman@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-prevent-derefencing-null-ptr-in-pfn_section_valid.patch removed from -mm tree
Message-Id: <20240704054159.DDE7AC4AF0D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: prevent derefencing NULL ptr in pfn_section_valid()
has been removed from the -mm tree.  Its filename was
     mm-prevent-derefencing-null-ptr-in-pfn_section_valid.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm: prevent derefencing NULL ptr in pfn_section_valid()
Date: Tue, 25 Jun 2024 20:16:39 -0400

Commit 5ec8e8ea8b77 ("mm/sparsemem: fix race in accessing
memory_section->usage") changed pfn_section_valid() to add a READ_ONCE()
call around "ms->usage" to fix a race with section_deactivate() where
ms->usage can be cleared.  The READ_ONCE() call, by itself, is not enough
to prevent NULL pointer dereference.  We need to check its value before
dereferencing it.

Link: https://lkml.kernel.org/r/20240626001639.1350646-1-longman@redhat.com
Fixes: 5ec8e8ea8b77 ("mm/sparsemem: fix race in accessing memory_section->usage")
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Charan Teja Kalla <quic_charante@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/mmzone.h~mm-prevent-derefencing-null-ptr-in-pfn_section_valid
+++ a/include/linux/mmzone.h
@@ -1979,8 +1979,9 @@ static inline int subsection_map_index(u
 static inline int pfn_section_valid(struct mem_section *ms, unsigned long pfn)
 {
 	int idx = subsection_map_index(pfn);
+	struct mem_section_usage *usage = READ_ONCE(ms->usage);
 
-	return test_bit(idx, READ_ONCE(ms->usage)->subsection_map);
+	return usage ? test_bit(idx, usage->subsection_map) : 0;
 }
 #else
 static inline int pfn_section_valid(struct mem_section *ms, unsigned long pfn)
_

Patches currently in -mm which might be from longman@redhat.com are


