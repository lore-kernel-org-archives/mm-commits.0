Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B7C3CAA53
	for <mm-commits@vger.kernel.org>; Wed, 14 Oct 2026 21:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792013212; cv=none; b=bJaymmB8FJlZaUGCmBXcrOg5adnfVlVqFFCXjD7pG919t40UFzRs5/2tOr6ETjgfzKRHWsFCT1wm6KKEb+OHt7wCpfbBArUiSvaAKWH1d+9I9nBWGSbTYnDPklHT48LZ0jLJGEiuXdMTUVr+HrBpcxX+4JQttE7E1CrW3/kpQXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792013212; c=relaxed/simple;
	bh=zxQ/Bb5pbxMrfj7MEOb15HG4gUFkJ3kGs7wPPTuLPa4=;
	h=Date:To:From:Subject:Message-Id; b=U8uGXaVJ778UP7B0efa8HMDAt8TUN6ZvIhWcQ3vZLwW2rFvcgtKRfvdcfmUm5ZLH6od6Vml1uzXKAbZIjFNXqWQ9e0JCXk0tRKgWR5VReyhQdhy+/EX6ssX6KpiQBCpu1NgcS8ERIYS6X+TzGcr83awHIAJgIWHFVt2tzW/7Osk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MxI9CrbT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MxI9CrbT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC051F000C4;
	Wed, 14 Oct 2026 21:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792013210;
	bh=zkGXq4dWKQ51dO3rUwbGth3hBLnxmK6YxKCVDIFfR+Q=;
	h=Date:To:From:Subject;
	b=MxI9CrbTRPY/V1xsmhsNgfiV0gyiiiLlgHBhMV0CXzlZozM7MxDunJ6R7O6K0EHTy
	 Pm+Y/+V0ec06zsho2cpPqPT2GYsXj+whEDdwupczXQNUsBiTUIon6ylCFkMYl3/PlA
	 NIQN8vF98r+d8CYOy0T3vMwXoQprQIONFEDEj/k8=
Date: Wed, 14 Oct 2026 14:26:50 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,ricardo@marliere.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-mremap_test-validate-the-preamble-region-before-mapping-it.patch added to mm-unstable branch
Message-Id: <20261014212650.7CC051F000C4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: mremap_test: Validate the preamble region before mapping it
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-mremap_test-validate-the-preamble-region-before-mapping-it.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-mremap_test-validate-the-preamble-region-before-mapping-it.patch

This patch will later appear in the mm-unstable branch at
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
From: Ricardo B. Marlière (SUSE) <ricardo@marliere.net>
Subject: selftests/mm: mremap_test: Validate the preamble region before mapping it
Date: Wed, 14 Oct 2026 15:46:46 -0300

remap_region() checks that the destination region is free before mapping
it, but not the preamble region placed right before it, so mapping the
preamble can intermittently fail with EEXIST:

  # Failed to map dest preamble region: File exists
  not ok 15 5MB mremap - Source 1MB-aligned, Dest 1MB-aligned with 40MB Preamble

This happens when the kernel's heap ASLR (arch_randomize_brk()) lands the
process heap inside that unchecked range.  Confirmed by correlating
brk(NULL) at startup with pass/fail across 60 runs: every failure had brk
land inside that range.

Fix it by including the preamble in the free-region check.

Link: https://lore.kernel.org/20261014-selftests-mm-mremap_preamble-v1-1-2e97f501cb56@marliere.net
Signed-off-by: Ricardo B. Marlière (SUSE) <ricardo@marliere.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
---

 tools/testing/selftests/mm/mremap_test.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/mremap_test.c~selftests-mm-mremap_test-validate-the-preamble-region-before-mapping-it
+++ a/tools/testing/selftests/mm/mremap_test.c
@@ -1006,8 +1006,10 @@ static long long remap_region(struct con
 	if (!((unsigned long long) addr & c.dest_alignment))
 		addr = (void *) ((unsigned long long) addr | c.dest_alignment);
 
-	/* Don't destroy existing mappings unless expected to overlap */
-	while (!is_remap_region_valid(addr, c.region_size) && !c.overlapping) {
+	/* Don't destroy existing mappings unless expected to overlap. */
+	while (!is_remap_region_valid(addr - c.dest_preamble_size,
+				      c.dest_preamble_size + c.region_size) &&
+	       !c.overlapping) {
 		/* Check for unsigned overflow */
 		tmp_addr = addr + c.dest_alignment;
 		if (tmp_addr < addr) {
_

Patches currently in -mm which might be from ricardo@marliere.net are

selftests-mm-mremap_test-validate-the-preamble-region-before-mapping-it.patch

