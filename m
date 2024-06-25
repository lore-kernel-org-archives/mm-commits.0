Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3AAD142E76
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293162; cv=none; b=BtOYy7vuGccIPWVuZCNMQfDQ/d09AZZCqiO8R4gCP3NuT36c+W4eqhr3xYmYI8OGGD6Wh7bh29a8sw/Ya2JK25fldx+NJ/Oq370It3NXvW1VkFYCREhwu20XA8UmswHIq0ygg1I0ORISfYF9c1lJnwuf25wbGPhjTBjJYle//Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293162; c=relaxed/simple;
	bh=1qFJsdLyPZi4EtRuv4qVnpSJSHF6Dy0JdmNAib/CbTU=;
	h=Date:To:From:Subject:Message-Id; b=dKTDcDli8UBZ1jM9l0tTmaeqc1V4uZ3YGYwoGsR6i7qj5AMFzJvj1Xs8Pwz2gDF38Le5sqGhtw23WK8rqKbIwIlgjj48y7i9LP2Wzbif/tDW2gZN5dK0JgXQ8Skroq0OqwPsUqV71cb+H9UA+MUl+DVz9Z40lcodYmDKIfKnRZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l4BTeByn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l4BTeByn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68084C4AF0C;
	Tue, 25 Jun 2024 05:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293162;
	bh=1qFJsdLyPZi4EtRuv4qVnpSJSHF6Dy0JdmNAib/CbTU=;
	h=Date:To:From:Subject:From;
	b=l4BTeBynwVK4YG1XVdVxDLUd7KUnqQF2DbvT68MWeybk6yiHBDax1FNmGdgEyQrnH
	 1t+4BJX4HvIwIAtVdiVLglwlbRosC+aSpDkWTIeF2n5HRXJEBS+qGp2dVKuwMD5zMS
	 F5gmmFmfEMRiAn01smprUG95vHq1CiRHsz/j+T7E=
Date: Mon, 24 Jun 2024 22:26:01 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,peterz@infradead.org,namhyung@kernel.org,msakai@redhat.com,mingo@redhat.com,mark.rutland@arm.com,kent.overstreet@linux.dev,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,colyli@suse.de,bfoster@redhat.com,bagasdotme@gmail.com,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-min_heap-add-min_heap_init.patch removed from -mm tree
Message-Id: <20240625052602.68084C4AF0C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib min_heap: add min_heap_init()
has been removed from the -mm tree.  Its filename was
     lib-min_heap-add-min_heap_init.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: lib min_heap: add min_heap_init()
Date: Fri, 24 May 2024 23:29:47 +0800

Add min_heap_init() for initializing heap with data, nr, and size.

Link: https://lkml.kernel.org/r/20240524152958.919343-6-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Coly Li <colyli@suse.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Sakai <msakai@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/min_heap.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/include/linux/min_heap.h~lib-min_heap-add-min_heap_init
+++ a/include/linux/min_heap.h
@@ -38,6 +38,21 @@ struct min_heap_callbacks {
 	void (*swp)(void *lhs, void *rhs);
 };
 
+/* Initialize a min-heap. */
+static __always_inline
+void __min_heap_init(min_heap_char *heap, void *data, int size)
+{
+	heap->nr = 0;
+	heap->size = size;
+	if (data)
+		heap->data = data;
+	else
+		heap->data = heap->preallocated;
+}
+
+#define min_heap_init(_heap, _data, _size)	\
+	__min_heap_init((min_heap_char *)_heap, _data, _size)
+
 /* Sift the element at pos down the heap. */
 static __always_inline
 void __min_heapify(min_heap_char *heap, int pos, size_t elem_size,
_

Patches currently in -mm which might be from visitorckw@gmail.com are


