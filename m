Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832451;
	b=XbnGOEzUnQxa/oJIVD5i1SXwB+FPX8uDlU21UVmUgOjDOUZsuYQLHIOjOELbuo72YY+8
	 hQqa+vnfvqbLWHgPrgHdqQ0y3GISbXqzEx7YJhCKzG3ORbuqw/O1zJd3U3tOVVWLVvtgs
	 fOEY1ywrgPMl2/CFmRDZZXJXD1jZMKgMzILB+/wqsYa/ddfQ+WjlZID1jbWn4CKo8PyPW
	 5rwVBGKxF7GbIc0IkNed64WfUNenkFG1XNMRYmtAf4BrTxD+AY+Btq0J05lYxVTHppd6h
	 ynXkaNFoviFmdtlrWQpEpZ1B98/0aHeiUcIMkJ5Xlk0hDPGhmLLimwuumy5djgHAHXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832451;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=6N0xOeAOM0mEHBx3rVsmZbrs+8VNa66n7eVKMlafq/8=;
	b=XTRl35TnvIvLHLzCEoz1KB36+c5IwLpk6ZZBp7cv1f8l5/47paYNKViE1zUtgrcEtOdl
	 h4P6Gu1meGqgDG/S+HhbwNEobQoVgw4KN7A44BkDR0KqjK1L0iBTdpqe0BX4CDq0wW3Dx
	 Q/u+IiZ1rG5jtEuPmEkGZRbocsvatnlxC97pLovWHoNAxC/9bR1occxTQy8VwDBfwC+PA
	 rNF24L83TQGNEh7pmE208BDJfh9j6jWkStZ8iiyghXZGbmcgoVPiT/Hq6DV7ahilj4MmK
	 BEAiKIpJ+Nx4PGnPrqiZoIb/0tHnX6EF+TSWwAg326WtL10iHYT0JFFNJxfSMWJrxaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="RfhCx/u4";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A8A606A320
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=RfhCx/u4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B351F01825;
	Sat, 24 Oct 2026 09:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832451;
	bh=6N0xOeAOM0mEHBx3rVsmZbrs+8VNa66n7eVKMlafq/8=;
	h=Date:To:From:Subject;
	b=RfhCx/u4WJg0ga2rc00nFihHYSqXKRRL8jiE/UXSY+n8wJ3JEZJyFKC60TY4yg0xW
	 re2ZtyNf5JnEm/RsTHYZ0XP5/w2a8ifc09COdPbfmFbh+yBa+XpCxJYqApzyH7R138
	 gS4vH81xumTlW31D6znEXVnrGGmZhIDHKl4qh0QU=
Date: Sat, 24 Oct 2026 02:00:50 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,corbet@lwn.net,lienze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-hugetlbpagerst-fix-typo-in-per-node-attribute-description.patch removed from -mm tree
Message-Id: <20261024090050.E5B351F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: docs: hugetlbpage.rst: fix typo in per-node attribute description
has been removed from the -mm tree.  Its filename was
     docs-hugetlbpagerst-fix-typo-in-per-node-attribute-description.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Enze Li <lienze@kylinos.cn>
Subject: docs: hugetlbpage.rst: fix typo in per-node attribute description
Date: Sun,  4 Oct 2026 00:11:25 +0800

The per-node hugepages section writes the free_hugepages and
surplus_hugepages file names with stray trailing quotes.  Quote the real
names as inline literals instead.

Link: https://lore.kernel.org/20261003161125.40485-1-lienze@kylinos.cn
Signed-off-by: Enze Li <lienze@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
---

 Documentation/admin-guide/mm/hugetlbpage.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/mm/hugetlbpage.rst~docs-hugetlbpagerst-fix-typo-in-per-node-attribute-description
+++ a/Documentation/admin-guide/mm/hugetlbpage.rst
@@ -373,9 +373,9 @@ contains the following attribute files::
 	free_hugepages
 	surplus_hugepages
 
-The free\_' and surplus\_' attribute files are read-only.  They return the number
-of free and surplus [overcommitted] huge pages, respectively, on the parent
-node.
+The ``free_hugepages`` and ``surplus_hugepages`` attribute files are read-only.
+They return the number of free and surplus [overcommitted] huge pages,
+respectively, on the parent node.
 
 The ``nr_hugepages`` attribute returns the total number of huge pages on the
 specified node.  When this attribute is written, the number of persistent huge
_

Patches currently in -mm which might be from lienze@kylinos.cn are


