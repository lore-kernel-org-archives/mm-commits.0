Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438E83612F4
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966115; cv=none; b=dd2cZJ/P7uF/wm2CHK/osCpwzaii+jb7iW/6Sr6oU/sztgDfnJrpKpoKwoJ1YFfzGpxSxe8oWSGddxO/MIqQ8OXT3FQOnCOv5rJd/E64bUV9FKofpmB6WXu2YTdevj/bS72lUzO7quR03bwTkU4l6mOk0BYexHS9PEisGe9yJrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966115; c=relaxed/simple;
	bh=s4gRuI5WEswZK6q8ykaCq6ujmDj9Qq4lXaYwWptxIOM=;
	h=Date:To:From:Subject:Message-Id; b=HDzFdjMz/u+B3HmSPrQi2H+OZ9LWsX6cR1ew7pRUuKf3vA5Y2NY3uXROwOZVivPhVcav93UESbYaiOvQMauhvhRDkuj4faJ3DJRNtXxUPaoDrDCzk2lKmH9y7gWIjZV57iTDJ7V+u+ck08p51PY2vVUzUgUpx4+/Z3iz4E0OYEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iRHb5mUI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iRHb5mUI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF65C16AAE;
	Wed, 21 Jan 2026 03:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966115;
	bh=s4gRuI5WEswZK6q8ykaCq6ujmDj9Qq4lXaYwWptxIOM=;
	h=Date:To:From:Subject:From;
	b=iRHb5mUIMKw3aPt8jm4hUx6zeM3EOkRueav9C9ckGu8hoiFtZmN8MktK1EPP4tFKG
	 YeX2Uj1TwCK8kHnW4eP7rIlwZsHmU8eVc5k3QXaX0bIci3cRNeBnDJ+aURTvh5sgSF
	 J3CBY7CQa9OZXixr7MmvlRI4Ysn7hAFM7+lCM/os=
Date: Tue, 20 Jan 2026 19:28:34 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,luizcap@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,chuhu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-va_high_addr_switch-return-fail-when-either-test-failed.patch removed from -mm tree
Message-Id: <20260121032835.1AF65C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: va_high_addr_switch return fail when either test failed
has been removed from the -mm tree.  Its filename was
     selftests-mm-va_high_addr_switch-return-fail-when-either-test-failed.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chunyu Hu <chuhu@redhat.com>
Subject: selftests/mm: va_high_addr_switch return fail when either test failed
Date: Sun, 21 Dec 2025 12:00:24 +0800

When the first test failed, and the hugetlb test passed, the result would
be pass, but we expect a fail.  Fix this issue by returning fail if either
is not KSFT_PASS.

Link: https://lkml.kernel.org/r/20251221040025.3159990-4-chuhu@redhat.com
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
Reviewed-by: Luiz Capitulino <luizcap@redhat.com>
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


