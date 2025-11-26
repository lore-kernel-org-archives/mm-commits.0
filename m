Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDDA348899
	for <mm-commits@vger.kernel.org>; Wed, 26 Nov 2025 17:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764178682; cv=none; b=WZ7pTlYGJYrOJiOeDs5rTeosEUrL6HpWySSwAte8YaAXCmhC15GyoVpjSn46y7Nj6gz/0ni4aG1UCoaLZ6M5E1l7uWXfAaZQo8VmGyQJwUZhGPR9FUud4TZXVVxJFVQs6rEOzfPaNkd/iX+uVy7KJt2LQ6jXYiCWkRMtYWLTBfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764178682; c=relaxed/simple;
	bh=sXqXSDEteBWyFQzhDHnczrnTwyQM92s0rPksBqTVQx4=;
	h=Date:To:From:Subject:Message-Id; b=kl0rYHm53wbM0eu4DG/Hug/gULS44qTXRZTzazDuHxrS4KlMq2XxDvFAVfGsRjSZ4uQ+L2aIVhKSqT8fa/ZRGZ08zimIsHs3pYLCyjAgFqSUh/ZwwvIjHIK7/FCJ/qTml5amZjwZnGy3J3YM341eLlQi2tl2rCT+pu1xBnR4HU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=szuIN9oa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="szuIN9oa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A57C4CEF8;
	Wed, 26 Nov 2025 17:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764178681;
	bh=sXqXSDEteBWyFQzhDHnczrnTwyQM92s0rPksBqTVQx4=;
	h=Date:To:From:Subject:From;
	b=szuIN9oakeZz6HEZsQLR2tvhGv6hHZ8hJOdadt9jjZxKcVptZhBW5RJ2nfU0zsl+g
	 whSM4uHwOdbsNWJM35YoAgNcWbstj2K9SQZyf70VmAzATv3mjc5IVNxqB6sU1OxbYm
	 8NSVo9tlNatuqDxJ0OBIEnTVzl8rLs5LuTLzVs98=
Date: Wed, 26 Nov 2025 09:38:00 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,peterx@redhat.com,nathan@kernel.org,morbo@google.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,justinstitt@google.com,ankitkhushwaha.linux@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-uffd-initialize-char-variable-to-null.patch added to mm-unstable branch
Message-Id: <20251126173801.67A57C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm/uffd: initialize char variable to Null
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-uffd-initialize-char-variable-to-null.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-uffd-initialize-char-variable-to-null.patch

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
From: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
Subject: selftests/mm/uffd: initialize char variable to Null
Date: Wed, 26 Nov 2025 21:38:30 +0530

In "uffd-stress.c" & "uffd-unit-tests.c". address of char variable having
garbage value (uninitialized) is passed to 'write' syscall triggers
warning.

	uffd-stress.c:246:39: warning: variable 'c' is uninitialized when
	passed  as a const pointer argument here
	[-Wuninitialized-const-pointer]

	uffd-unit-tests.c:581:31: warning: variable 'c' is uninitialized
	when passed as a const pointer argument here
	[-Wuninitialized-const-pointer]

so the fix is to assign char variable to '\0' to prevent writing of
garbage value.

Link: https://lkml.kernel.org/r/20251126160830.52124-1-ankitkhushwaha.linux@gmail.com
Signed-off-by: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-stress.c     |    2 +-
 tools/testing/selftests/mm/uffd-unit-tests.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-uffd-initialize-char-variable-to-null
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -241,7 +241,7 @@ static int stress(struct uffd_args *args
 			return 1;
 
 	for (cpu = 0; cpu < gopts->nr_parallel; cpu++) {
-		char c;
+		char c = '\0';
 		if (bounces & BOUNCE_POLL) {
 			if (write(gopts->pipefd[cpu*2+1], &c, 1) != 1)
 				err("pipefd write error");
--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-uffd-initialize-char-variable-to-null
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -543,7 +543,7 @@ static void uffd_minor_test_common(uffd_
 {
 	unsigned long p;
 	pthread_t uffd_mon;
-	char c;
+	char c = '\0';
 	struct uffd_args args = { 0 };
 	args.gopts = gopts;
 
@@ -759,7 +759,7 @@ static void uffd_sigbus_test_common(uffd
 	pthread_t uffd_mon;
 	pid_t pid;
 	int err;
-	char c;
+	char c = '\0';
 	struct uffd_args args = { 0 };
 	args.gopts = gopts;
 
@@ -819,7 +819,7 @@ static void uffd_events_test_common(uffd
 	pthread_t uffd_mon;
 	pid_t pid;
 	int err;
-	char c;
+	char c = '\0';
 	struct uffd_args args = { 0 };
 	args.gopts = gopts;
 
@@ -1125,7 +1125,7 @@ uffd_move_test_common(uffd_global_test_o
 {
 	unsigned long nr;
 	pthread_t uffd_mon;
-	char c;
+	char c = '\0';
 	unsigned long long count;
 	struct uffd_args args = { 0 };
 	char *orig_area_src = NULL, *orig_area_dst = NULL;
_

Patches currently in -mm which might be from ankitkhushwaha.linux@gmail.com are

selftests-mm-uffd-initialize-char-variable-to-null.patch

