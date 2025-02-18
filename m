Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A73717A5BE
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 03:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739849402; cv=none; b=hQ0bHiIEGRDUlbuyTZqQB6g25N6RV5Q4ODC5XGkNZ/9pw66pHFqY79eV6s8/g/GBpT2j9+selioZlReIx38VdeYRZy5lrRENTS5jJTEX1YyVrit9m6x6jQ1dEDpASQkjbejwv3ACRxAzPO9w5+4OX9LIpECkh3owxUxdjmzPBfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739849402; c=relaxed/simple;
	bh=dOusRb2yI8TnGhroLCW9TQV82SKEypOmhQ5P5xcknxc=;
	h=Date:To:From:Subject:Message-Id; b=qlvg1HH8XhG16JUblz3yHqvErsfD3XKrZVYCmR7caN1QU+Ov7X+NJwKDplSz079q4WW37qpIOAOhbhw8Quj6O7rzEQaK1kNgO/XKPDffzqifOkKlz8XDkvN5sWfyZU2IgkeeMxIC5juMFlEqmS9XapO5eixeqrKYhcN+/I/dD54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OzQHdNfJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OzQHdNfJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C4DC4CEE6;
	Tue, 18 Feb 2025 03:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739849402;
	bh=dOusRb2yI8TnGhroLCW9TQV82SKEypOmhQ5P5xcknxc=;
	h=Date:To:From:Subject:From;
	b=OzQHdNfJ4xr97w6pqQHG+x9ZwCsFAQnf8foE0BgqXTrIWkkom/GqiH7Lfszg2UZIk
	 ooxUj5/VrdDZSHbyiGvO4mkDGDLCHYrBeknbjyCo4uHoNyk2hCOWTugp5ESEhV/TGX
	 4XCNZejCY3TH36V8kDA5zQHS+RY092rJuvMBzvGM=
Date: Mon, 17 Feb 2025 19:30:01 -0800
To: mm-commits@vger.kernel.org,yazen.ghannam@amd.com,tony.luck@intel.com,tianruidong@linux.alibaba.com,tglx@linutronix.de,peterz@infradead.org,nao.horiguchi@gmail.com,mingo@redhat.com,linmiaohe@huawei.com,jpoimboe@kernel.org,Jonathan.Cameron@huawei.com,jarkko@kernel.org,jane.chu@oracle.com,hpa@zytor.com,dave.hansen@linux.intel.com,bp@alien8.de,baolin.wang@linux.alibaba.com,xueshuai@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mce-dump-error-msg-from-severities.patch added to mm-unstable branch
Message-Id: <20250218033002.34C4DC4CEE6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/mce: dump error msg from severities
has been added to the -mm mm-unstable branch.  Its filename is
     x86-mce-dump-error-msg-from-severities.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-mce-dump-error-msg-from-severities.patch

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
Subject: x86/mce: dump error msg from severities
Date: Mon, 17 Feb 2025 14:33:32 +0800

The message in severities is useful for identifying the type of MCE that
has occurred; dump it if it is valid.

Link: https://lkml.kernel.org/r/20250217063335.22257-3-xueshuai@linux.alibaba.com
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
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

 arch/x86/kernel/cpu/mce/core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kernel/cpu/mce/core.c~x86-mce-dump-error-msg-from-severities
+++ a/arch/x86/kernel/cpu/mce/core.c
@@ -1456,6 +1456,8 @@ static void queue_task_work(struct mce_h
 	if (count > 1)
 		return;
 
+	if (msg)
+		pr_err("%s\n", msg);
 	task_work_add(current, &current->mce_kill_me, TWA_RESUME);
 }
 
_

Patches currently in -mm which might be from xueshuai@linux.alibaba.com are

x86-mce-collect-error-message-for-severities-below-mce_panic_severity.patch
x86-mce-dump-error-msg-from-severities.patch
x86-mce-add-ex_type_efault_reg-as-in-kernel-recovery-context-to-fix-copy-from-user-operations-regression.patch
mm-hwpoison-fix-incorrect-not-recovered-report-for-recovered-clean-pages.patch
mm-memory-failure-move-return-value-documentation-to-function-declaration.patch

