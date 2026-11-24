Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795542981;
	b=FpjV9ELG7bEHVFueJrT31FLwuaiEP5pF+UMwVWDDcfh2MEs5rwRGh5/gLeQJ6jb17PLK
	 hQqmddcZvElGxSf64/0HUH+j7CH7JTMBYN3fELahp3+FRun5QdpDMTd5jlsmoX2UQdvqC
	 VqDvgJ9cFq/zfo8gI6kiqLcIlmY6MdANADZwb/RGnDBtrhCLZ3Jq7Aq+Eg4LiStoj6rz0
	 C131XVNMIxhRh5HpYZn5IUF1iWc7MFz0ioXdndj6xgu2RFApf4d0th20YctCFI7zBOKYi
	 ACuaz4/0zmjoY6PHuXIgCMtps6PuzIsnKnH69CSdpAfCVw6defADZ/a/1ZpAJ2Y+WUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795542981;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=yt7fJSF1RZ0mzuaa3aovGFJ6m2+F0MUsVTxZXqXhkHk=;
	b=rYD2mcAKLSSX35bQzVirvgmiPMJRg6q32V3VyiPtFDL5Pl6Fa9Rwa6UgG3mVAhRok0Dq
	 HWPOxvG+Ex1S4BdlxPTU8gqKpUxB6HQdb50UG1te1hiVBUHEwHFvq0Nk6qoSDXU0iJyQV
	 u7ucx+go9dNunCoxDmvXYPtxyaKIz52qJC7DUn3EqtjcWe0X2Ud0Bz94dxXJweAozbjvp
	 F5O4T/sznUlP6KRZbvKxBWXrPMwytc6Na+Lm8WuG0XZzLvdlY0bhSfZnKq/bP3X17b3hr
	 5ZbIX/+Frc4Zq2AUoeElWrRjoeXx1ThMmVUU6tWAJKTzNB7gQsX2fQaPKX7f4lk85Iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=uof4+qi5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279EA606A323
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 17:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=uof4+qi5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19751F000C0;
	Tue, 24 Nov 2026 17:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795542980;
	bh=yt7fJSF1RZ0mzuaa3aovGFJ6m2+F0MUsVTxZXqXhkHk=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=uof4+qi5PE9ygKh3Ua+eIMvwJpEJHF1EMXM39tP0++y9Hv9A44tqlC8ffs1mu+wuX
	 w7iPCe40f3oC7VgYNx84+OB7WZjo8JO33lTqN/Agq4Aokhup7VtwRVL0eYEUmGpg6w
	 vWHSca4YkjtSTkBl7BXAb7ORhwW5SBg+547/bUxQ=
Date: Tue, 24 Nov 2026 09:56:20 -0800
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124-late-2026-vma-flags-v2-8-bf3fade93064@kernel.org>
References: <20261124-late-2026-vma-flags-v2-8-bf3fade93064@kernel.org>
Subject: + selinux-convert-vma-flag-tests-to-use-vma_flags_t.patch added to mm-new branch
Message-Id: <20261124175620.B19751F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selinux: convert VMA flag tests to use vma_flags_t
has been added to the -mm mm-new branch.  Its filename is
     selinux-convert-vma-flag-tests-to-use-vma_flags_t.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selinux-convert-vma-flag-tests-to-use-vma_flags_t.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: selinux: convert VMA flag tests to use vma_flags_t
Date: Tue, 24 Nov 2026 17:08:00 +0000

Replace use of the legacy vm_flags_t flags with vma_flags_t values in the
SELinux mmap backing file and mprotect LSM hooks.

No functional change intended.

Link: https://patch.msgid.link/20261124-late-2026-vma-flags-v2-8-bf3fade93064@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Paul Moore <paul@paul-moore.com>
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
Cc: Fan Wu <wufan@kernel.org>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Ondrej Mosnáček <omosnacek@gmail.com>

 security/selinux/hooks.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/security/selinux/hooks.c~selinux-convert-vma-flag-tests-to-use-vma_flags_t
+++ a/security/selinux/hooks.c
@@ -4205,16 +4205,16 @@ static int selinux_mmap_backing_file(str
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
 
@@ -4228,13 +4228,13 @@ static int selinux_file_mprotect(struct
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

mm-msync-return-enomem-if-page-aligned-length-overflows.patch
mm-vma-drop-mm-asynchronously-in-vma_start_read.patch
mm-vma-predicate-vma_assert_stabilised-on-config_debug_vm.patch
mm-only-assert-mmap-locks-if-config_debug_vm-or-lockdep-is-set.patch
mm-only-assert-vma-locks-if-config_debug_vm-is-set.patch
mm-convert-warn_on_onces-to-vm_warn_on_once-in-vma-lock-code.patch
mm-madvise-zap-markers-from-guard-regions.patch
mm-mmap-free-gathered-pages-before-mmf_oom_skip.patch
percpu-fix-contig-hints-that-are-too-low.patch
percpu-search-the-whole-reserved-chunk.patch
mm-filemap-convert-fault-and-readahead-logic-to-use-vma_flags_t.patch
mm-madvise-convert-madvise_vma_behavior-to-use-vma_flags_t.patch
mm-convert-miscellaneous-vma-flag-tests-to-use-vma_flags_t.patch
fs-proc-task_mmu-convert-vma-flag-tests-to-use-vma_flags_t.patch
fs-coredump-convert-vma_dump_size-to-use-vma_flags_t.patch
uprobes-convert-vma-flag-tests-to-use-vma_flags_t.patch
perf-convert-vma-flag-tests-to-use-vma_flags_t.patch
selinux-convert-vma-flag-tests-to-use-vma_flags_t.patch
apparmor-convert-vma-flag-tests-to-use-vma_flags_t.patch
ima-convert-vma-flag-tests-to-use-vma_flags_t.patch
ipe-convert-vma-flag-tests-to-use-vma_flags_t.patch

