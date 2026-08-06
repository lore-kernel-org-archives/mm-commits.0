Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15483B640
	for <mm-commits@vger.kernel.org>; Thu,  6 Aug 2026 18:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786041371; cv=none; b=uG0turotWG+mA9u67oJHW2lvHcEk01XNvr6NBA7VZFMvuLcbXpE3oYtU/RZZGaVhhUEVaHO3idaccsOYRs8Epfw5Lo+y5AavWy/HQUfrcggrAMHW17HjACUEnS8oOTuBuhmv8rbQH8R2TYkNcFRO8MGTBGpyoTHV5E0eHL1xBIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786041371; c=relaxed/simple;
	bh=sD0beItS+tLd10L0IED0TrrZ72sQUDS7u0oEeGWn474=;
	h=Date:To:From:Subject:Message-Id; b=dthvU3DHIQkGWWgGLWnQPItSyhKDwAXjCplU0XUtS1cmMIJA1UO3H9dYco4aLk78bNHgy0Vw4INGfr7mRcDe8d9JaaOsjPIBUW0EfEjh1RHfwW2fSGGXBHQ/HRQ9GRmIBy6V+MZ1bxAhoRT4xcmhyjpiI4J09BRc5vCgwU/MTbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kOsMZkNP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kOsMZkNP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B931F00A3A;
	Thu,  6 Aug 2026 18:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786041369;
	bh=HHnEZ++Y4ssj+G8N5vTX1wi7KTzsWY8mGDQ4t9AHEkw=;
	h=Date:To:From:Subject;
	b=kOsMZkNP5Ng2wzxnr8C/q1F6OswjGK/sj74OJYpsTbwOwNH3FgbhW0nhlELv/XySm
	 NrIpJsOdCruhzsPzUJvt209GtiUhonntRkpywi6y9D/op6/LP+iiaai+ObKFQBqcd4
	 gdFHKAR4DoBWOxIw5yiTslE8vLjCeUvzuY5i4wyM=
Date: Thu, 06 Aug 2026 11:36:09 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,audra@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + correct-__pagemap_scan_get_categories-return-value.patch added to mm-new branch
Message-Id: <20260806183609.C2B931F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm/vm_util.c: correct __pagemap_scan_get_categories return value
has been added to the -mm mm-new branch.  Its filename is
     correct-__pagemap_scan_get_categories-return-value.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/correct-__pagemap_scan_get_categories-return-value.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Audra Mitchell <audra@redhat.com>
Subject: selftests/mm/vm_util.c: correct __pagemap_scan_get_categories return value
Date: Thu, 6 Aug 2026 11:00:34 -0400

Currently __pagemap_scan_get_categories returns the result from the ioctl
call which should be an int, not uint64_t.  The ioctl may return -1 on
error, which will be interpreted as UINT64_MAX.  Adjust the return type to
use the correct value.

Link: https://lore.kernel.org/20260806150339.1824251-2-audra@redhat.com
Signed-off-by: Audra Mitchell <audra@redhat.com>
Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/vm_util.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/vm_util.c~correct-__pagemap_scan_get_categories-return-value
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -34,7 +34,7 @@ uint64_t pagemap_get_entry(int fd, char
 	return entry;
 }
 
-static uint64_t __pagemap_scan_get_categories(int fd, char *start, struct page_region *r)
+static int __pagemap_scan_get_categories(int fd, char *start, struct page_region *r)
 {
 	struct pm_scan_arg arg;
 
@@ -58,7 +58,7 @@ static uint64_t __pagemap_scan_get_categ
 static uint64_t pagemap_scan_get_categories(int fd, char *start)
 {
 	struct page_region r;
-	long ret;
+	int ret;
 
 	ret = __pagemap_scan_get_categories(fd, start, &r);
 	if (ret < 0)
_

Patches currently in -mm which might be from audra@redhat.com are

correct-__pagemap_scan_get_categories-return-value.patch

