Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837AB13AD1C
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744923; cv=none; b=VWM0sdsBfQv8Wb5cX6jFx70bpnvHLi+HTqeAL5BxHDkrly1q8xvLmbLh5mUZ2bj/gd2qC81NWi4Klbl5ggpdCnP+hvCLeWbLn2Cp9Q+0x1R6vwH0O1+YFwpq26sIlZAl7VdPaklAyLAJo5XsW/H5bH8m4DE3AnWs2bDDmGXJi4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744923; c=relaxed/simple;
	bh=wc4eIEb/Dn3BcNp+/ulhzprSFWtp/251Pwu2z+miC4w=;
	h=Date:To:From:Subject:Message-Id; b=aWX4JvSofhFm/N/BU51FsSsMLEJAlp3VRDnD2o84UcYY8/I37vggjBWSbkfiIa48c7RNxKnUOunW+7nv8kttfv+zyKhFGBVQad8yTmIVptvEJLaRSyokRx6SYyX+/4A4Eg/0NHy3Lse15tGz2JluKxwpKPMFoJARDdOyeuPPMO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rV0BKb6Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rV0BKb6Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5965FC4CEF7;
	Sun, 29 Mar 2026 00:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744923;
	bh=wc4eIEb/Dn3BcNp+/ulhzprSFWtp/251Pwu2z+miC4w=;
	h=Date:To:From:Subject:From;
	b=rV0BKb6YtO816o4OoC/uodiJjWD+2F/kCkjfRgGscNe1iflL+p1GR9cOtMUAz22dg
	 m1rGBxnOJJGvE9vCQz8ohTz519Up0QAu5ixagqh83i4klnX0xUVzUGexJOOStPXnQ4
	 PqzxTePFrsKkm9ixbJLYFSDMzo1figxjIExX/PPs=
Date: Sat, 28 Mar 2026 17:42:02 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,sidhartha.kumar@oracle.com,rppt@kernel.org,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,axelrasmussen@google.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-remove-warn_ons-from-onlineoffline_mem_sections.patch removed from -mm tree
Message-Id: <20260329004203.5965FC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse: remove WARN_ONs from (online|offline)_mem_sections()
has been removed from the -mm tree.  Its filename was
     mm-sparse-remove-warn_ons-from-onlineoffline_mem_sections.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/sparse: remove WARN_ONs from (online|offline)_mem_sections()
Date: Fri, 20 Mar 2026 23:13:35 +0100

We do not allow offlining of memory with memory holes, and always hotplug
memory without holes.

Consequently, we cannot end up onlining or offlining memory sections that
have holes (including invalid sections).  That's also why these WARN_ONs
never fired.

Let's remove the WARN_ONs along with the TODO regarding double-checking.
Link: https://lkml.kernel.org/r/20260320-sparsemem_cleanups-v2-3-096addc8800d@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

--- a/mm/sparse.c~mm-sparse-remove-warn_ons-from-onlineoffline_mem_sections
+++ a/mm/sparse.c
@@ -638,13 +638,8 @@ void online_mem_sections(unsigned long s
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
 		unsigned long section_nr = pfn_to_section_nr(pfn);
-		struct mem_section *ms;
+		struct mem_section *ms = __nr_to_section(section_nr);
 
-		/* onlining code should never touch invalid ranges */
-		if (WARN_ON(!valid_section_nr(section_nr)))
-			continue;
-
-		ms = __nr_to_section(section_nr);
 		ms->section_mem_map |= SECTION_IS_ONLINE;
 	}
 }
@@ -656,16 +651,8 @@ void offline_mem_sections(unsigned long
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
 		unsigned long section_nr = pfn_to_section_nr(pfn);
-		struct mem_section *ms;
-
-		/*
-		 * TODO this needs some double checking. Offlining code makes
-		 * sure to check pfn_valid but those checks might be just bogus
-		 */
-		if (WARN_ON(!valid_section_nr(section_nr)))
-			continue;
+		struct mem_section *ms = __nr_to_section(section_nr);
 
-		ms = __nr_to_section(section_nr);
 		ms->section_mem_map &= ~SECTION_IS_ONLINE;
 	}
 }
_

Patches currently in -mm which might be from david@kernel.org are


