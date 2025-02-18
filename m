Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382CF1A8418;
	Tue, 18 Feb 2025 04:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739851257; cv=none; b=POTWaPUEUziPqx/kzD8ZKZp/lQT3dhM17Dp9NTMpq2uW+ktyhXdna0nAg1vKYeaoCDSuAMqIVtFmGuZ4bQSFPk48lEFqb+6AYdd5szKg4vbAcwDpIBuqetfBtLJwLMN+109t9VuL4v5Yl1IWWuq/Udkvs4YYrkUakxuLvqvMT+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739851257; c=relaxed/simple;
	bh=h45u/OaAiziWryhkP9CY9iJcxHUsDg1SXBY362XmXgs=;
	h=Date:To:From:Subject:Message-Id; b=HzChTmhGnMTN8kuUSf8VUwsxzqkgiIHQLZk+CvuFXQfGrwWUt8uRJlAg04kLCkJEQbzdLnxK+sS9xYldZzzMC0dI5uuv3tLx/ID28toIk7WYizRB7Qcx+kDaRT9mxB/oj/4jVEPAAoPWiG/1R8d5KudyBlCIpVNksyPIAz7voU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jbOv/gpW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jbOv/gpW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B3CCC4CEE9;
	Tue, 18 Feb 2025 04:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739851256;
	bh=h45u/OaAiziWryhkP9CY9iJcxHUsDg1SXBY362XmXgs=;
	h=Date:To:From:Subject:From;
	b=jbOv/gpWC5weiAEm2egSZIztiynx5gI4C/ZLE3+IpVKUgHR3R6gO2Fp91dXvvIoic
	 Zs1U/WLr5aYxb0e6OwLe6NYoHL1ipKD6COiDFxinrY6oB5OdW2xjz+wzh9Z8K/a4LW
	 gEfzrqg4TuGs61XIViu3Y0wUoaUifj2I2JtOk/zI=
Date: Mon, 17 Feb 2025 20:00:55 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,mhocko@suse.com,linmiaohe@huawei.com,david@redhat.com,mawupeng1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-hotplug-check-folio-ref-count-first-in-do_migrate_range.patch added to mm-hotfixes-unstable branch
Message-Id: <20250218040056.7B3CCC4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memory-hotplug: check folio ref count first in do_migrate_range
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memory-hotplug-check-folio-ref-count-first-in-do_migrate_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-hotplug-check-folio-ref-count-first-in-do_migrate_range.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Ma Wupeng <mawupeng1@huawei.com>
Subject: mm: memory-hotplug: check folio ref count first in do_migrate_range
Date: Mon, 17 Feb 2025 09:43:28 +0800

If a folio has an increased reference count, folio_try_get() will acquire
it, perform necessary operations, and then release it.  In the case of a
poisoned folio without an elevated reference count (which is unlikely for
memory-failure), folio_try_get() will simply bypass it.

Therefore, relocate the folio_try_get() function, responsible for checking
and acquiring this reference count at first.

Link: https://lkml.kernel.org/r/20250217014329.3610326-3-mawupeng1@huawei.com
Signed-off-by: Ma Wupeng <mawupeng1@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory-hotplug-check-folio-ref-count-first-in-do_migrate_range
+++ a/mm/memory_hotplug.c
@@ -1822,12 +1822,12 @@ static void do_migrate_range(unsigned lo
 		if (folio_test_large(folio))
 			pfn = folio_pfn(folio) + folio_nr_pages(folio) - 1;
 
-		/*
-		 * HWPoison pages have elevated reference counts so the migration would
-		 * fail on them. It also doesn't make any sense to migrate them in the
-		 * first place. Still try to unmap such a page in case it is still mapped
-		 * (keep the unmap as the catch all safety net).
-		 */
+		if (!folio_try_get(folio))
+			continue;
+
+		if (unlikely(page_folio(page) != folio))
+			goto put_folio;
+
 		if (folio_test_hwpoison(folio) ||
 		    (folio_test_large(folio) && folio_test_has_hwpoisoned(folio))) {
 			if (WARN_ON(folio_test_lru(folio)))
@@ -1835,14 +1835,8 @@ static void do_migrate_range(unsigned lo
 			if (folio_mapped(folio))
 				unmap_poisoned_folio(folio, pfn, false);
 
-			continue;
-		}
-
-		if (!folio_try_get(folio))
-			continue;
-
-		if (unlikely(page_folio(page) != folio))
 			goto put_folio;
+		}
 
 		if (!isolate_folio_to_list(folio, &source)) {
 			if (__ratelimit(&migrate_rs)) {
_

Patches currently in -mm which might be from mawupeng1@huawei.com are

mm-memory-failure-update-ttu-flag-inside-unmap_poisoned_folio.patch
mm-memory-hotplug-check-folio-ref-count-first-in-do_migrate_range.patch
hwpoison-memory_hotplug-lock-folio-before-unmap-hwpoisoned-folio.patch

