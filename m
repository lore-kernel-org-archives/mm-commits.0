Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6733DB964
	for <mm-commits@vger.kernel.org>; Wed,  9 Sep 2026 07:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788938026; cv=none; b=iCI2dZOPQtbSiE+rq94gCJQbeccZInYyC1WkzgNIJL5r4k1k7H7C7lcknFnqcURNMFs4kJPTnJ+ADUWajp9Hws61EEemMVDiGdZkLsQqbdVU4EKUV+XL3ZFyLU3pdwP/MnSTjZS/uUlmh1+tGgZ05tv4xZ+9eMXrkhEVzlyDbAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788938026; c=relaxed/simple;
	bh=u6MnqflHqSzabA7afDuu6bMt1729M+mJ5iMB/IMKY7U=;
	h=Date:To:From:Subject:Message-Id; b=iTdNQcGKxsJu2XiQ2SSrVh8T0Ru/xAnJIM+PhyDNEMgz3AMO/2q8WsnSEeMIv/B8tReHJR74JshtzjEYIWkOLOxHmXPP9fuybY0SD+MIKx7J9JpIP2F+kIxICDS7JdThJTj9QJluev1XqBjvRUWuQdpNKhsu5efZjN51Mq+JU3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bCU7hpbK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bCU7hpbK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE141F00A3A;
	Wed,  9 Sep 2026 07:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788938025;
	bh=3BtSZGC7MYpgsVLaW4niSzgfd4qgiTLvkccq9hJOWm8=;
	h=Date:To:From:Subject;
	b=bCU7hpbKjDq+XhRNOjXY4jOWQoeKjSr3+WosQo26zoGx9lFIF74MUIzhhQXMn74pK
	 3vE10AHb6o1iausJfKzgccVRZ6fbgsHg89bSDGMqKD/NW+vbJ2iLNYfEoU+Z6T15uY
	 Gr/5OAuxytkuGoaeBlbv1MKGV0tK46sE00atWsas=
Date: Wed, 09 Sep 2026 00:13:44 -0700
To: mm-commits@vger.kernel.org,thehajime@gmail.com,ljs@kernel.org,liam@infradead.org,tasos.papagiannnis@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-nommu-reject-wrapping-ranges-in-access_remote_vm.patch added to mm-new branch
Message-Id: <20260909071344.EBE141F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/nommu: reject wrapping ranges in access_remote_vm()
has been added to the -mm mm-new branch.  Its filename is
     mm-nommu-reject-wrapping-ranges-in-access_remote_vm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-nommu-reject-wrapping-ranges-in-access_remote_vm.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
Subject: mm/nommu: reject wrapping ranges in access_remote_vm()
Date: Wed, 9 Sep 2026 09:42:31 +0300

The NOMMU implementation of access_process_vm() rejects address ranges
whose end wraps around, but access_remote_vm() bypasses this check even
though both functions delegate to __access_remote_vm().

Move the wraparound check into __access_remote_vm() so it applies to both
entry points.

This iss originally reported in [1].

Link: https://lore.kernel.org/20260909064231.18693-1-tasos.papagiannnis@gmail.com
Fixes: f55f199b7d76 ("NOMMU: implement access_remote_vm")
Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
Closes: https://lore.kernel.org/bpf/4ef240a5bea36ff84df9589671367832860795159386a4c8fba546a0fa8b786f@mail.kernel.org/ [1]
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Hajime Tazaki <thehajime@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/nommu.c~mm-nommu-reject-wrapping-ranges-in-access_remote_vm
+++ a/mm/nommu.c
@@ -1674,6 +1674,9 @@ static int __access_remote_vm(struct mm_
 	struct vm_area_struct *vma;
 	int write = gup_flags & FOLL_WRITE;
 
+	if (addr + len < addr)
+		return 0;
+
 	if (mmap_read_lock_killable(mm))
 		return 0;
 
@@ -1727,9 +1730,6 @@ int access_process_vm(struct task_struct
 {
 	struct mm_struct *mm;
 
-	if (addr + len < addr)
-		return 0;
-
 	mm = get_task_mm(tsk);
 	if (!mm)
 		return 0;
_

Patches currently in -mm which might be from tasos.papagiannnis@gmail.com are

mm-nommu-reject-wrapping-ranges-in-access_remote_vm.patch

