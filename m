Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5CB53365
	for <mm-commits@vger.kernel.org>; Mon, 30 Jun 2025 22:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751323027; cv=none; b=EoJtw91UVQL/De1qmhScJ0TrVauAZhciJPRRw6/FTJd+ZedrxTr9Q4NmRJMfmoKsmwOCzdcU577QkL6N9mNA3rGcLkWd9r3iPDX8d0sRS4TsBebZfLBNYtjbsgtoXtfpIznYEBCCuloPaSEcGkSbsVlGovchRz6OxZbe1avk7TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751323027; c=relaxed/simple;
	bh=ftdvPyl47XqsAMnSmkGf4U29THT2EU1VhCbvCd1uxTw=;
	h=Date:To:From:Subject:Message-Id; b=dlctiIFfYlN+eo5d+eRrwnCzqJZmudileZQUBPsfg1HpxaoTeEWoo8e8jsMOoMp4umElW2fVHLi1tiabuXzoG10F0L8dAHPdeLJH5jdQ/WS2rWkj9SgzY5AwbrxvLxHrvXnZEgdlSiUuBF8HnBIeK5rFdGWZRTLSn+r1uUKdhKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0ODARdMG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0ODARdMG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A84C4CEE3;
	Mon, 30 Jun 2025 22:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751323025;
	bh=ftdvPyl47XqsAMnSmkGf4U29THT2EU1VhCbvCd1uxTw=;
	h=Date:To:From:Subject:From;
	b=0ODARdMGEhbmOtVnJod7TQHJ/YGf3GhTz/bYnSSE5ldk7goON5ted9hxKGIpjTX7U
	 9IvZCg3HyDlF9dODpsmGK2PtfDDSzAh3ug7ALhMOv6EeHLF5mGA9lLeo8gRUEfZJK7
	 kaSKE3gf7QVaZIK1Ohk5m2tkbcHn3WGDaTOpof94=
Date: Mon, 30 Jun 2025 15:37:05 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-use-str_plural-in-report_hugepages.patch added to mm-new branch
Message-Id: <20250630223705.D3A84C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: use str_plural() in report_hugepages()
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-use-str_plural-in-report_hugepages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-use-str_plural-in-report_hugepages.patch

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
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: mm/hugetlb: use str_plural() in report_hugepages()
Date: Mon, 30 Jun 2025 19:18:26 +0200

Use the string choice helper function str_plural() to simplify the code
and to fix the following Coccinelle/coccicheck warning reported by
string_choices.cocci:

  opportunity for str_plural(nrinvalid)

Link: https://lkml.kernel.org/r/20250630171826.114008-2-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-str_plural-in-report_hugepages
+++ a/mm/hugetlb.c
@@ -25,6 +25,7 @@
 #include <linux/mmdebug.h>
 #include <linux/sched/signal.h>
 #include <linux/rmap.h>
+#include <linux/string_choices.h>
 #include <linux/string_helpers.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
@@ -3722,7 +3723,7 @@ static void __init report_hugepages(void
 			buf, h->nr_huge_pages);
 		if (nrinvalid)
 			pr_info("HugeTLB: %s page size: %lu invalid page%s discarded\n",
-					buf, nrinvalid, nrinvalid > 1 ? "s" : "");
+					buf, nrinvalid, str_plural(nrinvalid));
 		pr_info("HugeTLB: %d KiB vmemmap can be freed for a %s page\n",
 			hugetlb_vmemmap_optimizable_size(h) / SZ_1K, buf);
 	}
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

mm-hugetlb-use-str_plural-in-report_hugepages.patch
alpha-replace-sprintf-strcpy-with-scnprintf-strscpy.patch

