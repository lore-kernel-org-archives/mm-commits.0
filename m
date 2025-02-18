Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74E1186295
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 03:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739849408; cv=none; b=JAn36ByvEVI61UpxWo5vM5/s99BnblXOVrYffPfUwAhg5x2EPBMpA27yCoHPpbILuxaYcLa5tdg823gYcU5Bnv60Wb4W0PD/fgRfhNXWyblwXLlhFgG7O4F34raKE+KeU0z6z/kgABpDmm8PH4AUNCsTdkBLXn3nXc4S861eDuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739849408; c=relaxed/simple;
	bh=vYQOomF8hk9KWQO/X5uNnmlb1qXH7PpHkdlXCnMhDEc=;
	h=Date:To:From:Subject:Message-Id; b=fWeesAm1DdnzA3wC4IPnvxCFu4tbflE9C/R5/hwtMfB6pDVtfQgE4WviBa3sHNl6EdZON26xO1hZaWwfky0d556lLANUTRkZHeUk/5DjuVIuin/QWKjvMIpI87BC1CiOnQ7B082QulacVmjCeSmm1R4z7aKJqj6+EJA0LN/0w9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n1peiS1f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n1peiS1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A3D6C4CEE6;
	Tue, 18 Feb 2025 03:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739849408;
	bh=vYQOomF8hk9KWQO/X5uNnmlb1qXH7PpHkdlXCnMhDEc=;
	h=Date:To:From:Subject:From;
	b=n1peiS1fMogoLZlrGm+0ARqS1aTJf7TU6InICWOt7RtiU3wSl6zMYHfU0fIB/uhPh
	 XUpu23keELm+2WYL+M/fgv5xUdHI4cwJkaug7Djhm3wKW5POVET4ruPtEVugu/2Ude
	 HPqNpw98FOSUNdWBq3HQnEAUJFGuRk32JEMfiiWE=
Date: Mon, 17 Feb 2025 19:30:08 -0800
To: mm-commits@vger.kernel.org,yazen.ghannam@amd.com,tony.luck@intel.com,tianruidong@linux.alibaba.com,tglx@linutronix.de,peterz@infradead.org,nao.horiguchi@gmail.com,mingo@redhat.com,linmiaohe@huawei.com,jpoimboe@kernel.org,Jonathan.Cameron@huawei.com,jarkko@kernel.org,jane.chu@oracle.com,hpa@zytor.com,dave.hansen@linux.intel.com,bp@alien8.de,baolin.wang@linux.alibaba.com,xueshuai@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-move-return-value-documentation-to-function-declaration.patch added to mm-unstable branch
Message-Id: <20250218033008.9A3D6C4CEE6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memory-failure: move return value documentation to function declaration
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-move-return-value-documentation-to-function-declaration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-move-return-value-documentation-to-function-declaration.patch

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
Subject: mm: memory-failure: move return value documentation to function declaration
Date: Mon, 17 Feb 2025 14:33:35 +0800

Part of return value comments for memory_failure() were originally
documented at the call site.  Move those comments to the function
declaration to improve code readability and to provide developers with
immediate access to function usage and return information.

Link: https://lkml.kernel.org/r/20250217063335.22257-6-xueshuai@linux.alibaba.com
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Yazen Ghannam <yazen.ghannam@amd.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/mce/core.c |    7 -------
 mm/memory-failure.c            |   10 +++++++---
 2 files changed, 7 insertions(+), 10 deletions(-)

--- a/arch/x86/kernel/cpu/mce/core.c~mm-memory-failure-move-return-value-documentation-to-function-declaration
+++ a/arch/x86/kernel/cpu/mce/core.c
@@ -1403,13 +1403,6 @@ static void kill_me_maybe(struct callbac
 		return;
 	}
 
-	/*
-	 * -EHWPOISON from memory_failure() means that it already sent SIGBUS
-	 * to the current process with the proper error info,
-	 * -EOPNOTSUPP means hwpoison_filter() filtered the error event,
-	 *
-	 * In both cases, no further processing is required.
-	 */
 	if (ret == -EHWPOISON || ret == -EOPNOTSUPP)
 		return;
 
--- a/mm/memory-failure.c~mm-memory-failure-move-return-value-documentation-to-function-declaration
+++ a/mm/memory-failure.c
@@ -2216,9 +2216,13 @@ static void kill_procs_now(struct page *
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

x86-mce-collect-error-message-for-severities-below-mce_panic_severity.patch
x86-mce-dump-error-msg-from-severities.patch
x86-mce-add-ex_type_efault_reg-as-in-kernel-recovery-context-to-fix-copy-from-user-operations-regression.patch
mm-hwpoison-fix-incorrect-not-recovered-report-for-recovered-clean-pages.patch
mm-memory-failure-move-return-value-documentation-to-function-declaration.patch

