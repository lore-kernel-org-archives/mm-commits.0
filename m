Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93767765B
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 16:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R3/aWPlK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C186C433C7;
	Tue, 12 Dec 2023 16:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702398232;
	bh=kCYg9q55mFcm1m9yvp37imGZIyjDYMlOE20+Pl+Rmks=;
	h=Date:To:From:Subject:From;
	b=R3/aWPlK2Lf2C4sNgva2O88Mn1KTzmvgC2BoxSCcc9tK6vy8DlnknSZVtKZy662uE
	 WT+qvHVMPoGsNW5f3krkbb6HLJui3hUYGQEYGsKHLDYksDsIFzlT/F0rJCuni9Ng6G
	 IBHN7tfjoD0QVH25z/pcn77PBfJCzu/5+41EvnlI=
Date: Tue, 12 Dec 2023 08:23:51 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,mingo@redhat.com,hpa@zytor.com,horms@kernel.org,dave.hansen@linux.intel.com,bp@alien8.de,bhe@redhat.com,bhelgaas@google.com,ytcoode@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-kexec-simplify-the-logic-of-mem_region_callback.patch added to mm-nonmm-unstable branch
Message-Id: <20231212162352.1C186C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/kexec: simplify the logic of mem_region_callback()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     x86-kexec-simplify-the-logic-of-mem_region_callback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-kexec-simplify-the-logic-of-mem_region_callback.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Yuntao Wang <ytcoode@gmail.com>
Subject: x86/kexec: simplify the logic of mem_region_callback()
Date: Tue, 12 Dec 2023 23:05:06 +0800

The expression `mstart + resource_size(res) - 1` is actually equivalent to
`res->end`, simplify the logic of this function to improve readability.

Link: https://lkml.kernel.org/r/20231212150506.31711-1-ytcoode@gmail.com
Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/machine_kexec_64.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/arch/x86/kernel/machine_kexec_64.c~x86-kexec-simplify-the-logic-of-mem_region_callback
+++ a/arch/x86/kernel/machine_kexec_64.c
@@ -42,12 +42,9 @@ struct init_pgtable_data {
 static int mem_region_callback(struct resource *res, void *arg)
 {
 	struct init_pgtable_data *data = arg;
-	unsigned long mstart, mend;
 
-	mstart = res->start;
-	mend = mstart + resource_size(res) - 1;
-
-	return kernel_ident_mapping_init(data->info, data->level4p, mstart, mend);
+	return kernel_ident_mapping_init(data->info, data->level4p,
+					 res->start, res->end);
 }
 
 static int
_

Patches currently in -mm which might be from ytcoode@gmail.com are

crash_core-fix-the-check-for-whether-crashkernel-is-from-high-memory.patch
kexec-use-align-macro-instead-of-open-coding-it.patch
x86-kexec-simplify-the-logic-of-mem_region_callback.patch

