Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7981A10A24
	for <mm-commits@vger.kernel.org>; Sat,  7 Sep 2024 03:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725679052; cv=none; b=J3f2MXu2/VzkePmdxtf31LXfT0ffEMpBJXCwQwx8opHxGfpKOeVwP4TPpjdH909q0EXwFHBlh3lgCfVK4IkUbU/KOUWXDYNvR+2jmuUkRQY4lrUwdaDD4gRF45lPeO500cJgQ1lnL+MW3gxleodmYHkEOBLL7OigzjYiTeLMfHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725679052; c=relaxed/simple;
	bh=cE/D/5kIM+ansJWemtg+8dyrMUpTv3x90epfJKCdp0A=;
	h=Date:To:From:Subject:Message-Id; b=T8yptsF8wsQzQgz+fFAdeMyhE2WP0yEUGRiMKZ80ZIz9a8RAVgOe2Q9r2m+xOhxXpXjjaRlG81EQSRT44pf+mOWQwn3puhGM6q64K/UWYHg9urvO66CLFhOwPqWKiYn+agY0lzJH+XnXXDuShsv6K0EsK+LR6BSHXiI/fT1uRGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KQH/z+U8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KQH/z+U8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5AEBC4CEC2;
	Sat,  7 Sep 2024 03:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725679052;
	bh=cE/D/5kIM+ansJWemtg+8dyrMUpTv3x90epfJKCdp0A=;
	h=Date:To:From:Subject:From;
	b=KQH/z+U80oN3v3LkPaccJ2tNtJKom0JF4PSiEi+yMO4imdgPxg3LGDxk3xdgkFo3X
	 +J4YD8Z7q6F1YV6qiGZflwSTrCLaJmns7Q7Pbm3QNAGe/m9z2w87pE/7ye4d/dn1X2
	 gkfeEyH3wS7IoMVT46VwPckFMmw3iMHaLTcSXLMA=
Date: Fri, 06 Sep 2024 20:17:31 -0700
To: mm-commits@vger.kernel.org,oleksiy.avramchenko@sony.com,mhocko@suse.com,hch@infradead.org,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmallocc-use-high-order-in-description-non-0-order-pages.patch added to mm-unstable branch
Message-Id: <20240907031731.E5AEBC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc.c: use "high-order" in description non 0-order pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmallocc-use-high-order-in-description-non-0-order-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmallocc-use-high-order-in-description-non-0-order-pages.patch

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
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc.c: use "high-order" in description non 0-order pages
Date: Fri, 6 Sep 2024 11:50:49 +0200

In many places, in the comments, we use both "higher-order" and
"high-order" to describe the non 0-order pages.  That is confusing,
because a "higher-order" statement does not reflect what it is compared
with.

Link: https://lkml.kernel.org/r/20240906095049.3486-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Suggested-by: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmallocc-use-high-order-in-description-non-0-order-pages
+++ a/mm/vmalloc.c
@@ -3589,7 +3589,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 			break;
 
 		/*
-		 * Higher order allocations must be able to be treated as
+		 * High-order allocations must be able to be treated as
 		 * independent small pages by callers (as they can with
 		 * small-page vmallocs). Some drivers do their own refcounting
 		 * on vmalloc_to_page() pages, some use page->mapping,
@@ -3652,7 +3652,7 @@ static void *__vmalloc_area_node(struct
 	page_order = vm_area_page_order(area);
 
 	/*
-	 * Higher order nofail allocations are really expensive and
+	 * High-order nofail allocations are really expensive and
 	 * potentially dangerous (pre-mature OOM, disruptive reclaim
 	 * and compaction etc.
 	 *
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmallocc-use-high-order-in-description-non-0-order-pages.patch

