Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E55718E1F
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 03:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739849400; cv=none; b=cLYyGY31CHhBJAzONUMZx0DF+LjcVLNPY0okXcQc7fZDdKzgkgARZZm2MTnuh8F/stMlCEp5GfmbbdQksd0CC3Bn95lY6Cg0bkf09VxzCMRVnVU01PhzBRDOdvXqDTL5k1gtsRzw38lqLfcp9RQrwZt+Ko4ETQGBMKFxCtoMbf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739849400; c=relaxed/simple;
	bh=PWuvqeMpjNEGLpjHkt/mgplP7M/kvpBCtYzKf/6cWNo=;
	h=Date:To:From:Subject:Message-Id; b=WiNaLxkmUAxc8VawPSR9LDmDqg6ejn2k2IanALDcWUi2fRJqBUMr7wdXLAp4oItXdgYup15lc3PvObTjurOFfbD0RZtX8p8/Kq9D1lfw2tZRFFhyXQLjJ7irMKXirBssQ0BE8QtnsI4TQJqA5hftU/Vzir3yYny4iS8G5vPuJCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EFzUF8Mb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EFzUF8Mb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16EF2C4CEE6;
	Tue, 18 Feb 2025 03:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739849400;
	bh=PWuvqeMpjNEGLpjHkt/mgplP7M/kvpBCtYzKf/6cWNo=;
	h=Date:To:From:Subject:From;
	b=EFzUF8MbYdhxWc0GTExK9/gTbrde1QeEvYDzWknyyY1Ov19DTt2cXbyS2g9J4iEwb
	 1BtPBoA/fSBTtwKa3p5FPeu901QCEVinzTROR8lngKCWzJMHzwZEu32oQoEfu8X8B0
	 oUBrZOInojNSe8i9b84MYkP6j6wqS/3fWld7jF/o=
Date: Mon, 17 Feb 2025 19:29:59 -0800
To: mm-commits@vger.kernel.org,yazen.ghannam@amd.com,tony.luck@intel.com,tianruidong@linux.alibaba.com,tglx@linutronix.de,peterz@infradead.org,nao.horiguchi@gmail.com,mingo@redhat.com,linmiaohe@huawei.com,jpoimboe@kernel.org,Jonathan.Cameron@huawei.com,jarkko@kernel.org,jane.chu@oracle.com,hpa@zytor.com,dave.hansen@linux.intel.com,bp@alien8.de,baolin.wang@linux.alibaba.com,xueshuai@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mce-collect-error-message-for-severities-below-mce_panic_severity.patch added to mm-unstable branch
Message-Id: <20250218033000.16EF2C4CEE6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/mce: collect error message for severities below MCE_PANIC_SEVERITY
has been added to the -mm mm-unstable branch.  Its filename is
     x86-mce-collect-error-message-for-severities-below-mce_panic_severity.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-mce-collect-error-message-for-severities-below-mce_panic_severity.patch

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
Subject: x86/mce: collect error message for severities below MCE_PANIC_SEVERITY
Date: Mon, 17 Feb 2025 14:33:31 +0800

Patch series "mm/hwpoison: Fix regressions in memory failure handling", v2.

This series addresses three regressions identified in memory failure
handling, as discovered using ras-tools[1]:

- `./einj_mem_uc copyin -f`
- `./einj_mem_uc futex -f`
- `./einj_mem_uc instr`

The regressions in the copyin and futex cases were caused by the
replacement of `EX_TYPE_UACCESS` with `EX_TYPE_EFAULT_REG` in some
copy-from-user operations, leading to kernel panics.  The instr case
regression resulted from the PTE entry not being marked as hwpoison,
causing the system to send unnecessary SIGBUS signals.

These fixes ensure proper handling of memory errors and prevent kernel
panics and unnecessary signal dispatch.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/aegl/ras-tools.git


This patch (of 5):

Currently, mce_no_way_out() only collects error messages when the error
severity is equal to `MCE_PANIC_SEVERITY`.  To improve diagnostics, modify
the behavior to also collect error messages when the severity is less than
`MCE_PANIC_SEVERITY`.

Link: https://lkml.kernel.org/r/20250217063335.22257-1-xueshuai@linux.alibaba.com
Link: https://lkml.kernel.org/r/20250217063335.22257-2-xueshuai@linux.alibaba.com
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Cc: Acked-by:Thomas Gleixner <tglx@linutronix.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: linmiaohe <linmiaohe@huawei.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ruidong Tian <tianruidong@linux.alibaba.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/mce/core.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/cpu/mce/core.c~x86-mce-collect-error-message-for-severities-below-mce_panic_severity
+++ a/arch/x86/kernel/cpu/mce/core.c
@@ -925,12 +925,13 @@ static __always_inline void quirk_zen_if
  * Do a quick check if any of the events requires a panic.
  * This decides if we keep the events around or clear them.
  */
-static __always_inline int mce_no_way_out(struct mce_hw_err *err, char **msg, unsigned long *validp,
-					  struct pt_regs *regs)
+static __always_inline bool mce_no_way_out(struct mce_hw_err *err, char **msg,
+					   unsigned long *validp,
+					   struct pt_regs *regs)
 {
 	struct mce *m = &err->m;
 	char *tmp = *msg;
-	int i;
+	int i, cur_sev = MCE_NO_SEVERITY, sev;
 
 	for (i = 0; i < this_cpu_read(mce_num_banks); i++) {
 		m->status = mce_rdmsrl(mca_msr_reg(i, MCA_STATUS));
@@ -945,13 +946,17 @@ static __always_inline int mce_no_way_ou
 			quirk_zen_ifu(i, m, regs);
 
 		m->bank = i;
-		if (mce_severity(m, regs, &tmp, true) >= MCE_PANIC_SEVERITY) {
+		sev = mce_severity(m, regs, &tmp, true);
+		if (sev >= cur_sev) {
 			mce_read_aux(err, i);
 			*msg = tmp;
-			return 1;
+			cur_sev = sev;
 		}
+
+		if (cur_sev == MCE_PANIC_SEVERITY)
+			return true;
 	}
-	return 0;
+	return false;
 }
 
 /*
_

Patches currently in -mm which might be from xueshuai@linux.alibaba.com are

x86-mce-collect-error-message-for-severities-below-mce_panic_severity.patch
x86-mce-dump-error-msg-from-severities.patch
x86-mce-add-ex_type_efault_reg-as-in-kernel-recovery-context-to-fix-copy-from-user-operations-regression.patch
mm-hwpoison-fix-incorrect-not-recovered-report-for-recovered-clean-pages.patch
mm-memory-failure-move-return-value-documentation-to-function-declaration.patch

