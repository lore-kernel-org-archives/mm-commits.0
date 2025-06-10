Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A187A4685
	for <mm-commits@vger.kernel.org>; Tue, 10 Jun 2025 20:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749587764; cv=none; b=GI2JefP8ojxDNUmrge1ato88ArEKgZWpyaVm/DhjdZ6LUyH/r1jLJsmNTlUubiKp+H96bii8MpuFtTBzJ31tod5IwdRrBJwxheWHRCCLGu1+EQbGfB8oX5A3TgVklvMMv0L/TpXOKoXFkzFHfGEpD+fAPJNV5ctkHClJYe/PGuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749587764; c=relaxed/simple;
	bh=27wQ/UdBVUG/1ltbBsRsBUXTjZyiw4WsyRJ9scBskTg=;
	h=Date:To:From:Subject:Message-Id; b=Ow7CbnYNhzWTeeHvn5g1r+xcw91zU2OYbWAzuSSDstpGCYfPIrebhISKsgWdOHyue2tOBYC0D7ZiwXiAUpRaEAPL6EGQQpE7+ty5vQUgQ5ggkhYB7JC3MXIu2n96dPQxT/o/CuJD+FHbFPrifAb/4OQQDigX7kSPB/16Q1wMyeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EL7wYBR6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EL7wYBR6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 324D5C4CEED;
	Tue, 10 Jun 2025 20:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749587764;
	bh=27wQ/UdBVUG/1ltbBsRsBUXTjZyiw4WsyRJ9scBskTg=;
	h=Date:To:From:Subject:From;
	b=EL7wYBR6AMhMgpgtWET7TYXzpoLC5e+0v9cynesexzpf+LdtZgHwxHhJVrAoZVbqr
	 uC1pPfhUMiKmTsDDla+yA2w6zq+/n2KOrRopohgYZe9E6ll8OYs4Y5CEv+zxmBow76
	 C+tfOC7SWBzorfOX5TEW+XCXTv8KOEgHYB/QDm9g=
Date: Tue, 10 Jun 2025 13:36:03 -0700
To: mm-commits@vger.kernel.org,thorsten.blum@linux.dev,jglisse@redhat.com,jgg@ziepe.ca,jeff.johnson@oss.qualcomm.com,david@redhat.com,apopple@nvidia.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_hmm-reduce-stack-usage.patch added to mm-new branch
Message-Id: <20250610203604.324D5C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_hmm: reduce stack usage
has been added to the -mm mm-new branch.  Its filename is
     lib-test_hmm-reduce-stack-usage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_hmm-reduce-stack-usage.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Arnd Bergmann <arnd@arndb.de>
Subject: lib/test_hmm: reduce stack usage
Date: Tue, 10 Jun 2025 11:21:50 +0200

The various test ioctl handlers use arrays of 64 integers that add up to
1KiB of stack data, which in turn leads to exceeding the warning limit in
some configurations:

lib/test_hmm.c:935:12: error: stack frame size (1408) exceeds limit (1280)
in 'dmirror_migrate_to_device' [-Werror,-Wframe-larger-than]

Use half the size for these arrays, in order to stay under the warning
limits.  The code can already deal with arbitrary lengths, but this may be
a little less efficient.

Link: https://lkml.kernel.org/r/20250610092159.2639515-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/lib/test_hmm.c~lib-test_hmm-reduce-stack-usage
+++ a/lib/test_hmm.c
@@ -330,7 +330,7 @@ static int dmirror_fault(struct dmirror
 {
 	struct mm_struct *mm = dmirror->notifier.mm;
 	unsigned long addr;
-	unsigned long pfns[64];
+	unsigned long pfns[32];
 	struct hmm_range range = {
 		.notifier = &dmirror->notifier,
 		.hmm_pfns = pfns,
@@ -879,8 +879,8 @@ static int dmirror_migrate_to_system(str
 	unsigned long size = cmd->npages << PAGE_SHIFT;
 	struct mm_struct *mm = dmirror->notifier.mm;
 	struct vm_area_struct *vma;
-	unsigned long src_pfns[64] = { 0 };
-	unsigned long dst_pfns[64] = { 0 };
+	unsigned long src_pfns[32] = { 0 };
+	unsigned long dst_pfns[32] = { 0 };
 	struct migrate_vma args = { 0 };
 	unsigned long next;
 	int ret;
@@ -939,8 +939,8 @@ static int dmirror_migrate_to_device(str
 	unsigned long size = cmd->npages << PAGE_SHIFT;
 	struct mm_struct *mm = dmirror->notifier.mm;
 	struct vm_area_struct *vma;
-	unsigned long src_pfns[64] = { 0 };
-	unsigned long dst_pfns[64] = { 0 };
+	unsigned long src_pfns[32] = { 0 };
+	unsigned long dst_pfns[32] = { 0 };
 	struct dmirror_bounce bounce;
 	struct migrate_vma args = { 0 };
 	unsigned long next;
@@ -1144,8 +1144,8 @@ static int dmirror_snapshot(struct dmirr
 	unsigned long size = cmd->npages << PAGE_SHIFT;
 	unsigned long addr;
 	unsigned long next;
-	unsigned long pfns[64];
-	unsigned char perm[64];
+	unsigned long pfns[32];
+	unsigned char perm[32];
 	char __user *uptr;
 	struct hmm_range range = {
 		.hmm_pfns = pfns,
_

Patches currently in -mm which might be from arnd@arndb.de are

lib-test_hmm-reduce-stack-usage.patch

