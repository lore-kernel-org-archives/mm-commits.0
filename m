Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3494FECD8
	for <mm-commits@vger.kernel.org>; Thu,  3 Sep 2026 19:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788465529; cv=none; b=Zdy4TF98DKwgU8H9RestqAvHxLVK73pYYu/2DTfysiQY6IeZIWkXmjgFuIkbX5Bo1uaDvXlpqOFJ/bRUXMoCRN+kiNhNXEFTgUWM+hw98So9bC8+pJNygdNXehJ8WlJyw/84Qei4r3EnS2Bo2zj0ryMERaAjdf4oQIzQEhb9kmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788465529; c=relaxed/simple;
	bh=CfsSic8UcMwkFiNN31QBuqNcgEJs28mQc8f85TVY1NQ=;
	h=Date:To:From:Subject:Message-Id; b=F9qa1j93mMY8KMPekR+Wkdi3kSfEmVMCrjSqAPJte6Vv7ysXdToiR4kw72/2gmEra3CTxCNNMz64kYc0vbQity6TdPPW+0zECwHl2LCEifsDsfpENBZkB17FX2owGIRD0LJLRa53zMyspNDfG5OnGVg1wCTEOCKj0cK+WmJl4B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FSH4Bg0R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FSH4Bg0R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B7251F000E9;
	Thu,  3 Sep 2026 19:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788465524;
	bh=IsCSK41/GH/5D0Zp8Lt65o5xQ1knXDxebac7kekTKtc=;
	h=Date:To:From:Subject;
	b=FSH4Bg0RkHMG+LUV4MxZkR5qXfUl18wnnxl6d4k76YicLWX8fMSZH6dprzTh25D4k
	 BxYjkQkcz42hImAK6AgZPT85MBxdjWm4R0wP3AYCJKNqfcbCrM5DWB5eqTNw812gk7
	 PtuES5L8DmEsoJUL/y6fPRHIYpWcrUj8YHuXgyuI=
Date: Thu, 03 Sep 2026 12:58:43 -0700
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,iweiny@kernel.org,david@kernel.org,dave.jiang@intel.com,alison.schofield@intel.com,chengkaitao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page-flags-define-hwpoison-test-and-change-helpers-unconditionally.patch added to mm-new branch
Message-Id: <20260903195844.3B7251F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page-flags: define HWPoison test-and-change helpers unconditionally
has been added to the -mm mm-new branch.  Its filename is
     mm-page-flags-define-hwpoison-test-and-change-helpers-unconditionally.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page-flags-define-hwpoison-test-and-change-helpers-unconditionally.patch

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
From: Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: mm/page-flags: define HWPoison test-and-change helpers unconditionally
Date: Thu, 3 Sep 2026 13:35:34 +0800

Patch series "Make HWPoison helpers config-independent".

Make the HWPoison page flag's test-and-set and test-and-clear accessors
available regardless of CONFIG_MEMORY_FAILURE.  When memory failure
handling is disabled, the accessors return false, matching the absence of
HWPoison state and providing a consistent interface across configurations.

Use the config-independent interface in the pmem driver to remove its
private test_and_clear_pmem_poison() wrapper and the associated header
dependency.  No functional change is intended.


This patch (of 2):

Page flag helpers for configuration-dependent flags provide false or no-op
variants so that their users can be independent of the configuration.

The HWPoison helpers do not fully follow this pattern.  When
CONFIG_MEMORY_FAILURE is enabled, PAGEFLAG() and TESTSCFLAG() provide the
regular, test-and-set, and test-and-clear operations.  When it is
disabled, only PAGEFLAG_FALSE() is instantiated, leaving
TestSetPageHWPoison() and TestClearPageHWPoison() undefined.

Use TESTSCFLAG_FALSE() to provide the missing accessors when memory
failure handling is disabled.  Both accessors return false, which is
consistent with HWPoison state being unavailable, and makes the accessor
interface consistent across configurations.

Link: https://lore.kernel.org/20260903053535.17611-1-kaitao.cheng@linux.dev
Link: https://lore.kernel.org/20260903053535.17611-2-kaitao.cheng@linux.dev
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Ira Weiny <iweiny@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/page-flags.h~mm-page-flags-define-hwpoison-test-and-change-helpers-unconditionally
+++ a/include/linux/page-flags.h
@@ -655,6 +655,7 @@ TESTSCFLAG(HWPoison, hwpoison, PF_ANY)
 #define __PG_HWPOISON (1UL << PG_hwpoison)
 #else
 PAGEFLAG_FALSE(HWPoison, hwpoison)
+TESTSCFLAG_FALSE(HWPoison, hwpoison)
 #define __PG_HWPOISON 0
 #endif
 
_

Patches currently in -mm which might be from chengkaitao@kylinos.cn are

mm-hugetlb-use-hugetlb_vmemmap_optimizable-in-boolean-contexts.patch
mm-page-flags-define-hwpoison-test-and-change-helpers-unconditionally.patch
nvdimm-pmem-remove-test_and_clear_pmem_poison.patch

