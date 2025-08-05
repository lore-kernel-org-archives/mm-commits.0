Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE4B1DF759
	for <mm-commits@vger.kernel.org>; Tue,  5 Aug 2025 22:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754433573; cv=none; b=cF9RRnDTE1y+N7mVF2STUMYvEfX3EN3hpd0BdcrBZmJvYieH3eTqo/dpdG4S4BrPVJ3rLSBHoOyAMGtr6HOTxzn1QHttqf9na0kOjGsyazkBPPPo5Ei7BGkHQ1fWAJ+4a7MWu+dAJ4mrXvtO1kMRJQEShvdY5E3+RqaG9ILyTZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754433573; c=relaxed/simple;
	bh=5uFPkjE9Zhyj2tZpqf19UcC4h9kOkQPyKqm1QVchxhg=;
	h=Date:To:From:Subject:Message-Id; b=mL3yfzhmDa0SBe+mRGyeGSBidq/tHeMLByaQDIR8pMfPQYmCMoLsqEuc7f3r+uBDY3ezu74r1H990/zR1X3zPGMbGo0AFs8RhXM8JQHlX+fs4aoSCMAK2vL2AMtVm5YxHJsmmo2/ewZ7a1vDq1hjozQJUIhkyI2XdlLf8b3+CUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lQPVgUH5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lQPVgUH5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97310C4CEF0;
	Tue,  5 Aug 2025 22:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754433571;
	bh=5uFPkjE9Zhyj2tZpqf19UcC4h9kOkQPyKqm1QVchxhg=;
	h=Date:To:From:Subject:From;
	b=lQPVgUH5OG1GeooaUs9bapx1bF7keJzO7RrqZoi7wqPbLPa9Cq6EpYw/YFz3lTD/+
	 E3vDoam1WBVMtqmMk/DyDRZ812v1qzMFXao5NaEdz517n495pHaBXAAcvXCKKkp57C
	 GOibaQ8gdZkj0uGMr/m4GWAJ55D2W9GcJltItG0g=
Date: Tue, 05 Aug 2025 15:39:30 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,saravanak@google.com,robh@kernel.org,mingo@redhat.com,hpa@zytor.com,graf@amazon.com,dyoung@redhat.com,bp@alien8.de,bhe@redhat.com,makb@juniper.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-add-kexec_file_no_cma-as-a-legal-flag.patch added to mm-hotfixes-unstable branch
Message-Id: <20250805223931.97310C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec: add KEXEC_FILE_NO_CMA as a legal flag
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kexec-add-kexec_file_no_cma-as-a-legal-flag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-add-kexec_file_no_cma-as-a-legal-flag.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Brian Mak <makb@juniper.net>
Subject: kexec: add KEXEC_FILE_NO_CMA as a legal flag
Date: Tue, 5 Aug 2025 14:15:26 -0700

Commit 07d24902977e ("kexec: enable CMA based contiguous allocation")
introduces logic to use CMA-based allocation in kexec by default.  As part
of the changes, it introduces a kexec_file_load flag to disable the use of
CMA allocations from userspace.  However, this flag is broken since it is
missing from the list of legal flags for kexec_file_load.  kexec_file_load
returns EINVAL when attempting to use the flag.

Fix this by adding the KEXEC_FILE_NO_CMA flag to the list of legal flags
for kexec_file_load.

Link: https://lkml.kernel.org/r/20250805211527.122367-2-makb@juniper.net
Fixes: 07d24902977e ("kexec: enable CMA based contiguous allocation")
Signed-off-by: Brian Mak <makb@juniper.net>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Young <dyoung@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Saravana Kannan <saravanak@google.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/kexec.h~kexec-add-kexec_file_no_cma-as-a-legal-flag
+++ a/include/linux/kexec.h
@@ -460,7 +460,8 @@ bool kexec_load_permitted(int kexec_imag
 
 /* List of defined/legal kexec file flags */
 #define KEXEC_FILE_FLAGS	(KEXEC_FILE_UNLOAD | KEXEC_FILE_ON_CRASH | \
-				 KEXEC_FILE_NO_INITRAMFS | KEXEC_FILE_DEBUG)
+				 KEXEC_FILE_NO_INITRAMFS | KEXEC_FILE_DEBUG | \
+				 KEXEC_FILE_NO_CMA)
 
 /* flag to track if kexec reboot is in progress */
 extern bool kexec_in_progress;
_

Patches currently in -mm which might be from makb@juniper.net are

kexec-add-kexec_file_no_cma-as-a-legal-flag.patch

