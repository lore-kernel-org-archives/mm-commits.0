Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B571824AF
	for <mm-commits@vger.kernel.org>; Wed, 12 Jun 2024 19:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718218892; cv=none; b=NYq0zL86hrZYgPNCMU75z07ChYUhV0/XJSSwqw63XJ+NHstpvnlR499KqFEu56LDkjuYuMawUtlEzqqZ4mJhgCzU7qgwl1Rs3Zsyhcr2Hi0WwtSyyUxEdmaTYBLRrAZDc/06pz/0IzFBzmWkymd1XiurKJNuHRwjhcN6mo9NBFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718218892; c=relaxed/simple;
	bh=HfCpi1lamEixzIU9W6b9bbwgZsDNtDlfDwu99ZF1E8A=;
	h=Date:To:From:Subject:Message-Id; b=KWHojKA2CLLmkSAicRJw5I40kVHKv/DHqtCeFQ0dA4xg/z6FjtrawVwkQqZriJK62Pr0eVTKUS4Snmx/U38k1pVcGCztvs6l/d04upuDReIH+t2dl0DbRrl4VkStSdE5J/ITLiDPoCVVQqSDyL/eWKKJZNN9azQwxhaLFDkiyhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GTnpyHYA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GTnpyHYA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 101BCC116B1;
	Wed, 12 Jun 2024 19:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718218891;
	bh=HfCpi1lamEixzIU9W6b9bbwgZsDNtDlfDwu99ZF1E8A=;
	h=Date:To:From:Subject:From;
	b=GTnpyHYAAM/VBuhdf0nHuITRcCTOoZIEnYMrdslO/iXdtlSwMSghl5iov5Q1ZY7Xb
	 yRwWuoj4MDZuJNop9PHiOCo7qNw+4kbQqpw4o+ACEi/wGNGOUPrn9QWDcg8/zwy1Ox
	 EeA9RlIdKGTkvKF2B6yxxGQNvXOLCgi2LTnR46WU=
Date: Wed, 12 Jun 2024 12:01:30 -0700
To: mm-commits@vger.kernel.org,tony.luck@intel.com,nao.horiguchi@gmail.com,lkp@intel.com,david@redhat.com,bp@alien8.de,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-remove-mf_msg_slab.patch added to mm-unstable branch
Message-Id: <20240612190131.101BCC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: remove MF_MSG_SLAB
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-remove-mf_msg_slab.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-remove-mf_msg_slab.patch

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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure: remove MF_MSG_SLAB
Date: Wed, 12 Jun 2024 15:18:24 +0800

Since commit 46df8e73a4a3 ("mm: free up PG_slab"), MF_MSG_SLAB becomes
unused.  Remove it.  No functional change intended.

Link: https://lkml.kernel.org/r/20240612071835.157004-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h      |    1 -
 include/ras/ras_event.h |    1 -
 mm/memory-failure.c     |    1 -
 3 files changed, 3 deletions(-)

--- a/include/linux/mm.h~mm-memory-failure-remove-mf_msg_slab
+++ a/include/linux/mm.h
@@ -4048,7 +4048,6 @@ enum mf_result {
 enum mf_action_page_type {
 	MF_MSG_KERNEL,
 	MF_MSG_KERNEL_HIGH_ORDER,
-	MF_MSG_SLAB,
 	MF_MSG_DIFFERENT_COMPOUND,
 	MF_MSG_HUGE,
 	MF_MSG_FREE_HUGE,
--- a/include/ras/ras_event.h~mm-memory-failure-remove-mf_msg_slab
+++ a/include/ras/ras_event.h
@@ -356,7 +356,6 @@ TRACE_EVENT(aer_event,
 #define MF_PAGE_TYPE		\
 	EM ( MF_MSG_KERNEL, "reserved kernel page" )			\
 	EM ( MF_MSG_KERNEL_HIGH_ORDER, "high-order kernel page" )	\
-	EM ( MF_MSG_SLAB, "kernel slab page" )				\
 	EM ( MF_MSG_DIFFERENT_COMPOUND, "different compound page after locking" ) \
 	EM ( MF_MSG_HUGE, "huge page" )					\
 	EM ( MF_MSG_FREE_HUGE, "free huge page" )			\
--- a/mm/memory-failure.c~mm-memory-failure-remove-mf_msg_slab
+++ a/mm/memory-failure.c
@@ -911,7 +911,6 @@ static const char *action_name[] = {
 static const char * const action_page_types[] = {
 	[MF_MSG_KERNEL]			= "reserved kernel page",
 	[MF_MSG_KERNEL_HIGH_ORDER]	= "high-order kernel page",
-	[MF_MSG_SLAB]			= "kernel slab page",
 	[MF_MSG_DIFFERENT_COMPOUND]	= "different compound page after locking",
 	[MF_MSG_HUGE]			= "huge page",
 	[MF_MSG_FREE_HUGE]		= "free huge page",
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory-failure-simplify-put_ref_page.patch
mm-memory-failure-remove-mf_msg_slab.patch
mm-memory-failure-add-macro-get_page_max_retry_num.patch
mm-memory-failure-save-some-page_folio-calls.patch
mm-memory-failure-remove-unneeded-empty-string.patch
mm-memory-failure-remove-confusing-initialization-to-count.patch
mm-memory-failure-dont-export-hwpoison_filter-when-config_hwpoison_inject.patch
mm-memory-failure-use-helper-macro-task_pid_nr.patch
mm-memory-failure-remove-obsolete-comment-in-unpoison_memory.patch
mm-memory-failure-move-some-function-declarations-into-internalh.patch
mm-memory-failure-fix-comment-of-get_hwpoison_page.patch
mm-memory-failure-remove-obsolete-comment-in-kill_proc.patch
mm-memory-failure-correct-comment-in-me_swapcache_dirty.patch

