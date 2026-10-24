Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832491;
	b=U3aX9jtogySHZmx+Gvl6KDFIpHHbTgPArOLpKNRyOmspAKBbBDiByObk9bD85fckwWUg
	 niQuzjvpuAl0OdSChj9YXc9kh28ROcr0IcnK+LeTlmMBBr0KlGBxtv7lQhUZ9Sy/na5Xk
	 cF406itFaB7OCSBC4/g/KTtXMeW3ZQavTIdjKWLpaUTwJLT7/C/cS8WiFtNYjDIwnYfxQ
	 0gVsYbotCd42UdYOrhPnpbMRfUip9yJ6t1OUWzI9LgwDW3cEBZ0lhv387o5kw9B0KaPbp
	 FU6pDPBnovokq0VzmT54oWodZYcUGPbnmrVnwqnYwtuvDwKlE8fo07u4CDxSjWeGzIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832491;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=7hYLVuSXSlaSKixOLXtysgJYNoMQMtNf+qds5+I6nYA=;
	b=Vvw5jSLzDtDKFSOvByjYIhOkD6dUm9XulKdwdhHH7qlL15NMoOsi5YsZWDAd00u9c0zL
	 +0+S0N4RrIYpq2F+CPmcEZO18cG3h3XHBplNPl4PcgVO331KkDqYJdqc+R+Q9hmzwLF8u
	 vOvQUCtlgEQvNN7cFHzkzmASHCmxS6+6hz+uCwNsFWPjt/AKjHlqiWdi7dit7+ZTlyyk2
	 b60gSXMynHBNykuumVor2WwGxBRsE8dyl+/t7VLFpSyhx5S/pJIfrMS0syPPRUonv9BWo
	 IixLhFDre3qEOoOCWAPUIL99g6ltDKsg8l6h1qKowjq3BMiMbkwuObJs7nynOrWJAJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ZRUeCQCf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C4A606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ZRUeCQCf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60DDA1F01825;
	Sat, 24 Oct 2026 09:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832491;
	bh=7hYLVuSXSlaSKixOLXtysgJYNoMQMtNf+qds5+I6nYA=;
	h=Date:To:From:Subject;
	b=ZRUeCQCfu/y/l0CNvBnC8XzeXP7GnQRg/yhFc3B2ZRK7gxJp+XbP6HveBjlIbtg2i
	 o/wJwt0ILoC1KGynRF0V0paDTipt2sHJbprPhnAEjzlCY6kohjJoWcGTRB1l/T/ff8
	 1BMpAtjpN5fXgembAxWpIKEArzQ3Vmwk8IcHDzdw=
Date: Sat, 24 Oct 2026 02:01:30 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,ryan.roberts@arm.com,nico.pache@linux.dev,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jannh@google.com,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-collapse-name-the-per-table-scan-reset-for-what-it-resets.patch removed from -mm tree
Message-Id: <20261024090131.60DDA1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/collapse: name the per-table scan reset for what it resets
has been removed from the -mm tree.  Its filename was
     mm-collapse-name-the-per-table-scan-reset-for-what-it-resets.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: mm/collapse: name the per-table scan reset for what it resets
Date: Wed, 14 Oct 2026 18:11:40 +0100

collapse_control_init_scan() resets what one scan accumulates: the node
load, the allocation nodemask and the eligible-PTE bitmap.  It runs before
every PTE table a scan is given, not once per control, so its name points
at the wrong thing.

Call it collapse_scan_reset().

Preparation for giving a control a real init, run once for a whole series
of scans.  Two names a word apart would then stand for two different jobs.

No functional change.

Link: https://lore.kernel.org/20261014171145.3292736-8-kas@kernel.org
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Assisted-by: LLM
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
---

 mm/khugepaged.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/khugepaged.c~mm-collapse-name-the-per-table-scan-reset-for-what-it-resets
+++ a/mm/khugepaged.c
@@ -532,7 +532,7 @@ void __khugepaged_exit(struct mm_struct
 	}
 }
 
-static void collapse_control_init_scan(struct collapse_control *cc)
+static void collapse_scan_reset(struct collapse_control *cc)
 {
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
@@ -1607,7 +1607,7 @@ static enum scan_result collapse_scan_pm
 		goto out;
 	}
 
-	collapse_control_init_scan(cc);
+	collapse_scan_reset(cc);
 
 	enabled_orders = collapse_possible_orders(vma, vma->vm_flags, tva_flags);
 
@@ -2681,7 +2681,7 @@ static enum scan_result collapse_scan_fi
 
 	present = 0;
 	swap = 0;
-	collapse_control_init_scan(cc);
+	collapse_scan_reset(cc);
 	rcu_read_lock();
 	xas_for_each(&xas, folio, start + HPAGE_PMD_NR - 1) {
 		if (xas_retry(&xas, folio))
_

Patches currently in -mm which might be from kas@kernel.org are


