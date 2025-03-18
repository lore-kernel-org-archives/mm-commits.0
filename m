Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941551C701E
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274646; cv=none; b=Mu7rj8ui9/7WmYhEczbPx1JXX3LHv3Q3+JgQ/kZJ1t+jU/X/bI7hyEU6ANd71sb0NX6mjwFl2bduHHdj8Yf464pfskBQvsPbQkOA6shgMj5ANAC8TnrGmTUC0b8QVuKwQkFIwCtMVVoBsAXC9YjOnTgA/FFzg0iBNwl9yl3JsWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274646; c=relaxed/simple;
	bh=nCHHu0oNMnOtJZvbtdAt4y8KRjr+uSiToePcQfrjupc=;
	h=Date:To:From:Subject:Message-Id; b=g8IkS8L7Hk2OhJlotAcgUiKCpVC55o+0J26at9nHguYlNPy6SIl5/BPZ/8xAH+PugDzbY7L4cDGBTYgmH7wAUMk3ePNTHC5omTobJQ4V+XyWQi7lxHcXgZbJQTAbeSm5vYpxE2bFPUVIh3LwEtH2nexhb2qqDDYxi/z5btB+Hks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bkk5FlB/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bkk5FlB/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A897C4CEDD;
	Tue, 18 Mar 2025 05:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274646;
	bh=nCHHu0oNMnOtJZvbtdAt4y8KRjr+uSiToePcQfrjupc=;
	h=Date:To:From:Subject:From;
	b=Bkk5FlB/ZoVGOR7xmHIZAjV0Tk5mqOw8j8iPjJqEnFLKd7oMHSJc7Szcpfi2xl8ro
	 vcdx7A4EQqdJkRILq9aAVEIkar8GJpGZoEFapoiKrH4GIkthFPiUZOkTL3FJLzqr+5
	 wrcnPDitQ4qkJ1FS56e9XUeDzfjftWr7HwYYwKk0=
Date: Mon, 17 Mar 2025 22:10:45 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,howlett@gmail.com,david@redhat.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-deduplicate-madvise_do_behavior-skip-case-handlings.patch removed from -mm tree
Message-Id: <20250318051046.6A897C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/madvise: deduplicate madvise_do_behavior() skip case handlings
has been removed from the -mm tree.  Its filename was
     mm-madvise-deduplicate-madvise_do_behavior-skip-case-handlings.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/madvise: deduplicate madvise_do_behavior() skip case handlings
Date: Wed, 12 Mar 2025 09:47:49 -0700

The logic for checking if a given madvise() request for a single memory
range can skip real work, namely madvise_do_behavior(), is duplicated in
do_madvise() and vector_madvise().  Split out the logic to a function and
reuse it.

Link: https://lkml.kernel.org/r/20250312164750.59215-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam R. Howlett <howlett@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   57 +++++++++++++++++++++++++++++--------------------
 1 file changed, 34 insertions(+), 23 deletions(-)

--- a/mm/madvise.c~mm-madvise-deduplicate-madvise_do_behavior-skip-case-handlings
+++ a/mm/madvise.c
@@ -1640,6 +1640,31 @@ static bool is_valid_madvise(unsigned lo
 	return true;
 }
 
+/*
+ * madvise_should_skip() - Return if the request is invalid or nothing.
+ * @start:	Start address of madvise-requested address range.
+ * @len_in:	Length of madvise-requested address range.
+ * @behavior:	Requested madvise behavor.
+ * @err:	Pointer to store an error code from the check.
+ *
+ * If the specified behaviour is invalid or nothing would occur, we skip the
+ * operation.  This function returns true in the cases, otherwise false.  In
+ * the former case we store an error on @err.
+ */
+static bool madvise_should_skip(unsigned long start, size_t len_in,
+		int behavior, int *err)
+{
+	if (!is_valid_madvise(start, len_in, behavior)) {
+		*err = -EINVAL;
+		return true;
+	}
+	if (start + PAGE_ALIGN(len_in) == start) {
+		*err = 0;
+		return true;
+	}
+	return false;
+}
+
 static bool is_madvise_populate(int behavior)
 {
 	switch (behavior) {
@@ -1747,23 +1772,15 @@ static int madvise_do_behavior(struct mm
  */
 int do_madvise(struct mm_struct *mm, unsigned long start, size_t len_in, int behavior)
 {
-	unsigned long end;
 	int error;
-	size_t len;
-
-	if (!is_valid_madvise(start, len_in, behavior))
-		return -EINVAL;
-
-	len = PAGE_ALIGN(len_in);
-	end = start + len;
-
-	if (end == start)
-		return 0;
 
+	if (madvise_should_skip(start, len_in, behavior, &error))
+		return error;
 	error = madvise_lock(mm, behavior);
 	if (error)
 		return error;
-	error = madvise_do_behavior(mm, start, len_in, len, behavior);
+	error = madvise_do_behavior(mm, start, len_in, PAGE_ALIGN(len_in),
+			behavior);
 	madvise_unlock(mm, behavior);
 
 	return error;
@@ -1790,19 +1807,13 @@ static ssize_t vector_madvise(struct mm_
 	while (iov_iter_count(iter)) {
 		unsigned long start = (unsigned long)iter_iov_addr(iter);
 		size_t len_in = iter_iov_len(iter);
-		size_t len;
+		int error;
 
-		if (!is_valid_madvise(start, len_in, behavior)) {
-			ret = -EINVAL;
-			break;
-		}
-
-		len = PAGE_ALIGN(len_in);
-		if (start + len == start)
-			ret = 0;
+		if (madvise_should_skip(start, len_in, behavior, &error))
+			ret = error;
 		else
-			ret = madvise_do_behavior(mm, start, len_in, len,
-					behavior);
+			ret = madvise_do_behavior(mm, start, len_in,
+					PAGE_ALIGN(len_in), behavior);
 		/*
 		 * An madvise operation is attempting to restart the syscall,
 		 * but we cannot proceed as it would not be correct to repeat
_

Patches currently in -mm which might be from sj@kernel.org are


