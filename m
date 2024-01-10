Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B782D7484
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 04:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nxCHd4ue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2412EC433F1;
	Wed, 10 Jan 2024 04:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704861850;
	bh=U5yYN77T1g/GU0SQhc35nnBgHxLGNlHozKaOhMHGtjU=;
	h=Date:To:From:Subject:From;
	b=nxCHd4uepxaJDr0q4Fgy1IAjWNJ5W62q7eAPGyQrzM77G0kh9sh2MPav4sv2zMFIJ
	 L6ke+Z7Qx4/F+7MeEDT8OO9PYL0eXMmrF+JiGLfQfa3R7OF1l8hWyo8NzBoTSewSgd
	 i5cmrDQgHJb7sFK8NY20HFU2yAtHOTPHwyljnNdk=
Date: Tue, 09 Jan 2024 20:44:09 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,usama.anjum@collabora.com,surenb@google.com,sfr@canb.auug.org.au,seanjc@google.com,ryan.roberts@arm.com,peterx@redhat.com,mirq-linux@rere.qmqm.pl,Liam.Howlett@oracle.com,hughd@google.com,david@redhat.com,avagin@google.com,arnd@arndb.de,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-move-mmu-notification-mechanism-inside-mm-lock-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20240110044410.2412EC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs-proc-task_mmu-move-mmu-notification-mechanism-inside-mm-lock-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fs-proc-task_mmu-move-mmu-notification-mechanism-inside-mm-lock-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-move-mmu-notification-mechanism-inside-mm-lock-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-proc-task_mmu-move-mmu-notification-mechanism-inside-mm-lock-fix
Date: Tue Jan  9 08:41:17 PM PST 2024

narrow the scope of `range', per Sean

Cc: Andrei Vagin <avagin@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-move-mmu-notification-mechanism-inside-mm-lock-fix
+++ a/fs/proc/task_mmu.c
@@ -2432,7 +2432,6 @@ static long pagemap_scan_flush_buffer(st
 
 static long do_pagemap_scan(struct mm_struct *mm, unsigned long uarg)
 {
-	struct mmu_notifier_range range;
 	struct pagemap_scan_private p = {0};
 	unsigned long walk_start;
 	size_t n_ranges_out = 0;
@@ -2450,6 +2449,7 @@ static long do_pagemap_scan(struct mm_st
 
 	for (walk_start = p.arg.start; walk_start < p.arg.end;
 			walk_start = p.arg.walk_end) {
+		struct mmu_notifier_range range;
 		long n_out;
 
 		if (fatal_signal_pending(current)) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fs-proc-task_mmu-move-mmu-notification-mechanism-inside-mm-lock-fix.patch

