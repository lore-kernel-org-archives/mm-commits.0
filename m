Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066425383
	for <mm-commits@vger.kernel.org>; Sat, 22 Feb 2025 00:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740183072; cv=none; b=AKT8ziq3edqaiqGO6EHJWK3vEklOTL/C80FembOzF41GnlUo/rFCceFBbkCQp/FKkOC/KXATgqMAqF7HOGGdFrrxtXZmVU7eJgl1E7z2hb6AxXtdVKoqnNTPRqU/v3YtViGZf4juGZQYTaO7ZqYOaH9HdoVaS4z1vUfFFOH+CQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740183072; c=relaxed/simple;
	bh=6KYGwyM7k/prh0qR0dxEkUDkn5euvJRtxCLWthqU5jE=;
	h=Date:To:From:Subject:Message-Id; b=CqrC1xx8oIRE5OgnYqLLNSxuBivnSZ5JsqGWoBJz4lngVWDUTW9CDt/KgK4j4AratgD+WWGox4hOVhIODUeSoZdri1ap+HJPmGUOdeVaVNs229RRL69K4fE/UIiWpmrLySGLt+GBBFmn4ZFLYdJCy5Q8VZkR7CHj/L0JsszUd+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RsAueNnA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RsAueNnA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B571C4CED6;
	Sat, 22 Feb 2025 00:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740183071;
	bh=6KYGwyM7k/prh0qR0dxEkUDkn5euvJRtxCLWthqU5jE=;
	h=Date:To:From:Subject:From;
	b=RsAueNnAyrez9V8HLIAbBr1YwTTq6xBcCjtY+KcWHEkdV7e98Jiarm5YVHaOmjffN
	 Z9ZgykJYktJTGBk/8nGkS62ZY7P4JLgBos/AvEU8dJ1kX/NHGCgBLh/f52cO3FVbwo
	 Ms4tQLp2HbgI0yrAtwHOQD2NdtKiNwRO87FpE+HY=
Date: Fri, 21 Feb 2025 16:11:10 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,mjguzik@gmail.com,lorenzo.stoakes@oracle.com,dev.jain@arm.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-print-some-details-when-uffd-stress-gets-bad-params.patch added to mm-unstable branch
Message-Id: <20250222001111.5B571C4CED6@smtp.kernel.org>
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
Date: Fri, 21 Feb 2025 18:25:45 +0000

So this can be debugged more easily.

Link: https://lkml.kernel.org/r/20250221-mm-selftests-v2-6-28c4d66383c5@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-stress.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-print-some-details-when-uffd-stress-gets-bad-params
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -457,7 +457,8 @@ int main(int argc, char **argv)
 
 	nr_pages_per_cpu = bytes / page_size / nr_threads;
 	if (!nr_pages_per_cpu) {
-		_err("invalid MiB");
+		_err("pages_per_cpu = 0, cannot test (%lu / %lu / %lu)",
+			nr_pages_per_cpu, bytes, page_size, nr_threads);
 		usage();
 	}
 
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-mmu_gather-update-comment-on-rcu-freeing.patch
selftests-mm-report-errno-when-things-fail-in-gup_longterm.patch
selftests-mm-fix-assumption-that-sudo-is-present.patch
selftests-mm-skip-uffd-stress-if-userfaultfd-not-available.patch
selftests-mm-skip-uffd-wp-mremap-if-userfaultfd-not-available.patch
selftests-mm-uffd-rename-nr_cpus-nr_threads.patch
selftests-mm-print-some-details-when-uffd-stress-gets-bad-params.patch
selftests-mm-dont-fail-uffd-stress-if-too-many-cpus.patch
selftests-mm-skip-map_populate-on-weird-filesystems.patch
selftests-mm-skip-gup_longerm-tests-on-weird-filesystems.patch

