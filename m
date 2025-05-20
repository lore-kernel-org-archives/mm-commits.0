Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17DDC1482E8
	for <mm-commits@vger.kernel.org>; Tue, 20 May 2025 02:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747709438; cv=none; b=WrdEYn5owUvelkayljP1NNf4hgdQCIr8S5rDPwDrdwzdmqw9HHp64aHMb+0ljQTMR8RiwAr3WIkpcM00T7m32EPd7fw1hH6PpAxuXeb7UE27DP+YBznPPNDUlonSrDTXTTIVb1m9e9BR2WX5Ejy+a34Ha1duxK5Ey3fBV1lKno8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747709438; c=relaxed/simple;
	bh=psFJsXYuf68MGHHecah94ZEkwIeGqOdJAeSpVycMLT4=;
	h=Date:To:From:Subject:Message-Id; b=bG1O0tPRcMDepdGWw533P5HgFJ6z6VN38Fk3Itp3zRsFpggynpMYjwXpP0ZoBt+6ViBAUQaXp0aTV+k3DAmYYbBuht5GmZot8wNypmBD3z8OCHevh1tbXxl3fySy3IV/+h6oQoHHXY09ShQXoAGxoc08lVBVDlP+q2kEpRxX+8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e/Z3Cvm7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e/Z3Cvm7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6ADC4CEED;
	Tue, 20 May 2025 02:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747709437;
	bh=psFJsXYuf68MGHHecah94ZEkwIeGqOdJAeSpVycMLT4=;
	h=Date:To:From:Subject:From;
	b=e/Z3Cvm7icxjoUepFEEiTnOEP8/ZBkxqTeauXQwFmRHwm/CmMXWAV/Twtv2hvrXtD
	 PqbDUm29alLVYwXDjvFDCokmXKcr699kJZvTU4PopSEH4VzqQSwhkGD8JE+pPqj70v
	 6xdu7pXqbqKYWq19kwSvHTDZhd7XYLlJZd+UYgdM=
Date: Mon, 19 May 2025 19:50:35 -0700
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,vitaly.wool@konsulko.se,shakeel.butt@linux.dev,nphamcs@gmail.com,igor.b@beldev.am,hannes@cmpxchg.org,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-zblock-allocator-fix-2-fix.patch added to mm-new branch
Message-Id: <20250520025037.7E6ADC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-add-zblock-allocator-fix-2-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-add-zblock-allocator-fix-2-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-zblock-allocator-fix-2-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-zblock-allocator-fix-2-fix
Date: Mon May 19 07:37:22 PM PDT 2025

try_alloc_pages() was renamed

Cc: David Hildenbrand <david@redhat.com>
Cc: Igor Belousov <igor.b@beldev.am>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-add-zblock-allocator-fix-2-fix
+++ a/mm/page_alloc.c
@@ -7423,4 +7423,4 @@ struct page *alloc_pages_nolock_noprof(i
 	kmsan_alloc_page(page, order, alloc_gfp);
 	return page;
 }
-EXPORT_SYMBOL_GPL(try_alloc_pages_noprof);
+EXPORT_SYMBOL_GPL(alloc_pages_nolock_noprof);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-add-zblock-allocator-fix.patch
mm-add-zblock-allocator-fix-2.patch
mm-add-zblock-allocator-fix-2-fix.patch
mm-add-zblock-allocator-fix-3.patch
mm-zblock-avoid-failing-the-build-fix.patch
revert-x86-mm-remove-unused-__set_memory_prot-fix.patch

