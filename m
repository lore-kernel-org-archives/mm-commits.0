Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCE418643
	for <mm-commits@vger.kernel.org>; Thu, 20 Jun 2024 01:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718847375; cv=none; b=iA8hMDzPTksNctke4doJj+pI7h1N1L1FQXPQVjT0MoMdln/dy2JKSaxwMqxUxE3JCDqqwR/PAEKY9kIs+86cuZB3b7M/6GYkbUdjLtX0IeQ8OZI4qw/721darxnPhsiTEWSCvaF8wB4qRB08A6k+3i8Xyu/aGNcFhbQHN1hPmXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718847375; c=relaxed/simple;
	bh=8UJ0ccfRyNCEK/MOg7lo8sGpR5Wd6yRPxDdRGf1wfUE=;
	h=Date:To:From:Subject:Message-Id; b=VOUyVJOdiybeA6WM+4DPs2oxuEvI6pLxwWorLlN7slpThXQOAtBeZVNVkOCFN1ksMJmKYi5maHny1Jg1AxofikJu8FLkWNfFsUUT38XeFN6t7y2Dic5QIsnY0NDbHx62/LW99kxhzmlkUR32nK3AsXZvacAaOoGRBvsmLHa5HfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O2KKCL2V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O2KKCL2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8EA7C2BBFC;
	Thu, 20 Jun 2024 01:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718847374;
	bh=8UJ0ccfRyNCEK/MOg7lo8sGpR5Wd6yRPxDdRGf1wfUE=;
	h=Date:To:From:Subject:From;
	b=O2KKCL2VqV6TVQkLB4ceahWCD2wT9QseZFJLa1LTlsEMRCgT6y4Wf2p2rjzBthQzO
	 65T3eQV24A+oalhxjbYFc+Tdd6CDO04C8MEk5+MWMdL9GwNdAfKekINpUlUIeRbMG3
	 +zNyJ/BefkZpunq92GUVfsuA3alMkOZ4uw/nRF9g=
Date: Wed, 19 Jun 2024 18:36:14 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-fix-a-typo-in-comment-about-gfp-flag.patch added to mm-unstable branch
Message-Id: <20240620013614.D8EA7C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: fix a typo in comment about GFP flag
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-fix-a-typo-in-comment-about-gfp-flag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-fix-a-typo-in-comment-about-gfp-flag.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/page_alloc: fix a typo in comment about GFP flag
Date: Wed, 19 Jun 2024 01:06:11 +0000

The GFP flags used to choose the zonelist is __GFP_THISNODE.

Let's change it to what exactly it should be.

Link: https://lkml.kernel.org/r/20240619010612.20740-3-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-a-typo-in-comment-about-gfp-flag
+++ a/mm/page_alloc.c
@@ -5239,7 +5239,7 @@ static void build_zonelists_in_node_orde
 }
 
 /*
- * Build gfp_thisnode zonelists
+ * Build __GFP_THISNODE zonelists
  */
 static void build_thisnode_zonelists(pg_data_t *pgdat)
 {
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-mm_initc-print-mem_init-info-after-defer_init-is-done.patch
mm-mm_initc-simplify-logic-of-deferred__pages.patch
mm-mm_initc-simplify-logic-of-deferred__pages-v2.patch
mm-sparse-nr_pages-wont-be-0.patch
mm-mm_initc-move-build-check-on-max_zonelists-out-of-ifdef.patch
mm-page_alloc-fix-a-typo-in-comment-about-gfp-flag.patch
mm-page_alloc-reword-the-comment-of-buddy_merge_likely.patch

