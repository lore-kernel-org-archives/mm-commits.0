Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937A7309F0D
	for <mm-commits@vger.kernel.org>; Sun, 21 Dec 2025 18:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766343471; cv=none; b=gqhblot4xvc6BrmYb6bJCcfHN8vvC0XPoJCN/LKOLpurYtKaCXyITEs+um0pEXAf/dy8lIvMOcXwbd0Frf0z3Q0V8C4ka7hHdFBdrajQSahc1cKGmKYaA19bCIIYhbhx1ysDnYIourogy/uInMMIoYnMqyO1S34lVCNs89TJMiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766343471; c=relaxed/simple;
	bh=7S1/Y+EZBSlwGBI+fiRS2/0j6TdM4uJxmksKfPh+7uE=;
	h=Date:To:From:Subject:Message-Id; b=IjJl+9fFGZTgwyJxIGKrcvaA6yJtDZ0jYud9WQZ9VaP0+5JEhQF7qqETKSc+KwaOMm011XLtFfrxr4J6Pkrskd/4tFEpT/wQ2pbnCQCzDVBiQipe5Yb1jaCEKItPY7M+FZkTkCKE8jjNWqT7CY00X2xzC5v8m+xLUhJz74yIbok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HF+YrTFW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HF+YrTFW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 186C3C4CEFB;
	Sun, 21 Dec 2025 18:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766343471;
	bh=7S1/Y+EZBSlwGBI+fiRS2/0j6TdM4uJxmksKfPh+7uE=;
	h=Date:To:From:Subject:From;
	b=HF+YrTFWdMFzu4M4UEkGUDWIBBrPSwoCd0IJopKbfM5fzuf0rC7NAMn+7NHtGXIE+
	 3tXttrfn3UztYfyq3ZRf6+29w1gKxKL6VzNGJeQK17BKgKxk9sSVukD/PNM/TPNi9/
	 9fpVpM1YCYafGl+tmbrmzOx1TZknawADIAh4ixcY=
Date: Sun, 21 Dec 2025 10:57:50 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,luizcap@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,chuhu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-va_high_addr_switch-return-fail-when-either-test-failed.patch added to mm-new branch
Message-Id: <20251221185751.186C3C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: va_high_addr_switch return fail when either test failed
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-va_high_addr_switch-return-fail-when-either-test-failed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-va_high_addr_switch-return-fail-when-either-test-failed.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Chunyu Hu <chuhu@redhat.com>
Subject: selftests/mm: va_high_addr_switch return fail when either test failed
Date: Sun, 21 Dec 2025 12:00:24 +0800

When the first test failed, and the hugetlb test passed, the result would
be pass, but we expect a fail.  Fix this issue by returning fail if either
is not KSFT_PASS.

Link: https://lkml.kernel.org/r/20251221040025.3159990-4-chuhu@redhat.com
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
Cc: Luiz Capitulino <luizcap@redhat.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/va_high_addr_switch.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/va_high_addr_switch.c~selftests-mm-va_high_addr_switch-return-fail-when-either-test-failed
+++ a/tools/testing/selftests/mm/va_high_addr_switch.c
@@ -322,7 +322,7 @@ static int supported_arch(void)
 
 int main(int argc, char **argv)
 {
-	int ret;
+	int ret, hugetlb_ret = KSFT_PASS;
 
 	if (!supported_arch())
 		return KSFT_SKIP;
@@ -331,6 +331,10 @@ int main(int argc, char **argv)
 
 	ret = run_test(testcases, sz_testcases);
 	if (argc == 2 && !strcmp(argv[1], "--run-hugetlb"))
-		ret = run_test(hugetlb_testcases, sz_hugetlb_testcases);
-	return ret;
+		hugetlb_ret = run_test(hugetlb_testcases, sz_hugetlb_testcases);
+
+	if (ret == KSFT_PASS && hugetlb_ret == KSFT_PASS)
+		return KSFT_PASS;
+	else
+		return KSFT_FAIL;
 }
_

Patches currently in -mm which might be from chuhu@redhat.com are

selftests-mm-fix-va_high_addr_switchsh-return-value.patch
selftests-mm-allocate-6-hugepages-in-va_high_addr_switchsh.patch
selftests-mm-remove-arm64-nr_hugepages-setup-for-va_high_addr_switch-test.patch
selftests-mm-va_high_addr_switch-return-fail-when-either-test-failed.patch
selftests-mm-fix-comment-for-check_test_requirements.patch

