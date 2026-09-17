Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D514B8288
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 23:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789689449; cv=none; b=smR4dbzvv/tFhAYLer9JfyuhChx2MYJYkm6VS+8GAqZSp79AGg20C5t4ynxKTtZ8rp3Lel8yaOrUJEx6sQiQS6fyvzCLKZ11IaVRA7sLl5pM3hKLRcyHYNUyVo8rWcIHv/UwwporMCk9aBDc7wpVzkfCOXNZ5Psj0ct5lrYckts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789689449; c=relaxed/simple;
	bh=pPbgb6zC5ydjXiHhR+MEPix5wd4mDmEIGkQFUoYUxgI=;
	h=Date:To:From:Subject:Message-Id; b=kLz7q7S0j/SupenVrm+u4OY3zO7fK5OCnSBEwW6dJ7B2HJj+VxcVKD+WOIi0ZwcIJziGlTaJ5/h6FuE8n0lfW7oqsfH0F2RwOGTnvwHpV+Poj86QOhHj6CF2My8T5rfbiOTSoeTKHR/kJWA0LAHgiKEm4+qbhfEbb0Otm3osfXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iA1fhxqw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iA1fhxqw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 041911F000FF;
	Thu, 17 Sep 2026 23:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789689448;
	bh=lWM17GhXkfkedET8RI6bgSm+u/uj8pwnnI0EXeJdbUY=;
	h=Date:To:From:Subject;
	b=iA1fhxqw6KEvYjNKzRtsqTFmktLWSOic2b8JjJsg4WhaEZShRcJtDokpciWKQP55M
	 ubSLPC4r34TwL5VSuAFGZ0iavmEXPrHI3EP29r88cuWb6b6F9dIWR3r5VAgIwDbr3i
	 wGSTvANPSq8ayOqJBcyqibpVj3DFLjyjHv8vpwf8=
Date: Thu, 17 Sep 2026 16:57:27 -0700
To: mm-commits@vger.kernel.org,wyihan@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-update-shmem-handler-to-the-mf_delayed-definition.patch added to mm-new branch
Message-Id: <20260917235728.041911F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: Update shmem handler to the MF_DELAYED definition
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-update-shmem-handler-to-the-mf_delayed-definition.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-update-shmem-handler-to-the-mf_delayed-definition.patch

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
From: Lisa Wang <wyihan@google.com>
Subject: mm: shmem: Update shmem handler to the MF_DELAYED definition
Date: Thu, 17 Sep 2026 20:43:49 +0000

To align with the definition of MF_DELAYED, update
shmem_error_remove_folio() to return MF_DELAYED.

shmem handles memory failures but defers the actual file truncation.  The
function's return value should therefore be MF_DELAYED to accurately
reflect the state.

Currently, this logical error does not cause a bug, because:

- For shmem folios, folio->private is not set.
- As a result, filemap_release_folio() is a no-op and returns true.
- This, in turn, causes truncate_error_folio() to incorrectly return
  MF_RECOVERED.
- The caller then treats MF_RECOVERED as a success condition, masking the
  issue.

The previous patch relays MF_DELAYED to the caller of
truncate_error_folio() before any logging, so returning MF_DELAYED from
shmem_error_remove_folio() will retain the original behavior of not adding
any logs.

The return value of truncate_error_folio() is consumed in action_result(),
which treats MF_DELAYED the same way as MF_RECOVERED, hence
action_result() also returns the same thing after this change.

Link: https://lore.kernel.org/20260917-memory-failure-mf-delayed-fix-v6-3-4b00856b5364@google.com
Signed-off-by: Lisa Wang <wyihan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michael Roth <michael.roth@amd.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-update-shmem-handler-to-the-mf_delayed-definition
+++ a/mm/shmem.c
@@ -5368,7 +5368,7 @@ static void __init shmem_destroy_inodeca
 static int shmem_error_remove_folio(struct address_space *mapping,
 				   struct folio *folio)
 {
-	return 0;
+	return MF_DELAYED;
 }
 
 static const struct address_space_operations shmem_aops = {
_

Patches currently in -mm which might be from wyihan@google.com are

mm-memory_failure-clarify-the-mf_delayed-definition.patch
mm-memory_failure-allow-truncate_error_folio-to-return-mf_delayed.patch
mm-shmem-update-shmem-handler-to-the-mf_delayed-definition.patch
mm-memory_failure-generalize-extra_pins-handling-to-all-mf_delayed-cases.patch
mm-selftests-add-shmem-into-memory-failure-test.patch

