Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568EC1CFEDC
	for <mm-commits@vger.kernel.org>; Thu, 22 Aug 2024 18:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724351680; cv=none; b=Eb/VG/FwOg8RUJRZuLmUK/XcOzAYzsNkPSMk00vNzwkWFghMyYOVgHYx26PghsJSopAKdcD06E/QnVhOzuMgRtzfY+PiiLGbak8OKpsMwBxcFFFm+yyTjl4swAiEEpqjkUIWYMEgN8vHZfMWB8SttKgHiyho5grWyjhttF9/EzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724351680; c=relaxed/simple;
	bh=zWwUylS4Vl4DD8j5jP2P2TU/g7FNmye/vX5Vrj0I+zg=;
	h=Date:To:From:Subject:Message-Id; b=DCnN+1+EEXuGousJMcW2EhuXGtdxrwAg0nYXuB4cVvCvNMnBBAitvxuBu9y1NWgFORgAF08K7yajjjpltp8qIZLPRNkEo59ciI6+vlZGP32HE3PHRooYQVpZDcQTDptOhnm49CpI0M4uuqymwG634SLaENEv2IWxdPiskA86Hqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vUPmtXeX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vUPmtXeX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1297C32782;
	Thu, 22 Aug 2024 18:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724351679;
	bh=zWwUylS4Vl4DD8j5jP2P2TU/g7FNmye/vX5Vrj0I+zg=;
	h=Date:To:From:Subject:From;
	b=vUPmtXeXEi8I58xKgr+HdwpZ8ek7q8hHMH0AeWFPS5jWnu/TEeqbCz5nFm0N5LuZ6
	 +CNAOw8B4qU+TZ7SA7khC6lzCfEcJYZuxTFCtm6FnNER0vtFSe2cvcEm4GH7qgM+69
	 aKLcb8QVrB6it12aDRHLXZX6ypdexANNnv7d9E1g=
Date: Thu, 22 Aug 2024 11:34:39 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,willy@infradead.org,muchun.song@linux.dev,liaoyu15@huawei.com,fvdl@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-contig_alloc-support-__gfp_comp-fix.patch added to mm-unstable branch
Message-Id: <20240822183439.D1297C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-contig_alloc-support-__gfp_comp-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-contig_alloc-support-__gfp_comp-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-contig_alloc-support-__gfp_comp-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-contig_alloc-support-__gfp_comp-fix
Date: Thu Aug 22 11:32:43 AM PDT 2024

fix folio_alloc_gigantic_noprof() WARN expression, per Yu Liao

Cc: Frank van der Linden <fvdl@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Yu Liao <liaoyu15@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/gfp.h~mm-contig_alloc-support-__gfp_comp-fix
+++ a/include/linux/gfp.h
@@ -452,7 +452,7 @@ static inline struct folio *folio_alloc_
 {
 	struct page *page;
 
-	if (WARN_ON(!order || !(gfp | __GFP_COMP)))
+	if (WARN_ON(!order || !(gfp & __GFP_COMP)))
 		return NULL;
 
 	page = alloc_contig_pages_noprof(1 << order, gfp, nid, node);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-mmzoneh-clean-up-watermark-accessors.patch
mm-remove-legacy-install_special_mapping-code-checkpatch-fixes.patch
mm-contig_alloc-support-__gfp_comp-fix.patch
mm-memory_hotplug-remove-head-variable-in-do_migrate_range-fix.patch
mm-memory-failure-add-unmap_posioned_folio-fix.patch
mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range-fix.patch
selftests-mm-add-more-mseal-traversal-tests-fix.patch
mm-remove-pageactive-fix.patch
fault-inject-improve-build-for-config_fault_injection=n-fix.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-2.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-3.patch

