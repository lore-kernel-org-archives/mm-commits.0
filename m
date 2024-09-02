Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99D42D057
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247832; cv=none; b=DB1+3T+Q2tuzO6qCQbBWED2psvGlaCnSUKsHwJgEHGDEUpqmnFd+gjtNA+EtYTAum3+RK66481E/TNYzlWoddvxiOqbX7WRoxkyHCbSpU0ChmxZ0IGodchO4J1m4w8FqNU2xhSEZZ25ekNZL3X1DfieN96QCVCMGR2ckwrNHDtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247832; c=relaxed/simple;
	bh=RJO9nGEHEtdbfPCSqFQL3Bdfe+XfVhkEBLONTTAXDdE=;
	h=Date:To:From:Subject:Message-Id; b=ORZqIFaxoGP56GoD1yj49MVFYU2jMSjBvyFHq1RPkp20udLe/tdhBW8wT0U93TRtL1GQbkTkD5BpDkS7TZzgtZLUSlI6H/f/JCfNSPJDRCljYjTS510dKsRIm9PGs0xtzv0zEjB3KqO06SkUr4B9kbfiRv4dJEzT1Og3IDmbJ8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DbmgXvLP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DbmgXvLP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 994C8C4CEC2;
	Mon,  2 Sep 2024 03:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247832;
	bh=RJO9nGEHEtdbfPCSqFQL3Bdfe+XfVhkEBLONTTAXDdE=;
	h=Date:To:From:Subject:From;
	b=DbmgXvLPl0TQUANr5dWEZmPe3X2YRoTWIBx7bXf2OGGbJNALKrNFpOCQ766X48YYw
	 CplAKy37SeIv1RytAvh3Sy7vl9MpfcDp8M3get1WeIGPh8pdQN2Slgh45fA9s2qJyu
	 dSc6KZ6T3m+obkxX1My3n/mred81X+UDDhkhnB08=
Date: Sun, 01 Sep 2024 20:30:32 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-print-store-type-in-mas_dump.patch removed from -mm tree
Message-Id: <20240902033032.994C8C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: print store type in mas_dump()
has been removed from the -mm tree.  Its filename was
     maple_tree-print-store-type-in-mas_dump.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: maple_tree: print store type in mas_dump()
Date: Wed, 14 Aug 2024 12:19:35 -0400

Knowing the store type of the maple state could be helpful for debugging.
Have mas_dump() print mas->store_type.

Link: https://lkml.kernel.org/r/20240814161944.55347-9-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

--- a/lib/maple_tree.c~maple_tree-print-store-type-in-mas_dump
+++ a/lib/maple_tree.c
@@ -7760,6 +7760,40 @@ void mas_dump(const struct ma_state *mas
 		break;
 	}
 
+	pr_err("Store Type: ");
+	switch (mas->store_type) {
+	case wr_invalid:
+		pr_err("invalid store type\n");
+		break;
+	case wr_new_root:
+		pr_err("new_root\n");
+		break;
+	case wr_store_root:
+		pr_err("store_root\n");
+		break;
+	case wr_exact_fit:
+		pr_err("exact_fit\n");
+		break;
+	case wr_split_store:
+		pr_err("split_store\n");
+		break;
+	case wr_slot_store:
+		pr_err("slot_store\n");
+		break;
+	case wr_append:
+		pr_err("append\n");
+		break;
+	case wr_node_store:
+		pr_err("node_store\n");
+		break;
+	case wr_spanning_store:
+		pr_err("spanning_store\n");
+		break;
+	case wr_rebalance:
+		pr_err("rebalance\n");
+		break;
+	}
+
 	pr_err("[%u/%u] index=%lx last=%lx\n", mas->offset, mas->end,
 	       mas->index, mas->last);
 	pr_err("     min=%lx max=%lx alloc=%p, depth=%u, flags=%x\n",
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


