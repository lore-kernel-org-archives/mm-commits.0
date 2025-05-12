Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE941553A3
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011070; cv=none; b=QgwpQuGGt4xBvabIApQdl+pNXEa7NGuEpkwlkGb4IZhM3zgTwyG+wKqFc2NS6mJpU6Bha+BCFMeROymqjeOl2Dh3UDortE5LfCRcoAA7RNiTRfcsaIoV9irCD6SbfH9sd/s5JnRxRiAWdknByO9kZoflaOHHrvu3Sd6YHsPHI+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011070; c=relaxed/simple;
	bh=3fjKoKhpDOVQeyu/7T9JSw4AAdXCd/rahVZJXXQbCMQ=;
	h=Date:To:From:Subject:Message-Id; b=VcAOSVI2jXc/0xacgP7eI5qYYlbl6FA8EGmfUg9g64H2AKyNgl31fFuB9Jdup9Z8PjEvwmSicecYRIFPTXydcE6Iv9jDYApoxij5kbinsqqPw9L+vcGhWhjdOLrioaWmd/CYWhYxwuKqyWz8Qt3CPRbUYcyKkrVUBd6aUAFsrAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DW1IPk0K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DW1IPk0K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B23C4C4CEE4;
	Mon, 12 May 2025 00:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011070;
	bh=3fjKoKhpDOVQeyu/7T9JSw4AAdXCd/rahVZJXXQbCMQ=;
	h=Date:To:From:Subject:From;
	b=DW1IPk0KMrvgd9iHYtJ11jsMCbEA/8XMK6Ka/ZhYBJnBVE4M8Z7B8T5iWM2ewqimg
	 TUhzbGOz9CLJs0eP1BIiQJWGvjtLMDMfIhLcPeFX1cQYcSI9Q4KS5ERgzvO2em2jbs
	 wt6NETClJfi2isKWZrvj8IdL9tS7K4j0WpaKMjVo=
Date: Sun, 11 May 2025 17:51:10 -0700
To: mm-commits@vger.kernel.org,hch@infradead.org,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] vmalloc-add-for_each_vmap_node-helper.patch removed from -mm tree
Message-Id: <20250512005110.B23C4C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: vmalloc: add for_each_vmap_node() helper
has been removed from the -mm tree.  Its filename was
     vmalloc-add-for_each_vmap_node-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: vmalloc: add for_each_vmap_node() helper
Date: Tue, 8 Apr 2025 17:15:47 +0200

To simplify iteration over vmap-nodes, add the for_each_vmap_node() macro
that iterates over all nodes in a system.  It tends to simplify the code.

Link: https://lkml.kernel.org/r/20250408151549.77937-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Christop Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/vmalloc.c~vmalloc-add-for_each_vmap_node-helper
+++ a/mm/vmalloc.c
@@ -900,6 +900,11 @@ static struct vmap_node *vmap_nodes = &s
 static __read_mostly unsigned int nr_vmap_nodes = 1;
 static __read_mostly unsigned int vmap_zone_size = 1;
 
+/* A simple iterator over all vmap-nodes. */
+#define for_each_vmap_node(vn)	\
+	for ((vn) = &vmap_nodes[0];	\
+		(vn) < &vmap_nodes[nr_vmap_nodes]; (vn)++)
+
 static inline unsigned int
 addr_to_node_id(unsigned long addr)
 {
_

Patches currently in -mm which might be from urezki@gmail.com are

maintainers-add-myself-as-vmalloc-co-maintainer.patch

