Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14536AFAE
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423572; cv=none; b=GagxnmhSba+5ybKO00O8Lc7bBSpT9GD+KJHah0muM3yIGY3AGZjTaDU2KG9QJ0QqBZ3qMsdu4Od7K7AVS7xodf2d9iAP/CEpGW4MMxi4o8LPaR3VS7brwfAbzCej4ymVOTrJ9b9o86BbGLKpUfFA/hPqIbHW21u3odsO4wSAwTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423572; c=relaxed/simple;
	bh=pqXKS0TYi1tQcPzgEuayo3FOh9yYiYG4tgOydzEjlx0=;
	h=Date:To:From:Subject:Message-Id; b=mhNWvJrk03QASKnhU6UMRgbsCgouuNrTbDTemzbXzxy3ROHp0m49tSV+pImRHHnMOeAUmuR0vdMHAZankbnM8n+q40VnBeDzi0Yk9UYwBl2iKs+E3UbybBItKrX/BUTCz5YFJj3ZZ0aj+tq8XCJRmvktFkKfRR6tda4fpzx+ahQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F2sJmsbD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F2sJmsbD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76EE6C4CEC2;
	Wed,  4 Sep 2024 04:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423572;
	bh=pqXKS0TYi1tQcPzgEuayo3FOh9yYiYG4tgOydzEjlx0=;
	h=Date:To:From:Subject:From;
	b=F2sJmsbD0cyVKiO63OVNvgFRqivc9V9ta0CW1Wt255kkt4yBw8/Fs5xZGRqJD0ujt
	 lR1wzipZPTsBvQ1zbqMp1HmUav/jT9ccFBDIGRySRZb+2pE9pXHWd+oTQmON2gUZ0Y
	 MC/GKHIqJEwX+c6tqBW45Z51CS8i7ruKUvKkHpW8=
Date: Tue, 03 Sep 2024 21:19:31 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,lorenzo.stoakes@oracle.com,kees@kernel.org,jeffxu@chromium.org,broonie@kernel.org,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-use-vms-accounted-pages-in-mmap_region.patch removed from -mm tree
Message-Id: <20240904041932.76EE6C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mmap: use vms accounted pages in mmap_region()
has been removed from the -mm tree.  Its filename was
     mm-mmap-use-vms-accounted-pages-in-mmap_region.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/mmap: use vms accounted pages in mmap_region()
Date: Fri, 30 Aug 2024 00:00:57 -0400

Change from nr_pages variable to vms.nr_accounted for the charged pages
calculation.  This is necessary for a future patch.

This also avoids checking security_vm_enough_memory_mm() if the amount of
memory won't change.

Link: https://lkml.kernel.org/r/20240830040101.822209-18-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Kees Cook <kees@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Paul Moore <paul@paul-moore.com>	[LSM]
Cc: Kees Cook <kees@kernel.org>
Cc: Bert Karwatzki <spasswolf@web.de>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Jiri Olsa <olsajiri@gmail.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/mmap.c~mm-mmap-use-vms-accounted-pages-in-mmap_region
+++ a/mm/mmap.c
@@ -1414,9 +1414,10 @@ unsigned long mmap_region(struct file *f
 	 */
 	if (accountable_mapping(file, vm_flags)) {
 		charged = pglen;
-		charged -= nr_accounted;
-		if (security_vm_enough_memory_mm(mm, charged))
+		charged -= vms.nr_accounted;
+		if (charged && security_vm_enough_memory_mm(mm, charged))
 			goto abort_munmap;
+
 		vms.nr_accounted = 0;
 		vm_flags |= VM_ACCOUNT;
 	}
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


