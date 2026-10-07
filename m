Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376A42E7F2C
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334215; cv=none; b=HwGRk/61k7caGCZ/vq5fGLOC8qub4G1wDSIDyZDcd00Z7OaVvTZgWELqadHilZrREgb46PtFCqfbCex6ozCIZg5hSEZuDWrf+h8iTFHVDKlmtewU25HtyK/NzscA9HNeAILsQfLRnJfvSk1bT3cmEuDwMRcvWIsCzsLbHYrCnJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334215; c=relaxed/simple;
	bh=J/8NZGxYRd1lE8utvMkILhZWhca//I9/20MiVxurih4=;
	h=Date:To:From:Subject:Message-Id; b=eQEoV0okQGGQDvrb+mdYiv2PeZ+9ArxlNkjNVa/2OL7DmUfyjFPx47tyVKmBA5Q2n6EJN6k/AwHZw8O4aA/WKi7JnJeEHoTG7eSibIpOsmQ5H+EtXyzyIZmQeAhaG1QW6o1Ea3PYN0BR7HbNbgmMKZYNJSgXUZg1nzpmfbiqhaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BHuMidY2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BHuMidY2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D1E91F0089C;
	Wed,  7 Oct 2026 00:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334214;
	bh=8HqSGx5oPt3w/yI1UnA0LUkpP0EzPa8GI/Ub52Thw78=;
	h=Date:To:From:Subject;
	b=BHuMidY2PzJ5+E1P7hTh0m7igsEcozFaZO/HWCgsbkKHcCka4s40qNr/7cIOIH/kg
	 m7UqeYSy4CId6P9ao19ZZgjwwG7B5huc7tnuwma0B12ow11vSRQ+CLykO5r22M5zaI
	 8tebaFtVrksuN+pTi8xbnWwKCxaQK/YaPFmcDkuo=
Date: Tue, 06 Oct 2026 17:50:13 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liujing@cmss.chinamobile.com,liam@infradead.org,david@kernel.org,corbet@lwn.net,chenyichong@uniontech.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-mm-page_owner_sort-show-available-sort-keys-in-usage-text.patch removed from -mm tree
Message-Id: <20261007005014.0D1E91F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/mm/page_owner_sort: show available sort keys in usage text
has been removed from the -mm tree.  Its filename was
     tools-mm-page_owner_sort-show-available-sort-keys-in-usage-text.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ye Liu <liuye@kylinos.cn>
Subject: tools/mm/page_owner_sort: show available sort keys in usage text
Date: Wed, 19 Aug 2026 10:16:11 +0800

The --sort option accepts abbreviated or complete key names, but the usage
text never listed them.  Users had to read the source or the documentation
to discover valid keys.

List all available keys (full form and abbreviation) with a brief
description and examples directly in the --sort help section.

Link: https://lore.kernel.org/20260819021611.2910835-4-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Yichong Chen <chenyichong@uniontech.com>
Cc: Liu Jing <liujing@cmss.chinamobile.com>
---

 tools/mm/page_owner_sort.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/tools/mm/page_owner_sort.c~tools-mm-page_owner_sort-show-available-sort-keys-in-usage-text
+++ a/tools/mm/page_owner_sort.c
@@ -772,6 +772,15 @@ static void usage(void)
 		"\t\t\targument in the form of a comma-separated list with some\n"
 		"\t\t\tcommon fields predefined (pid, tgid, comm, stacktrace, allocator, module)\n"
 		"--sort <order>\t\tSpecify sort order as: [+|-]key[,[+|-]key[,...]]\n"
+		"\t\t\tAvailable keys:\n"
+		"\t\t\t  pid(p), tgid(tg), name(n), stacktrace(st),\n"
+		"\t\t\t  txt(T), alloc_ts(at), allocator(ator), module(mod)\n"
+		"\t\t\tThe \"+\" is optional since default direction is\n"
+		"\t\t\tincreasing numerical or lexicographic order.\n"
+		"\t\t\tMixed use of abbreviated and complete-form is allowed.\n"
+		"\t\t\tExamples:\n"
+		"\t\t\t  --sort=n,+pid,-tgid\n"
+		"\t\t\t  --sort=mod,at\n"
 	);
 }
 
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-vmalloc-group-xa_init-with-vbq-field-initializations.patch
mm-vmalloc-extract-vmap_insert_free_area-helper.patch
mm-vmalloc-extract-show_busy_info-from-vmalloc_info_show.patch
mm-vmalloc-fix-vmalloc_dump_obj-address-alignment-for-last-page-lookups.patch
mm-vmalloc-fix-vmalloc_dump_obj-cross-zone-va-lookup.patch

