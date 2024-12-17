Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0E626296
	for <mm-commits@vger.kernel.org>; Tue, 17 Dec 2024 18:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734458807; cv=none; b=l51K8uniNF07AglUx8JHSgdsC4tvitq/w1tBM6wSyri3Tt+mRMlnMVfd2fgnX7xUBFP5AgZGj8k9L1cbJZ1RNSCCXY7QvVz9X1OvgxxeD06H8AES8bRy7EGrC7zaWxd+OrzBR2f4JO8x4mlc69qAgivfOPgDTWZDM8hWK4gf2tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734458807; c=relaxed/simple;
	bh=v56tMx9q+g8/y3A845pg4jCoOR5e4JGBQb2kOYoQUlk=;
	h=Date:To:From:Subject:Message-Id; b=NuzLDHscdVykpzrkoJw3wt7WGwc22FvVCTW8cDAKZDKZ170CoJL8MmZN3jvHmdLL4MjONlPH/enHeE0asKJ1p+xCS3CYKPrbxKm1HSl/p48nE7h9Djxl3I058M+5pO/CR0BzyQb7ZWlG72CCZ0gqtQJ3hbeBxCIg8BTYeznRH/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KkEw2guR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KkEw2guR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A1AC4CED3;
	Tue, 17 Dec 2024 18:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734458807;
	bh=v56tMx9q+g8/y3A845pg4jCoOR5e4JGBQb2kOYoQUlk=;
	h=Date:To:From:Subject:From;
	b=KkEw2guRstup+jjnNKGjyDFWiX80rd7WYQB9QQq3IWkT8z3216GVBCozwAqcd8lPv
	 x8O6x2tRBBm4slzhKdYewORyscL8e49JsyXn5Qg8BIGhwpfL73auksuOJ+fPVWcn76
	 svVvX1lc1VGkc751P424nnyE7OwemlPzFwiJoxe0=
Date: Tue, 17 Dec 2024 10:06:46 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-fix-the-incorrect-filehugemapped-field.patch added to mm-hotfixes-unstable branch
Message-Id: <20241217180646.E1A1AC4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs: mm: fix the incorrect 'FileHugeMapped' field
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     docs-mm-fix-the-incorrect-filehugemapped-field.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-fix-the-incorrect-filehugemapped-field.patch

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

docs-mm-fix-the-incorrect-filehugemapped-field.patch
mm-factor-out-the-order-calculation-into-a-new-helper.patch
mm-shmem-change-shmem_huge_global_enabled-to-return-huge-order-bitmap.patch
mm-shmem-add-large-folio-support-for-tmpfs.patch
mm-shmem-add-a-kernel-command-line-to-change-the-default-huge-policy-for-tmpfs.patch
docs-tmpfs-drop-fadvise-from-the-documentation.patch

