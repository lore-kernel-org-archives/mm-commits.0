Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E742517D2
	for <mm-commits@vger.kernel.org>; Tue,  7 Oct 2025 22:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759876019; cv=none; b=Gzixymf2t5th+pJT9EsW/JOZK/Ty1d0n7WNN/Sr7YKjFRWKjEM9elH33QwPYuYQYizufcukmJ+2JN7u5idQGc7WihNwoK1ye/uls0bHvU+LgKmbOEC+oB2845kvBRa1jRm3oPRrAQ6D5R7Ek2XpLQvGkEVTOUaFeLsvpmuGpDxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759876019; c=relaxed/simple;
	bh=2AzWb58ShsjbicGcVhNw4I+pNPCZgvIfQo4bROGWK6Y=;
	h=Date:To:From:Subject:Message-Id; b=FgOq9VOjNk5Nm9lPsVto9z256NM3DPXfoykno1JTTroH09IBGpst9+bUWkF512UdelbdmjHJPFW0LQ3UCvr23Z3sPyp5SIAKKhveVb2Ivn2VlrSu6MYpko8/C0lNGdShZWLbwqBlDbd8dJOF410P/Rmro9Xa+XhFMZKvH0wPKL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oV/VgxTP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oV/VgxTP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50CFCC4CEF1;
	Tue,  7 Oct 2025 22:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759876018;
	bh=2AzWb58ShsjbicGcVhNw4I+pNPCZgvIfQo4bROGWK6Y=;
	h=Date:To:From:Subject:From;
	b=oV/VgxTP72zqiXR6K1nM/lGs2YrAmE5OHpkoELyXfazv/mH/BI4AlhrnCshFEQ9+D
	 WcHcflSbDbQ/qKd5z+/Sv4Xh9G4H8wEpc+X8CSPsSyavqJv5HeTVaTBslT2y5s6jqx
	 CVfCTS6xGaa9Eo3tx4mylYoKshhw43PkwgerJnPY=
Date: Tue, 07 Oct 2025 15:26:57 -0700
To: mm-commits@vger.kernel.org,riel@surriel.com,osalvador@suse.de,muchun.song@linux.dev,hannes@cmpxchg.org,david@redhat.com,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-allow-overcommitting-gigantic-hugepages.patch added to mm-new branch
Message-Id: <20251007222658.50CFCC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: allow overcommitting gigantic hugepages
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-allow-overcommitting-gigantic-hugepages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-allow-overcommitting-gigantic-hugepages.patch

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
From: Usama Arif <usamaarif642@gmail.com>
Subject: mm/hugetlb: allow overcommitting gigantic hugepages
Date: Mon, 6 Oct 2025 19:56:07 +0100

Currently, gigantic hugepages cannot use the overcommit mechanism
(nr_overcommit_hugepages), forcing users to permanently reserve memory via
nr_hugepages even when pages might not be actively used.

Remove this blanket restriction on gigantic hugepage overcommit.  This
will bring the same benefits to gigantic pages as hugepages:

- Memory is only taken out of regular use when actually needed
- Unused surplus pages can be returned to the system
- Better memory utilization, especially with CMA backing which can
  significantly increase the changes of hugepage allocation

Without this patch:
echo 3 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_overcommit_hugepages
bash: echo: write error: Invalid argument

With this patch:
echo 3 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_overcommit_hugepages
./mmap_hugetlb_test
Successfully allocated huge pages at address: 0x7f9d40000000

cat mmap_hugetlb_test.c
...
    unsigned long ALLOC_SIZE = 3 * (unsigned long) HUGE_PAGE_SIZE;
    addr = mmap(NULL,
                ALLOC_SIZE, // 3GB
                PROT_READ | PROT_WRITE,
                MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB | MAP_HUGE_1GB,
                -1,
                0);

    if (addr == MAP_FAILED) {
        fprintf(stderr, "mmap failed: %s\n", strerror(errno));
        return 1;
    }
    printf("Successfully allocated huge pages at address: %p\n", addr);
...

Link: https://lkml.kernel.org/r/20251006185607.3257340-1-usamaarif642@gmail.com
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-allow-overcommitting-gigantic-hugepages
+++ a/mm/hugetlb.c
@@ -2232,7 +2232,7 @@ static struct folio *alloc_surplus_huget
 {
 	struct folio *folio = NULL;
 
-	if (hstate_is_gigantic(h))
+	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
 		return NULL;
 
 	spin_lock_irq(&hugetlb_lock);
@@ -4294,7 +4294,7 @@ static ssize_t nr_overcommit_hugepages_s
 	unsigned long input;
 	struct hstate *h = kobj_to_hstate(kobj, NULL);
 
-	if (hstate_is_gigantic(h))
+	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
 		return -EINVAL;
 
 	err = kstrtoul(buf, 10, &input);
@@ -5181,7 +5181,7 @@ static int hugetlb_overcommit_handler(co
 
 	tmp = h->nr_overcommit_huge_pages;
 
-	if (write && hstate_is_gigantic(h))
+	if (write && hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
 		return -EINVAL;
 
 	ret = proc_hugetlb_doulongvec_minmax(table, write, buffer, length, ppos,
_

Patches currently in -mm which might be from usamaarif642@gmail.com are

mm-hugetlb-allow-overcommitting-gigantic-hugepages.patch

