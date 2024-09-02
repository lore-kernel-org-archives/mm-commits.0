Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B473E2C80
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247839; cv=none; b=Y8pJcYqxwKADhFxJs8TyqOIag2NSEUyjCKG7laxHLKjye9CqXyelIpABs3taLOLG4vxQeJN9leMIQJn7V1Ox4MPpUDf8/xX1yPBwoMduy57u8M4bigPtJp0N8A7FSXs5W7ocm522TEqMTLLEp8/nPPH3q+6tdwTs0uR/18gCF0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247839; c=relaxed/simple;
	bh=9ikqHYH6Xm3E3Gcx79K7qDZE4qiEostmc+7TThGQBMM=;
	h=Date:To:From:Subject:Message-Id; b=k9lJ89I2XTl86kVnksUCib0HelPol7dO3vsHpeTN+g4D4GjtOTrjChvEmCPe0laPeGU6pAYv6Qi3Cs2fXiD4bfMX9qXz29coLYmlkORQG9SIAgtj6FAHx8ZDejNssDtz6+Gsaj0tqh+UlHS+sOq9e6IAKYNOZUzfO7tbmmOsKf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v4a9iz0E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v4a9iz0E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80449C4CEC2;
	Mon,  2 Sep 2024 03:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247839;
	bh=9ikqHYH6Xm3E3Gcx79K7qDZE4qiEostmc+7TThGQBMM=;
	h=Date:To:From:Subject:From;
	b=v4a9iz0EJDA+IriIIgnMTNPE9tftvBzGi8KTFJgDvTlNo/q3klbCDxf20W72x4o9V
	 sr29FQPmgWits0gcnyRXi4dww8e2t+n3ZYexJqTuhExNyBb2rMIjdzC5ANMNV7vHtZ
	 njmVouoPM1jQvvlHLcjQRUBGxE1qeXRZjX4f6QXA=
Date: Sun, 01 Sep 2024 20:30:39 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-have-mas_store-allocate-nodes-if-needed.patch removed from -mm tree
Message-Id: <20240902033039.80449C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: have mas_store() allocate nodes if needed
has been removed from the -mm tree.  Its filename was
     maple_tree-have-mas_store-allocate-nodes-if-needed.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: maple_tree: have mas_store() allocate nodes if needed
Date: Wed, 14 Aug 2024 12:19:40 -0400

Not all users of mas_store() enter with nodes already preallocated.
Check for the MA_STATE_PREALLOC flag to decide whether to preallocate nodes
within mas_store() rather than relying on future write helper functions
to perform the allocations. This allows the write helper functions to be
simplified as they do not have to do checks to make sure there are
enough allocated nodes to perform the write.

Link: https://lkml.kernel.org/r/20240814161944.55347-14-sidhartha.kumar@oracle.com
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-have-mas_store-allocate-nodes-if-needed
+++ a/lib/maple_tree.c
@@ -5477,13 +5477,12 @@ static inline void mte_destroy_walk(stru
  * @entry: The entry to store.
  *
  * The @mas->index and @mas->last is used to set the range for the @entry.
- * Note: The @mas should have pre-allocated entries to ensure there is memory to
- * store the entry.  Please see mas_expected_entries()/mas_destroy() for more details.
  *
  * Return: the first entry between mas->index and mas->last or %NULL.
  */
 void *mas_store(struct ma_state *mas, void *entry)
 {
+	int request;
 	MA_WR_STATE(wr_mas, mas, entry);
 
 	trace_ma_write(__func__, mas, 0, entry);
@@ -5506,7 +5505,23 @@ void *mas_store(struct ma_state *mas, vo
 	 */
 	mas_wr_prealloc_setup(&wr_mas);
 	mas_wr_store_type(&wr_mas);
+	if (mas->mas_flags & MA_STATE_PREALLOC) {
+		mas_wr_store_entry(&wr_mas);
+		MAS_WR_BUG_ON(&wr_mas, mas_is_err(mas));
+		return wr_mas.content;
+	}
+
+	request = mas_prealloc_calc(mas, entry);
+	if (!request)
+		goto store;
+
+	mas_node_count(mas, request);
+	if (mas_is_err(mas))
+		return NULL;
+
+store:
 	mas_wr_store_entry(&wr_mas);
+	mas_destroy(mas);
 	return wr_mas.content;
 }
 EXPORT_SYMBOL_GPL(mas_store);
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


