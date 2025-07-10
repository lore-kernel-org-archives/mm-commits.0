Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9D8285052
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126285; cv=none; b=bteMLj7fot1gv/cLllvX4KrwBX7Gx6m6TV6l7ggBWW//JbRA6fPDJHvAE3hD6AmoLK7roQjhXmYCC7ViGVwiNvdiUKzpeS/hJnSwIPgGeuOpdYyvdmL0qnJ6xAiyqUi0TvcE7j9neh1r958VvzG74aENrsLk+G73LECLzt6JBgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126285; c=relaxed/simple;
	bh=fq5qIVfitdkUlb/vKGggC8ZremHwuSvoRTWF+LJkLls=;
	h=Date:To:From:Subject:Message-Id; b=n5oRYDKaXdE4u+JbPcmgm6TV/DoXRSfVNw6FcmM+LH7LcaLjJc/aYRMx9RLmNubFOI/GBwrjxY1m1QElqoUAN4bwZVIJPQik0tlyT9tWcIR1LvSOn3JxyU0/mAQmdt+a6/pwIudxwBPoOMIYuC2k5/FKlHjJBbS1Lz+XrJ8e56o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PN5wI8tP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PN5wI8tP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE2BC4CEE3;
	Thu, 10 Jul 2025 05:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126285;
	bh=fq5qIVfitdkUlb/vKGggC8ZremHwuSvoRTWF+LJkLls=;
	h=Date:To:From:Subject:From;
	b=PN5wI8tPu4uq/+K9kexFP4SaAaKxgT3hhV2WeqhDubMimw8YHZ5h24KCk/6b80taZ
	 SIpU+kDU4UixYtNRAfTEp3V7ecx4k6W6xKS5fiMWsgoIQsiE+6lgXIeebTjssF6ch9
	 HxsvhFxTv/ZC77TX1p4vcpwftDw4ScAsyVE4ZsOc=
Date: Wed, 09 Jul 2025 22:44:45 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,rostedt@goodmis.org,peterz@infradead.org,osalvador@suse.de,oleg@redhat.com,namhyung@kernel.org,mingo@redhat.com,mhiramat@kernel.org,mark.rutland@arm.com,kan.liang@linux.intel.com,jolsa@kernel.org,irogers@google.com,david@redhat.com,apopple@nvidia.com,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,acme@kernel.org,shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-folio_expected_ref_count-helper-for-reference-counting.patch removed from -mm tree
Message-Id: <20250710054445.AEE2BC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use folio_expected_ref_count() helper for reference counting
has been removed from the -mm tree.  Its filename was
     mm-use-folio_expected_ref_count-helper-for-reference-counting.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Oscar Salvador <osalvador@suse.de>
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


