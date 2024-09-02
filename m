Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10262D057
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247835; cv=none; b=AkKoe4LZHJn91Ka+G7s9d4VqH3JTx1Brpb6rYZDF3hrq1xw5REPBXPto+p71u9buh7/UqVdufhHXYzEliatncJp4a//gb8OsktgX1cY6gKtTqxCdndneLN1+V9exEPFs7s/8GJq6SRGVtU1DuFNdD2+HGh1hbBrs61syJXi4dT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247835; c=relaxed/simple;
	bh=oUKdZkvnHAaTHzSd6BrTlpfA3FXzuwhfkTgiTgxVyLI=;
	h=Date:To:From:Subject:Message-Id; b=lPZAU5xQ2q/E2HBiSXfjBOHeeCaGSGAlZuOhwdZSLuXqpm7OMfy9wU90eJbg8qieWQ8eCsu7NMPhV8n7TBrZ5jwC8+qCi2Sqpoh5z+udVIqcE+SWklVqubvFdx7dnyZ3ieyewkDl0Nz2AxSP91HcUesHftb8KRul1imsEFKL6kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wsHV6uKi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wsHV6uKi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96B5C4CEC2;
	Mon,  2 Sep 2024 03:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247835;
	bh=oUKdZkvnHAaTHzSd6BrTlpfA3FXzuwhfkTgiTgxVyLI=;
	h=Date:To:From:Subject:From;
	b=wsHV6uKiRLfJymk3L5/wOim+WL8sIBfsz7vZ9d5uKBdVVyEMe5FIKJotpO4h6u2iu
	 HbNmV415rlDdIYXqJiOHHW9/uwGs+2J1lrIsHlrJdZSAyNhtJDYLhxHXOTiq0kL5sV
	 FOeMKP2EBvu/95NSXnJa3dULoLa+ZSCiMLem/3m4=
Date: Sun, 01 Sep 2024 20:30:35 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-convert-mas_insert-to-preallocate-nodes.patch removed from -mm tree
Message-Id: <20240902033035.A96B5C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: convert mas_insert() to preallocate nodes
has been removed from the -mm tree.  Its filename was
     maple_tree-convert-mas_insert-to-preallocate-nodes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: maple_tree: convert mas_insert() to preallocate nodes
Date: Wed, 14 Aug 2024 12:19:37 -0400

By setting the store type in mas_insert(), we no longer need to use
mas_wr_modify() to determine the correct store function to use. Instead,
set the store type and call mas_wr_store_entry(). Also, pass in the
requested gfp flags to mas_insert() so they can be passed to the call to
mas_wr_preallocate().

Link: https://lkml.kernel.org/r/20240814161944.55347-11-sidhartha.kumar@oracle.com
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/lib/maple_tree.c~maple_tree-convert-mas_insert-to-preallocate-nodes
+++ a/lib/maple_tree.c
@@ -4457,26 +4457,24 @@ static inline void *mas_insert(struct ma
 	if (wr_mas.content)
 		goto exists;
 
-	if (mas_is_none(mas) || mas_is_ptr(mas)) {
-		mas_store_root(mas, entry);
+	mas_wr_preallocate(&wr_mas, entry);
+	if (mas_is_err(mas))
 		return NULL;
-	}
 
 	/* spanning writes always overwrite something */
-	if (!mas_wr_walk(&wr_mas))
+	if (mas->store_type == wr_spanning_store)
 		goto exists;
 
 	/* At this point, we are at the leaf node that needs to be altered. */
-	wr_mas.offset_end = mas->offset;
-	wr_mas.end_piv = wr_mas.r_max;
-
-	if (wr_mas.content || (mas->last > wr_mas.r_max))
-		goto exists;
+	if (mas->store_type != wr_new_root && mas->store_type != wr_store_root) {
+		wr_mas.offset_end = mas->offset;
+		wr_mas.end_piv = wr_mas.r_max;
 
-	if (!entry)
-		return NULL;
+		if (wr_mas.content || (mas->last > wr_mas.r_max))
+			goto exists;
+	}
 
-	mas_wr_modify(&wr_mas);
+	mas_wr_store_entry(&wr_mas);
 	return wr_mas.content;
 
 exists:
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


