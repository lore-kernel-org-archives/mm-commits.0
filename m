Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A6A7EEF8
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104032; cv=none; b=BPeFn9zscgtsi9pJCNCH3r68bt9rbTmnNc4Y1uklKMzH1BlwA8tKe2wbWHkb3zo385nXGM6i3Dq66P8vL4Q8wN24yCMJh+jFXKCKbBsnwobmH9pVSrmef8rjbF0clqnOdGxylO1bb5RNC9AZ8zUu7A2VYQW0sThQmxRdveAlKCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104032; c=relaxed/simple;
	bh=FdQIl1Fq3cviJG+bohJWbEA+/BMaiIc3GuubAYys4JA=;
	h=Date:To:From:Subject:Message-Id; b=cjijfgnEZ3LchUMLHlCqb01MLZCO05+RpCWd20DncsiN/r0D6vGQvROvVVNCEbGRVf9gP2sZI1Wrk5vxFJWsPDlW6qxrRaIXM1U1j5B02Vx6sAyeDfb+IiROb3NtaTYnm9BwREBtnN90/TWND8MUEHHDinZ3JkaU0YZch5Njwv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E0rSWaos; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E0rSWaos"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590A4C113CD;
	Fri, 26 Apr 2024 04:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104032;
	bh=FdQIl1Fq3cviJG+bohJWbEA+/BMaiIc3GuubAYys4JA=;
	h=Date:To:From:Subject:From;
	b=E0rSWaosLQ8f/nf5iNHq1RYX/7ULcZwWL6D1ERG3519pOpUhFRkU4nr6zSxlxK1XK
	 uxFqDwltG2HWjpfTY25XLgQYmiryLAlPCJSKYazcki0S2T2UQfvRn9S02684A2fHK0
	 PW9pVr+RrgZ8243MgLUXGsFbgyGP5TrcUAs8yqrc=
Date: Thu, 25 Apr 2024 21:00:31 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,mgorman@suse.de,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-__absent_pages_in_range-as-static.patch removed from -mm tree
Message-Id: <20240426040032.590A4C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: make __absent_pages_in_range() as static
has been removed from the -mm tree.  Its filename was
     mm-make-__absent_pages_in_range-as-static.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm: make __absent_pages_in_range() as static
Date: Tue, 26 Mar 2024 14:11:29 +0800

It's only called in mm/mm_init.c now.

Link: https://lkml.kernel.org/r/20240326061134.1055295-4-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 --
 mm/mm_init.c       |    2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/include/linux/mm.h~mm-make-__absent_pages_in_range-as-static
+++ a/include/linux/mm.h
@@ -3229,8 +3229,6 @@ static inline unsigned long get_num_phys
  */
 void free_area_init(unsigned long *max_zone_pfn);
 unsigned long node_map_pfn_alignment(void);
-unsigned long __absent_pages_in_range(int nid, unsigned long start_pfn,
-						unsigned long end_pfn);
 extern unsigned long absent_pages_in_range(unsigned long start_pfn,
 						unsigned long end_pfn);
 extern void get_pfn_range_for_nid(unsigned int nid,
--- a/mm/mm_init.c~mm-make-__absent_pages_in_range-as-static
+++ a/mm/mm_init.c
@@ -1144,7 +1144,7 @@ static void __init adjust_zone_range_for
  * Return the number of holes in a range on a node. If nid is MAX_NUMNODES,
  * then all holes in the requested range will be accounted for.
  */
-unsigned long __init __absent_pages_in_range(int nid,
+static unsigned long __init __absent_pages_in_range(int nid,
 				unsigned long range_start_pfn,
 				unsigned long range_end_pfn)
 {
_

Patches currently in -mm which might be from bhe@redhat.com are

documentation-kdump-clean-up-the-outdated-description.patch
kexec-fix-the-unexpected-kexec_dprintk-macro.patch
crash-add-prefix-for-crash-dumping-messages.patch

