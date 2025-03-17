Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4362D21518B
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188239; cv=none; b=gjhwcPrBNreh8EOS1n9TQ1q2cpFv3lMU8ZAcSw0wEBGbm3c3afLBp2AqII/CqhF/Kj+TXW4Fu2c1ny1whzob8bN0MULyt5G8wub7WTP/79LNAsCVnD6eO05kDaCmtJYzRo3FzfT+65BtvkCmy26xUJa6i89N2F3X+tXnyBfX9kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188239; c=relaxed/simple;
	bh=GpjcIOQw+0p+lT0r9wAFF/qPEaBB9Qj219AHOpc9BZE=;
	h=Date:To:From:Subject:Message-Id; b=BpO+Zs15TLzqvwECGbTyJZVWVs/nMT//TJJp4qXN/rB33JA5C/9T9E0GDSD5eeNsjhm5EvG7f1rySdyGGb7/Wi0mL8vHSxmuGMyMt6VQ7bv7mv5Ctx6ErFNZPSb5MpLXEXQo37C+jzx8bNEfS7hssqebE3LMlYkp+8Asd2omJzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jRg2xZYL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jRg2xZYL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B79C4CEEC;
	Mon, 17 Mar 2025 05:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188238;
	bh=GpjcIOQw+0p+lT0r9wAFF/qPEaBB9Qj219AHOpc9BZE=;
	h=Date:To:From:Subject:From;
	b=jRg2xZYLcGWZXWk1rZR8osTYKmipmnSQKTmUEQRq9RmA1mDSgmsicUT7AnO4eTxoz
	 n1BsrCkChChcGbKzNL77Bro0LUw0EdlgNMu3Ht9wcHK64n0KHIhomzZ5uzelpLnur6
	 DUH8w1DvClnXbL4FuY1F8hkKP/5vhxhAePcffOLc=
Date: Sun, 16 Mar 2025 22:10:38 -0700
To: mm-commits@vger.kernel.org,ryncsn@gmail.com,chrisl@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-skip-scanning-cluster-range-if-its-empty-cluster.patch removed from -mm tree
Message-Id: <20250317051038.B6B79C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap: skip scanning cluster range if it's empty cluster
has been removed from the -mm tree.  Its filename was
     mm-swap-skip-scanning-cluster-range-if-its-empty-cluster.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/swap: skip scanning cluster range if it's empty cluster
Date: Wed, 5 Feb 2025 17:27:13 +0800

Since ci->lock has been taken when isolating cluster from
si->free_clusters or taking si->percpu_cluster->next[order], it's
unnecessary to scan and check the cluster range availability if i'ts empty
cluster, and this can accelerate the huge page swapping.

Link: https://lkml.kernel.org/r/20250205092721.9395-5-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/swapfile.c~mm-swap-skip-scanning-cluster-range-if-its-empty-cluster
+++ a/mm/swapfile.c
@@ -730,6 +730,9 @@ static bool cluster_scan_range(struct sw
 	unsigned long offset, end = start + nr_pages;
 	unsigned char *map = si->swap_map;
 
+	if (cluster_is_empty(ci))
+		return true;
+
 	for (offset = start; offset < end; offset++) {
 		switch (READ_ONCE(map[offset])) {
 		case 0:
_

Patches currently in -mm which might be from bhe@redhat.com are


