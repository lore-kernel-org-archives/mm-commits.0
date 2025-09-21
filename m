Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F54628DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489839; cv=none; b=aKCd2ADqZwLGBsV/n5zxa/g9M3w/gBGSa9JokK+KjO1KRHKQyZbUQVB0oneJ1qoO5nqHxuVsitJbgRIz0puNKzpe17t+hg3+/9/w3CJN95fIa+u6nu0WphUn3+NqZ5KRcv8rlFA62l2/70FwTz5o2oXnU72AWeCckbRuHXxAP00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489839; c=relaxed/simple;
	bh=jnHeKDJZ8oMQcGrqACLhgxOTLE876LKYukaGG6+WL4U=;
	h=Date:To:From:Subject:Message-Id; b=bglsl2szeooB7RIrIH7do1NII9Nrr0my7ZJ+dyC6SJz4xG/h40vHE8SUSUeIBRR9Gilne7VNt+U+YM+r/U2e7C8cwwTnUOEeQhQJ4vPEiPCKcZUc2vBhl3UmUgOCP05O3m2K+s47KmEDGONKAbg6im/2he/O5DzdS+6iTO398XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DCqEKy17; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DCqEKy17"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336C0C4CEE7;
	Sun, 21 Sep 2025 21:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489839;
	bh=jnHeKDJZ8oMQcGrqACLhgxOTLE876LKYukaGG6+WL4U=;
	h=Date:To:From:Subject:From;
	b=DCqEKy17EMMtoKcSHTNGtrCMIPmHPqKQ9z+rNbxXj9fUqMoG1sY+WYG4NCeznD+dt
	 9uPh99zY3TQDpUlu9AQSDXvtBzH/RyRmOiKwDLr3ibYHbqrSeFd2gB0IRQfAHQU+ig
	 hrUWjMb1E/q0QCYkutVNFeeNfO5y1m5KtIbKeM18=
Date: Sun, 21 Sep 2025 14:23:58 -0700
To: mm-commits@vger.kernel.org,ulf.hansson@linaro.org,oakad@yahoo.com,maximlevitsky@gmail.com,lorenzo.stoakes@oracle.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mspro_block-drop-nth_page-usage-within-sg-entry.patch removed from -mm tree
Message-Id: <20250921212359.336C0C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mspro_block: drop nth_page() usage within SG entry
has been removed from the -mm tree.  Its filename was
     mspro_block-drop-nth_page-usage-within-sg-entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mspro_block: drop nth_page() usage within SG entry
Date: Mon, 1 Sep 2025 17:03:48 +0200

It's no longer required to use nth_page() when iterating pages within a
single SG entry, so let's drop the nth_page() usage.

Link: https://lkml.kernel.org/r/20250901150359.867252-28-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/mspro_block.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/memstick/core/mspro_block.c~mspro_block-drop-nth_page-usage-within-sg-entry
+++ a/drivers/memstick/core/mspro_block.c
@@ -560,8 +560,7 @@ has_int_reg:
 		t_offset += msb->current_page * msb->page_size;
 
 		sg_set_page(&t_sg,
-			    nth_page(sg_page(&(msb->req_sg[msb->current_seg])),
-				     t_offset >> PAGE_SHIFT),
+			    sg_page(&(msb->req_sg[msb->current_seg])) + (t_offset >> PAGE_SHIFT),
 			    msb->page_size, offset_in_page(t_offset));
 
 		memstick_init_req_sg(*mrq, msb->data_dir == READ
_

Patches currently in -mm which might be from david@redhat.com are


