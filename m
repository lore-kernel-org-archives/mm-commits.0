Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794246370;
	b=JCjoiDo4SsXHsTiDdTG/JqMbPkuAcSa6OSgwfTW5J9KdJ/zZXib08HkNpJ8k5nEJN0ln
	 QjLYTQOY+OCX96yx1A0jnFJCiz5cs1N9UnX3oIW+Hp/4MRh7iAYegtIxTnZlk0GFh9dLU
	 Wj9UWvy7YN+aUfEwkfy+f+PNNUW3TCqMDyV9HkOLloN8DoxDwrl0i5z8qToINExUqtz4v
	 D4DCM70OK0jMHklkMebYB87cImdK5yscUIW42QqQ7nezAAPOubCDlPvCDaq6XRMHVUqEB
	 LKWrzjm/QzxfMCjucGKTF/byove5PU7tVv9gUlxyj8ZuSLmxr9/L0O6Ehocf+v/X+IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794246370;
	h=Received:DKIM-Signature:Date:To:Cc:From:Subject:Message-Id;
	bh=E87/P1JtfDc1gxFOd1ggA/N99y7LvuBKHk7jdxQ93L0=;
	b=zdgySe2YccSH+9yy1FsPqvMEL/1QIjy6op0NBhvCQNlIBN/knEWEVXMx5zx9geRr3Pl5
	 p08aYVon7omRfS7xBVjxByELPj6/CHBT1sa4AYbl4Fx/KUOIN8BcvUbDZydTBIMxqy52L
	 vRc0yz4D4T8sfvoSWpX5mjiyAsnMCO6OiButEkpyBLL8nsfK9OMHIQqP6QWIjjPPw/Xtb
	 lLXfWdxc8afKlixsRFyi7BAr8d0Wblxa3/tCl/HdX+cJbxQcJCrb8u17v/4dsyAAmOo2g
	 TJXIBVtu8M/PoJo5HvkiZMb4a0cKiuzCR1c9T+gtKQWkXtHY/2tkundphV0FlxVCnUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="uh/4txGm";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A43606A326
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 17:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=uh/4txGm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29FFC1F008A1;
	Mon,  9 Nov 2026 17:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794246370;
	bh=E87/P1JtfDc1gxFOd1ggA/N99y7LvuBKHk7jdxQ93L0=;
	h=Date:To:Cc:From:Subject;
	b=uh/4txGmwbWrcitaY5IXNkCP6255zz9k5umGLtljC1riJ511M+sZ6a0BdDcFyIPYA
	 y1DzXDt1JP9nfHmixtTLlEyg64cXFqxj81rVomkQFu77KsUNssiJZgvMQdmYrdfHgm
	 evxUJmawtA/QFeAXMj85gQ4SEIs6cnn/4N/FwJqY=
Date: Mon, 09 Nov 2026 09:46:09 -0800
To: mm-commits@vger.kernel.org, ljs@kernel.org, akpm@linux-foundation.org
Cc: David Hildenbrand <david@kernel.org>
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] perf-convert-vma-flag-tests-to-use-vma_flags_t.patch removed from -mm tree
Message-Id: <20261109174610.29FFC1F008A1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: perf: convert VMA flag tests to use vma_flags_t
has been removed from the -mm tree.  Its filename was
     perf-convert-vma-flag-tests-to-use-vma_flags_t.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: perf: convert VMA flag tests to use vma_flags_t
Date: Thu, 05 Nov 2026 21:31:03 +0000

Replace use of the legacy vm_flags_t flags with vma_flags_t values in the
perf mmap and mmap event logic.

No functional change intended.

Link: https://lore.kernel.org/20261105-late-2026-vma-flags-v1-12-0d3cd15ab75f@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Rik van Riel <riel@surriel.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Xu Xin <xu.xin@linux.dev>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Kairui Song <kasong@tencent.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: SJ Park <sj@kernel.org>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: John Johansen <john.johansen@canonical.com>
Cc: Georgia Garcia <georgia.garcia@canonical.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: James Morris <jmorris@namei.org>
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: Roberto Sassu <roberto.sassu@huawei.com>
Cc: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: Eric Snowberg <eric.snowberg@oracle.com>
Cc: Fan Wu <wufan@kernel.org>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Ondrej Mosnáček <omosnacek@gmail.com>
---

 kernel/events/core.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

--- a/kernel/events/core.c~perf-convert-vma-flag-tests-to-use-vma_flags_t
+++ a/kernel/events/core.c
@@ -7224,6 +7224,7 @@ static int map_range(struct perf_buffer
 		unsigned long va = vma->vm_start + PAGE_SIZE * pagenum;
 		struct page *page = perf_mmap_to_page(rb,
 				vma_start_pgoff(vma) + pagenum);
+		vma_flags_t vma_flags = vma->flags;
 
 		if (page == NULL) {
 			err = -EINVAL;
@@ -7231,8 +7232,9 @@ static int map_range(struct perf_buffer
 		}
 
 		/* Map readonly, perf_mmap_pfn_mkwrite() called on write fault. */
+		vma_flags_clear(&vma_flags, VMA_SHARED_BIT);
 		err = remap_pfn_range(vma, va, page_to_pfn(page), PAGE_SIZE,
-				      vm_get_page_prot(vma->vm_flags & ~VM_SHARED));
+				      vma_flags_to_page_prot(vma_flags));
 		if (err)
 			break;
 	}
@@ -7350,7 +7352,7 @@ static int perf_mmap_rb(struct vm_area_s
 	if (!perf_mmap_calc_limits(vma, &user_extra, &extra))
 		return -EPERM;
 
-	if (vma->vm_flags & VM_WRITE)
+	if (vma_test(vma, VMA_WRITE_BIT))
 		rb_flags |= RING_BUFFER_WRITABLE;
 
 	rb = rb_alloc(nr_pages,
@@ -7431,7 +7433,7 @@ static int perf_mmap_aux(struct vm_area_
 
 		WARN_ON(!rb && event->rb);
 
-		if (vma->vm_flags & VM_WRITE)
+		if (vma_test(vma, VMA_WRITE_BIT))
 			rb_flags |= RING_BUFFER_WRITABLE;
 
 		ret = rb_alloc_aux(rb, event, pgoff_start, nr_pages,
@@ -7466,7 +7468,7 @@ static int perf_mmap(struct file *file,
 	if (event->cpu == -1 && event->attr.inherit)
 		return -EINVAL;
 
-	if (!(vma->vm_flags & VM_SHARED))
+	if (!vma_test(vma, VMA_SHARED_BIT))
 		return -EINVAL;
 
 	ret = security_perf_event_read(event);
@@ -9829,7 +9831,7 @@ static int perf_event_mmap_match(struct
 {
 	struct perf_mmap_event *mmap_event = data;
 	struct vm_area_struct *vma = mmap_event->vma;
-	int executable = vma->vm_flags & VM_EXEC;
+	bool executable = vma_test(vma, VMA_EXEC_BIT);
 
 	return (!executable && event->attr.mmap_data) ||
 	       (executable && (event->attr.mmap || event->attr.mmap2));
@@ -9862,7 +9864,7 @@ static void perf_event_mmap_output(struc
 		if (use_build_id)
 			misc |= PERF_RECORD_MISC_MMAP_BUILD_ID;
 	}
-	if (!(mmap_event->vma->vm_flags & VM_EXEC))
+	if (!vma_test(mmap_event->vma, VMA_EXEC_BIT))
 		misc |= PERF_RECORD_MISC_MMAP_DATA;
 
 	perf_event_header__init(&mmap_event->event_id.header, &sample,
@@ -9913,19 +9915,19 @@ static void perf_event_mmap_event(struct
 	char *buf = NULL;
 	char *name = NULL;
 
-	if (vma->vm_flags & VM_READ)
+	if (vma_test(vma, VMA_READ_BIT))
 		prot |= PROT_READ;
-	if (vma->vm_flags & VM_WRITE)
+	if (vma_test(vma, VMA_WRITE_BIT))
 		prot |= PROT_WRITE;
-	if (vma->vm_flags & VM_EXEC)
+	if (vma_test(vma, VMA_EXEC_BIT))
 		prot |= PROT_EXEC;
 
-	if (vma->vm_flags & VM_MAYSHARE)
+	if (vma_test(vma, VMA_MAYSHARE_BIT))
 		flags = MAP_SHARED;
 	else
 		flags = MAP_PRIVATE;
 
-	if (vma->vm_flags & VM_LOCKED)
+	if (vma_test(vma, VMA_LOCKED_BIT))
 		flags |= MAP_LOCKED;
 	if (vma_is_hugetlb(vma))
 		flags |= MAP_HUGETLB;
@@ -10091,7 +10093,7 @@ static void perf_addr_filters_adjust(str
 	 * Data tracing isn't supported yet and as such there is no need
 	 * to keep track of anything that isn't related to executable code:
 	 */
-	if (!(vma->vm_flags & VM_EXEC))
+	if (!vma_test(vma, VMA_EXEC_BIT))
 		return;
 
 	rcu_read_lock();
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-read-anon_vma-carefully-in-validate_mm.patch
security-convert-vma-flag-tests-to-use-vma_flags_t.patch

