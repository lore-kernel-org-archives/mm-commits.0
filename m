Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DED273D9F
	for <mm-commits@vger.kernel.org>; Mon, 29 Jun 2026 17:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782754218; cv=none; b=TYVP5qB2+Gwxy1z8gE1ikUkr5J1PskgSO9q193wL2HIAL4/Q/OSVynnPakzTd3omdnKl367eWBfcduxyoHd2Fzmde3i3ueA/i09fZ3Z3saqLKpVrJquTtnHaTwnLN1DLGdSPlc4qKMqO8icfLj6kqS3QLh65h5RDVHRqLtOEX74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782754218; c=relaxed/simple;
	bh=fNvmaczNcJlvucMm13zqZQWRhBcZ/StnKYpUzlDuK9E=;
	h=Date:To:From:Subject:Message-Id; b=lxwQeDvrQ2SF8GgKcpPts2XjotT9rJOav5XDvi9+1ram37tyDOI65XtFvZd3sMtVcTrQaNklyTmhU0Z6gEb59ME0xsnKY4pk/V2dP6xHHmsXbjgmMqcTvsjI0pvahNylLGI4dnOX01nwhL9Vbo9znO8llkG84EaA5vbwoR/mKSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=czt7DV22; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="czt7DV22"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 715FA1F000E9;
	Mon, 29 Jun 2026 17:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782754216;
	bh=nd0veltyAy+lHDX1BXoV4+/rzGHBjxBpINtTCJ2vmvw=;
	h=Date:To:From:Subject;
	b=czt7DV22tQ4OX+nQ9zwNyItDiC7+L4qXOjM0LHBKFq3S8nSXOksgnbw//HCjjzPw8
	 uiWxVyCZD24KxGaR6bnYejHD46/mgCX9X/K1A/ncDXo8wVM1/C87CpqTRo9mG612Gy
	 ZkeD6HZoL4vhqcH9v/NHqI/8pqXWu4dxmbRqEls4=
Date: Mon, 29 Jun 2026 10:30:16 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ljs@kernel.org,david@kernel.org,brauner@kernel.org,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-a-second-pagecache-maintainer.patch added to mm-hotfixes-unstable branch
Message-Id: <20260629173016.715FA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: a second pagecache maintainer
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-a-second-pagecache-maintainer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-a-second-pagecache-maintainer.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: a second pagecache maintainer
Date: Mon, 29 Jun 2026 15:59:28 +0200

As MM is slowly transitioning towards a more distributed maintainership
model, we agreed with Matthew that I will be a co-maintainer in case he is
not available.

Link: https://lore.kernel.org/20260629135927.2586391-2-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~mm-a-second-pagecache-maintainer
+++ a/MAINTAINERS
@@ -20406,7 +20406,7 @@ F:	kernel/padata.c
 
 PAGE CACHE
 M:	Matthew Wilcox (Oracle) <willy@infradead.org>
-R:	Jan Kara <jack@suse.cz>
+M:	Jan Kara <jack@suse.cz>
 L:	linux-fsdevel@vger.kernel.org
 L:	linux-mm@kvack.org
 S:	Supported
_

Patches currently in -mm which might be from jack@suse.cz are

mm-a-second-pagecache-maintainer.patch

