Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C79B232395
	for <mm-commits@vger.kernel.org>; Mon, 20 Oct 2025 18:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760985883; cv=none; b=PTH1vaGUaILkM9w+4k27dsm2ICfF+aaf93Tj9o7DNKV62yOUBfWhbb2n0vKao+llMrB+XlwnN8Q6E7cYmkqzUd4AC/PGePAACN4ljnOJMxBAv6R49uuuZ2eAAlEUMGldOCwv+QIMQmkHfSBuagdbDvA679uGicdGB6U4Abt402c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760985883; c=relaxed/simple;
	bh=JgQEAvnsfCkx3WmkJdH4e1LFb4wDxA2erBKBKQT4QLM=;
	h=Date:To:From:Subject:Message-Id; b=i33N06M3H3rMkvpVGga3btBi9ol4taE9bl8gmuhmo50PLcZrdfPTHebkycyGnpi6XlO/0UEVbmr6eJzzY8agpP/ky9KD+nOsVYeC5k3e2h+moxs71+C08vTQYd89yanjMmxKQ9rZsXz5GKsD/wI6NpY0meIBT31A7pwEDlhomW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K1aMtWhq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K1aMtWhq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E57C113D0;
	Mon, 20 Oct 2025 18:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760985882;
	bh=JgQEAvnsfCkx3WmkJdH4e1LFb4wDxA2erBKBKQT4QLM=;
	h=Date:To:From:Subject:From;
	b=K1aMtWhqnCLFJ9h5ummdg05l5/gzOZ+vm8FUQ8Si7Co6NchIRZHIA/BFzCNclKOVR
	 VR51zLWqp1qha7rA+8zjirqLDX+T7/QH+M/KMGyi5TNYtciiVPJNbg04I8FYkq6vpB
	 YJhEvpe/onIdtbzEn3S/FCsGWTt7dwThYOlNgKic=
Date: Mon, 20 Oct 2025 11:44:41 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,sfr@canb.auug.org.au,bhe@redhat.com,bagasdotme@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vmalloc-separate-gfp_mask-adjunctive-parentheses-in-__vmalloc_node_noprof-kernel-doc-comment.patch added to mm-new branch
Message-Id: <20251020184442.77E57C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vmalloc: separate gfp_mask adjunctive parentheses in __vmalloc_node_noprof() kernel-doc comment
has been added to the -mm mm-new branch.  Its filename is
     vmalloc-separate-gfp_mask-adjunctive-parentheses-in-__vmalloc_node_noprof-kernel-doc-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmalloc-separate-gfp_mask-adjunctive-parentheses-in-__vmalloc_node_noprof-kernel-doc-comment.patch

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
From: Bagas Sanjaya <bagasdotme@gmail.com>
Subject: vmalloc: separate gfp_mask adjunctive parentheses in __vmalloc_node_noprof() kernel-doc comment
Date: Mon, 20 Oct 2025 11:49:33 +0700

Sphinx reports htmldocs warning on __vmalloc_node() comment:

Documentation/core-api/mm-api:52: ./mm/vmalloc.c:4036: WARNING: Inline strong start-string without end-string. [docutils]

Fix it by separating adjunctive parentheses from preceding gfp_mask
formatting markup.

Link: https://lkml.kernel.org/r/20251020044933.15222-1-bagasdotme@gmail.com
Fixes: 32904ba6f5ef ("vmalloc: update __vmalloc_node_noprof() documentation")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/linux-next/20251020134902.3a11107e@canb.auug.org.au/
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Stehen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~vmalloc-separate-gfp_mask-adjunctive-parentheses-in-__vmalloc_node_noprof-kernel-doc-comment
+++ a/mm/vmalloc.c
@@ -4034,7 +4034,7 @@ fail:
  * Allocate enough pages to cover @size from the page level allocator with
  * @gfp_mask flags.  Map them into contiguous kernel virtual space.
  *
- * Semantics of @gfp_mask(including reclaim/retry modifiers such as
+ * Semantics of @gfp_mask (including reclaim/retry modifiers such as
  * __GFP_NOFAIL) are the same as in __vmalloc_node_range_noprof().
  *
  * Return: pointer to the allocated memory or %NULL on error
_

Patches currently in -mm which might be from bagasdotme@gmail.com are

vmalloc-separate-gfp_mask-adjunctive-parentheses-in-__vmalloc_node_noprof-kernel-doc-comment.patch

