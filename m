Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D08F1F4262
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343106; cv=none; b=hdDjM9XbiHQuItgnzyJfS+6QJpg3oR09NnxQsevYsTFI5Nv/TrmzAQtwgXrDF2EUsmClfwnqa5flBify/uly0lzUip0+lE3MXpPLeuuO0k+DnFzeAN1qRuokhFEjep/v/q62rgzpWL+D5hXr8hUqyEsWlEaH2Bo7telc/MJJlk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343106; c=relaxed/simple;
	bh=DF7AhPgfOVsxHRnjdGZyNFwSz5gJZdEQJ9dBdkf1RFo=;
	h=Date:To:From:Subject:Message-Id; b=cKf0B098uur1nbXh8FgmVBqRolDObG/X5LU16+NPLld93qYwa0oSUYZvIM5FIL2xZ5+EtAxf/pT0IME9RliuSZ4Lt+99s8Px7OqBA7byeoHVEtVv4wE/q5ns0CZcMxlOwMydg3IKteGHecpQInBec0yG5qVyXYFzJ8SASumjaMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P1KWl9hx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P1KWl9hx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD634C4CEF5;
	Mon, 17 Nov 2025 01:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343105;
	bh=DF7AhPgfOVsxHRnjdGZyNFwSz5gJZdEQJ9dBdkf1RFo=;
	h=Date:To:From:Subject:From;
	b=P1KWl9hxHXTYq0ZbD8P2IeDaF/qH70HIJ73aer4pTZA3Pk4f/eTwpaxuBlgRNkhz3
	 j1TwnvcOsyZ2hl3XN5Ds1+xUr+D1ewkhruI3o/tlihUnPJVrbW6YtP3eL1dAwowXdN
	 eRYwDVYlrpCcgeTs2Zoep8HZuYfGcE1aTazX6M6U=
Date: Sun, 16 Nov 2025 17:31:45 -0800
To: mm-commits@vger.kernel.org,osalvador@suse.de,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-dirty-replace-read_once-with-pudp_get.patch removed from -mm tree
Message-Id: <20251117013145.AD634C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/dirty: replace READ_ONCE() with pudp_get()
has been removed from the -mm tree.  Its filename was
     mm-dirty-replace-read_once-with-pudp_get.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/dirty: replace READ_ONCE() with pudp_get()
Date: Mon, 6 Oct 2025 06:52:14 +0100

Replace READ_ONCE() with a standard page table accessor i.e pudp_get() that
anyways defaults into READ_ONCE() in cases where platform does not override

Link: https://lkml.kernel.org/r/20251006055214.1845342-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mapping_dirty_helpers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mapping_dirty_helpers.c~mm-dirty-replace-read_once-with-pudp_get
+++ a/mm/mapping_dirty_helpers.c
@@ -149,7 +149,7 @@ static int wp_clean_pud_entry(pud_t *pud
 			      struct mm_walk *walk)
 {
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
-	pud_t pudval = READ_ONCE(*pud);
+	pud_t pudval = pudp_get(pud);
 
 	/* Do not split a huge pud */
 	if (pud_trans_huge(pudval)) {
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are


