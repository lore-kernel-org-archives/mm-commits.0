Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A852C1F0E42
	for <mm-commits@vger.kernel.org>; Wed, 12 Mar 2025 22:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741818377; cv=none; b=hTm9McbO9N658BtYD0d7gHM62UxG4VtlMun18Xi+jJtu0GbiBijNFcqkF32BrkPmgrxjoPgILvBr59LJK8U70hLbToN9BFgOvppFRvrCziZH0tLEkb8jZIgkAPhJymBdkDKUYPUEsL5PhN0KKwtBDioGMtq6sOV+r/T3wmif5CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741818377; c=relaxed/simple;
	bh=oHS0ScJf1Mt2bTAufKN9pG2QgLgn06pGqjuBNRCwNCQ=;
	h=Date:To:From:Subject:Message-Id; b=NOmydHDlSiawVM0NVrQ//X1772ixqzDmzFcPavXtkoA/AI73PA64+f5FzK2DTCwjvbl8sHOzu/utuncUJYcqqD4TpdDwihUsxKQyslDlTuHiObTstMUz+wu2mdRczRWorg3GZEfbuDkxNVeI1a9z9CdNjzgN6SWWn7JQL+59WtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zY3/lkJQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zY3/lkJQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E91C4CEDD;
	Wed, 12 Mar 2025 22:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741818377;
	bh=oHS0ScJf1Mt2bTAufKN9pG2QgLgn06pGqjuBNRCwNCQ=;
	h=Date:To:From:Subject:From;
	b=zY3/lkJQN4mB8jX09PEpEeN5E9RhNkQXggT9qFco4/2Z2zweC3z8z1KLUEMuZ4dmy
	 tWnA4K7Cxj70/WkFg+HCbnvQsFjQ/IKo7Rrtmf5oct+SAXoNRntHf+rt1OxcOas37z
	 qbfqCPuxFjIc2R7L96E76ok654BgYgekHjzUz5Yo=
Date: Wed, 12 Mar 2025 15:26:16 -0700
To: mm-commits@vger.kernel.org,yazen.ghannam@amd.com,tony.luck@intel.com,tianruidong@linux.alibaba.com,tglx@linutronix.de,peterz@infradead.org,nao.horiguchi@gmail.com,mingo@redhat.com,linmiaohe@huawei.com,jpoimboe@kernel.org,Jonathan.Cameron@huawei.com,jarkko@kernel.org,jane.chu@oracle.com,hpa@zytor.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,baolin.wang@linux.alibaba.com,xueshuai@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-enhance-comments-for-return-value-of-memory_failure.patch added to mm-unstable branch
Message-Id: <20250312222617.19E91C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memory-failure: enhance comments for return value of memory_failure()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-enhance-comments-for-return-value-of-memory_failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-enhance-comments-for-return-value-of-memory_failure.patch

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
From: Shuai Xue <xueshuai@linux.alibaba.com>
Subject: mm: memory-failure: enhance comments for return value of memory_failure()
Date: Wed, 12 Mar 2025 19:28:52 +0800

The comments for the return value of memory_failure are not complete,
supplement the comments.

Link: https://lkml.kernel.org/r/20250312112852.82415-4-xueshuai@linux.alibaba.com
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Yazen Ghannam <yazen.ghannam@amd.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Tested-by: Tony Luck <tony.luck@intel.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ruidong Tian <tianruidong@linux.alibaba.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-enhance-comments-for-return-value-of-memory_failure
+++ a/mm/memory-failure.c
@@ -2215,9 +2215,13 @@ static void kill_procs_now(struct page *
  * Must run in process context (e.g. a work queue) with interrupts
  * enabled and no spinlocks held.
  *
- * Return: 0 for successfully handled the memory error,
- *         -EOPNOTSUPP for hwpoison_filter() filtered the error event,
- *         < 0(except -EOPNOTSUPP) on failure.
+ * Return:
+ *   0             - success,
+ *   -ENXIO        - memory not managed by the kernel
+ *   -EOPNOTSUPP   - hwpoison_filter() filtered the error event,
+ *   -EHWPOISON    - the page was already poisoned, potentially
+ *                   kill process,
+ *   other negative values - failure.
  */
 int memory_failure(unsigned long pfn, int flags)
 {
_

Patches currently in -mm which might be from xueshuai@linux.alibaba.com are

x86-mce-use-is_copy_from_user-to-determine-copy-from-user-context.patch
mm-hwpoison-do-not-send-sigbus-to-processes-with-recovered-clean-pages.patch
mm-memory-failure-enhance-comments-for-return-value-of-memory_failure.patch

