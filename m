Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794246372;
	b=YkfSoKcW4W6HSBoe/1WtNBT4QSjmOX4pwi9vjIfMvwhdBU2hs5ArTywtSoAg/8t1NI8b
	 s82nWjOuCPKZDotA1GPBD4JsNlil1BzAh4q76xm+eabsx61w3/jMhI4NVfHTRaFdm877Z
	 vL2YTeD9S7hnV6e6M+nLZ5FUOlr5BUiqHtju1/FtxplfagwOHOCYn6PYjxi9NBp5xYfAQ
	 a0+ckrQ8nr3SZthIMvmgHNZFhXuexEIS64x/I7yiggAHFYdQNZ/VfpWSe7lVhUB+ssh5C
	 l8ngs0tz3gDI0x6QLs0o2c88GXKJ8W2oTO8BY0wRPDmP+OPp/fKIec4CYgNZyYKlVkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794246372;
	h=Received:DKIM-Signature:Date:To:Cc:From:Subject:Message-Id;
	bh=oMU8TE+NJRUKA5MtcEGciXeMedfaN5ozJjZk6CzMlTs=;
	b=IglFNDTvQOT+nlAONSO0dUUzjSYYZ8gE9luAURujT6h58zZSGt6rLHC1YXmqZqX3xZSa
	 9dzjS0741ES+GD3HsV33hjoEn523MNp4evgi3LliP2a1QxW2fLyOidrXsW3hnRRhtCy06
	 NOI4gWZ5A1QJvDDoiAtyEGgubNNb64wm6GcTDQz8hp/+xRx6HdvSheut7GYcqNs/ulZqg
	 Tcu/sivftnkxgTRpb8IIEMnRIskvDIEbaaVadLFLegI5CN9ng3GxxJwaPZTO+k7R+465p
	 mSYZ1chNln6q9t1n+UNvssEdHiVxqy2K+UfQIAJaARjCMAkZLHVmlCXjSlmYIaQbaGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Yfr3nWVm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A15606A31C
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 17:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Yfr3nWVm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD9BD1F0089F;
	Mon,  9 Nov 2026 17:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794246371;
	bh=oMU8TE+NJRUKA5MtcEGciXeMedfaN5ozJjZk6CzMlTs=;
	h=Date:To:Cc:From:Subject;
	b=Yfr3nWVmsjK62KLAfGdbT4pWb4R1ru3CIkVgEYuIPWAkw+3Jq3DdvXI9t8rwypzfl
	 GLDEYc2YXFZrarXvn2t0iMh7DYo8fxeFRg7BiXasyA2UEBh5rZ7yQoG5FjTDiPogRu
	 +/vOWJUCQECMec+VOdaiBwjWyZuJKQmQ5Xkg0qiw=
Date: Mon, 09 Nov 2026 09:46:11 -0800
To: mm-commits@vger.kernel.org, ljs@kernel.org, akpm@linux-foundation.org
Cc: David Hildenbrand <david@kernel.org>
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] security-convert-vma-flag-tests-to-use-vma_flags_t.patch removed from -mm tree
Message-Id: <20261109174611.CD9BD1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: security: convert VMA flag tests to use vma_flags_t
has been removed from the -mm tree.  Its filename was
     security-convert-vma-flag-tests-to-use-vma_flags_t.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: security: convert VMA flag tests to use vma_flags_t
Date: Thu, 05 Nov 2026 21:31:04 +0000

Replace use of the legacy vm_flags_t flags with vma_flags_t values in the
mmap and mprotect LSM hooks of SELinux, AppArmor, IMA and IPE.

No functional change intended.

Link: https://lore.kernel.org/20261105-late-2026-vma-flags-v1-13-0d3cd15ab75f@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Paul Moore <paul@paul-moore.com>
Acked-by: Fan Wu <wufan@kernel.org>  # for the IPE part
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
Cc: James Morris <jmorris@namei.org>
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: Roberto Sassu <roberto.sassu@huawei.com>
Cc: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: Eric Snowberg <eric.snowberg@oracle.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Ondrej Mosnáček <omosnacek@gmail.com>
---

 security/apparmor/lsm.c           |    2 +-
 security/integrity/ima/ima_main.c |    2 +-
 security/ipe/hooks.c              |    2 +-
 security/selinux/hooks.c          |   14 +++++++-------
 4 files changed, 10 insertions(+), 10 deletions(-)

--- a/security/apparmor/lsm.c~security-convert-vma-flag-tests-to-use-vma_flags_t
+++ a/security/apparmor/lsm.c
@@ -591,7 +591,7 @@ static int apparmor_file_mprotect(struct
 				  unsigned long reqprot, unsigned long prot)
 {
 	return common_mmap(OP_FMPROT, vma->vm_file, prot,
-			   !(vma->vm_flags & VM_SHARED) ? MAP_PRIVATE : 0);
+			   !vma_test(vma, VMA_SHARED_BIT) ? MAP_PRIVATE : 0);
 }
 
 #ifdef CONFIG_IO_URING
--- a/security/integrity/ima/ima_main.c~security-convert-vma-flag-tests-to-use-vma_flags_t
+++ a/security/integrity/ima/ima_main.c
@@ -556,7 +556,7 @@ static int ima_file_mprotect(struct vm_a
 
 	/* Is mprotect making an mmap'ed file executable? */
 	if (!(ima_policy_flag & IMA_APPRAISE) || !vma->vm_file ||
-	    !(prot & PROT_EXEC) || (vma->vm_flags & VM_EXEC))
+	    !(prot & PROT_EXEC) || vma_test(vma, VMA_EXEC_BIT))
 		return 0;
 
 	security_current_getlsmprop_subj(&prop);
--- a/security/ipe/hooks.c~security-convert-vma-flag-tests-to-use-vma_flags_t
+++ a/security/ipe/hooks.c
@@ -112,7 +112,7 @@ int ipe_file_mprotect(struct vm_area_str
 	struct ipe_eval_ctx ctx = IPE_EVAL_CTX_INIT;
 
 	/* Already Executable */
-	if (vma->vm_flags & VM_EXEC)
+	if (vma_test(vma, VMA_EXEC_BIT))
 		return 0;
 
 	if (prot & PROT_EXEC) {
--- a/security/selinux/hooks.c~security-convert-vma-flag-tests-to-use-vma_flags_t
+++ a/security/selinux/hooks.c
@@ -4206,16 +4206,16 @@ static int selinux_mmap_backing_file(str
 {
 	unsigned long prot = 0;
 
-	/* translate vma->vm_flags perms into PROT perms */
-	if (vma->vm_flags & VM_READ)
+	/* translate VMA flag perms into PROT perms */
+	if (vma_test(vma, VMA_READ_BIT))
 		prot |= PROT_READ;
-	if (vma->vm_flags & VM_WRITE)
+	if (vma_test(vma, VMA_WRITE_BIT))
 		prot |= PROT_WRITE;
-	if (vma->vm_flags & VM_EXEC)
+	if (vma_test(vma, VMA_EXEC_BIT))
 		prot |= PROT_EXEC;
 
 	return selinux_mmap_file_common(backing_file, prot,
-					vma->vm_flags & VM_SHARED,
+					vma_test(vma, VMA_SHARED_BIT),
 					true);
 }
 
@@ -4229,13 +4229,13 @@ static int selinux_file_mprotect(struct
 	u32 av;
 	const struct file *file = vma->vm_file;
 	bool backing_file;
-	bool shared = vma->vm_flags & VM_SHARED;
+	bool shared = vma_test(vma, VMA_SHARED_BIT);
 
 	/* check if we need to trigger the "backing files are awful" mode */
 	backing_file = file && (file->f_mode & FMODE_BACKING);
 
 	if (default_noexec &&
-	    (prot & PROT_EXEC) && !(vma->vm_flags & VM_EXEC)) {
+	    (prot & PROT_EXEC) && !vma_test(vma, VMA_EXEC_BIT)) {
 		/*
 		 * We don't use the vma_is_initial_heap() helper as it has
 		 * a history of problems and is currently broken on systems
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-read-anon_vma-carefully-in-validate_mm.patch

