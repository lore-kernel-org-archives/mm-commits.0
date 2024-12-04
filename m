Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C921F03F8
	for <mm-commits@vger.kernel.org>; Wed,  4 Dec 2024 22:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733352797; cv=none; b=XC/wsx4Dd7RXTWcEOoCNZ5qrgpOY5qZB4bbJzUcECTlDuohqeB6h3tE2zkSpAyw5xaqvPTuXhsEIdzeY+Zpc7uAwWUo6YMyYtogqs+yWZJCxBtMlxN7d2CdrwtmzB18Rz6A6w7Jh6wCyzZMUUujX4ESrBE0de9cfVg4JfSZXeEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733352797; c=relaxed/simple;
	bh=fQ1EoS718AbaJV1GP5YcChZizH8x4HWFN1N4KPchU6U=;
	h=Date:To:From:Subject:Message-Id; b=VGE4LaKLJyrVh3hk1bCiVwAFELYW14klqiZEs9NOa9Sa1zuV7aWcASQSmDz6ihOS9zoxI6zZoiNYEe3Pb/hZHJ0JrAw8Bmm8tvYDPQZLXPEhQsph0nrnWpLESDKbGaU5iYX+nZxirR2I4YvHnfsCOiDf2IpQw+3xRUPKRnoHXZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2L68nMJl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2L68nMJl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8F3C4CECD;
	Wed,  4 Dec 2024 22:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733352796;
	bh=fQ1EoS718AbaJV1GP5YcChZizH8x4HWFN1N4KPchU6U=;
	h=Date:To:From:Subject:From;
	b=2L68nMJlkPhCTv3SBQJfnlMaPzqA5havdkpStm55045ZxN5f+8pZ+sdPK71WXRsM8
	 MckB3WUnLOfAdScmFdQR5eh/meyTcw7TKiMkRkKqEwYhXdXJ4m/agwd3gSz++KsFBP
	 OMa7hlCHdJzfIZytmtvv4KWgeHbnoLe4+PLy+7PQ=
Date: Wed, 04 Dec 2024 14:53:16 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,willy@infradead.org,will@kernel.org,rientjes@google.com,peterz@infradead.org,peterx@redhat.com,muchun.song@linux.dev,mgorman@suse.de,luto@kernel.org,lorenzo.stoakes@oracle.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-select-arch_supports_pt_reclaim-if-x86_64.patch added to mm-unstable branch
Message-Id: <20241204225316.8A8F3C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86: select ARCH_SUPPORTS_PT_RECLAIM if X86_64
has been added to the -mm mm-unstable branch.  Its filename is
     x86-select-arch_supports_pt_reclaim-if-x86_64.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-select-arch_supports_pt_reclaim-if-x86_64.patch

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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: x86: select ARCH_SUPPORTS_PT_RECLAIM if X86_64
Date: Wed, 4 Dec 2024 19:09:51 +0800

Now, x86 has fully supported the CONFIG_PT_RECLAIM feature, and reclaiming
PTE pages is profitable only on 64-bit systems, so select
ARCH_SUPPORTS_PT_RECLAIM if X86_64.

Link: https://lkml.kernel.org/r/841c1f35478d5354872d307888979c9e20de9c09.1733305182.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/Kconfig~x86-select-arch_supports_pt_reclaim-if-x86_64
+++ a/arch/x86/Kconfig
@@ -322,6 +322,7 @@ config X86
 	select FUNCTION_ALIGNMENT_4B
 	imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
 	select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
+	select ARCH_SUPPORTS_PT_RECLAIM		if X86_64
 
 config INSTRUCTION_DECODER
 	def_bool y
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-pgtable-make-ptep_clear-non-atomic.patch
mm-khugepaged-recheck-pmd-state-in-retract_page_tables.patch
mm-userfaultfd-recheck-dst_pmd-entry-in-move_pages_pte.patch
mm-introduce-zap_nonpresent_ptes.patch
mm-introduce-do_zap_pte_range.patch
mm-skip-over-all-consecutive-none-ptes-in-do_zap_pte_range.patch
mm-zap_install_uffd_wp_if_needed-return-whether-uffd-wp-pte-has-been-re-installed.patch
mm-do_zap_pte_range-return-any_skipped-information-to-the-caller.patch
mm-make-zap_pte_range-handle-full-within-pmd-range.patch
mm-pgtable-reclaim-empty-pte-page-in-madvisemadv_dontneed.patch
x86-mm-free-page-table-pages-by-rcu-instead-of-semi-rcu.patch
x86-select-arch_supports_pt_reclaim-if-x86_64.patch

