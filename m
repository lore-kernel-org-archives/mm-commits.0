Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6CC285077
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126267; cv=none; b=EQt5dRGE8WimGqVYhU7uX6bAM3vbCiOduoWdFkZ8S2iJcshlAQLcs21BsojKkc/TKdcHxf8da+J5EXfu/epJfBwu/keb9KdYbQKkHU+Vw7y9Etq/xkRO6DhC+e+FjWVUpOmQoFEyQK85wSuzs/HzBnVJFlznbsOXeerPhcVKw3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126267; c=relaxed/simple;
	bh=KzAcsvdI4xCrdZDILxLumM6HuLMC2Qa5gYFZeJEwmtY=;
	h=Date:To:From:Subject:Message-Id; b=oOCt9k555+HNAVQh2l51ok1QbaZAe902k5agX1oAYyRmfC21lMj2cW/FE3K19Bk92ZqAoPEdi9mMUqAAmC/NRBtJ+zV8C4A6xbnNkolEekqQBrbAKQ8+dtkf06rAcVTMTwdOS+l5w30F5CwcaV9/e4PFSa4hD0GKO6+rULtDKa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cf3N9ohR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cf3N9ohR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C1FC4CEE3;
	Thu, 10 Jul 2025 05:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126267;
	bh=KzAcsvdI4xCrdZDILxLumM6HuLMC2Qa5gYFZeJEwmtY=;
	h=Date:To:From:Subject:From;
	b=cf3N9ohRnvTS59AMkpGb8xb3EH8ySN+ATaGjU1cWe+XhirBdPMoqshFRMYruB7vP7
	 0T1TNbQ2kzwaYKusxKYB4iKDEa5TGyXupl60RdOH3RI88A8+nvKeG/goOnvYRmGdKp
	 1X+LqnvpXCDEi0yQeSJdqxMfGrVY6H24+N6ohggU=
Date: Wed, 09 Jul 2025 22:44:26 -0700
To: mm-commits@vger.kernel.org,thorsten.blum@linux.dev,jglisse@redhat.com,jgg@ziepe.ca,jeff.johnson@oss.qualcomm.com,david@redhat.com,apopple@nvidia.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-test_hmm-reduce-stack-usage.patch removed from -mm tree
Message-Id: <20250710054427.13C1FC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/test_hmm: reduce stack usage
has been removed from the -mm tree.  Its filename was
     lib-test_hmm-reduce-stack-usage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

lib-test_objagg-split-test_hints_case-into-two-functions.patch

