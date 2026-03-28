Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46DE33DEF7
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 16:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774716217; cv=none; b=MOpVklp1gNamloOKCMbYVUPAvn02co4G/ukMQL4NfFdYrzMnvBog/rI5gCXAfF6dweKV/R1rOCur9/d2w69Gb+yRC9a+jBHONkaruo1TWd/T+FSgs861dJqnQXWs4figJEY3yxN5xaUBiIz5DsDxSK1FhwV0066qPHS9kQsRG44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774716217; c=relaxed/simple;
	bh=FiiipKKJhWMLdqeweCgV/hFj+WvTCAKrgCg/GhHsjfk=;
	h=Date:To:From:Subject:Message-Id; b=fNH58jTi9dmW7ZMDzWkf/We2JVF1YYY3eEVmBKlMeOQ7MkSEmTZv0WYAmod1U/5nhBVHaimwKzei1S+QqpMZxiVt4YwKHsrIYBNvUdkvvtj/tFPQnejBIQcZ/+eMPf07SgOamUr4hko55QWiZ90EmrzF+IX3jqYYY2EboqDsMlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rWsypRXc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rWsypRXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AE5AC4CEF7;
	Sat, 28 Mar 2026 16:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774716216;
	bh=FiiipKKJhWMLdqeweCgV/hFj+WvTCAKrgCg/GhHsjfk=;
	h=Date:To:From:Subject:From;
	b=rWsypRXc/xyXXOrriOpex0xYRxFJ1UzT7Jdi+imwjzcZNEUvTeumgI3MQw02l3fj8
	 JaKk+6Yo2QVtRa9/vojwVIde7hO3OgJ4ZyO8xsGGOROqV+4+AN2XHAL+UONbQ55Suw
	 KJhNA/OmzpemfhH+4eiUrJHzO7dhmOqZu+JEixrk=
Date: Sat, 28 Mar 2026 09:43:35 -0700
To: mm-commits@vger.kernel.org,mhklinux@outlook.com,ljs@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] drivers-hv-vmbus-replace-deprecated-mmap-hook-with-mmap_prepare-fix.patch removed from -mm tree
Message-Id: <20260328164336.6AE5AC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drivers-hv-vmbus-replace-deprecated-mmap-hook-with-mmap_prepare-fix
has been removed from the -mm tree.  Its filename was
     drivers-hv-vmbus-replace-deprecated-mmap-hook-with-mmap_prepare-fix.patch

This patch was dropped because it was folded into drivers-hv-vmbus-replace-deprecated-mmap-hook-with-mmap_prepare.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers-hv-vmbus-replace-deprecated-mmap-hook-with-mmap_prepare-fix
Date: Thu Mar 26 10:54:42 PM PDT 2026

restore struct vmbus_channel comment, per Michael Kelley

Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hyperv.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/hyperv.h~drivers-hv-vmbus-replace-deprecated-mmap-hook-with-mmap_prepare-fix
+++ a/include/linux/hyperv.h
@@ -1015,7 +1015,7 @@ struct vmbus_channel {
 	/* The max size of a packet on this channel */
 	u32 max_pkt_size;
 
-	/* function to mmap_prepare ring buffer memory to the channel's sysfs ring attribute */
+	/*  function to mmap ring buffer memory to the channel's sysfs ring attribute */
 	int (*mmap_prepare_ring_buffer)(struct vmbus_channel *channel, struct vm_area_desc *desc);
 
 	/* boolean to control visibility of sysfs for ring buffer */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

liveupdate-initialize-incoming-flb-state-before-finish-fix.patch
drivers-hv-vmbus-replace-deprecated-mmap-hook-with-mmap_prepare.patch
selftests-mm-vm_util-robust-write_file-fix.patch
lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix.patch

