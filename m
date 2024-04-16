Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5E313A248
	for <mm-commits@vger.kernel.org>; Tue, 16 Apr 2024 20:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713297842; cv=none; b=VBO2NHSGfxfjkmS9mkXx84OFPG+CBUq7Fms3Q0yFOoKYBRddErjqA30mgGQu756evddAFEiACr5suZ9B4JTrKIXZV09W+1mzNrY5oJvvjhKdSQptsldSvS6W0lRvhqzgKR7CIpwMohNIjzXnRzIvJ0N6VtZbSiwrckhKvOZvFMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713297842; c=relaxed/simple;
	bh=De9RRUIlYcvv91IxRah1lhwSRbpfCxGKGY7eWRE3qSc=;
	h=Date:To:From:Subject:Message-Id; b=VgZdNgUa1HV0PTuMFRpUed9OSLGQpLj6S69b7CnaYWcDentGYw19K+t3MhzucZNoIL+hFMO0KR1ly9dBihvm6xV5K4+tI5ZJgHQ1RzuecFwkEyil9/AHmHlarfEJ66IpYCNRcN90/lnEhUbzG6s5d9XbFTQN+Cr3i0UmQdWp5Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Te4A0OwS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Te4A0OwS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 543C1C3277B;
	Tue, 16 Apr 2024 20:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713297842;
	bh=De9RRUIlYcvv91IxRah1lhwSRbpfCxGKGY7eWRE3qSc=;
	h=Date:To:From:Subject:From;
	b=Te4A0OwS4C7b1lBTLSrxyfh42LFoufIJOYOeCDvgucMt+K5twCUiXsFz+a2eis7kb
	 SzZ8FWzWPoHTv4YL1ezkHGzJUdcrWLDmkb4nszBy548C4jG+9avqzGGOajt/p95z0m
	 LqZf3j+ZjOZXdPMTagA67a7oONIntspUlpaRbmmY=
Date: Tue, 16 Apr 2024 13:04:01 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,osalvador@suse.de,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-guard-the-size-of-mem_section-is-power-of-2.patch added to mm-unstable branch
Message-Id: <20240416200402.543C1C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse: guard the size of mem_section is power of 2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-sparse-guard-the-size-of-mem_section-is-power-of-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-guard-the-size-of-mem_section-is-power-of-2.patch

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
Subject: mm/sparse: guard the size of mem_section is power of 2
Date: Tue, 16 Apr 2024 01:25:59 +0000

We usually have this check, while commit 2a3cb8baef71 ("mm/sparse: delete
old sparse_init and enable new one") missed to take it.

Link: https://lkml.kernel.org/r/20240416012559.4536-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/sparse.c~mm-sparse-guard-the-size-of-mem_section-is-power-of-2
+++ a/mm/sparse.c
@@ -560,6 +560,8 @@ void __init sparse_init(void)
 	unsigned long pnum_end, pnum_begin, map_count = 1;
 	int nid_begin;
 
+	/* see include/linux/mmzone.h 'struct mem_section' definition */
+	BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));
 	memblocks_present();
 
 	pnum_begin = first_present_section_nr();
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-sparse-guard-the-size-of-mem_section-is-power-of-2.patch

