Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8CC3C09E8
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068161; cv=none; b=CpLnKyLVS33fDAcgJiKnkzOsbCT5r/Fb1mz0gm9PIn5PHI/9OY+lnzAzltc25oVtkS8GizBq9VESBksA+GCJ9hXScHJVVPafoayLyD0WCg4unNSzcBI+fdzzI8ud0LLFWamRADvrNL/BOS9gIeniOTidcPooo7H4msBOvhkw/MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068161; c=relaxed/simple;
	bh=evdTxY9RmmmYxGoMV1vybTubuSKqS8WaliZwyZB44eI=;
	h=Date:To:From:Subject:Message-Id; b=H2xTjLz+uo5DhGgd6tg61PbkCmndoxf0FtuHfUpDcD7claHTx3jYR78sEYbNj/yIwuPYMlguLvwA2YXHLLud34VG7tVq1qebzJqARFj0jYFAb1ojDzTK8iszQkXxFpovIgIVoOAz6FQAWZsz6VUafacFHCsMfuxao1QTX9DI4rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ps0fzqo4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ps0fzqo4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5269A1F00A3A;
	Fri,  7 Aug 2026 02:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068160;
	bh=1n2pC8DlHiK46LRAuwpw38NpkIQf0NkybnxQ78AAVgY=;
	h=Date:To:From:Subject;
	b=Ps0fzqo4nXuNLhgAhpNo3xw5+7s1ae4ueSPdMdKzDP+/PHKVSh9VhHGVs1zedh4oU
	 O/sMwvmvVQGyNWQ1c50ltpUACZgWtmQfjHkn9I/pUU1iL6K3yrzk39s2XfTF0YDjkZ
	 x1BpNchIfuIvLKlONNKR36htfjuFFJy5D3bEy7Ok=
Date: Thu, 06 Aug 2026 19:02:39 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,sj@kernel.org,seanjc@google.com,rppt@kernel.org,peterx@redhat.com,pbonzini@redhat.com,lkp@intel.com,ljs@kernel.org,liam@infradead.org,jthoughton@google.com,david@kernel.org,corbet@lwn.net,aarcange@redhat.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fold-userfaultfd_rwp-to-false-without-config_arch_has_pte_protnone.patch removed from -mm tree
Message-Id: <20260807020240.5269A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fold userfaultfd_rwp() to false without CONFIG_ARCH_HAS_PTE_PROTNONE
has been removed from the -mm tree.  Its filename was
     mm-fold-userfaultfd_rwp-to-false-without-config_arch_has_pte_protnone.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: mm: fold userfaultfd_rwp() to false without CONFIG_ARCH_HAS_PTE_PROTNONE
Date: Mon, 27 Jul 2026 10:16:11 +0100

RWP tracks accesses by installing PAGE_NONE (protnone) PTEs, so its code
paths are gated on userfaultfd_rwp().  Without
CONFIG_ARCH_HAS_PTE_PROTNONE there is no PAGE_NONE -- <linux/pgtable.h>
defines it to a BUILD_BUG() stub, relying on callers folding such paths to
dead code via IS_ENABLED(CONFIG_ARCH_HAS_PTE_PROTNONE).

userfaultfd_rwp() was not a compile-time constant, so the compiler could
not fold those paths.  With an older compiler (gcc 8.5.0, sparc64) the
PAGE_NONE reference in move_pages_huge_pmd() survived to codegen:

  mm/huge_memory.c:2874: _dst_pmd = pmd_modify(_dst_pmd, PAGE_NONE);
  compiler_types.h:702: error: call to '__compiletime_assert_501'
    declared with attribute error: BUILD_BUG failed

RWP cannot exist without protnone, so return a compile-time false when
CONFIG_ARCH_HAS_PTE_PROTNONE is unset; every RWP path then folds away.

Link: https://lore.kernel.org/amcitKvUvFYr8W38@thinkstation
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202607250853.VaJWGLeA-lkp@intel.com/
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: James Houghton <jthoughton@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/userfaultfd_k.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/include/linux/userfaultfd_k.h~mm-fold-userfaultfd_rwp-to-false-without-config_arch_has_pte_protnone
+++ a/include/linux/userfaultfd_k.h
@@ -221,6 +221,12 @@ static inline bool userfaultfd_minor(str
 
 static inline bool userfaultfd_rwp(struct vm_area_struct *vma)
 {
+	/*
+	 * Callers gate PAGE_NONE usage on this; PAGE_NONE is a BUILD_BUG()
+	 * without CONFIG_ARCH_HAS_PTE_PROTNONE, so fold to false.
+	 */
+	if (!IS_ENABLED(CONFIG_ARCH_HAS_PTE_PROTNONE))
+		return false;
 	return vma_test_single_mask(vma, VMA_UFFD_RWP);
 }
 
_

Patches currently in -mm which might be from kas@kernel.org are


