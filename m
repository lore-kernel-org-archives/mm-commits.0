Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794246357;
	b=WQbNrFBGkIfph5BosIlzOENOq/CBW8QricaMQOU+2eOCXVLe5V3FUhi4Oshk6/dOPzR8
	 49FGiPqBxzJNPw0Xv218LIC4VFb/sFz6ITdlmjIrBwNLRyuKH1XjfxPispk4eiuytxLp5
	 ikGH2qQoWvUOanbzOJL+i2VUtoMCKSgNGrWjN5sVja/t72ZbBBU6oTA3Th0G/J0JNUbBY
	 BG4xxLkCfLGhTZylA4THWcLwlcOYj4DAgxENBuIFEeryuY0Ywbx+3r8kzheiKgldGNKxY
	 69V0ThAm7ShK4nKhcWPzqiVJ5xsBXnx5s5AIzAYUqOQd1e4REbuGQY7cp/3mwPKgsdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794246357;
	h=Received:DKIM-Signature:Date:To:Cc:From:Subject:Message-Id;
	bh=p60lsRdxGnfPzx7eEjGEWUH3Au1CpPJ9/jbH8zguKG4=;
	b=aRU1xkt/442LzEegqM0YF7IGvQfonVW3oqAYgdK81DZHkp6QVWou1pqkmawg903S/4JQ
	 4OdwHyYRHtNviTkO7051ZIydkMxlrq2UTFLHqBdqiXOMTQ01onyYiWJTgSTe/heUHKmLn
	 0Di4uACt1S6wd6hhjTb1VIFjiN0V2GM+HfKwhUt7514BrwlsbpAFGrIUafo8mK43yGzY4
	 p62zHvzj4QmFuP8GXayCWeZy3u9ntF1qhZwEre3z0TRShIgfW/nUUUI/PzcYOyCd4JnYw
	 fJxP6wigMs9bLXx3oYI8npFQSgMwpWMYdC/xmYvVegCC+gv+4Zbjf5nJjuHpRuVRjNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UMkdGhbU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FADB606A321
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 17:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UMkdGhbU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B46B01F008A4;
	Mon,  9 Nov 2026 17:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794246356;
	bh=p60lsRdxGnfPzx7eEjGEWUH3Au1CpPJ9/jbH8zguKG4=;
	h=Date:To:Cc:From:Subject;
	b=UMkdGhbUw1BBqpNCMfQfTJUU7z7jVSB3bbYC4m58HAvxkiDO6td2hQsFOQX0hWz/U
	 ZOGN6glluhKtIU31VTUGKnhpc0sGzwiaqPQridSpEytcZ0tFCHbA5jqQL4B550cFtP
	 PjeKiFFkIR6xes8fvpVDaWCE8s55P+bOh2v0EWeU=
Date: Mon, 09 Nov 2026 09:45:56 -0800
To: mm-commits@vger.kernel.org, ljs@kernel.org, akpm@linux-foundation.org
Cc: David Hildenbrand <david@kernel.org>
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-migrate-convert-vma-flag-tests-to-use-vma_flags_t.patch removed from -mm tree
Message-Id: <20261109174556.B46B01F008A4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/migrate: convert VMA flag tests to use vma_flags_t
has been removed from the -mm tree.  Its filename was
     mm-migrate-convert-vma-flag-tests-to-use-vma_flags_t.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/migrate: convert VMA flag tests to use vma_flags_t
Date: Thu, 05 Nov 2026 21:30:55 +0000

Replace use of the legacy vm_flags_t flags with vma_flags_t values in the
migration logic.

We retain the READ_ONCE() of vma->vm_flags in remove_migration_pte(), as
there is no vma_flags_t equivalent, and arch_make_huge_pte() continues to
take legacy flags for the time being.

No functional change intended.

Link: https://lore.kernel.org/20261105-late-2026-vma-flags-v1-4-0d3cd15ab75f@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
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
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
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

 mm/migrate.c        |    5 +++--
 mm/migrate_device.c |    8 ++++----
 2 files changed, 7 insertions(+), 6 deletions(-)

--- a/mm/migrate.c~mm-migrate-convert-vma-flag-tests-to-use-vma_flags_t
+++ a/mm/migrate.c
@@ -310,7 +310,7 @@ static bool try_to_map_unused_to_zeropag
 	VM_BUG_ON_PAGE(pte_present(old_pte), page);
 	VM_WARN_ON_ONCE_FOLIO(folio_is_device_private(folio), folio);
 
-	if (folio_test_mlocked(folio) || (pvmw->vma->vm_flags & VM_LOCKED) ||
+	if (folio_test_mlocked(folio) || vma_test(pvmw->vma, VMA_LOCKED_BIT) ||
 	    mm_forbids_zeropage(pvmw->vma->vm_mm))
 		return false;
 
@@ -2711,7 +2711,8 @@ int migrate_misplaced_folio_prepare(stru
 		 * See folio_maybe_mapped_shared() on possible imprecision
 		 * when we cannot easily detect if a folio is shared.
 		 */
-		if ((vma->vm_flags & VM_EXEC) && folio_maybe_mapped_shared(folio))
+		if (vma_test(vma, VMA_EXEC_BIT) &&
+		    folio_maybe_mapped_shared(folio))
 			return -EACCES;
 
 		/*
--- a/mm/migrate_device.c~mm-migrate-convert-vma-flag-tests-to-use-vma_flags_t
+++ a/mm/migrate_device.c
@@ -842,7 +842,7 @@ static int migrate_vma_insert_huge_pmd_p
 	if (folio_is_device_private(folio)) {
 		swp_entry_t swp_entry;
 
-		if (vma->vm_flags & VM_WRITE)
+		if (vma_test(vma, VMA_WRITE_BIT))
 			swp_entry = make_writable_device_private_entry(
 						page_to_pfn(page));
 		else
@@ -855,7 +855,7 @@ static int migrate_vma_insert_huge_pmd_p
 			goto free_abort;
 		}
 		entry = folio_mk_pmd(folio, vma->vm_page_prot);
-		if (vma->vm_flags & VM_WRITE)
+		if (vma_test(vma, VMA_WRITE_BIT))
 			entry = pmd_mkwrite(pmd_mkdirty(entry), vma);
 	}
 
@@ -1043,7 +1043,7 @@ static void migrate_vma_insert_page(stru
 	if (folio_is_device_private(folio)) {
 		swp_entry_t swp_entry;
 
-		if (vma->vm_flags & VM_WRITE)
+		if (vma_test(vma, VMA_WRITE_BIT))
 			swp_entry = make_writable_device_private_entry(
 						page_to_pfn(page));
 		else
@@ -1057,7 +1057,7 @@ static void migrate_vma_insert_page(stru
 			goto abort;
 		}
 		entry = mk_pte(page, vma->vm_page_prot);
-		if (vma->vm_flags & VM_WRITE)
+		if (vma_test(vma, VMA_WRITE_BIT))
 			entry = pte_mkwrite(pte_mkdirty(entry), vma);
 	}
 
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-read-anon_vma-carefully-in-validate_mm.patch
mm-convert-thp-vma-flag-tests-to-use-vma_flags_t.patch
mm-ksm-convert-vma-flag-tests-to-use-vma_flags_t.patch
mm-madvise-convert-madvise_vma_behavior-to-use-vma_flags_t.patch
mm-convert-miscellaneous-vma-flag-tests-to-use-vma_flags_t.patch
fs-proc-task_mmu-convert-vma-flag-tests-to-use-vma_flags_t.patch
fs-coredump-convert-vma_dump_size-to-use-vma_flags_t.patch
uprobes-convert-vma-flag-tests-to-use-vma_flags_t.patch
perf-convert-vma-flag-tests-to-use-vma_flags_t.patch
security-convert-vma-flag-tests-to-use-vma_flags_t.patch

