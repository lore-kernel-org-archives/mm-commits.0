Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2331798F
	for <mm-commits@vger.kernel.org>; Thu, 12 Jun 2025 05:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749706857; cv=none; b=bOPxpavMdxy7WjL6A4/XQehxK/+wZAUVpbfZQGXQCWMjSvMmBz1u9w3w7RMT/c/csglddb5H+TBKfcEYu3ZREM8O/AvQuywG4E+DIgzJhZ3jX+t6UrnK0uBk7Eq9bD2ivg+HeuDuHRb+Z4gcP5JQopXZAxEBArYfN24kNGZBU/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749706857; c=relaxed/simple;
	bh=lpamnmj5OTRtpFNGxCMZkQth+PWkDnwaaFNUH3JvOp8=;
	h=Date:To:From:Subject:Message-Id; b=BPz0rDHk8PXjm11qLrR514ooq/AV3mCaNSPWi56tyV1ODi4KZUFH67d7oFyxHECD5AtUgYlPBHa+cYMq4++Vy8Pe60BFCiYO6+NHzmoc6hwGoNhUvO0DLrRSK43Y+inr1FDXdOXATUFbfOtJ6ghoUmrx6ANzD/q1vc5QyL01y8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mBi4buyy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mBi4buyy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71FEBC4CEEB;
	Thu, 12 Jun 2025 05:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749706856;
	bh=lpamnmj5OTRtpFNGxCMZkQth+PWkDnwaaFNUH3JvOp8=;
	h=Date:To:From:Subject:From;
	b=mBi4buyyyX7q5EzdgAAhXh759LLgMpHTL6APdPS+cQMrA0XF7Za+lXQtme5pK7cEu
	 dSuKJbC3ADgyly6Tb41oAQN4Td29H8vK+Y9acu+puY9LlxGYjJ5qQoYrjseDQm58VC
	 yJgRxtwQut3rbCIM03L8nYNSJ45HolQGoO3wuNJw=
Date: Wed, 11 Jun 2025 22:40:55 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,wangfushuai@baidu.com,tz2294@columbia.edu,npache@redhat.com,david@redhat.com,corbet@lwn.net,catalin.marinas@arm.com,andrii@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] docs-proc-update-vmflags-documentation-in-smaps-fix.patch removed from -mm tree
Message-Id: <20250612054056.71FEBC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs-proc-update-vmflags-documentation-in-smaps-fix
has been removed from the -mm tree.  Its filename was
     docs-proc-update-vmflags-documentation-in-smaps-fix.patch

This patch was dropped because it was folded into docs-proc-update-vmflags-documentation-in-smaps.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: docs-proc-update-vmflags-documentation-in-smaps-fix
Date: Sat Jun  7 02:20:52 PM PDT 2025

add "dp" (VM_DROPPABLE), per Tal

Cc: Tal Zussman <tz2294@columbia.edu>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mariano Pache <npache@redhat.com>
Cc: wangfushuai <wangfushuai@baidu.com>
Cc: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    1 +
 1 file changed, 1 insertion(+)

--- a/Documentation/filesystems/proc.rst~docs-proc-update-vmflags-documentation-in-smaps-fix
+++ a/Documentation/filesystems/proc.rst
@@ -610,6 +610,7 @@ encoded manner. The codes are the follow
     ss    shadow/guarded control stack page
     sl    sealed
     lf    lock on fault pages
+    dp    always lazily freeable mapping
     ==    =======================================
 
 Note that there is no guarantee that every flag and associated mnemonic will
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

docs-proc-update-vmflags-documentation-in-smaps.patch
drivers-rapidio-rio_cmc-prevent-possible-used-uninitialized.patch
mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix.patch

