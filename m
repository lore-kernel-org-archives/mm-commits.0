Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284E618A6DB;
	Tue, 18 Feb 2025 03:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739849407; cv=none; b=q0KDtQ+LGYpRqXX14IXbEkmNOFd8UYDtHU/QrhtaJxV56hRV6zURo+KCV86rJJjDbZEUAg8OEED1OnJppHrGYFvOW2LsTj19eAne9WXNJumfNzEr3qrezCbMrFJcf5nMOjwkhGRbqCXxm1tL0RtzZQ1ScPIfSPLgZiqROdD531Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739849407; c=relaxed/simple;
	bh=SyQB9SkXvPzfX3KdD57jjhRb3Sqa7wo6LxGljuuL09A=;
	h=Date:To:From:Subject:Message-Id; b=LmMKH1VN0S64N6L405wUMqkL3A8LFNN4LcyEAS+Sytr9npflrUILxa+Gs2Dexu5OWPgEuXY2MaZjmaw61xA7N/NhaE4PbkpuGEMr/rR8I20ymqpuBskS+xcE+xyTWdG7g5leowcxKtibWNMYteNgq/KLt2xeifJRlNeo9XJ4j9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SfxyDzPG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SfxyDzPG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F85C4CEE6;
	Tue, 18 Feb 2025 03:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739849406;
	bh=SyQB9SkXvPzfX3KdD57jjhRb3Sqa7wo6LxGljuuL09A=;
	h=Date:To:From:Subject:From;
	b=SfxyDzPGSh0gU8dhxycZvw3GX+KqSPxWTT5VjH8ggcsgVPmcq/iNlGrQ5QlmJNtBW
	 iP6QDcsFUoEmBr/US+5nulQ6xVFepdkku8Qb+TDqapp3kLVolWNaFbNuCUKArcjSKv
	 xu9wcHZ/JiVTwUvk0z+556iRkGXaRtaHQKsENivo=
Date: Mon, 17 Feb 2025 19:30:06 -0800
To: mm-commits@vger.kernel.org,yazen.ghannam@amd.com,tony.luck@intel.com,tianruidong@linux.alibaba.com,tglx@linutronix.de,stable@vger.kernel.org,peterz@infradead.org,nao.horiguchi@gmail.com,mingo@redhat.com,linmiaohe@huawei.com,jpoimboe@kernel.org,Jonathan.Cameron@huawei.com,jarkko@kernel.org,jane.chu@oracle.com,hpa@zytor.com,dave.hansen@linux.intel.com,bp@alien8.de,baolin.wang@linux.alibaba.com,xueshuai@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-fix-incorrect-not-recovered-report-for-recovered-clean-pages.patch added to mm-unstable branch
Message-Id: <20250218033006.88F85C4CEE6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hwpoison: fix incorrect "not recovered" report for recovered clean pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hwpoison-fix-incorrect-not-recovered-report-for-recovered-clean-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hwpoison-fix-incorrect-not-recovered-report-for-recovered-clean-pages.patch

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
Subject: mm/hwpoison: fix incorrect "not recovered" report for recovered clean pages
Date: Mon, 17 Feb 2025 14:33:34 +0800

When an uncorrected memory error is consumed there is a race between the
CMCI from the memory controller reporting an uncorrected error with a UCNA
signature, and the core reporting and SRAR signature machine check when
the data is about to be consumed.

If the CMCI wins that race, the page is marked poisoned when
uc_decode_notifier() calls memory_failure().  For dirty pages,
memory_failure() invokes try_to_unmap() with the TTU_HWPOISON flag,
converting the PTE to a hwpoison entry.  As a result,
kill_accessing_process():

- call walk_page_range() and return 1 regardless of whether
  try_to_unmap() succeeds or fails,
- call kill_proc() to make sure a SIGBUS is sent
- return -EHWPOISON to indicate that SIGBUS is already sent to the
  process and kill_me_maybe() doesn't have to send it again.

However, for clean pages, the TTU_HWPOISON flag is cleared, leaving the
PTE unchanged and not converted to a hwpoison entry.  Conversely, for
clean pages where PTE entries are not marked as hwpoison,
kill_accessing_process() returns -EFAULT, causing kill_me_maybe() to send
a SIGBUS.

Console log looks like this:

    Memory failure: 0x827ca68: corrupted page was clean: dropped without side effects
    Memory failure: 0x827ca68: recovery action for clean LRU page: Recovered
    Memory failure: 0x827ca68: already hardware poisoned
    mce: Memory error not recovered

To fix it, return 0 for "corrupted page was clean", preventing an
unnecessary SIGBUS.

Link: https://lkml.kernel.org/r/20250217063335.22257-5-xueshuai@linux.alibaba.com
Fixes: 046545a661af ("mm/hwpoison: fix error page recovered but reported "not recovered"")
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Cc: <stable@vger.kernel.org>
Cc: Acked-by:Thomas Gleixner <tglx@linutronix.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: linmiaohe <linmiaohe@huawei.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ruidong Tian <tianruidong@linux.alibaba.com>
Cc: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-fix-incorrect-not-recovered-report-for-recovered-clean-pages
+++ a/mm/memory-failure.c
@@ -881,12 +881,17 @@ static int kill_accessing_process(struct
 	mmap_read_lock(p->mm);
 	ret = walk_page_range(p->mm, 0, TASK_SIZE, &hwpoison_walk_ops,
 			      (void *)&priv);
+	/*
+	 * ret = 1 when CMCI wins, regardless of whether try_to_unmap()
+	 * succeeds or fails, then kill the process with SIGBUS.
+	 * ret = 0 when poison page is a clean page and it's dropped, no
+	 * SIGBUS is needed.
+	 */
 	if (ret == 1 && priv.tk.addr)
 		kill_proc(&priv.tk, pfn, flags);
-	else
-		ret = 0;
 	mmap_read_unlock(p->mm);
-	return ret > 0 ? -EHWPOISON : -EFAULT;
+
+	return ret > 0 ? -EHWPOISON : 0;
 }
 
 /*
_

Patches currently in -mm which might be from xueshuai@linux.alibaba.com are

x86-mce-collect-error-message-for-severities-below-mce_panic_severity.patch
x86-mce-dump-error-msg-from-severities.patch
x86-mce-add-ex_type_efault_reg-as-in-kernel-recovery-context-to-fix-copy-from-user-operations-regression.patch
mm-hwpoison-fix-incorrect-not-recovered-report-for-recovered-clean-pages.patch
mm-memory-failure-move-return-value-documentation-to-function-declaration.patch

