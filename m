Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6340839FD
	for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2024 16:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714407226; cv=none; b=kXcgUpgqTEKsTsohm2XNdgThtCXZqvRHvqbhlgFTIj9GCWeBLTtZLRYrZI1cyb7PA2NOWlL2YltnCBY3In6qAue5HSu3yc9mdRFF3/+noa8aAl+KGOVMp4iJane8rbFx6svbIz8Bduk75ep2uyb9G1uRNYeAE5d5csNw5aYbKsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714407226; c=relaxed/simple;
	bh=Weho3ETAh2l55nyX2LlFPZYlrxDxFaSZ5vqFhLTC0iE=;
	h=Date:To:From:Subject:Message-Id; b=cU79DODUoHch26OLYh4C2L3aixerCGBYbU14z2/GfTamxW3HxLwsZzKyXMyKJ48xp56C52+0h66katuRpMn2T3FxqtB6Qj7PP0VNK9QHflchpNcc8h+7a1E05b32mZJPGzQfUX+n5S5bax+LBKmGXpxa8sxH7hKAfWAy3Xfe7yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gFLNSqyz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gFLNSqyz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0B7C113CD;
	Mon, 29 Apr 2024 16:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714407226;
	bh=Weho3ETAh2l55nyX2LlFPZYlrxDxFaSZ5vqFhLTC0iE=;
	h=Date:To:From:Subject:From;
	b=gFLNSqyztij5fRTJR0Oznpcg5fvTv5UjlMgtSgesQBw6K1B9WlkZF04hDOmgwwpGi
	 0NisX7jux4oBOCqd20VsVvDiaKkO556OaP50yKjnLPRATntSxrPcm5+ibogMREhuiJ
	 hrccgO3IYbosZIyaK+FJTDPIUDU6hwjL3qx9jTmo=
Date: Mon, 29 Apr 2024 09:13:44 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,elver@google.com,djwong@kernel.org,david@fromorbit.com,andreyknvl@gmail.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmpage_owner-dont-remove-__gfp_nolockdep-in-add_stack_record_to_list.patch added to mm-hotfixes-unstable branch
Message-Id: <20240429161345.EE0B7C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm,page_owner: don't remove __GFP_NOLOCKDEP in add_stack_record_to_list
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mmpage_owner-dont-remove-__gfp_nolockdep-in-add_stack_record_to_list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmpage_owner-dont-remove-__gfp_nolockdep-in-add_stack_record_to_list.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Christoph Hellwig <hch@lst.de>
Subject: mm,page_owner: don't remove __GFP_NOLOCKDEP in add_stack_record_to_list
Date: Mon, 29 Apr 2024 10:28:28 +0200

Otherwise we'll generate false lockdep positives.

Link: https://lkml.kernel.org/r/20240429082828.1615986-1-hch@lst.de
Fixes: 217b2119b9e2 ("mm,page_owner: implement the tracking of the stacks count")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_owner.c~mmpage_owner-dont-remove-__gfp_nolockdep-in-add_stack_record_to_list
+++ a/mm/page_owner.c
@@ -170,7 +170,7 @@ static void add_stack_record_to_list(str
 
 	/* Filter gfp_mask the same way stackdepot does, for consistency */
 	gfp_mask &= ~GFP_ZONEMASK;
-	gfp_mask &= (GFP_ATOMIC | GFP_KERNEL);
+	gfp_mask &= (GFP_ATOMIC | GFP_KERNEL | __GFP_NOLOCKDEP);
 	gfp_mask |= __GFP_NOWARN;
 
 	set_current_in_page_owner();
_

Patches currently in -mm which might be from hch@lst.de are

mmpage_owner-dont-remove-__gfp_nolockdep-in-add_stack_record_to_list.patch

