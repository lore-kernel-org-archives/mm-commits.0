Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B20834545
	for <mm-commits@vger.kernel.org>; Mon, 16 Jun 2025 23:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750116174; cv=none; b=joQSe4yXtc8bhUYAmVAHxht1oLkdUeQ6hMiAaZ4VuTFDBTH+UIYwsttqfhpZkztv70J/Jdbk9dnjW5uprK2TmJ2WE3V+YodaV/sVQypBiFWA/6XjKWqJ87oLBNr3Ayj1ek/m4psehuSHMnIcc11NGc7DApbKM/ua4dpAitCjSKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750116174; c=relaxed/simple;
	bh=AcnI/tsYcxgNCmC4I/PW9dmmlku91/JeRq2/n3ris+s=;
	h=Date:To:From:Subject:Message-Id; b=MFTSJHuqHYrdpztPdfS4W/MRMmisEFQd6LhdevdQ/qtzJUjqm/zrInodnicO3dnRFgdZQU6hLd0bUIj92v3qzRUwy7EmWVqND95VwzDhFIeYls0djUUsXM7rFQ4AQE+TTOqLNJsmJT7rfeGyLFM8J90B1/8mwhVFA15aS9pCdb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pEuA5V4o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pEuA5V4o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61B1C4CEEA;
	Mon, 16 Jun 2025 23:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750116173;
	bh=AcnI/tsYcxgNCmC4I/PW9dmmlku91/JeRq2/n3ris+s=;
	h=Date:To:From:Subject:From;
	b=pEuA5V4oRIZ+uqa+HWmm/LPTXU3nh/KKr4qPVpJHsTRb8W6vm236orIaAvFigIfG7
	 ueHNCCZeBhLcytDir9wNsZ0Rj1m2OgubZ0iqcI0C4E521V5RSuuQn95+hLlwANn15V
	 WYr94foD0PuI6D3pfIQt+WfFZvUw2EcsKbmSsjKA=
Date: Mon, 16 Jun 2025 16:22:53 -0700
To: mm-commits@vger.kernel.org,zhangpeng.00@bytedance.com,willy@infradead.org,surenb@google.com,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,howlett@gmail.com,hailong.liu@oppo.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-radix-tree-test-maple-tree-chaining-mas_preallocate-calls.patch added to mm-new branch
Message-Id: <20250616232253.C61B1C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/testing/radix-tree: test maple tree chaining mas_preallocate() calls
has been added to the -mm mm-new branch.  Its filename is
     tools-testing-radix-tree-test-maple-tree-chaining-mas_preallocate-calls.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-radix-tree-test-maple-tree-chaining-mas_preallocate-calls.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: tools/testing/radix-tree: test maple tree chaining mas_preallocate() calls
Date: Mon, 16 Jun 2025 14:45:21 -0400

Testing calling multiple mas_preallocate() calls in a row after adjusting
the maple state.  Ensures new calls to mas_preallocate() will change the
number of allocated nodes.

Link: https://lkml.kernel.org/r/20250616184521.3382795-4-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Hailong Liu <hailong.liu@oppo.com>
Cc: "Liam R. Howlett" <howlett@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/maple.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/tools/testing/radix-tree/maple.c~tools-testing-radix-tree-test-maple-tree-chaining-mas_preallocate-calls
+++ a/tools/testing/radix-tree/maple.c
@@ -35693,6 +35693,18 @@ static noinline void __init check_preall
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
 	MT_BUG_ON(mt, allocated != 0);
+
+	/* Chaining multiple preallocations */
+	mt_set_in_rcu(mt);
+	mas_set_range(&mas, 800, 805); /* Slot store, should be 0 allocations */
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
+	allocated = mas_allocated(&mas);
+	MT_BUG_ON(mt, allocated != 0);
+	mas.last = 809; /* Node store */
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
+	allocated = mas_allocated(&mas);
+	MT_BUG_ON(mt, allocated != 1);
+	mas_store_prealloc(&mas, ptr);
 }
 /* End of preallocation testing */
 
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-fix-ma_state_prealloc-flag-in-mas_preallocate.patch
tools-testing-radix-tree-test-maple-tree-chaining-mas_preallocate-calls.patch

