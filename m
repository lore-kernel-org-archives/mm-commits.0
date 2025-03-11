Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A432620E5
	for <mm-commits@vger.kernel.org>; Tue, 11 Mar 2025 17:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741714613; cv=none; b=PiXE4BsbhPCvjgv/XMWHjsBT071BQbyeWTtHf6OnYDjZDo5lBMQDxe5pn+lzVJ/VyJZ8BUc6l4eBod4Mz4arXeCfnDm9wgweypERc5jkRv5SGOhKv/DMZCWFdvLPvk+ZpCetK4LxrCsPTu6q6DETc+dtaZ+4XMaSC+ZLwnDEe/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741714613; c=relaxed/simple;
	bh=B5qiHdi0zKipLezeqR9P/cbqGIr4jhXTMKsq6oZ1irI=;
	h=Date:To:From:Subject:Message-Id; b=XhRi0q9ZtjX8v2Ua2Hnh0bR+cyaGbHpt35nSeHekUgFfw04Leca8UQTnUW91G9qFMP8UeqXOoX/3H2u/3Y2LCVSPdLsbGVCNgngLf7v2KQ5/USqfEpvvoYtWEcQ1gfWDBGEPEDPw7YAYMnjpTpCQ/w50LAYN1Uljz/QM0/9QX6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oF+xFEZk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oF+xFEZk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90ED2C4CEEA;
	Tue, 11 Mar 2025 17:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741714612;
	bh=B5qiHdi0zKipLezeqR9P/cbqGIr4jhXTMKsq6oZ1irI=;
	h=Date:To:From:Subject:From;
	b=oF+xFEZkWL5wbRgx9czVb1hfEA2u6XCQU/GDZJA60Wqkgm+ro4Y980mt3zc4tvwvf
	 E6G/bugsxV1+BVyJOXnJROZ1D4GHo5NApQQ4EgZE5OveC0bVcgQdc6uqrtvYaMKC/9
	 vcZaUNqwLQ7yMUd4kqOgcDbI9KopWDtfYRRaPJts=
Date: Tue, 11 Mar 2025 10:36:52 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,mjguzik@gmail.com,lorenzo.stoakes@oracle.com,dev.jain@arm.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-print-some-details-when-uffd-stress-gets-bad-params.patch added to mm-unstable branch
Message-Id: <20250311173652.90ED2C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: print some details when uffd-stress gets bad params
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-print-some-details-when-uffd-stress-gets-bad-params.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-print-some-details-when-uffd-stress-gets-bad-params.patch

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
From: Brendan Jackman <jackmanb@google.com>
Subject: selftests/mm: print some details when uffd-stress gets bad params
Date: Tue, 11 Mar 2025 13:18:16 +0000

So this can be debugged more easily.

Link: https://lkml.kernel.org/r/20250311-mm-selftests-v4-5-dec210a658f5@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-stress.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-print-some-details-when-uffd-stress-gets-bad-params
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -457,7 +457,8 @@ int main(int argc, char **argv)
 
 	nr_pages_per_cpu = bytes / page_size / nr_parallel;
 	if (!nr_pages_per_cpu) {
-		_err("invalid MiB");
+		_err("pages_per_cpu = 0, cannot test (%lu / %lu / %lu)",
+			bytes, page_size, nr_parallel);
 		usage();
 	}
 
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-mmu_gather-update-comment-on-rcu-freeing.patch
selftests-mm-report-errno-when-things-fail-in-gup_longterm.patch
selftests-mm-skip-uffd-stress-if-userfaultfd-not-available.patch
selftests-mm-skip-uffd-wp-mremap-if-userfaultfd-not-available.patch
selftests-mm-uffd-rename-nr_cpus-nr_parallel.patch
selftests-mm-print-some-details-when-uffd-stress-gets-bad-params.patch
selftests-mm-dont-fail-uffd-stress-if-too-many-cpus.patch
selftests-mm-skip-map_populate-on-weird-filesystems.patch
selftests-mm-skip-gup_longterm-tests-on-weird-filesystems.patch
selftests-mm-drop-unnecessary-sudo-usage.patch
selftests-mm-ensure-uffd-wp-mremap-gets-pages-of-each-size.patch
selftests-mm-skip-mlock-tests-if-nobody-user-cant-read-it.patch
selftests-mm-mlock-print-error-on-failure.patch
mm-page_alloc-warn-on-nr_reserved_highatomic-underflow.patch
mm-page_alloc-clarify-terminology-in-migratetype-fallback-code.patch
mm-page_alloc-clarify-should_claim_block-commentary.patch
scripts-gdb-add-lx_per_cpu_ptr.patch

