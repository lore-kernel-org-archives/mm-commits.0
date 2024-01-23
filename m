Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5644B648
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 01:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705973138; cv=none; b=dOzY824RrZHtx4WGwc/vcnBPo+9DGzKQXl+WCo+mZE5oAqOdF/Es73VifSRE8eCK54J/ht3RsYZBww/kpX/IeB1Eu9nceJx+8oq6vsZvhQJGorbQLDsEzU4KoVKnCydAligyEXLbFozjIUyjwI6kNjVrhUOwk4MuT2RJhHQWERE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705973138; c=relaxed/simple;
	bh=ULkJF95/shH5/h4BlpWgQHDIPExu4SbiU+puCFjCkv8=;
	h=Date:To:From:Subject:Message-Id; b=lptXtlraLPkovzdNNM5dtfV66JzdJHtWymu6F5PXqlNdgRW22Y4jSRHAudTiOxew3WAXEuqMOTZ1jfNrGIfQOPyhqSqqjcrxEMrElt6iDgtX0v752BqzGjMcfSOSKZgFHwFWvR/EilSAbKO3ykIUL3mo/Frm5CrBdCKTD+wm5+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DaZYP4gu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DaZYP4gu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A982AC433F1;
	Tue, 23 Jan 2024 01:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705973138;
	bh=ULkJF95/shH5/h4BlpWgQHDIPExu4SbiU+puCFjCkv8=;
	h=Date:To:From:Subject:From;
	b=DaZYP4gua/+JEL9ZaJTtKkohS+PzMCxyora6CG15/PU9dVmq/IK1SRpeVnQ95+XJ4
	 XsaTSIKk0EYzrvaBjf8bhVc0kJMCuC2kE/KXpnodYr7J+h/4jtPf8HKwB6mpaGjto2
	 jQREpmrZFEXzw6h40MI28FV62CMILGFH/UhnBMXs=
Date: Mon, 22 Jan 2024 17:25:34 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-optimize-fork-with-pte-mapped-thp-fix.patch added to mm-unstable branch
Message-Id: <20240123012537.A982AC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-memory-optimize-fork-with-pte-mapped-thp-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-optimize-fork-with-pte-mapped-thp-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-optimize-fork-with-pte-mapped-thp-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memory-optimize-fork-with-pte-mapped-thp-fix
Date: Mon Jan 22 05:18:40 PM PST 2024

update it for "mm: convert mm_counter_file() to take a folio"

Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-memory-optimize-fork-with-pte-mapped-thp-fix
+++ a/mm/memory.c
@@ -1031,7 +1031,7 @@ copy_present_ptes(struct vm_area_struct
 		} else {
 			folio_ref_add(folio, nr);
 			folio_dup_file_rmap_ptes(folio, page, nr);
-			rss[mm_counter_file(page)] += nr;
+			rss[mm_counter_file(folio)] += nr;
 		}
 		__copy_present_ptes(dst_vma, src_vma, dst_pte, src_pte, pte,
 				    addr, nr);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory-optimize-fork-with-pte-mapped-thp-fix.patch
kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer-fix.patch

