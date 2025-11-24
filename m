Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE702F7456
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025841; cv=none; b=lxtQScO7VyPOX4pRJpZneAQ1DmKeVPWTn/MPYtu60hFoC4aKg0e1stl9E3kqgfSa9LmpILrZDNNYFQ7i6ekpVIihfg0kFdV4bxbZhBbDqwoJLQLylRG7/DwX314pKVRLQbRU8XuHvx7MzYoyJRMuGtBlTkLIqadGlGmH3RzxN2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025841; c=relaxed/simple;
	bh=8oPPx6XFokHzg5ScASJaG2XHuUqyf/hMO84eZGH3ZlQ=;
	h=Date:To:From:Subject:Message-Id; b=BszlBxseeUGs0uOGHuulUNvEc7nrAoZFfjsKV3eU4lRexsbvuLvoWehzKnS1aoVz4jgdgzN+qsLkaPldxDxLp2VviOXQdq4vxIPrjsloCCFaQdxytig9+knpgfSBvzc7ppLJlZheYtFQGphcuY6FGvUrkTs/NOnF5FAZJpijqrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lJahTYRT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lJahTYRT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B0CC116D0;
	Mon, 24 Nov 2025 23:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025840;
	bh=8oPPx6XFokHzg5ScASJaG2XHuUqyf/hMO84eZGH3ZlQ=;
	h=Date:To:From:Subject:From;
	b=lJahTYRTOiCYmc+sFHUkugvy+VjY51d55Os4ChZ36code206ak0HsiYshHiQ3BMjf
	 yDLMlcQGdbiEEKNp8ay4BFpj09zFKaTslCQzXBf0kgFia8hQU+modmOVL7nweQH7TA
	 JPgXT/m4oQaFSuOam5OK3jZDqkjRyC0FqdNN6JTs=
Date: Mon, 24 Nov 2025 15:10:40 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,rostedt@goodmis.org,npache@redhat.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-continue-to-collapse-on-scan_pmd_none.patch removed from -mm tree
Message-Id: <20251124231040.C2B0CC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: continue to collapse on SCAN_PMD_NONE
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-continue-to-collapse-on-scan_pmd_none.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/khugepaged: continue to collapse on SCAN_PMD_NONE
Date: Fri, 14 Nov 2025 03:00:27 +0000

SCAN_PMD_NONE means current pmd is empty, but we can still continue
collapse next pmd range.

Link: https://lkml.kernel.org/r/20251114030028.7035-3-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Barry Song <baohua@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/khugepaged.c~mm-khugepaged-continue-to-collapse-on-scan_pmd_none
+++ a/mm/khugepaged.c
@@ -2833,6 +2833,7 @@ handle_result:
 			goto handle_result;
 		/* Whitelisted set of results where continuing OK */
 		case SCAN_PMD_NULL:
+		case SCAN_PMD_NONE:
 		case SCAN_PTE_NON_PRESENT:
 		case SCAN_PTE_UFFD_WP:
 		case SCAN_LACK_REFERENCED_PAGE:
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


