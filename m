Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBBEF125DB
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 07:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706255699; cv=none; b=HmU5A9eJDWdRXlk/4vTV4ojQmX38eue+ozfpK5sgeVvBGfxttW5hHwi8/HdXqG9hGFRG+mJmeiH9PzViFkeh1HrKM1g72F+92/6sBx7q5Z1nbf9uFHCeLs85k3qTZ8McUrHUaZ1o2WJuAqb7iVZn32q+nxmw0xCACfO2h/RBngA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706255699; c=relaxed/simple;
	bh=shuShr0feCCezeAAMbks+856lygIuQoiXB3ebwAqb54=;
	h=Date:To:From:Subject:Message-Id; b=gM+R7t58lfX85EE5rK3B1t5jmZRfu/0+aOanL8qXzOBqWi9ck2+nkfZ1RlcJ3oHc66ghoeP4acROBYgbamiXea4zmC7ZmmXzkIMmBJlor8ZW+6bmEdXZc4g5mZ4mYjy7A3AK4f3ugp5OCe2MtCmPZN1ugXpzEjre4PTmNWs5Xsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DJ1HzKCj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DJ1HzKCj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4335CC43390;
	Fri, 26 Jan 2024 07:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706255699;
	bh=shuShr0feCCezeAAMbks+856lygIuQoiXB3ebwAqb54=;
	h=Date:To:From:Subject:From;
	b=DJ1HzKCjyIfA+kEdGNktZZsQEyCj2pY2qM9t22GqJx3U1CgMtTNUCfxSfRMaG50xW
	 d4sbMQGb4cJVJaJVE9VzQ+SkFJNqk1CfYDkt8LgOK0bBK72y2WAQLZeMN2N8GHcHJa
	 +KG2ALKQrJUnbrlYvKudmnssd3ztXGyvJYplKlsc=
Date: Thu, 25 Jan 2024 23:54:56 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,peterz@infradead.org,oleg@redhat.com,namhyung@kernel.org,mingo@redhat.com,mark.rutland@arm.com,jolsa@kernel.org,irogers@google.com,adrian.hunter@intel.com,acme@kernel.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] uprobes-use-pagesize-aligned-virtual-address-when-replacing-pages.patch removed from -mm tree
Message-Id: <20240126075459.4335CC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: uprobes: use pagesize-aligned virtual address when replacing pages
has been removed from the -mm tree.  Its filename was
     uprobes-use-pagesize-aligned-virtual-address-when-replacing-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: uprobes: use pagesize-aligned virtual address when replacing pages
Date: Mon, 15 Jan 2024 11:07:31 +0100

uprobes passes an unaligned page mapping address to
folio_add_new_anon_rmap(), which ends up triggering a VM_BUG_ON() we
recently extended in commit 372cbd4d5a066 ("mm: non-pmd-mappable, large
folios for folio_add_new_anon_rmap()").

Arguably, this is uprobes code doing something wrong; however, for the
time being it would have likely worked in rmap code because
__folio_set_anon() would set folio->index to the same value.

Looking at __replace_page(), we'd also pass slightly wrong values to
mmu_notifier_range_init(), page_vma_mapped_walk(), flush_cache_page(),
ptep_clear_flush() and set_pte_at_notify().  I suspect most of them are
fine, but let's just mark the introducing commit as the one needed fixing.
I don't think CC stable is warranted.

We'll add more sanity checks in rmap code separately, to make sure that we
always get properly aligned addresses.

Link: https://lkml.kernel.org/r/20240115100731.91007-1-david@redhat.com
Fixes: c517ee744b96 ("uprobes: __replace_page() should not use page_address_in_vma()")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Jiri Olsa <jolsa@kernel.org>
Closes: https://lkml.kernel.org/r/ZaMR2EWN-HvlCfUl@krava
Tested-by: Jiri Olsa <jolsa@kernel.org>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alexander Shishkin
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/events/uprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/events/uprobes.c~uprobes-use-pagesize-aligned-virtual-address-when-replacing-pages
+++ a/kernel/events/uprobes.c
@@ -537,7 +537,7 @@ retry:
 		}
 	}
 
-	ret = __replace_page(vma, vaddr, old_page, new_page);
+	ret = __replace_page(vma, vaddr & PAGE_MASK, old_page, new_page);
 	if (new_page)
 		put_page(new_page);
 put_old:
_

Patches currently in -mm which might be from david@redhat.com are


