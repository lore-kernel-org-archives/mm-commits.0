Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C10142E7A
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291622; cv=none; b=isB0gP+otF6gPyVwQXO/HUKGxZuoJTkmRmdWPzi0wQiJB3xiyW/g7k+DYCqY6zdklY4OBUh/PxsFlEgpvj6ku9tq2DFMfpl8ctog/+nFLeB5yu6NoThmyWrEu2mxvjD6ermEAwzyKiJUKh8GG1WmrcK6VoHJDOHMetHpA0MS6Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291622; c=relaxed/simple;
	bh=aS9EjmY+poZ7Rt9mexa6YR9vHvp/VzrHrIPhHhYgH/s=;
	h=Date:To:From:Subject:Message-Id; b=ZKNz0OPqEEOYPbSiVplUd1lWsFsR1DHVmU0xURPEyGeq60aEnbStJaWOY/U2jZuJGf1dSGuP3IpyJIKnYqVcvFBTs0CutWCCUIy4G4oU73pd+BQEH8ZXBKb/EKbptelpluaakvVRmSu5VmdPw7aBOgPdo27HIndmDOV/WMs7RwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BdM9aiF+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BdM9aiF+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE1AC32782;
	Tue, 25 Jun 2024 05:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291622;
	bh=aS9EjmY+poZ7Rt9mexa6YR9vHvp/VzrHrIPhHhYgH/s=;
	h=Date:To:From:Subject:From;
	b=BdM9aiF+75AhCEff4NV5Z9ZyDtU6iq4SFj9GhKGUM6GcnGdkzbcBu2ontzXA/1thq
	 aE54f/qWxI9a9+xLm2LmDKHG6isFMQz087Xx4vTF4mLSnKuuS7NccPh3xWb2by4Ffk
	 HpHmRA4rsijlSMxrUP87DvBZZKiqjmIHkqwKQQgc=
Date: Mon, 24 Jun 2024 22:00:21 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,dave.hansen@intel.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arch-x86-do-not-explicitly-clear-reserved-flag-in-free_pagetable.patch removed from -mm tree
Message-Id: <20240625050022.2BE1AC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arch/x86: do not explicitly clear Reserved flag in free_pagetable
has been removed from the -mm tree.  Its filename was
     arch-x86-do-not-explicitly-clear-reserved-flag-in-free_pagetable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: arch/x86: do not explicitly clear Reserved flag in free_pagetable
Date: Mon, 27 May 2024 06:45:23 +0200

In free_pagetable() we use the non-atomic version for clearing the
PageReserved bit from the page.  free_pagetable() will either call
free_reserved_page() or put_page_bootmem(), which will eventually end up
calling free_reserved_page(), and in there we already clear the
PageReserved flag.

Link: https://lkml.kernel.org/r/20240527044523.29207-1-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/x86/mm/init_64.c~arch-x86-do-not-explicitly-clear-reserved-flag-in-free_pagetable
+++ a/arch/x86/mm/init_64.c
@@ -980,8 +980,6 @@ static void __meminit free_pagetable(str
 
 	/* bootmem page has reserved flag */
 	if (PageReserved(page)) {
-		__ClearPageReserved(page);
-
 		magic = page->index;
 		if (magic == SECTION_INFO || magic == MIX_SECTION_INFO) {
 			while (nr_pages--)
_

Patches currently in -mm which might be from osalvador@suse.de are


