Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8581435DA6C
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622897; cv=none; b=BmodsFVDzQTEhkrDWOnmNUcx2xu2l1nEDQlxc93aSLepUaoc0IJWGULlxCeEdoxoqsWg/KMNNdH5WJpwqF9hQSMzi6pqdL/vnJQ0ILUISvUBl2v8iGv1J036R1UIZc7L7oBxaJ3Z3Z0eakHax7TRRAYKtj6/Hl8w7mUClOMysHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622897; c=relaxed/simple;
	bh=HZiLECApTWWxaw2DoO+mn7Nqk6PVN4NkONE4OyC7qD8=;
	h=Date:To:From:Subject:Message-Id; b=rNh89cOgd2uB44zv/+m9rQUnIN0ZXxzpL96X2qHteTRVBm4fDfV7IeXNbq4tF4dWS53GmOOr2rvPoV7dNkul8E39qyZJe4WwjUIOSIaV7mGS3XPmytqKQwY2j94E6Ltwrcr0ZW42eNMUucjlTPakX2h/ookGYGQDod232JzBeYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NxeND02D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NxeND02D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7601F000E9;
	Tue, 25 Aug 2026 01:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622895;
	bh=XOB3IG9qxc7GSwbkdMCKp3TX2zd1erjGlZgmgH2IcJk=;
	h=Date:To:From:Subject;
	b=NxeND02DzncIJvkq4kwOtdLdvgT1UmEuuDwwUrx5lHYUgi1iM/3dBvxTCX22jxqn3
	 vij+8WlmRTrsHiwlaxAdYBNktk8cj0ll9CCcTz78CZFSOCm0ySOCtRgnwhahLx6eEB
	 Cnj53mDxyGqkkbvZGx8Yadd+Oo2R0TE7zLyIX7OQ=
Date: Mon, 24 Aug 2026 18:54:54 -0700
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmstat-add-nrswpinout-counters.patch removed from -mm tree
Message-Id: <20260825015455.5A7601F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmstat: add NRSWP{IN,OUT} counters
has been removed from the -mm tree.  Its filename was
     mm-vmstat-add-nrswpinout-counters.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm/vmstat: add NRSWP{IN,OUT} counters
Date: Mon, 13 Jul 2026 11:33:44 +0200

Count how many swap I/Os we cause.  Due to batching this can be different
than the current counter number of pages written/read, and tracking this
information is useful to see how efficient the batching is.

The counters are added at the end of enum vm_event_item and the
vmstat_text array under the assumption that the order of fields in
/proc/vmstat is an ABI.  If that is not the case, they could be grouped
with the other swap counters.

Link: https://lore.kernel.org/20260713093350.2154226-8-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Youngjun Park <youngjun.park@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |    4 ++++
 mm/page_io.c                  |    2 ++
 mm/vmstat.c                   |    6 +++++-
 3 files changed, 11 insertions(+), 1 deletion(-)

--- a/include/linux/vm_event_item.h~mm-vmstat-add-nrswpinout-counters
+++ a/include/linux/vm_event_item.h
@@ -175,6 +175,10 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		KSTACK_REST,
 #endif
 #endif /* CONFIG_DEBUG_STACK_USAGE */
+#ifdef CONFIG_SWAP
+		NRSWPIN,
+		NRSWPOUT,
+#endif /* CONFIG_SWAP */
 		NR_VM_EVENT_ITEMS
 };
 
--- a/mm/page_io.c~mm-vmstat-add-nrswpinout-counters
+++ a/mm/page_io.c
@@ -704,6 +704,7 @@ void swap_write_submit(struct swap_io_ct
 {
 	if (!ctx->sio)
 		return;
+	count_vm_events(NRSWPOUT, 1);
 	ctx->sis->ops->submit_write(ctx);
 	ctx->sio = NULL;
 	ctx->sis = NULL;
@@ -713,6 +714,7 @@ void swap_read_submit(struct swap_io_ctx
 {
 	if (!ctx->sio)
 		return;
+	count_vm_events(NRSWPIN, 1);
 	ctx->sis->ops->submit_read(ctx);
 	ctx->sio = NULL;
 	ctx->sis = NULL;
--- a/mm/vmstat.c~mm-vmstat-add-nrswpinout-counters
+++ a/mm/vmstat.c
@@ -1502,7 +1502,11 @@ const char * const vmstat_text[] = {
 #if THREAD_SIZE > 65536
 	[I(KSTACK_REST)]			= "kstack_rest",
 #endif
-#endif
+#endif /* CONFIG_DEBUG_STACK_USAGE */
+#ifdef CONFIG_SWAP
+	[I(NRSWPIN)]				= "nrswpin",
+	[I(NRSWPOUT)]				= "nrswpout",
+#endif /* CONFIG_SWAP */
 #undef I
 #endif /* CONFIG_VM_EVENT_COUNTERS */
 };
_

Patches currently in -mm which might be from hch@lst.de are


