Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3844F1EC01C
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 00:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725408044; cv=none; b=pQOklUYQydNf4IWB/JZHcON150abbdNMZvPhtFSj9MjFhE+h95h1abi2CREIxkXmU61YHfOZSqiFWDd46apcRTh+Ln6q3PU2eymlkI5TXFlYOk0DZIxeRyJU/MTAcCZYrHhzs2LyTFFPWvUVx00KqJRJEuwsDn16UlKtXrbxuyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725408044; c=relaxed/simple;
	bh=pI+tkEqsnIGaBEHife1AtzDY4+3+2JAG+FnQQZNb3Wc=;
	h=Date:To:From:Subject:Message-Id; b=S01hJiAd8yPBjk7WQy84suhyMouX+0Mnxb0Zw5l+DlxWx9ZZ3FvHFCvEZ9WLq5AADFB13vAo8pDiWTrB6mu5izs7uKfT3M4tagQQo8E4WDDtt0G8sHahVVEsa6w3FVgaI2eeBM4tfFDHCZa4s3ad8oJ2nqFLB72LHwdOhMU97UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JqHfkpT8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JqHfkpT8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB99C4CEC4;
	Wed,  4 Sep 2024 00:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725408043;
	bh=pI+tkEqsnIGaBEHife1AtzDY4+3+2JAG+FnQQZNb3Wc=;
	h=Date:To:From:Subject:From;
	b=JqHfkpT8Ci7b03ooaXIhVAX73g9if4puGI0zQ29RnQujQXprdyWfdUpj5VWZcQNM3
	 Q8VZq3PCsgBNo4qnck4zpsJJU7mSAXiuLIcUpI9NfrBTbfQYVLiV4BXfhbHDdCjp43
	 bkG45mQxRV8yYcJANqNz8Dt9hrbTcJ9Ev335oz6U=
Date: Tue, 03 Sep 2024 17:00:42 -0700
To: mm-commits@vger.kernel.org,mhocko@suse.com,david@redhat.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-warn-about-illegal-__gfp_nofail-usage-in-a-more-appropriate-location-and-manner-fix.patch added to mm-unstable branch
Message-Id: <20240904000043.9FB99C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: also update the doc for __GFP_NOFAIL with order > 1
has been added to the -mm mm-unstable branch.  Its filename is
     mm-warn-about-illegal-__gfp_nofail-usage-in-a-more-appropriate-location-and-manner-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-warn-about-illegal-__gfp_nofail-usage-in-a-more-appropriate-location-and-manner-fix.patch

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
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: also update the doc for __GFP_NOFAIL with order > 1
Date: Wed, 4 Sep 2024 10:26:19 +1200

Obviously we only support order <= 1 __GFP_NOFAIL allocation and if
someone wants larger memory, they should consider using kvmalloc()
instead.

Link: https://lkml.kernel.org/r/20240903223935.1697-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp_types.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/gfp_types.h~mm-warn-about-illegal-__gfp_nofail-usage-in-a-more-appropriate-location-and-manner-fix
+++ a/include/linux/gfp_types.h
@@ -253,7 +253,8 @@ enum {
  * used only when there is no reasonable failure policy) but it is
  * definitely preferable to use the flag rather than opencode endless
  * loop around allocator.
- * Using this flag for costly allocations is _highly_ discouraged.
+ * Allocating pages from the buddy with __GFP_NOFAIL and order > 1 is
+ * not supported. Please consider using kvmalloc() instead.
  */
 #define __GFP_IO	((__force gfp_t)___GFP_IO)
 #define __GFP_FS	((__force gfp_t)___GFP_FS)
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-rename-instances-of-swap_info_struct-to-meaningful-si.patch
mm-attempt-to-batch-free-swap-entries-for-zap_pte_range.patch
mm-attempt-to-batch-free-swap-entries-for-zap_pte_range-fix.patch
mm-count-the-number-of-anonymous-thps-per-size.patch
mm-count-the-number-of-partially-mapped-anonymous-thps-per-size.patch
mm-document-__gfp_nofail-must-be-blockable.patch
mm-warn-about-illegal-__gfp_nofail-usage-in-a-more-appropriate-location-and-manner.patch
mm-warn-about-illegal-__gfp_nofail-usage-in-a-more-appropriate-location-and-manner-fix.patch

