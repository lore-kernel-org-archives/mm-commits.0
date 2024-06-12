Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8393C823AC
	for <mm-commits@vger.kernel.org>; Wed, 12 Jun 2024 19:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718218902; cv=none; b=eagsYpx22qEBl5vaEd7nCMozZ91hkoxdBvbcXl1bvStJIgNS4pq8Vz5IpB9jkRP0xkJ1pN0khfkWBVulG5A512fY7M0WWNuOj+LnBixukfxoFeJwMiVPBE81QBEmCCNl+ZWKcMLNXIvlt/ssC0UKsAJef0EgG0yL/+9hHZ7irxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718218902; c=relaxed/simple;
	bh=w3ESQ/nPsdgE8wThOyFfzQr/WjY31JmlnwOsfb4FXMw=;
	h=Date:To:From:Subject:Message-Id; b=VyajwkhZTOI1GRJE2N5QBKQEk3qigx7j7BpVzB0BELAntHRTW0WH7djYK8VUNddIFLDrtaeJoKgTLpJ+Gu5lKEuGxIlFaL24SelK2BwD1Ei75Amepz+07x5Efu1qXcgnxhHfveDBpM/9aZR+IYL7h/pCU4UrVnWwjJxBmdu3NcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p9u1Jka3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p9u1Jka3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42545C116B1;
	Wed, 12 Jun 2024 19:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718218902;
	bh=w3ESQ/nPsdgE8wThOyFfzQr/WjY31JmlnwOsfb4FXMw=;
	h=Date:To:From:Subject:From;
	b=p9u1Jka3mfN3GIyuIScVJdeuIb6Uctw0Y+1iURBRgBd+tlOTbtpq/gdKRTp2bN/oc
	 U/JaNQSYDQoUDQvn/BeG6ivmO6vnkogLJZWP0y1U4R0mlKQEX/Z+InrUs0+WM/hMnM
	 aA9eVokFUBMXNhMpneB4tBAYHyNLb3a2I3Eq++Rs=
Date: Wed, 12 Jun 2024 12:01:41 -0700
To: mm-commits@vger.kernel.org,tony.luck@intel.com,nao.horiguchi@gmail.com,lkp@intel.com,david@redhat.com,bp@alien8.de,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-remove-obsolete-comment-in-unpoison_memory.patch added to mm-unstable branch
Message-Id: <20240612190142.42545C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: remove obsolete comment in unpoison_memory()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-remove-obsolete-comment-in-unpoison_memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-remove-obsolete-comment-in-unpoison_memory.patch

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
Subject: mm/memory-failure: remove obsolete comment in unpoison_memory()
Date: Wed, 12 Jun 2024 15:18:31 +0800

Since commit 130d4df57390 ("mm/sl[au]b: rearrange struct slab fields to
allow larger rcu_head"), folio->_mapcount is not overloaded with SLAB. 
Update corresponding comment.

Link: https://lkml.kernel.org/r/20240612071835.157004-10-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: kernel test robot <lkp@intel.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-remove-obsolete-comment-in-unpoison_memory
+++ a/mm/memory-failure.c
@@ -2584,10 +2584,6 @@ int unpoison_memory(unsigned long pfn)
 	    folio_test_reserved(folio) || folio_test_offline(folio))
 		goto unlock_mutex;
 
-	/*
-	 * Note that folio->_mapcount is overloaded in SLAB, so the simple test
-	 * in folio_mapped() has to be done after folio_test_slab() is checked.
-	 */
 	if (folio_mapped(folio)) {
 		unpoison_pr_info("Unpoison: Someone maps the hwpoison page %#lx\n",
 				 pfn, &unpoison_rs);
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

