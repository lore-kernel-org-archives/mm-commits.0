Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794246367;
	b=ahj3XgRZzwVJGeQ2wlyduoS11ThTIeMMIDsD8QHe4W6EcFydiwxjUMK0Qya6La2UKdwZ
	 QclE5WD55oao87f2UERGSSt7mGsoCuMq8iXrOo70/Q+JnBUhyk9uhuYM6NbT4VIBo7x9p
	 PqTaVCfeA9mMqtktVwRlgUZ4vqcuis9y3tZDp+YrFJy9cNeZtFu72euQf9Cxi5Fb/oWsg
	 hlhBcD9OYnmzyER73G3L8i1zfcUD5ixqje2A5PgB/241uyacKHzyg0dBdigRxorH58iC/
	 InqJj6hkQ9GpnUbrtOWCy+2IRqkxhbkDMxuxaCEXKv9pZoP/EQeDDgFrkTVPSRogJeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794246367;
	h=Received:DKIM-Signature:Date:To:Cc:From:Subject:Message-Id;
	bh=dfySfXKzYhpaR3S9uvqKqfOZO8bWQkjuSGRL/zjgaYU=;
	b=I8buuJXZeEaEg7d4AJZDjSNQLJlV7E/Zdo2l0enfcfnFrlBrQZHdQc2QE3hJSMcRvfEq
	 VvGgkBXweooF3zj3X/ag62MdwbLk9rBoz+UQp3RyEfPK4WF1HuKNdUpHe62pc6SgkPxYg
	 8pgglZf+zxRQSBtJk5lMf77fCAcVMCOIOWKbl9Sg+yXUaO9QiMcBHCYO/9ScKTGW/e8I5
	 6g5cdKSJ/V3SspZfs0u1Z47wJkA8dr1BhCnuJuiwJFORml3iQVynQ4qltSbci4EknkAey
	 +sxcZBAZDjQouPXkHY2SbDXNXKppid6OVpctmd5qx+wVF3v3X7n3ogrIi/v7qH59zGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Y9Y6hG7x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE7C606A32A
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 17:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Y9Y6hG7x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D29A61F008A1;
	Mon,  9 Nov 2026 17:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794246366;
	bh=dfySfXKzYhpaR3S9uvqKqfOZO8bWQkjuSGRL/zjgaYU=;
	h=Date:To:Cc:From:Subject;
	b=Y9Y6hG7x0g/NWrfxxw34UayWxzm8n7w3nC2X9ekBIfgQiIBYpcJ6rBL7ub+ltM5Eh
	 jXcr4tEnd+XAb3h9C2ECXNzXvmjpRkV7n1sgQe39iksRFyskRYODVxahltrbIojyFd
	 XmLxG5LazI69ZYaRpI0WMv8znmw5oWmeB9/Fff+Y=
Date: Mon, 09 Nov 2026 09:46:06 -0800
To: mm-commits@vger.kernel.org, ljs@kernel.org, akpm@linux-foundation.org
Cc: David Hildenbrand <david@kernel.org>
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] fs-coredump-convert-vma_dump_size-to-use-vma_flags_t.patch removed from -mm tree
Message-Id: <20261109174606.D29A61F008A1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: fs/coredump: convert vma_dump_size() to use vma_flags_t
has been removed from the -mm tree.  Its filename was
     fs-coredump-convert-vma_dump_size-to-use-vma_flags_t.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: fs/coredump: convert vma_dump_size() to use vma_flags_t
Date: Thu, 05 Nov 2026 21:31:01 +0000

Replace use of the legacy vm_flags_t flags with vma_flags_t values when
determining how much of a VMA to dump.

The flags copied into struct core_vma_metadata remain legacy flags as they
are consumed by the binfmt handlers.

No functional change intended.

Link: https://lore.kernel.org/20261105-late-2026-vma-flags-v1-10-0d3cd15ab75f@kernel.org
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

 fs/coredump.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/fs/coredump.c~fs-coredump-convert-vma_dump_size-to-use-vma_flags_t
+++ a/fs/coredump.c
@@ -1837,15 +1837,15 @@ static unsigned long vma_dump_size(struc
 	if (always_dump_vma(vma))
 		goto whole;
 
-	if (vma->vm_flags & VM_DONTDUMP)
+	if (vma_test(vma, VMA_DONTDUMP_BIT))
 		return 0;
 
 	/* support for DAX */
 	if (vma_is_dax(vma)) {
-		if ((vma->vm_flags & VM_SHARED) &&
+		if (vma_test(vma, VMA_SHARED_BIT) &&
 		    COREDUMP_MEMORY_TYPE_INCLUDE(memory_types, DAX_SHARED))
 			goto whole;
-		if (!(vma->vm_flags & VM_SHARED) &&
+		if (!vma_test(vma, VMA_SHARED_BIT) &&
 		    COREDUMP_MEMORY_TYPE_INCLUDE(memory_types, DAX_PRIVATE))
 			goto whole;
 		return 0;
@@ -1853,21 +1853,21 @@ static unsigned long vma_dump_size(struc
 
 	/* Hugetlb memory check */
 	if (vma_is_hugetlb(vma)) {
-		if ((vma->vm_flags & VM_SHARED) &&
+		if (vma_test(vma, VMA_SHARED_BIT) &&
 		    COREDUMP_MEMORY_TYPE_INCLUDE(memory_types, HUGETLB_SHARED))
 			goto whole;
-		if (!(vma->vm_flags & VM_SHARED) &&
+		if (!vma_test(vma, VMA_SHARED_BIT) &&
 		    COREDUMP_MEMORY_TYPE_INCLUDE(memory_types, HUGETLB_PRIVATE))
 			goto whole;
 		return 0;
 	}
 
 	/* Do not dump I/O mapped devices or special mappings */
-	if (vma->vm_flags & VM_IO)
+	if (vma_test(vma, VMA_IO_BIT))
 		return 0;
 
 	/* By default, dump shared memory if mapped from an anonymous file. */
-	if (vma->vm_flags & VM_SHARED) {
+	if (vma_test(vma, VMA_SHARED_BIT)) {
 		if (file_inode(vma->vm_file)->i_nlink == 0 ?
 			    COREDUMP_MEMORY_TYPE_INCLUDE(memory_types, ANON_SHARED) :
 			    COREDUMP_MEMORY_TYPE_INCLUDE(memory_types, FILE_SHARED))
@@ -1890,7 +1890,7 @@ static unsigned long vma_dump_size(struc
 	 * dump the first page to aid in determining what was mapped here.
 	 */
 	if (COREDUMP_MEMORY_TYPE_INCLUDE(memory_types, ELF_HEADERS) &&
-	    vma->vm_pgoff == 0 && (vma->vm_flags & VM_READ)) {
+	    vma->vm_pgoff == 0 && vma_test(vma, VMA_READ_BIT)) {
 		if ((READ_ONCE(file_inode(vma->vm_file)->i_mode) & 0111) != 0)
 			return PAGE_SIZE;
 
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-read-anon_vma-carefully-in-validate_mm.patch
uprobes-convert-vma-flag-tests-to-use-vma_flags_t.patch
perf-convert-vma-flag-tests-to-use-vma_flags_t.patch
security-convert-vma-flag-tests-to-use-vma_flags_t.patch

