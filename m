Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4712946BC
	for <mm-commits@vger.kernel.org>; Fri, 12 Jan 2024 22:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y4Mv3QZb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0EA9C433C7;
	Fri, 12 Jan 2024 22:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705098950;
	bh=Z7mLFQdILSMqNYJ773S0LPMSGXqy5KRkIk8iRVh2q18=;
	h=Date:To:From:Subject:From;
	b=Y4Mv3QZbYrS+i8IJmAiGr6YBmZY3l3fPJX7aQMdng/vvVvzxYvf7g3VVZ7U9KdjGs
	 RlGBtGDIwv/MqKkjQaznkcSc+8ih95IpRIDb2292rATCPmXH3us2W4gYE5ABbo6sz+
	 yUUAeL5C21LrMkrwoXIS39wKAv5LlZDO68Z1udr0=
Date: Fri, 12 Jan 2024 14:35:50 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,usama.anjum@collabora.com,surenb@google.com,sfr@canb.auug.org.au,seanjc@google.com,ryan.roberts@arm.com,peterx@redhat.com,mirq-linux@rere.qmqm.pl,Liam.Howlett@oracle.com,hughd@google.com,david@redhat.com,avagin@google.com,arnd@arndb.de,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] fs-proc-task_mmu-move-mmu-notification-mechanism-inside-mm-lock-fix.patch removed from -mm tree
Message-Id: <20240112223550.A0EA9C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs-proc-task_mmu-move-mmu-notification-mechanism-inside-mm-lock-fix
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-move-mmu-notification-mechanism-inside-mm-lock-fix.patch

This patch was dropped because it was folded into fs-proc-task_mmu-move-mmu-notification-mechanism-inside-mm-lock.patch

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

fs-proc-task_mmu-move-mmu-notification-mechanism-inside-mm-lock.patch
kernel-crash_corec-make-__crash_hotplug_lock-static.patch

