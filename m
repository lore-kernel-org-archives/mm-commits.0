Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C02130495
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725924850; cv=none; b=O5Omrq0xOmSlys3PhwfxixvnVrM+pXwAV8aF1Ihip+98GcwY1KTReOTbqLBGus/PbYp+ersci3RqpaV3yZKV+ibrEkCeuqPXI0Sa17S2fp6u/LdYSEv5tAn3LJZ7uB+x+vOkaeQllYhcnu8jSGbw6WzMA2eo9+ldedi1wpDfYYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725924850; c=relaxed/simple;
	bh=1Gtw3epo1o7aoMJL5HqYXNNqyLkFBbCkgb8ByOihYA0=;
	h=Date:To:From:Subject:Message-Id; b=JjiXT/o96cpTgDz7qAVbTinaMwoY43Y6f03eSTAoWcmwvbwkOWCpkDn1ItzZiQVEtSY8uBIHp8h6w8OyzDt6e5194sRQirSe3GiNefz5vwZdz7JKwoGYwlreRrK+sSqWU12XHGCbNLm/lh3vT8fzTKME6KeI5syKZiaXur3c6HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TK4TvplK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TK4TvplK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B46CC4CEC5;
	Mon,  9 Sep 2024 23:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725924850;
	bh=1Gtw3epo1o7aoMJL5HqYXNNqyLkFBbCkgb8ByOihYA0=;
	h=Date:To:From:Subject:From;
	b=TK4TvplK+Dagaq51UY2ZGscnqZTOcipkl/tr/LrC4y0+3JzafbOslMqfQgB4gmFMn
	 ziYYFMbiImnfiLCJrlMSWSyFES7v5G9OcPkyWS17rzpuGGQ3uvz4oHfECMYAZuQnwL
	 E9wjcJ2YO6FXzlBePrDVw2AR5CC2DbONGhmPIT2M=
Date: Mon, 09 Sep 2024 16:34:09 -0700
To: mm-commits@vger.kernel.org,mhocko@suse.com,david@redhat.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-warn-about-illegal-__gfp_nofail-usage-in-a-more-appropriate-location-and-manner-fix.patch removed from -mm tree
Message-Id: <20240909233410.1B46CC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: also update the doc for __GFP_NOFAIL with order > 1
has been removed from the -mm tree.  Its filename was
     mm-warn-about-illegal-__gfp_nofail-usage-in-a-more-appropriate-location-and-manner-fix.patch

This patch was dropped because it was folded into mm-warn-about-illegal-__gfp_nofail-usage-in-a-more-appropriate-location-and-manner.patch

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

mm-count-the-number-of-anonymous-thps-per-size.patch
mm-count-the-number-of-partially-mapped-anonymous-thps-per-size.patch
mm-document-__gfp_nofail-must-be-blockable.patch
mm-warn-about-illegal-__gfp_nofail-usage-in-a-more-appropriate-location-and-manner.patch

