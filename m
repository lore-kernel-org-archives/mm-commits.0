Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1802EB10
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011363; cv=none; b=kWtUrIp7tgH7XaNt7r6mXb5ZeORhzoZfVZME6OgE12GIXV8KB54NCEgDv984ZmTQQ1fNx4bxZ4Cg0vJ8/z1Xo1bgroHeAv/A263xQZZ2BtB4NOeSvJjEm/sjDWe1PoNijy0dR4TZ27n5GN2/pWZFyIHTfQpmETGGCbKCsHjvZzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011363; c=relaxed/simple;
	bh=n5xVFDyEfFD/Dh0rKz6aoppMbRulwBQ8KSoLCfkeGY0=;
	h=Date:To:From:Subject:Message-Id; b=sAwh5MClFbbxbo+a+FQxDZAH4SvdcLLwjrIfM3YbTJXhVV059G2dncwoZiYI3ytJUzEvLDKvDr7l5B1npcbiOHgFdBBrUP5xJ0Jjil9lSGYbAGI691OoJ0HflhQiuRFI8TySo0D7bvwRCdpQnDUBS2FxKV3arGjFBMKtVdzsa7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Eo7LyvX7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Eo7LyvX7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC35C4CEE4;
	Mon, 12 May 2025 00:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011362;
	bh=n5xVFDyEfFD/Dh0rKz6aoppMbRulwBQ8KSoLCfkeGY0=;
	h=Date:To:From:Subject:From;
	b=Eo7LyvX78atwIsiF0m/OflUTAtKUfDnN+MV3Heo0lXC2xDiQtmiF2YG4XhtvUp5/a
	 muDcwVUxDvSqoDV444pWuUq+LL3zHUwHI9DxeNHCND2H8GYHH7CXQnRUjhyBia5NHR
	 rD1rnofQuJqFa2bsKrpbzKUMBfe0mLHnqzK2ZS2E=
Date: Sun, 11 May 2025 17:56:02 -0700
To: mm-commits@vger.kernel.org,ebiggers@kernel.org,csander@purestorage.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scatterlist-inline-sg_next.patch removed from -mm tree
Message-Id: <20250512005602.CBC35C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scatterlist: inline sg_next()
has been removed from the -mm tree.  Its filename was
     scatterlist-inline-sg_next.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Caleb Sander Mateos <csander@purestorage.com>
Subject: scatterlist: inline sg_next()
Date: Wed, 16 Apr 2025 10:06:13 -0600

sg_next() is a short function called frequently in I/O paths. Define it
in the header file so it can be inlined into its callers.

Link: https://lkml.kernel.org/r/20250416160615.3571958-1-csander@purestorage.com
Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/scatterlist.h |   23 ++++++++++++++++++++++-
 lib/scatterlist.c           |   23 -----------------------
 2 files changed, 22 insertions(+), 24 deletions(-)

--- a/include/linux/scatterlist.h~scatterlist-inline-sg_next
+++ a/include/linux/scatterlist.h
@@ -95,6 +95,28 @@ static inline bool sg_is_last(struct sca
 }
 
 /**
+ * sg_next - return the next scatterlist entry in a list
+ * @sg:		The current sg entry
+ *
+ * Description:
+ *   Usually the next entry will be @sg@ + 1, but if this sg element is part
+ *   of a chained scatterlist, it could jump to the start of a new
+ *   scatterlist array.
+ *
+ **/
+static inline struct scatterlist *sg_next(struct scatterlist *sg)
+{
+	if (sg_is_last(sg))
+		return NULL;
+
+	sg++;
+	if (unlikely(sg_is_chain(sg)))
+		sg = sg_chain_ptr(sg);
+
+	return sg;
+}
+
+/**
  * sg_assign_page - Assign a given page to an SG entry
  * @sg:		    SG entry
  * @page:	    The page
@@ -418,7 +440,6 @@ static inline void sg_init_marker(struct
 
 int sg_nents(struct scatterlist *sg);
 int sg_nents_for_len(struct scatterlist *sg, u64 len);
-struct scatterlist *sg_next(struct scatterlist *);
 struct scatterlist *sg_last(struct scatterlist *s, unsigned int);
 void sg_init_table(struct scatterlist *, unsigned int);
 void sg_init_one(struct scatterlist *, const void *, unsigned int);
--- a/lib/scatterlist.c~scatterlist-inline-sg_next
+++ a/lib/scatterlist.c
@@ -14,29 +14,6 @@
 #include <linux/folio_queue.h>
 
 /**
- * sg_next - return the next scatterlist entry in a list
- * @sg:		The current sg entry
- *
- * Description:
- *   Usually the next entry will be @sg@ + 1, but if this sg element is part
- *   of a chained scatterlist, it could jump to the start of a new
- *   scatterlist array.
- *
- **/
-struct scatterlist *sg_next(struct scatterlist *sg)
-{
-	if (sg_is_last(sg))
-		return NULL;
-
-	sg++;
-	if (unlikely(sg_is_chain(sg)))
-		sg = sg_chain_ptr(sg);
-
-	return sg;
-}
-EXPORT_SYMBOL(sg_next);
-
-/**
  * sg_nents - return total count of entries in scatterlist
  * @sg:		The scatterlist
  *
_

Patches currently in -mm which might be from csander@purestorage.com are


