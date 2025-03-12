Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332111F0980;
	Wed, 12 Mar 2025 22:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741818376; cv=none; b=SUe1D6wl2PkCNXJmqEnh2utqzAc3KO19FSHt+5sV5G5ei1GB5kouzK9an96RJotNb6gHtQp0QRnkPM8y6b0vNWF3PzZBt2FKBA4sO5lKrIn+mzdwNiYKh06bIu1aT3guxuRqPWWp6R064JKds5heP2elmUKfYHfeWRRL1jKm12Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741818376; c=relaxed/simple;
	bh=UoGO1y2Nz9qxKT9P5/BY6QSZpqY6eS/gP7FgNDyFCNw=;
	h=Date:To:From:Subject:Message-Id; b=qJl140paWm7U61p8VPVE5Evi9NfeekB2qga60EShphAz4z4ggOhFQC5IDb7i3wtywox3HIIe4fO2JdaoTDRLVIdMn0SHeVUPyiAevUnge8yf2axtjt09xypbXD7aGWW7ivn8PM0mM3cys0vD2M8cXBlBBsHQxRehDyDvEtcBpyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zyYita31; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zyYita31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5002C4CEDD;
	Wed, 12 Mar 2025 22:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741818375;
	bh=UoGO1y2Nz9qxKT9P5/BY6QSZpqY6eS/gP7FgNDyFCNw=;
	h=Date:To:From:Subject:From;
	b=zyYita318hdTyqWKJBCJcydc5qqtGAnFPljztnYxLKSuJraHqKiYyINl5Fcf1Ae2e
	 74q/bu8r6yohsTlya2AftrbARhSlx2sAFYuFaMpoZ0Erp1JN6GrxFTmo4C0IV/dT7c
	 yydk+5dgZBozrSkQY147EPbd3TwF2Cc31v2FEqI8=
Date: Wed, 12 Mar 2025 15:26:15 -0700
To: mm-commits@vger.kernel.org,yazen.ghannam@amd.com,tony.luck@intel.com,tianruidong@linux.alibaba.com,tglx@linutronix.de,stable@vger.kernel.org,peterz@infradead.org,nao.horiguchi@gmail.com,mingo@redhat.com,linmiaohe@huawei.com,jpoimboe@kernel.org,Jonathan.Cameron@huawei.com,jarkko@kernel.org,jane.chu@oracle.com,hpa@zytor.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,baolin.wang@linux.alibaba.com,xueshuai@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-do-not-send-sigbus-to-processes-with-recovered-clean-pages.patch added to mm-unstable branch
Message-Id: <20250312222615.A5002C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hwpoison: do not send SIGBUS to processes with recovered clean pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hwpoison-do-not-send-sigbus-to-processes-with-recovered-clean-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hwpoison-do-not-send-sigbus-to-processes-with-recovered-clean-pages.patch

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
Subject: mm/hwpoison: do not send SIGBUS to processes with recovered clean pages
Date: Wed, 12 Mar 2025 19:28:51 +0800

When an uncorrected memory error is consumed there is a race between the
CMCI from the memory controller reporting an uncorrected error with a UCNA
signature, and the core reporting and SRAR signature machine check when
the data is about to be consumed.

- Background: why *UN*corrected errors tied to *C*MCI in Intel platform [1]

Prior to Icelake memory controllers reported patrol scrub events that
detected a previously unseen uncorrected error in memory by signaling a
broadcast machine check with an SRAO (Software Recoverable Action
Optional) signature in the machine check bank.  This was overkill because
it's not an urgent problem that no core is on the verge of consuming that
bad data.  It's also found that multi SRAO UCE may cause nested MCE
interrupts and finally become an IERR.

Hence, Intel downgrades the machine check bank signature of patrol scrub
from SRAO to UCNA (Uncorrected, No Action required), and signal changed to
#CMCI.  Just to add to the confusion, Linux does take an action (in
uc_decode_notifier()) to try to offline the page despite the UC*NA*
signature name.

- Background: why #CMCI and #MCE race when poison is consuming in Intel platform [1]

Having decided that CMCI/UCNA is the best action for patrol scrub errors,
the memory controller uses it for reads too.  But the memory controller is
executing asynchronously from the core, and can't tell the difference
between a "real" read and a speculative read.  So it will do CMCI/UCNA if
an error is found in any read.

Thus:

1) Core is clever and thinks address A is needed soon, issues a speculative read.
2) Core finds it is going to use address A soon after sending the read request
3) The CMCI from the memory controller is in a race with MCE from the core
   that will soon try to retire the load from address A.

Quite often (because speculation has got better) the CMCI from the memory
controller is delivered before the core is committed to the instruction
reading address A, so the interrupt is taken, and Linux offlines the page
(marking it as poison).

- Why user process is killed for instr case

Commit 046545a661af ("mm/hwpoison: fix error page recovered but reported
"not recovered"") tries to fix noise message "Memory error not recovered"
and skips duplicate SIGBUSs due to the race.  But it also introduced a bug
that kill_accessing_process() return -EHWPOISON for instr case, as result,
kill_me_maybe() send a SIGBUS to user process.

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
unnecessary SIGBUS to user process.

[1] https://lore.kernel.org/lkml/20250217063335.22257-1-xueshuai@linux.alibaba.com/T/#mba94f1305b3009dd340ce4114d3221fe810d1871
Link: https://lkml.kernel.org/r/20250312112852.82415-3-xueshuai@linux.alibaba.com
Fixes: 046545a661af ("mm/hwpoison: fix error page recovered but reported "not recovered"")
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Tested-by: Tony Luck <tony.luck@intel.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ruidong Tian <tianruidong@linux.alibaba.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Yazen Ghannam <yazen.ghannam@amd.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-do-not-send-sigbus-to-processes-with-recovered-clean-pages
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

x86-mce-use-is_copy_from_user-to-determine-copy-from-user-context.patch
mm-hwpoison-do-not-send-sigbus-to-processes-with-recovered-clean-pages.patch
mm-memory-failure-enhance-comments-for-return-value-of-memory_failure.patch

