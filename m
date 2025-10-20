Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A2C1E511
	for <mm-commits@vger.kernel.org>; Mon, 20 Oct 2025 19:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760987447; cv=none; b=QJZrkz6PBcsDtNn7uEoUR6pewoC01vlcRVEkOpnQdTIcHF+u5j4kmSc56c98VGxg+z3sXItNgAlj6qqbyvD15/Wjs5P/QArAX0JnM77ReaybnYzo4dre1+UB59DTPjQTxUciZXKaLF5qBagqOXnex9ZiO6AJrFnve615ZjV5U14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760987447; c=relaxed/simple;
	bh=IYWgiNAeERdjFDt0aA77pMybCYdzgaO+nUuAT3jtpYM=;
	h=Date:To:From:Subject:Message-Id; b=lYNNlDoYivlsd/3MO89CNDGG4fBrmyivuAJzexd5OKcrgb+UfCAJGER5OwtMXzU9xkegV+THmJYcKT9duVTU/bFb4Az+j57mfmCml2opq7rDgBoCFDMoXb1Y4I1dvSQE0yw5wJVvkVm5DmpuYnDUOgO2Wpj4HJdWyUaeaHyaDNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UICJ6jeA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UICJ6jeA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3517DC113D0;
	Mon, 20 Oct 2025 19:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760987447;
	bh=IYWgiNAeERdjFDt0aA77pMybCYdzgaO+nUuAT3jtpYM=;
	h=Date:To:From:Subject:From;
	b=UICJ6jeAObIfXRUMa6Rqcn6VvBhc3jy+Y2402GwcPythZZi+OT8s3ItQkpwEBsDKX
	 xQMaEnVJwEUXNSUvYBUcoraCu6tyBdDBQdM5RQ1Pu14FtOzJF4NYXMW2uQSgSD7DBA
	 gaPvkRK5mkiDXVnAGuv3wZ+bw0htoiHBATBM1+Bc=
Date: Mon, 20 Oct 2025 12:10:46 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,urezki@gmail.com,khalid@kernel.org,david.hunter.linux@gmail.com,mehdi.benhadjkhelifa@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-use-kmalloc_array-instead-of-kmalloc.patch added to mm-new branch
Message-Id: <20251020191047.3517DC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: use kmalloc_array() instead of kmalloc()
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-use-kmalloc_array-instead-of-kmalloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-use-kmalloc_array-instead-of-kmalloc.patch

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
From: Mehdi Ben Hadj Khelifa <mehdi.benhadjkhelifa@gmail.com>
Subject: mm/vmalloc: use kmalloc_array() instead of kmalloc()
Date: Sat, 18 Oct 2025 21:11:48 +0100

The number of NUMA nodes (nr_node_ids) is bounded, so overflow is not a
practical concern here.  However, using kmalloc_array() better reflects
the intent to allocate an array of unsigned ints, and improves consistency
with other NUMA-related allocations.

No functional change intended.

Link: https://lkml.kernel.org/r/20251018201207.27441-1-mehdi.benhadjkhelifa@gmail.com
Signed-off-by: Mehdi Ben Hadj Khelifa <mehdi.benhadjkhelifa@gmail.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Khalid Aziz <khalid@kernel.org>
Cc: David Hunter <david.hunter.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-use-kmalloc_array-instead-of-kmalloc
+++ a/mm/vmalloc.c
@@ -5140,7 +5140,7 @@ static int vmalloc_info_show(struct seq_
 	unsigned int *counters;
 
 	if (IS_ENABLED(CONFIG_NUMA))
-		counters = kmalloc(nr_node_ids * sizeof(unsigned int), GFP_KERNEL);
+		counters = kmalloc_array(nr_node_ids, sizeof(unsigned int), GFP_KERNEL);
 
 	for_each_vmap_node(vn) {
 		spin_lock(&vn->busy.lock);
_

Patches currently in -mm which might be from mehdi.benhadjkhelifa@gmail.com are

mm-vmalloc-use-kmalloc_array-instead-of-kmalloc.patch

