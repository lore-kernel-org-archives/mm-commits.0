Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A0B139D0A
	for <mm-commits@vger.kernel.org>; Tue, 31 Dec 2024 02:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735610401; cv=none; b=KK8t6TkmbXkePypjgJIY3mrObbJLAlcwBi0ptl4zlrHDG/5x1p0OPtVUDjHCKLmuUJUtYmYxEq2lRjVuaiTAVoPqB57pQ47gBsLz3TwZmdZmvVM+WcVUJWeOmyvtwvcNY9SKa1evkaapIV4dYJOI7msPgXTi0tVh6McESe06h8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735610401; c=relaxed/simple;
	bh=P310uBg1S5iVLh1dFXKh9C4gKKWtgTo3FSwGGY4ZeU8=;
	h=Date:To:From:Subject:Message-Id; b=mCmqeDFdBd8ZPSZ1h0uYGYvqXWF41T9P9dVU9Pe9huEJnTcQBuKdYvKXVRxY1NxG/fyThHzH5QCwZVC8+FqMt9JI7Ad52vIRSRPeaoHQ6o1m5Z7em9+6wxY9LKIc2xtywqFOZAkDer4vUNPUMbrM5hThX4zHtTf1bDChcvXWglY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ed+6CTXa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ed+6CTXa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD44C4CED0;
	Tue, 31 Dec 2024 02:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735610401;
	bh=P310uBg1S5iVLh1dFXKh9C4gKKWtgTo3FSwGGY4ZeU8=;
	h=Date:To:From:Subject:From;
	b=Ed+6CTXa+c3jnkqqtpogqM8oovRaUhbC5Rs/BOg/GaJZ3yl8evi+c/CR3Kcoa0s/v
	 f3tgvfptxAzxzDKqpDwGSsEn01l5NzrJw2JAKbGm3ABJbBFyW/cOOExKQCfSIxIVPO
	 uKKqVlhvgZVkceA2RuMsc5uNFZHnzLvETwp/Xtss=
Date: Mon, 30 Dec 2024 18:00:00 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] docs-mm-fix-the-incorrect-filehugemapped-field.patch removed from -mm tree
Message-Id: <20241231020001.7BD44C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs: mm: fix the incorrect 'FileHugeMapped' field
has been removed from the -mm tree.  Its filename was
     docs-mm-fix-the-incorrect-filehugemapped-field.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: docs: mm: fix the incorrect 'FileHugeMapped' field
Date: Tue, 17 Dec 2024 16:55:39 +0800

The '/proc/PID/smaps' does not have the 'FileHugeMapped' field to count
the file transparent huge pages, instead, the 'FilePmdMapped' field should
be used.  Fix it.

Link: https://lkml.kernel.org/r/d520ce3aba2b03b088be30bece732426a939049a.1734425264.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~docs-mm-fix-the-incorrect-filehugemapped-field
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -436,7 +436,7 @@ AnonHugePmdMapped).
 The number of file transparent huge pages mapped to userspace is available
 by reading ShmemPmdMapped and ShmemHugePages fields in ``/proc/meminfo``.
 To identify what applications are mapping file transparent huge pages, it
-is necessary to read ``/proc/PID/smaps`` and count the FileHugeMapped fields
+is necessary to read ``/proc/PID/smaps`` and count the FilePmdMapped fields
 for each mapping.
 
 Note that reading the smaps file is expensive and reading it
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-factor-out-the-order-calculation-into-a-new-helper.patch
mm-shmem-change-shmem_huge_global_enabled-to-return-huge-order-bitmap.patch
mm-shmem-add-large-folio-support-for-tmpfs.patch
mm-shmem-add-a-kernel-command-line-to-change-the-default-huge-policy-for-tmpfs.patch
docs-tmpfs-drop-fadvise-from-the-documentation.patch

