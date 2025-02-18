Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9CB19F115;
	Tue, 18 Feb 2025 03:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739849405; cv=none; b=UccUtBfeaVQAoKgvIh20PysrzRs/bRTNKoVoZwg9GLolS4PRZpmRSHQOb5e2HY3TPZUb1uJO2hJAghnZpy5qKEaP3kywUTI66oYzcU7OooACOZEgpQXGiiXMD+4AwlchGFnq8/WB97dfOfp/akSQEAGywi/br6JhaI45dk+VkSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739849405; c=relaxed/simple;
	bh=weL8xmE4l3Bx/MdvXdm65Gox2/U0dEiS50cMaIv8G0s=;
	h=Date:To:From:Subject:Message-Id; b=rx/mq2vmBnBYrG8ywPTk3D7RE0hGo01r+o6DcRNcguUR0QCbrz7VWKDQaCIdl/vA+60qsCiPjusOsz7xyEUuDc5/BG7IRJNTY9/hnNxrs4LYjWV/IqcweXjuUTLYNV7S6JPyAsa/4ZLg024+Dn8D/Vc4ieDYuX4iDrPa/9cZbXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bJ5DVxLi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bJ5DVxLi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5382EC4CEE6;
	Tue, 18 Feb 2025 03:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739849404;
	bh=weL8xmE4l3Bx/MdvXdm65Gox2/U0dEiS50cMaIv8G0s=;
	h=Date:To:From:Subject:From;
	b=bJ5DVxLihPsPtxHQVXeawe9SEDgpKl6rAtu8vKq6PZma53S1gFvcByyJ7V5MsjElc
	 oCogfXBHiBKDGVpQYkeNp2n+JPN/ZJAitb1Ldsz0cOsha2L48WQK3URlHpsh7TQHdg
	 /CQvGufqqhGraGv6567dtb10PEdTPYD5aFu1saCc=
Date: Mon, 17 Feb 2025 19:30:03 -0800
To: mm-commits@vger.kernel.org,yazen.ghannam@amd.com,tony.luck@intel.com,tianruidong@linux.alibaba.com,tglx@linutronix.de,stable@vger.kernel.org,peterz@infradead.org,nao.horiguchi@gmail.com,mingo@redhat.com,linmiaohe@huawei.com,jpoimboe@kernel.org,Jonathan.Cameron@huawei.com,jarkko@kernel.org,jane.chu@oracle.com,hpa@zytor.com,dave.hansen@linux.intel.com,bp@alien8.de,baolin.wang@linux.alibaba.com,xueshuai@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mce-add-ex_type_efault_reg-as-in-kernel-recovery-context-to-fix-copy-from-user-operations-regression.patch added to mm-unstable branch
Message-Id: <20250218033004.5382EC4CEE6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/mce: add EX_TYPE_EFAULT_REG as in-kernel recovery context to fix copy-from-user operations regression
has been added to the -mm mm-unstable branch.  Its filename is
     x86-mce-add-ex_type_efault_reg-as-in-kernel-recovery-context-to-fix-copy-from-user-operations-regression.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-mce-add-ex_type_efault_reg-as-in-kernel-recovery-context-to-fix-copy-from-user-operations-regression.patch

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
Subject: x86/mce: add EX_TYPE_EFAULT_REG as in-kernel recovery context to fix copy-from-user operations regression
Date: Mon, 17 Feb 2025 14:33:33 +0800

Commit 4c132d1d844a ("x86/futex: Remove .fixup usage") introduced a new
extable fixup type, EX_TYPE_EFAULT_REG, and later patches updated the
extable fixup type for copy-from-user operations, changing it from
EX_TYPE_UACCESS to EX_TYPE_EFAULT_REG.

Specifically, commit 99641e094d6c ("x86/uaccess: Remove .fixup usage")
altered the extable fixup type for the get_user family, while commit
4c132d1d844a ("x86/futex: Remove .fixup usage") addressed the futex
operations.  This change inadvertently caused a regression where the error
context for some copy-from-user operations no longer functions as an
in-kernel recovery context, leading to kernel panics with the message:
"Machine check: Data load in unrecoverable area of kernel."

To fix the regression, add EX_TYPE_EFAULT_REG as a in-kernel recovery
context for copy-from-user operations.

Link: https://lkml.kernel.org/r/20250217063335.22257-4-xueshuai@linux.alibaba.com
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Fixes: 4c132d1d844a ("x86/futex: Remove .fixup usage")
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

 arch/x86/kernel/cpu/mce/severity.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/arch/x86/kernel/cpu/mce/severity.c~x86-mce-add-ex_type_efault_reg-as-in-kernel-recovery-context-to-fix-copy-from-user-operations-regression
+++ a/arch/x86/kernel/cpu/mce/severity.c
@@ -16,6 +16,7 @@
 #include <asm/traps.h>
 #include <asm/insn.h>
 #include <asm/insn-eval.h>
+#include <linux/extable.h>
 
 #include "internal.h"
 
@@ -285,7 +286,8 @@ static bool is_copy_from_user(struct pt_
  */
 static noinstr int error_context(struct mce *m, struct pt_regs *regs)
 {
-	int fixup_type;
+	const struct exception_table_entry *e;
+	int fixup_type, imm;
 	bool copy_user;
 
 	if ((m->cs & 3) == 3)
@@ -294,9 +296,14 @@ static noinstr int error_context(struct
 	if (!mc_recoverable(m->mcgstatus))
 		return IN_KERNEL;
 
+	e = search_exception_tables(m->ip);
+	if (!e)
+		return IN_KERNEL;
+
 	/* Allow instrumentation around external facilities usage. */
 	instrumentation_begin();
-	fixup_type = ex_get_fixup_type(m->ip);
+	fixup_type = FIELD_GET(EX_DATA_TYPE_MASK, e->data);
+	imm  = FIELD_GET(EX_DATA_IMM_MASK,  e->data);
 	copy_user  = is_copy_from_user(regs);
 	instrumentation_end();
 
@@ -304,9 +311,13 @@ static noinstr int error_context(struct
 	case EX_TYPE_UACCESS:
 		if (!copy_user)
 			return IN_KERNEL;
-		m->kflags |= MCE_IN_KERNEL_COPYIN;
-		fallthrough;
-
+		m->kflags |= MCE_IN_KERNEL_COPYIN | MCE_IN_KERNEL_RECOV;
+		return IN_KERNEL_RECOV;
+	case EX_TYPE_IMM_REG:
+		if (!copy_user || imm != -EFAULT)
+			return IN_KERNEL;
+		m->kflags |= MCE_IN_KERNEL_COPYIN | MCE_IN_KERNEL_RECOV;
+		return IN_KERNEL_RECOV;
 	case EX_TYPE_FAULT_MCE_SAFE:
 	case EX_TYPE_DEFAULT_MCE_SAFE:
 		m->kflags |= MCE_IN_KERNEL_RECOV;
_

Patches currently in -mm which might be from xueshuai@linux.alibaba.com are

x86-mce-collect-error-message-for-severities-below-mce_panic_severity.patch
x86-mce-dump-error-msg-from-severities.patch
x86-mce-add-ex_type_efault_reg-as-in-kernel-recovery-context-to-fix-copy-from-user-operations-regression.patch
mm-hwpoison-fix-incorrect-not-recovered-report-for-recovered-clean-pages.patch
mm-memory-failure-move-return-value-documentation-to-function-declaration.patch

