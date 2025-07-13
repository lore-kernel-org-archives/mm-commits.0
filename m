Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB181EF38E
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450034; cv=none; b=sJDeGw0jCDIofgiNNxgtWs75MviBr7A33DtJPEjEuEFmh683JcXv+3kolG+YMDb8AG3x9iQ8/oy6Tr2RtRo7NWYJ8KPuVmLDbDF/XMkM4HaG9VycRQZpds+SD1ZaB5/o5H96SoyuhPiXrjlpoh8/zT3kTYDrqiEpxNxxUeXkGpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450034; c=relaxed/simple;
	bh=DVTLNGleYjRkNAzyT9BUKj3wAb/pXxeWzF4nOBXEAAE=;
	h=Date:To:From:Subject:Message-Id; b=tXRhTIlBNuZ+xUI3VRgKum8AP4wYsjCCBde4Q0XIL26qD7tD6XuStPV62wgzC5VAm91Q8nhi5HWft8l+X5V2W10t6JQaS0FOVZYlH1SEZlleXgvoAMbgpb3mPyC/P1Gt7TI1ZU4j/zrR4MBsjKmWQgAft6SqHchcRtPMfxx0M84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ps/afWZw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ps/afWZw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15BD3C4CEE3;
	Sun, 13 Jul 2025 23:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450034;
	bh=DVTLNGleYjRkNAzyT9BUKj3wAb/pXxeWzF4nOBXEAAE=;
	h=Date:To:From:Subject:From;
	b=Ps/afWZwfQqm5sG7ylon8KoIZ/f1L9F/XtLuL3uPfX9O9TC9clZmOiIV+PStGdLSV
	 v4jevl1W4QD3XeqS7EVwFznrsmlPnyQzO0r1lCpzA7diT/3oX7yWU02V7xo//vkynM
	 Bv7+J8Wpawag6X3Fc3wlOjgu7iaYjxOvcanOZ6TQ=
Date: Sun, 13 Jul 2025 16:40:33 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,dev.jain@arm.com,david@redhat.com,anshuman.khandual@arm.com,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-use-str_plural-in-report_hugepages.patch removed from -mm tree
Message-Id: <20250713234034.15BD3C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: use str_plural() in report_hugepages()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-use-str_plural-in-report_hugepages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Muchun Song <muchun.song@linux.dev>
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

mm-memfd-replace-deprecated-strcpy-with-memcpy-in-alloc_name.patch

