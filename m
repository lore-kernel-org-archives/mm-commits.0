Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A635409103;
	Fri,  9 Oct 2026 05:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525475; cv=none; b=LdSIpzcgcuTLVWhsgPw3Z5ZB4FM7V3RPnoHPQL/qKYh2woUFFjzIPeumzaxKignLikd3+ZXe1kiNmFXAfWrFRmkXdsuthJZE0XTVvhDodXTssGjDODJ3e1TVe1brYFbrAFG+SjCf2CeIp6EBy5phMiDNz5H1y2EYPEefI/HxhUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525475; c=relaxed/simple;
	bh=3NZauo4UwOSTOWYml1Jmh4xwmkVmmR0ZC7arrGBmbNc=;
	h=Date:To:From:Subject:Message-Id; b=ZAHx8uoMiy5TLm/qPELZQcj0h5b/Trzbn9nUodfA0ZAJ0IO188fkPZ6dVHaTCdO0vYoMVzOFQWmgix7IpE5p9hX0bc5S53VLj+0e6M9oynCslRQdiEddFc4PSPb3bIMhcUMuLNCAcjWYvQA+o863wrNJ48c3/NJ7BYACQbmZ/E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D33nA9Z/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D33nA9Z/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D92F1F000FF;
	Fri,  9 Oct 2026 05:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525474;
	bh=UHLAOC19qxdx6qNnUp7JohGY6KaBP1CPRJd2VymKPfo=;
	h=Date:To:From:Subject;
	b=D33nA9Z/ciRoZVz93/AycLnXdbT680tkY2ET7z9yPQJkC8/PKXwAvlkE+Rsv/dpQh
	 VYTrWmKD77uvN/ub66CEXMtf04i2RwSoTSEx2uqvt69B4vj2ZSv7og5UYVxPBDAnwT
	 Npt5rFPmvNjtpylNEeboJWaAp4P1z4yvrVZPihvc=
Date: Thu, 08 Oct 2026 22:57:53 -0700
To: mm-commits@vger.kernel.org,thehajime@gmail.com,stable@vger.kernel.org,ljs@kernel.org,liam@infradead.org,tasos.papagiannnis@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-nommu-reject-wrapping-ranges-in-access_remote_vm.patch removed from -mm tree
Message-Id: <20261009055754.5D92F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/nommu: reject wrapping ranges in access_remote_vm()
has been removed from the -mm tree.  Its filename was
     mm-nommu-reject-wrapping-ranges-in-access_remote_vm.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
Subject: mm/nommu: reject wrapping ranges in access_remote_vm()
Date: Wed, 9 Sep 2026 09:42:31 +0300

The NOMMU implementation of access_process_vm() rejects address ranges
whose end wraps around, but access_remote_vm() bypasses this check even
though both functions delegate to __access_remote_vm().

Move the wraparound check into __access_remote_vm() so it applies to both
entry points.

This is originally reported in [1].

Link: https://lore.kernel.org/20260909064231.18693-1-tasos.papagiannnis@gmail.com
Fixes: f55f199b7d76 ("NOMMU: implement access_remote_vm")
Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://lore.kernel.org/bpf/4ef240a5bea36ff84df9589671367832860795159386a4c8fba546a0fa8b786f@mail.kernel.org/ [1]
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Hajime Tazaki <thehajime@gmail.com>
Cc: <stable@vger.kernel.org>
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


