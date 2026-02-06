Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409FF288AD
	for <mm-commits@vger.kernel.org>; Fri,  6 Feb 2026 23:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770419015; cv=none; b=dUTIanyud8K2SoH8RH2WTUtjjREr+hAxREK9IOlETQ0Y5aJmogK0NFd3aiZCgg0udXN0u+i5OwaHMMZHQpBFCnD49P3BvGqpTDhmc7XV2j1cmpZ+Yu4ZtFS+J/JD2iJIHWwlDgh6oc9KJsJVKyF6Z57BRNpTjl/FaNQqeZE7kGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770419015; c=relaxed/simple;
	bh=jCAqAqynXFeMrJEPtKOf1ENM2yslbqZGUdwTiZc6R+Y=;
	h=Date:To:From:Subject:Message-Id; b=MBVZ/ARVbQK15Xc2oWj4A+a6AhAeCf+fg7fm6jJoIoIbTJ4x54l6JmnvtJFxAk2skMdcvWaxY57EvpulRGy4P/g5YtKLg7G9yzzaI6zxcGKoUc1CPOvbqLW5vggGBGsK8D2KBdOLZp0pecFQ37wjTcmxVwVzYy31ln4U1Oa4K+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YOTL+x3H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YOTL+x3H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF51CC116C6;
	Fri,  6 Feb 2026 23:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770419014;
	bh=jCAqAqynXFeMrJEPtKOf1ENM2yslbqZGUdwTiZc6R+Y=;
	h=Date:To:From:Subject:From;
	b=YOTL+x3Huz24r003QGjwYFpW4LW3ECAgx0zSDdNAPUwKXJdOml2rLKqiS3JTI5NXn
	 Bf7yOUgZ3efRsZ4jxfDMYGVzlFS21Y7fq9ljtsO5m8Bi445jqvB83hEuxR+PkqH+2o
	 8S0CsUWt21Jr78Q7hARsvn3/hm3bql3UgFTYF3GI=
Date: Fri, 06 Feb 2026 15:03:34 -0800
To: mm-commits@vger.kernel.org,lkp@intel.com,david@kernel.org,ankur.a.arora@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-folio_zero_user-open-code-range-computation-in-folio_zero_user-v3.patch added to mm-unstable branch
Message-Id: <20260206230334.BF51CC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-folio_zero_user-open-code-range-computation-in-folio_zero_user-v3
has been added to the -mm mm-unstable branch.  Its filename is
     mm-folio_zero_user-open-code-range-computation-in-folio_zero_user-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-folio_zero_user-open-code-range-computation-in-folio_zero_user-v3.patch

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
From: Ankur Arora <ankur.a.arora@oracle.com>
Subject: mm-folio_zero_user-open-code-range-computation-in-folio_zero_user-v3
Date: Fri, 6 Feb 2026 14:38:01 -0800

remove unneeded cast, per David

Link: https://lkml.kernel.org/r/20260206223801.2617497-1-ankur.a.arora@oracle.com
Fixes: 93552c9a3350 ("mm: folio_zero_user: cache neighbouring pages")

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202601240453.QCjgGdJa-lkp@intel.com/
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-folio_zero_user-open-code-range-computation-in-folio_zero_user-v3
+++ a/mm/memory.c
@@ -7340,7 +7340,7 @@ void folio_zero_user(struct folio *folio
 		struct page *page = folio_page(folio, r[i].start);
 
 		if (nr_pages > 0)
-			clear_contig_highpages(page, addr, (unsigned int)nr_pages);
+			clear_contig_highpages(page, addr, nr_pages);
 	}
 }
 
_

Patches currently in -mm which might be from ankur.a.arora@oracle.com are

mm-folio_zero_user-open-code-range-computation-in-folio_zero_user.patch
mm-folio_zero_user-open-code-range-computation-in-folio_zero_user-v3.patch

