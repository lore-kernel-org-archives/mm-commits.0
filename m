Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E79D1A256E
	for <mm-commits@vger.kernel.org>; Fri,  1 Aug 2025 22:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754087139; cv=none; b=iMEF09ysPuzVuzf+5PQZAH8zD+5KrJnYKTz+IzjddXQDHjVyjeeWMb/DIcx+sV9o5SLe3yXw2IuSmyRY+J0ys+YOEvc870R3I6jL9GtucWaWztrZ7yTlVBNo2jEUvYCZv/XR+4SSUir/4CXwp4tNcy2vYBfz3iZnGguwYlCTwoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754087139; c=relaxed/simple;
	bh=T9ozw36oa+JP/8ly4hfCFfwhCyx0l60AALHjgElhI2M=;
	h=Date:To:From:Subject:Message-Id; b=CCdqHtqmbEi3poslQqa3EUjt2pYftuC1tptHJcxoX90o3524rwU79/D4t2OMgyi4PaMEHUsUcbxVBurrqDM6FnqBv7xoqtiGK7zO04it+q2VjeASUAwGKdk33lThmcxk6hhRWQAT/PDzuQ3qfsHBUYS9nTp0Urx8otW8fX9qUP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Lh/1m+OG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Lh/1m+OG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B74EC4CEE7;
	Fri,  1 Aug 2025 22:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754087138;
	bh=T9ozw36oa+JP/8ly4hfCFfwhCyx0l60AALHjgElhI2M=;
	h=Date:To:From:Subject:From;
	b=Lh/1m+OGq6BdSE+rSfGkIvvlpOm5B9LMQYuYSBnBzwFGnWLwaCzclEEp671l9aStc
	 L0ildsy3/T0KitK4Zts9JpBdVjdSh1J/XM5bnvzW602lHy7SHvbSN6IQ8e/TAGINbw
	 UC0EeaQxkSgn6ovoprMEiUtyMQFwXq4MzGcGHQfk=
Date: Fri, 01 Aug 2025 15:25:38 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,peterx@redhat.com,pranav.tyagi03@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-use-__auto_type-in-swap-macro.patch added to mm-nonmm-unstable branch
Message-Id: <20250801222538.9B74EC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: use __auto_type in swap() macro
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-mm-use-__auto_type-in-swap-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-use-__auto_type-in-swap-macro.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Pranav Tyagi <pranav.tyagi03@gmail.com>
Subject: selftests/mm: use __auto_type in swap() macro
Date: Wed, 30 Jul 2025 19:53:01 +0530

Replace typeof() with __auto_type in the swap() macro in uffd-stress.c. 
__auto_type was introduced in GCC 4.9 and reduces the compile time for all
compilers.  No functional changes intended.

Link: https://lkml.kernel.org/r/20250730142301.6754-1-pranav.tyagi03@gmail.com
Signed-off-by: Pranav Tyagi <pranav.tyagi03@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-stress.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-use-__auto_type-in-swap-macro
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -51,7 +51,7 @@ static char *zeropage;
 pthread_attr_t attr;
 
 #define swap(a, b) \
-	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
+	do { __auto_type __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
 
 const char *examples =
 	"# Run anonymous memory test on 100MiB region with 99999 bounces:\n"
_

Patches currently in -mm which might be from pranav.tyagi03@gmail.com are

selftests-mm-use-__auto_type-in-swap-macro.patch

