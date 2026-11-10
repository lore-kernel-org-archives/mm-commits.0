Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794293133;
	b=kt1lpcdl1p93n3Kerwps3tPdI6ePeDKAYgnthCwTt8cfEWvPM0R/WWiN3OpSDDUbbfQn
	 EJWnTzB95x+NC9RfLMeioXtUAFRa9bwDm/DUNvLqoV3arjiWrx94LOWibcQl9mNwOGgE1
	 agSYfiZB2mOpcV/2Euz4LGmcLr+UpWvipeROSlDn4q6rjPV9j0/QyzPSA2LkSmT7ekAkg
	 /V/V77zHmzJ+KvmFIExqUDXAjsGMj/B6Qh8uT5vPFdf6rs82m/yr7K4ufpnQs2UP/bwYb
	 v4NJhUlrCK5woJNYqJVDFTIM65OgexHBrg5thuMWx/3aeGB1Vhpg0j06KiGyQ0x9k3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794293133;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=v73rjsZ52oh84OVAHd0hhLfTyWwxgFrGuKwXT1yjHA0=;
	b=qDxgfAAs1Z4kdUPiy0qHt+rdWnVMTjmFcwcBYXAJpLCdNm/sUGADyAkT9pFqUEbEGqd5
	 d4BmCq3RWao1o7VK/X6vtP1Y/gWad/opuiAq72tDQzvxRvpx9QL/E258UHJkLHnZL0cYo
	 Z2pFfyNetX8AfglaYuiHhJ7WIN4Y4DRfoXhMJiDidTrZGFvQliwOvfkGLCJqW5/Do4UeX
	 kW5nEw+Pe6ehDvLpaIFNkpCS155bNeDlB15zW4Y3bTp0fg5NQhWb0XIeFxfwcPsf+dyzc
	 rU4guAQBCiUP1Aw75DoPigQgkmaBSVOa7RaGgfBEJE10FthKsqCqURMYKxGlK86I+Bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=eb5SwEBZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98BE606CB30
	for <mm-commits@vger.kernel.org>; Tue, 10 Nov 2026 06:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=eb5SwEBZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D3B1F008A2;
	Tue, 10 Nov 2026 06:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794293132;
	bh=v73rjsZ52oh84OVAHd0hhLfTyWwxgFrGuKwXT1yjHA0=;
	h=Date:To:From:Subject;
	b=eb5SwEBZyfSdaJ1K9pqsfPcz8163xJ7iJsUdTGWb3Tj3+ZVF586zBIyDiIkzjIsWN
	 31+l6R4zDlhwtAPlykRR8zQXZHLlARLqSbbAYeGDT7/0eIczRhWTZCZb8PWQmeLfYZ
	 oKa1oV11Fs7pyH7aA7gQ+jXbd4ar03jEm0MYxjtI=
Date: Mon, 09 Nov 2026 22:45:32 -0800
To: mm-commits@vger.kernel.org,pizhenwei@bytedance.com,
	nao.horiguchi@gmail.com,mchehab+huawei@kernel.org,linmiaohe@huawei.com,
	m.chehab@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memory-failure-update-statistics-before-emitting-the-trace-event.patch removed from -mm tree
Message-Id: <20261110064532.93D3B1F008A2@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: memory-failure: update statistics before emitting the trace event
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-update-statistics-before-emitting-the-trace-event.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mauro Carvalho Chehab <m.chehab@huawei.com>
Subject: mm: memory-failure: update statistics before emitting the trace event
Date: Wed, 28 Oct 2026 09:09:57 +0100

Today's rasdaemon-ci run showed a race condition at the page poison logic
affecting userspace (rasdaemon): action_result() emits a
memory_failure_event before incrementing num_poisoned_pages and updating
the per-node memory failure statistics.

That causes userspace to read /proc/meminfo to detect HardwareCorrupted
trace events to warn if the value exceeds POISON_STAT_THRESHOLD.  This
works most of the cases, but there is a chance that the value not being
updated in time before libtraceevent notification is handled.

Root cause is commit e240ac52f7da ("mm/memory-failure.c: simplify
num_poisoned_pages_inc/dec") which changed the order of updates.

Rasdaemod-ci run up to Oct 27 worked properly, but on today's run, it
failed to get the HardwareCorrupted data from /proc/meminfo because
it was updated only after trigging the hardware error event:
	https://mchehab.github.io/rasdaemon-ci/failures/20261028T035110Z-40629018388/daily/aarch64/consumer-poison-page-stat.html

E.g. it failed to log this:
	rasdaemon: Poison page statistics exceeded threshold: 4 kB (threshold: 0 kB)

This is important for rasdaemon, as the consumer's action monitors a
failed threshold before poisoning pages.  So, if the counter doesn't
update properly, it will end not poisoning pages at the expected
threshold.

Link: https://lore.kernel.org/d472a9a3ccfa8c0359d7d7acabed92c8927d8e47.1793174996.git.mchehab+huawei@kernel.org
Fixes: e240ac52f7da ("mm/memory-failure.c: simplify num_poisoned_pages_inc/dec")
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://github.com/mchehab/rasdaemon-ci/actions/runs/40629018388
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: zhenwei pi <pizhenwei@bytedance.com>
---

 mm/memory-failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-update-statistics-before-emitting-the-trace-event
+++ a/mm/memory-failure.c
@@ -1320,13 +1320,13 @@ static bool panic_on_unrecoverable_mf(en
 static int action_result(unsigned long pfn, enum mf_action_page_type type,
 			 enum mf_result result)
 {
-	trace_memory_failure_event(pfn, type, result);
-
 	if (type != MF_MSG_ALREADY_POISONED && type != MF_MSG_PFN_MAP) {
 		num_poisoned_pages_inc(pfn);
 		update_per_node_mf_stats(pfn, result);
 	}
 
+	trace_memory_failure_event(pfn, type, result);
+
 	pr_err("%#lx: recovery action for %s: %s\n",
 		pfn, action_page_types[type], action_name[result]);
 
_

Patches currently in -mm which might be from m.chehab@huawei.com are


