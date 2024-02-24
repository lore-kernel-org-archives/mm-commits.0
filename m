Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53B94688
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739367; cv=none; b=s8UtjiQ9ws5/+h12Kc5FxB68Cg0H/S8YlTImT01d5zd6KVO8nuklertgI9Mq10qDdEfskh4uhO7/aE+uXd02cilwQw2zCx8zdnYiJQv/z8Td9gV4BG5w54Kb8lYtnYRKLYCQSXy41FASP5R9qhk2U0IqiZ8amH8XdXgR4g8UJ3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739367; c=relaxed/simple;
	bh=NiWfH+xpHmR/mcivZdOxUrmm62L2sGcOglpSmClQxjA=;
	h=Date:To:From:Subject:Message-Id; b=uCNtxq4zJTHTkFYFh0a4Q4TCkyBtVB9TeHxMEuvMZ0/xkknZgn2A3Ss2xyRCzqEYEfzOyWIPxWEZonjcucs4X11n+qJgkTxzLEBc+WiPfndp32Ga+tZ6+33Lgp3UOoDwaBaN8iJN/xZ9jzH/drkVhHXvIvl5Bcz4JWrKSeCi/kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zIT7+tRk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zIT7+tRk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA0EC433C7;
	Sat, 24 Feb 2024 01:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739367;
	bh=NiWfH+xpHmR/mcivZdOxUrmm62L2sGcOglpSmClQxjA=;
	h=Date:To:From:Subject:From;
	b=zIT7+tRkZJ5VKLpiI0B60ak3uKv6k+Dt+QIRjthF5fz+ttWH3LaTZ1/pzShqxUMov
	 DR3Rf5q5joFeRws0h0RiM+9NJegnSDvTFcYBcxzjgBG0iamZlsj9ECwlyCDFKOzDVP
	 fjINrMNzF20FZ/dLhk4iOu98XvBIUO/ZxkSOIqJY=
Date: Fri, 23 Feb 2024 17:49:26 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,paulmck@kernel.org,oleksiy.avramchenko@sony.com,lstoakes@gmail.com,Liam.Howlett@oracle.com,k-hagio-ab@nec.com,joel@joelfernandes.org,hch@lst.de,david@fromorbit.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-rename-adjust_va_to_fit_type-function.patch removed from -mm tree
Message-Id: <20240224014927.7BA0EC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmalloc: rename adjust_va_to_fit_type() function
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-rename-adjust_va_to_fit_type-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm: vmalloc: rename adjust_va_to_fit_type() function
Date: Tue, 2 Jan 2024 19:46:24 +0100

This patch renames the adjust_va_to_fit_type() function to va_clip() which
is shorter and more expressive.

There is no a functional change as a result of this patch.

Link: https://lkml.kernel.org/r/20240102184633.748113-3-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Kazuhito Hagio <k-hagio-ab@nec.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-rename-adjust_va_to_fit_type-function
+++ a/mm/vmalloc.c
@@ -1382,9 +1382,9 @@ classify_va_fit_type(struct vmap_area *v
 }
 
 static __always_inline int
-adjust_va_to_fit_type(struct rb_root *root, struct list_head *head,
-		      struct vmap_area *va, unsigned long nva_start_addr,
-		      unsigned long size)
+va_clip(struct rb_root *root, struct list_head *head,
+		struct vmap_area *va, unsigned long nva_start_addr,
+		unsigned long size)
 {
 	struct vmap_area *lva = NULL;
 	enum fit_type type = classify_va_fit_type(va, nva_start_addr, size);
@@ -1500,7 +1500,7 @@ va_alloc(struct vmap_area *va,
 		return vend;
 
 	/* Update the free vmap_area. */
-	ret = adjust_va_to_fit_type(root, head, va, nva_start_addr, size);
+	ret = va_clip(root, head, va, nva_start_addr, size);
 	if (WARN_ON_ONCE(ret))
 		return vend;
 
@@ -4155,9 +4155,8 @@ retry:
 			/* It is a BUG(), but trigger recovery instead. */
 			goto recovery;
 
-		ret = adjust_va_to_fit_type(&free_vmap_area_root,
-					    &free_vmap_area_list,
-					    va, start, size);
+		ret = va_clip(&free_vmap_area_root,
+			&free_vmap_area_list, va, start, size);
 		if (WARN_ON_ONCE(unlikely(ret)))
 			/* It is a BUG(), but trigger recovery instead. */
 			goto recovery;
_

Patches currently in -mm which might be from urezki@gmail.com are


