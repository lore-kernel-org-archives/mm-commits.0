Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E3DFBF6;
	Thu,  4 Jul 2024 05:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720071721; cv=none; b=aAL8flPXFxuvRZS7bxJctJX4ly1eNeJC46qMxHGYXfQ3jgH/OJ9YtRaA2xK3qM4vh5H8UU9Jjwj51YXMWJwd7o3ZJi71sz1aer9wDlqK9nYU/fEuu2wIrvCWYBAeX9D5b15BEYKfuRBAiQe11ntxbzeBJnfjRwU41tghpgtrpj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720071721; c=relaxed/simple;
	bh=TrCpBj08eXq0y4lbSdkOuU+I9XJBCmQVY1EKb7N1w4k=;
	h=Date:To:From:Subject:Message-Id; b=TcAl3yiPP0Q1QOH+QRsKJLKhNJYBcVbrbV51/pBVvD6X2c1yf3And0BfVD39vWClM1/AonKKSV3/TZCzpOXGrRB8e5n1qnkhFvMP3qF44DAG7rqVArjVkTxFGK8kNURMaQ7treQmj93ZSwqR27mL/tbvyJefIvbWLOG2xtXXf8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hAgqyxfB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hAgqyxfB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC1CC3277B;
	Thu,  4 Jul 2024 05:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720071721;
	bh=TrCpBj08eXq0y4lbSdkOuU+I9XJBCmQVY1EKb7N1w4k=;
	h=Date:To:From:Subject:From;
	b=hAgqyxfBGpKUcc7MSBvQPuQZogDWDQiWw2gUoYtEseaojdwxvU/+8h/v+0J6/1tAD
	 wZ7LLBURIO+DscowiBPte9gGMyXtLDIFhq91XfJVUgwdBzZxGTYj4lQHcXFnaiN5DU
	 Uck0xbsLZ/PG0yNnXNp6pmuNIzw0nb9JKRnnLDlU=
Date: Wed, 03 Jul 2024 22:42:00 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,oleksiy.avramchenko@sony.com,nbowler@draconx.ca,hch@infradead.org,hailong.liu@oppo.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-vmalloc-check-if-a-hash-index-is-in-cpu_possible_mask.patch removed from -mm tree
Message-Id: <20240704054201.0FC1CC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmalloc: check if a hash-index is in cpu_possible_mask
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-check-if-a-hash-index-is-in-cpu_possible_mask.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm: vmalloc: check if a hash-index is in cpu_possible_mask
Date: Wed, 26 Jun 2024 16:03:30 +0200

The problem is that there are systems where cpu_possible_mask has gaps
between set CPUs, for example SPARC.  In this scenario addr_to_vb_xa()
hash function can return an index which accesses to not-possible and not
setup CPU area using per_cpu() macro.  This results in an oops on SPARC.

A per-cpu vmap_block_queue is also used as hash table, incorrectly
assuming the cpu_possible_mask has no gaps.  Fix it by adjusting an index
to a next possible CPU.

Link: https://lkml.kernel.org/r/20240626140330.89836-1-urezki@gmail.com
Fixes: 062eacf57ad9 ("mm: vmalloc: remove a global vmap_blocks xarray")
Reported-by: Nick Bowler <nbowler@draconx.ca>
Closes: https://lore.kernel.org/linux-kernel/ZntjIE6msJbF8zTa@MiWiFi-R3L-srv/T/
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hailong.Liu <hailong.liu@oppo.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-check-if-a-hash-index-is-in-cpu_possible_mask
+++ a/mm/vmalloc.c
@@ -2543,7 +2543,15 @@ static DEFINE_PER_CPU(struct vmap_block_
 static struct xarray *
 addr_to_vb_xa(unsigned long addr)
 {
-	int index = (addr / VMAP_BLOCK_SIZE) % num_possible_cpus();
+	int index = (addr / VMAP_BLOCK_SIZE) % nr_cpu_ids;
+
+	/*
+	 * Please note, nr_cpu_ids points on a highest set
+	 * possible bit, i.e. we never invoke cpumask_next()
+	 * if an index points on it which is nr_cpu_ids - 1.
+	 */
+	if (!cpu_possible(index))
+		index = cpumask_next(index, cpu_possible_mask);
 
 	return &per_cpu(vmap_block_queue, index).vmap_blocks;
 }
_

Patches currently in -mm which might be from urezki@gmail.com are


