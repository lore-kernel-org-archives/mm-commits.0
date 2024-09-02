Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A5C224EF
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247830; cv=none; b=R2Oyr1pfVDdcYevftdkmmPkscQOO1nvA/lolb198DYO6WfNN3lmBzM64Z4ja6jW/7vv57gfDF9sObZKg8xJd6G2X82a8FAn3XibTqnavN4+foj1zfFbl+8aeH5plRCie9glPcWZr6jAiiYglIid5SszJVc05+D3Mose9zJpKzAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247830; c=relaxed/simple;
	bh=NpAALFyXhM+ieqNz1MB5ZdFRGFNKxFYRLieiBqwP5SE=;
	h=Date:To:From:Subject:Message-Id; b=lBDALId/Mq1uF5owMvR733MgnerZ/Ku0gZL1PH2uUYElujPmhY0nBwsQnSOAeb/TKrE2U6DM6VEWX9tsGcKQk5ny75HiUPqpQGoYv/Q7cpjB79u3XwPzMJKppQ3tj2iKrFrcQNE7HsDP9V6slfynd3L8iwNI3cvQXTmnKQ0zky8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2BpQl9Vs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2BpQl9Vs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49BB4C4CEC2;
	Mon,  2 Sep 2024 03:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247830;
	bh=NpAALFyXhM+ieqNz1MB5ZdFRGFNKxFYRLieiBqwP5SE=;
	h=Date:To:From:Subject:From;
	b=2BpQl9VsoBsCWGLW7cN5S8WdAHcAYmJGXT3Eh8ABnarZtJfFeKkkjQ34Y0P7ib35S
	 TLrH9A0p1qFmCMHrPv4YNjVJdGP2QAKKDoCWLVZN3O6Cc5YfqO8BodwswGDLZR39ji
	 LpBWmBc7l/UmHRrf0zSaCCkqaj+gZk/xzJXUguEo=
Date: Sun, 01 Sep 2024 20:30:29 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-preallocate-nodes-in-mas_erase.patch removed from -mm tree
Message-Id: <20240902033030.49BB4C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: preallocate nodes in mas_erase()
has been removed from the -mm tree.  Its filename was
     maple_tree-preallocate-nodes-in-mas_erase.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: maple_tree: preallocate nodes in mas_erase()
Date: Wed, 14 Aug 2024 12:19:33 -0400

Use mas_wr_preallocate() in mas_erase() to preallocate enough nodes to
complete the erase.  Add error handling by skipping the store if the
preallocation lead to some error besides no memory.

Link: https://lkml.kernel.org/r/20240814161944.55347-7-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-preallocate-nodes-in-mas_erase
+++ a/lib/maple_tree.c
@@ -6371,14 +6371,18 @@ write_retry:
 
 	/* Must reset to ensure spanning writes of last slot are detected */
 	mas_reset(mas);
-	mas_wr_store_setup(&wr_mas);
-	mas_wr_store_entry(&wr_mas);
+	mas_wr_preallocate(&wr_mas, NULL);
 	if (mas_nomem(mas, GFP_KERNEL)) {
 		/* in case the range of entry changed when unlocked */
 		mas->index = mas->last = index;
 		goto write_retry;
 	}
 
+	if (mas_is_err(mas))
+		goto out;
+
+	mas_wr_store_entry(&wr_mas);
+out:
 	mas_destroy(mas);
 	return entry;
 }
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


