Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D712913
	for <mm-commits@vger.kernel.org>; Sat,  8 Feb 2025 03:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738983904; cv=none; b=hqMZvZQrnh0Pe8ZKAc3SHGVM4eDXWEzIKPxerk/uf3cDJ22UulWhl8IeNgRqq1Mr6IiXmzSIhNOdiBJxddCVILSa/sQH4SxdL/BOCudQR8kD8TA2mAYBxEEAt38FVSY8qlQncoRZcf9CsPbNZa4YLGZGPp7nzBhhxJMHg77SMwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738983904; c=relaxed/simple;
	bh=36HBW9y2SRErOvgk3/7Ggh5S4s/HOziBRpxCynLV7ss=;
	h=Date:To:From:Subject:Message-Id; b=j1Rw6PFpLEVLLTdsaHBxvLyuPFdUdepPjOXwsQqkCTt25DgW36bNJks5Whaf3D4qSyA9ZPcbIPhNmbzImftMJseLcAhO52fI5MQiIYFd4abVdZWrkGdwnZnd4AGImmHn45L6Acejex9bsAa9fIb1wQ8ptc/SwY5C0+59zv+kuSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tgqtvlwd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tgqtvlwd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EFCCC4CED1;
	Sat,  8 Feb 2025 03:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738983903;
	bh=36HBW9y2SRErOvgk3/7Ggh5S4s/HOziBRpxCynLV7ss=;
	h=Date:To:From:Subject:From;
	b=tgqtvlwdmsK3CYZzex6uAtqKbPUtiJLHfuHVrefX3xFBw6L9ukuAFfKqjA1mDJT5A
	 eBoXYYCggzkRScaj178TOVbTUeb8sJpkpfAzB1rQWChbQu1OZrUgcon+pvzfBiMbNL
	 hrKSiQBgJFbl5OVOmv+N5+RvwVnXJiyZ2rBUJYR8=
Date: Fri, 07 Feb 2025 19:05:03 -0800
To: mm-commits@vger.kernel.org,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-myself-as-shmem-reviewer.patch added to mm-unstable branch
Message-Id: <20250208030503.9EFCCC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add myself as shmem reviewer
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-add-myself-as-shmem-reviewer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-myself-as-shmem-reviewer.patch

This patch will later appear in the mm-unstable branch at
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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: MAINTAINERS: add myself as shmem reviewer
Date: Fri, 7 Feb 2025 17:44:22 +0800

In the past year, I've primarily focused on shmem and added several
features to it, such as support for mTHP, large folio swap-out and swap-in
support, mTHP collapse support, skipping swapcache, and tmpfs support for
large folios, and so on.  Meanwhile I've also been helping with testing
and reviewing shmem related patches.

So I am willing to continue assisting with testing and reviewing shmem
related patches.  Let me be Cc'd on patches related to shmem.

Link: https://lkml.kernel.org/r/bcefbba9b2b44d4e661e6cc2c4187292a5beb467.1738918357.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickens <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-myself-as-shmem-reviewer
+++ a/MAINTAINERS
@@ -23883,6 +23883,7 @@ F:	drivers/hwmon/tmp513.c
 
 TMPFS (SHMEM FILESYSTEM)
 M:	Hugh Dickins <hughd@google.com>
+R:	Baolin Wang <baolin.wang@linux.alibaba.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	include/linux/shmem_fs.h
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-shmem-drop-the-unused-macro.patch
mm-shmem-remove-fadvise-comments.patch
mm-shmem-remove-duplicate-error-validation.patch
mm-shmem-change-the-return-value-of-shmem_find_swap_entries.patch
mm-shmem-factor-out-the-within_size-logic-into-a-new-helper.patch
maintainers-add-myself-as-shmem-reviewer.patch

