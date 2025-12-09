Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65754305957
	for <mm-commits@vger.kernel.org>; Tue,  9 Dec 2025 19:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765308380; cv=none; b=DZamnSuDzeYubell5hL1BdLRPYdysjmHD+poMXepAMs15bFRfnGTYxHhVCz9q4kMMBtk5CfCx5wYVSTFLwb4nplo63YQlEBGTpw7eNcI7tjrT7gkx/QZ0iGyYntPacOUf4RAlWvLk9VdRhLunVuw2DQFdD9CZ8e6vZlm4n3OO1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765308380; c=relaxed/simple;
	bh=f2OW9NEWcC0z34g80/2QHTZArXb2kcRGZXD1VxhinT0=;
	h=Date:To:From:Subject:Message-Id; b=s9X97EdCKFDl9QOfSeUMG03PEhhqqsVyITM/bXW7P3FfJBniEaXeSgpEfD5e0YW09YLr2C7GaQU/PNheUgN3lox6vhnmHb8eehAODDUqAzNlIpS7WksOfu2P/p3t8OeCYRErZb+vYH5iSrY/fPd3xgBRzuaaF43R+TnOPhaHtU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gi9/LRiY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gi9/LRiY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2DCAC4CEFB;
	Tue,  9 Dec 2025 19:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765308379;
	bh=f2OW9NEWcC0z34g80/2QHTZArXb2kcRGZXD1VxhinT0=;
	h=Date:To:From:Subject:From;
	b=Gi9/LRiYzqcS5tpw6XHAfKhWCsqtoqcZtAYExQWUScbNFKiKqbruD4tTemdkNZfpN
	 /pcBuzN4qAFFzdiuBILUOttB6U36aWCeQlTxIAHGpq/Eri46xg8VVG9ACpxnNNNGv9
	 YwQnAMOqByF6AiDVxsWstWbnLZkpvZIIeWelmt8w=
Date: Tue, 09 Dec 2025 11:26:19 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,fvdl@google.com,david@kernel.org,guojinhui.liam@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-fix-sparse_vmemmap_init_nid_early-definition-without-config_sparsemem.patch removed from -mm tree
Message-Id: <20251209192619.C2DCAC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse: fix sparse_vmemmap_init_nid_early definition without CONFIG_SPARSEMEM
has been removed from the -mm tree.  Its filename was
     mm-sparse-fix-sparse_vmemmap_init_nid_early-definition-without-config_sparsemem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Jinhui Guo" <guojinhui.liam@bytedance.com>
Subject: mm/sparse: fix sparse_vmemmap_init_nid_early definition without CONFIG_SPARSEMEM
Date: Thu, 27 Nov 2025 17:25:12 +0800

When CONFIG_SPARSEMEM is disabled, the macro
sparse_vmemmap_init_nid_early(_nid, _use) passes two arguments, while the
actual function accepts only nid.  Drop the extra argument _use.

Link: https://lkml.kernel.org/r/20251127092512.278-1-guojinhui.liam@bytedance.com
Fixes: d65917c42373 ("mm/sparse: allow for alternate vmemmap section init at boot")
Signed-off-by: Jinhui Guo <guojinhui.liam@bytedance.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mmzone.h~mm-sparse-fix-sparse_vmemmap_init_nid_early-definition-without-config_sparsemem
+++ a/include/linux/mmzone.h
@@ -2289,7 +2289,7 @@ void sparse_init(void);
 #else
 #define sparse_init()	do {} while (0)
 #define sparse_index_init(_sec, _nid)  do {} while (0)
-#define sparse_vmemmap_init_nid_early(_nid, _use) do {} while (0)
+#define sparse_vmemmap_init_nid_early(_nid) do {} while (0)
 #define sparse_vmemmap_init_nid_late(_nid) do {} while (0)
 #define pfn_in_present_section pfn_valid
 #define subsection_map_init(_pfn, _nr_pages) do {} while (0)
_

Patches currently in -mm which might be from guojinhui.liam@bytedance.com are


