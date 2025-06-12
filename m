Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39AA5258
	for <mm-commits@vger.kernel.org>; Thu, 12 Jun 2025 00:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749689332; cv=none; b=hW7Pz+ommoDyptBl19larzbs4SeFptNQuuOx07tECkj2kJfnXK1wJ/Yq6bkbmZPl8m4u1dWm0bxhITcFdNPdW6/gL7Y5LXZluXCi2lrONLUBMN5fPcGQnFkOSFhXtGYLYxGrWA/NdyhAl2laWMa52j9GFSfsgasQypMOKqfWBVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749689332; c=relaxed/simple;
	bh=RQcpzmPkeFaEqDc1CM/drqIi4rJz3nZFMFjAk8N0MXc=;
	h=Date:To:From:Subject:Message-Id; b=P7iJ0+sey0NikdwA6F51EHGED/3ojM5xFG+lOBAi0oeyVlpdTNh37G1bXMp0Caz+eqcoZ+CmDjGYHdgyzoBP+kWqu35OLi+I0QWr9LdwAgQdUB0QYqjDAakK6GKKnr3fmwbNfJG6XZ9EoQaS1Vg6EGWrgKUJBeARP70zSAYZnUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R0DhU3Xj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R0DhU3Xj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41753C4CEEF;
	Thu, 12 Jun 2025 00:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749689331;
	bh=RQcpzmPkeFaEqDc1CM/drqIi4rJz3nZFMFjAk8N0MXc=;
	h=Date:To:From:Subject:From;
	b=R0DhU3Xj7MK0PYcDpUqwcNMuzabiS78U+oHjRCZhrKzPz86Ora3q+MHp+sn0+7ive
	 Kgi4G3ctorHbBlksPP2FGtSnhsq4pMZg698plK7OMR/4Pvz5SnplYTFr3udEJT0sHL
	 ss80B+/SRdA6DiNTowpp5/gZdKrNuFqH0xOPTtZc=
Date: Wed, 11 Jun 2025 17:48:50 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,rostedt@goodmis.org,peterz@infradead.org,oleg@redhat.com,namhyung@kernel.org,mingo@redhat.com,mhiramat@kernel.org,mark.rutland@arm.com,kan.liang@linux.intel.com,jolsa@kernel.org,irogers@google.com,david@redhat.com,apopple@nvidia.com,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,acme@kernel.org,shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-folio_expected_ref_count-helper-for-reference-counting.patch added to mm-new branch
Message-Id: <20250612004851.41753C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use folio_expected_ref_count() helper for reference counting
has been added to the -mm mm-new branch.  Its filename is
     mm-use-folio_expected_ref_count-helper-for-reference-counting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-folio_expected_ref_count-helper-for-reference-counting.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Shivank Garg <shivankg@amd.com>
Subject: mm: use folio_expected_ref_count() helper for reference counting
Date: Wed, 11 Jun 2025 05:27:07 +0000

Replace open-coded folio reference count calculations with the
folio_expected_ref_count().

No functional changes intended.

Link: https://lkml.kernel.org/r/20250611052706.515408-2-shivankg@amd.com
Signed-off-by: Shivank Garg <shivankg@amd.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Namhyung kim <namhyung@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/events/uprobes.c |    3 +--
 mm/memfd.c              |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/kernel/events/uprobes.c~mm-use-folio_expected_ref_count-helper-for-reference-counting
+++ a/kernel/events/uprobes.c
@@ -436,8 +436,7 @@ static int __uprobe_write_opcode(struct
 	 * there are no unexpected folio references ...
 	 */
 	if (is_register || userfaultfd_missing(vma) ||
-	    (folio_ref_count(folio) != folio_mapcount(folio) + 1 +
-	     folio_test_swapcache(folio) * folio_nr_pages(folio)))
+	    (folio_ref_count(folio) != folio_expected_ref_count(folio) + 1))
 		goto remap;
 
 	/*
--- a/mm/memfd.c~mm-use-folio_expected_ref_count-helper-for-reference-counting
+++ a/mm/memfd.c
@@ -32,8 +32,7 @@
 
 static bool memfd_folio_has_extra_refs(struct folio *folio)
 {
-	return folio_ref_count(folio) - folio_mapcount(folio) !=
-	       folio_nr_pages(folio);
+	return folio_ref_count(folio) != folio_expected_ref_count(folio);
 }
 
 static void memfd_tag_pins(struct xa_state *xas)
_

Patches currently in -mm which might be from shivankg@amd.com are

selftests-mm-increase-timeout-from-180-to-900-seconds.patch
mm-use-folio_expected_ref_count-helper-for-reference-counting.patch

