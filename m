Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4A976046
	for <mm-commits@vger.kernel.org>; Fri, 28 Jun 2024 20:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719608198; cv=none; b=eG9o1CEyDkkSHclIKjjyA3uEyaCIJwqlIcCPc/jb2XMsy6jl9GAFIsaz2eemCFVi+suu+2TQCoe7ngH2+5Y3PlYUucPNCwc+n83Ad4dAANl/bg0frUXF+7Mm5xFyZnx9X/hT8I6QqsKEy5ZaZUpNekQegSMb2PNShyoOg0nfhKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719608198; c=relaxed/simple;
	bh=/jvfTiIvFPh/cVFPEfoaJxrh3zshmIsIA6Yjrv8H6rw=;
	h=Date:To:From:Subject:Message-Id; b=FTeJT1JFK/G+gd4u2HHufwULxlmKim6WszT/cwZt+8CFJQNsin5wV7X96WfWGKokk8yhC0ViDI9qo9lmtHHX66kJ8VkDvoC2EiOo1A7nSZaTJ7OHfxZIiLyBBomrbKJi8les17b3FUzIhV6It+viyRlDyVXb1l5ro7UahqM5ZBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uUEeZ/cO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uUEeZ/cO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8321AC2BD10;
	Fri, 28 Jun 2024 20:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719608197;
	bh=/jvfTiIvFPh/cVFPEfoaJxrh3zshmIsIA6Yjrv8H6rw=;
	h=Date:To:From:Subject:From;
	b=uUEeZ/cOGlQg0AAZ3Vihdp5xB/JUbOufKJf11L/z4PekyMIFuYknCwapTAMxDYi8P
	 e7bW1Xf6ECYP1REtMFOXHjAOi1JUIlCl5BzkbyFB32M1oSLV93Y4t8iWAqXnuBHAPo
	 GwlgKnis/pzxU+IRS5esUHP/UWZ2lAbzVUruGO0k=
Date: Fri, 28 Jun 2024 13:56:36 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,libang.li@antgroup.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-fix-input-and-output-inconsistencies.patch added to mm-unstable branch
Message-Id: <20240628205637.8321AC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem: fix input and output inconsistencies
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-fix-input-and-output-inconsistencies.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-fix-input-and-output-inconsistencies.patch

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
From: "Bang Li" <libang.li@antgroup.com>
Subject: mm/shmem: fix input and output inconsistencies
Date: Fri, 28 Jun 2024 11:23:27 +0800

Commit 19eaf44954df ("mm: thp: support allocation of anonymous multi-size
THP") added mTHP support for anonymous shmem.  We can configure different
policies through the multi-size THP sysfs interface for anonymous shmem.

But when we configure the "advise" policy of
/sys/kernel/mm/transparent_hugepage/hugepages-xxxkB/shmem_enabled, we
cannot write the "advise", but write the "madvise", which is unreasonable.
We should keep the output and input values consistent, which is more
convenient for users.

Link: https://lkml.kernel.org/r/20240628032327.16987-1-libang.li@antgroup.com
Fixes: 61a57f1b1da9 ("mm: shmem: add multi-size THP sysfs interface for anonymous shmem")
Signed-off-by: Bang Li <libang.li@antgroup.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Bang Li <libang.li@antgroup.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-fix-input-and-output-inconsistencies
+++ a/mm/shmem.c
@@ -4976,7 +4976,7 @@ static ssize_t thpsize_shmem_enabled_sto
 		clear_bit(order, &huge_shmem_orders_madvise);
 		set_bit(order, &huge_shmem_orders_within_size);
 		spin_unlock(&huge_shmem_orders_lock);
-	} else if (sysfs_streq(buf, "madvise")) {
+	} else if (sysfs_streq(buf, "advise")) {
 		spin_lock(&huge_shmem_orders_lock);
 		clear_bit(order, &huge_shmem_orders_always);
 		clear_bit(order, &huge_shmem_orders_inherit);
_

Patches currently in -mm which might be from libang.li@antgroup.com are

support-thpeligible-semantics-for-mthp-with-anonymous-shmem.patch
mm-shmem-fix-input-and-output-inconsistencies.patch

