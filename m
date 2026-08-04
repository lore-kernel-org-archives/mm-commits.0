Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19973E8C74
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816336; cv=none; b=UaUxvWauhEaOm8Pb5N0fqd8RBgV+tZcqBQVfju787Ul4HrMkc4bVJ8jwMnvr8xk55Lje8TaGBz21TCcHNWFyumnHFjoq1QIeA4cua91rqbkkqZwZUW97N/LbKlsW0oXGXb6lqEZMWzcA5++2AXpYUEjMTSxMWHZu0lbyi1algXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816336; c=relaxed/simple;
	bh=yB2CAGIV3BiQ7z8a5tl/qCzSnt5KVrUtW7CWue+O3k4=;
	h=Date:To:From:Subject:Message-Id; b=hCQ7gr6EJT/juDxVTMKYXkkdCf/YQCzHp6ceo3GKaU3cgCRCT7LvXRPxxK1tlPT2NeCn7Ds2LY8nY9GOs5R75PCE5bheTybgD/oFvuzQ4gCECiK+RmzzhUE1zAG+YO+nY8yUTwR4wsHQ9vWPh5JC296bqBHEejoPfhdMLBaqxw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xGi6sZ1v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xGi6sZ1v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 887261F000E9;
	Tue,  4 Aug 2026 04:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816335;
	bh=Wgk0txcmoaTVzVhV0eZcKSrLfn/F0s4z7ulqyIczSi4=;
	h=Date:To:From:Subject;
	b=xGi6sZ1vODBfEXbGOFLn3bTKaYV3C8zuFVIpI8dIfDC2GoEXJLqanS3M64bnmkRlq
	 1Rf6oh5MvdgGCDJJEL9Tau0OvbX/ELYghMTkP3XDjnexGJXIzOyMQzIwumgsbsBOSG
	 OVamZ4ZrDugBnSjeJJFwl1JNTbWxDtC2mY8G/10o=
Date: Mon, 03 Aug 2026 21:05:35 -0700
To: mm-commits@vger.kernel.org,ebiggers@kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] raid6-enable-lock-context-analysis.patch removed from -mm tree
Message-Id: <20260804040535.887261F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: raid6: enable lock context analysis
has been removed from the -mm tree.  Its filename was
     raid6-enable-lock-context-analysis.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: raid6: enable lock context analysis
Date: Wed, 15 Jul 2026 16:47:36 +0200

The code doesn't have any locking, so this is trivial.

Link: https://lore.kernel.org/20260715144825.95432-6-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/raid/raid6/Makefile |    2 ++
 1 file changed, 2 insertions(+)

--- a/lib/raid/raid6/Makefile~raid6-enable-lock-context-analysis
+++ a/lib/raid/raid6/Makefile
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
+CONTEXT_ANALYSIS := y
+
 ccflags-y			+= -I $(src)
 
 ifeq ($(CONFIG_RAID6_PQ_ARCH),y)
_

Patches currently in -mm which might be from hch@lst.de are

mm-remove-wb_writeout_inc.patch
shmem-provide-a-shmem_write_folio-wrapper.patch
mm-swap-introduce-struct-swap_io_ctx.patch
mm-swap-also-use-struct-swap_iocb-for-block-i-o.patch
mm-swap-remove-count_swpout_vm_event.patch
mm-swap-use-swap_ops-to-register-swap-devices-methods.patch
mm-swap-remove-swp_fs_ops.patch
mm-vmstat-add-nrswpinout-counters.patch

