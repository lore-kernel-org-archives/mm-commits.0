Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741312AF0A
	for <mm-commits@vger.kernel.org>; Tue, 15 Apr 2025 01:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744679108; cv=none; b=fByYaP1vRy3l3Zz2Ds9gP+aoRwYVhtzqq4z2nQres0eaZmvJsPN0QZiT7ZKwOWp8UJie3CW6rzVVlaZ9q7WdTyeGJ9ptoBIEnWNt8eR9Wqb5b5BxyJfT9iWzux9Lwqn5S2Qy0sZ0IAjcp9zUQX374DvWWfj3R0mLdgjaXa5oL8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744679108; c=relaxed/simple;
	bh=nYOgMxYPVhKgVSZJ7TjFTI0uNk/6ZikUil8BnyvfvSQ=;
	h=Date:To:From:Subject:Message-Id; b=sRY/+2zqC7nPviRAAmFB+Vsh2E1GkDjpaFlu+oDB8gHoidADqQ/jI3MnZ/WuSdXkA26lMFk7aB/H6iuGO6QfW7Yd4bAcE4VfIT+xc9uVRnjssXN4jk8G5mLedOS1nLN5cQfE7usDPlF09tEFA5aUsPWWRtLUBmHvgB2ZyVoLDFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J1nRYVLe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J1nRYVLe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17A3C4CEE2;
	Tue, 15 Apr 2025 01:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744679107;
	bh=nYOgMxYPVhKgVSZJ7TjFTI0uNk/6ZikUil8BnyvfvSQ=;
	h=Date:To:From:Subject:From;
	b=J1nRYVLe/uRQdPjSEnPfdHj2Bwi1iVvgI3faYJjCK4HuSYcDbZlQBvdHm5xPNeyym
	 VbP1N7tzH8V6TwZeqEQUT7wXop9SEWvHlhgOlgnUdndZ3sE/ha3wLnK4KHma7TYJ82
	 uZmskuA1hqd3oXMwZwXc3mBUINTDJLTDiIma/avU=
Date: Mon, 14 Apr 2025 18:05:07 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,surenb@google.com,rppt@kernel.org,david@redhat.com,baohua@kernel.org,gaoxu2@honor.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-nr_free_highatomic-in-show_free_areas.patch added to mm-new branch
Message-Id: <20250415010507.C17A3C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add nr_free_highatomic in show_free_areas
has been added to the -mm mm-new branch.  Its filename is
     mm-add-nr_free_highatomic-in-show_free_areas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-nr_free_highatomic-in-show_free_areas.patch

This patch will later appear in the mm-new branch at
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
From: gaoxu <gaoxu2@honor.com>
Subject: mm: add nr_free_highatomic in show_free_areas
Date: Sat, 12 Apr 2025 09:27:24 +0000

commit c928807f6f6b6("mm/page_alloc: keep track of free highatomic")
adds a new variable nr_free_highatomic, which is useful for analyzing low
mem issues. add nr_free_highatomic in show_free_areas.

Signed-off-by: gao xu <gaoxu2@honor.com>
Link: https://lkml.kernel.org/r/d92eeff74f7a4578a14ac777cfe3603a@honor.com
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/show_mem.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/show_mem.c~mm-add-nr_free_highatomic-in-show_free_areas
+++ a/mm/show_mem.c
@@ -305,6 +305,7 @@ static void show_free_areas(unsigned int
 			" low:%lukB"
 			" high:%lukB"
 			" reserved_highatomic:%luKB"
+			" free_highatomic:%luKB"
 			" active_anon:%lukB"
 			" inactive_anon:%lukB"
 			" active_file:%lukB"
@@ -326,6 +327,7 @@ static void show_free_areas(unsigned int
 			K(low_wmark_pages(zone)),
 			K(high_wmark_pages(zone)),
 			K(zone->nr_reserved_highatomic),
+			K(zone->nr_free_highatomic),
 			K(zone_page_state(zone, NR_ZONE_ACTIVE_ANON)),
 			K(zone_page_state(zone, NR_ZONE_INACTIVE_ANON)),
 			K(zone_page_state(zone, NR_ZONE_ACTIVE_FILE)),
_

Patches currently in -mm which might be from gaoxu2@honor.com are

mm-add-nr_free_highatomic-in-show_free_areas.patch

