Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A32721D3C0
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489995; cv=none; b=bLg0eelinKCgYdAQiHHggrJ0QyuQ2Y7WIeeV2LI/2Uk+Vv6goxuTXVkrrP3hYsezK/hsz9GYD50+Yv7oyVlqt585LrT3FVkq0c4rjIyw3mrcy9i6DvLs4Xa21AxBnaTb6nukl5JC/cVpTyEDWrHIhkOG+GcIvXHdfNjLpXoapJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489995; c=relaxed/simple;
	bh=PQGtHLKJLmm3ce0872e8Ewluk8oYBrzqGa6T8k6Efag=;
	h=Date:To:From:Subject:Message-Id; b=jJY27+vAw1ZEDcepODbNBTJyNImx0kaKlvKkpFA/qaygc3c1eW6hBGSxxKxAZ+Eb6Gn6LCRMF2+/2+hLj5WGDk6WPlPDG3l4eoJOrZQUzfM3ax0LwKLyrtdTpEIabtK1uCHxXsLoFK83xekAfacdxBH2KpyYmzOZQJVzJt3RoNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1iS1ArgH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1iS1ArgH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D73C4CEE7;
	Sun, 21 Sep 2025 21:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489995;
	bh=PQGtHLKJLmm3ce0872e8Ewluk8oYBrzqGa6T8k6Efag=;
	h=Date:To:From:Subject:From;
	b=1iS1ArgHfKgR6GfTAimuEgNlkeZPGlIpuqVi0vm7eyfoXeMmwKzVyTQm1C+th0Bph
	 pRAsBYM/ayiPGiSUsIo+GRKjq6yiSBqJi0sgB+jqofnw8jGbAUgM0h/UeDkCG7MDQN
	 awlT4n+EPIs2/Ocf4pvZoBtGN6SPPGTLKQGdjqWE=
Date: Sun, 21 Sep 2025 14:26:34 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jhubbard@nvidia.com,jgg@ziepe.ca,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-gup_tests-option-to-gup-all-pages-in-a-single-call.patch removed from -mm tree
Message-Id: <20250921212635.60D73C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: gup_tests: option to GUP all pages in a single call
has been removed from the -mm tree.  Its filename was
     selftests-mm-gup_tests-option-to-gup-all-pages-in-a-single-call.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: selftests/mm: gup_tests: option to GUP all pages in a single call
Date: Wed, 10 Sep 2025 11:30:51 +0200

We recently missed detecting an issue during early testing because the
default (!all) tests would not trigger it and even when running "all"
tests it only would happen sometimes because of races.

So let's allow for an easy way to specify "GUP all pages in a single
call", extend the test matrix and extend our default (!all) tests.

By GUP'ing all pages in a single call, with the default size of 128MiB
we'll cover multiple leaf page tables / PMDs on architectures with sane
THP sizes.

Link: https://lkml.kernel.org/r/20250910093051.1693097-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/gup_test.c     |    2 ++
 tools/testing/selftests/mm/run_vmtests.sh |    8 +++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/gup_test.c~selftests-mm-gup_tests-option-to-gup-all-pages-in-a-single-call
+++ a/tools/testing/selftests/mm/gup_test.c
@@ -139,6 +139,8 @@ int main(int argc, char **argv)
 			break;
 		case 'n':
 			nr_pages = atoi(optarg);
+			if (nr_pages < 0)
+				nr_pages = size / psize();
 			break;
 		case 't':
 			thp = 1;
--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-gup_tests-option-to-gup-all-pages-in-a-single-call
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -138,7 +138,7 @@ run_gup_matrix() {
                     # -n: How many pages to fetch together?  512 is special
                     # because it's default thp size (or 2M on x86), 123 to
                     # just test partial gup when hit a huge in whatever form
-                    for num in "-n 1" "-n 512" "-n 123"; do
+                    for num in "-n 1" "-n 512" "-n 123" "-n -1"; do
                         CATEGORY="gup_test" run_test ./gup_test \
                                 $huge $test_cmd $write $share $num
                     done
@@ -314,9 +314,11 @@ if $RUN_ALL; then
     run_gup_matrix
 else
     # get_user_pages_fast() benchmark
-    CATEGORY="gup_test" run_test ./gup_test -u
+    CATEGORY="gup_test" run_test ./gup_test -u -n 1
+    CATEGORY="gup_test" run_test ./gup_test -u -n -1
     # pin_user_pages_fast() benchmark
-    CATEGORY="gup_test" run_test ./gup_test -a
+    CATEGORY="gup_test" run_test ./gup_test -a -n 1
+    CATEGORY="gup_test" run_test ./gup_test -a -n -1
 fi
 # Dump pages 0, 19, and 4096, using pin_user_pages:
 CATEGORY="gup_test" run_test ./gup_test -ct -F 0x1 0 19 0x1000
_

Patches currently in -mm which might be from david@redhat.com are


