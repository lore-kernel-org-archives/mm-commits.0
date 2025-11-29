Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE727FBA2
	for <mm-commits@vger.kernel.org>; Sat, 29 Nov 2025 18:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764441714; cv=none; b=lVrWdsbOCyT2Y6G8HGGOp1OndmRjKTZBTIvp1ziBmbQmuBh6UFIoUdR/4nF7XOIsOk/ODZ+EBS2ik2h48MUmhDrXxsQ3+Uua64lOVLMFnDw28Qo/QqLUrgEFq9mqCS7VjPYJ3Qb0uk2r6HB7o3sMXbr9yw5NrGcTjycDjeEs9tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764441714; c=relaxed/simple;
	bh=KrCQq5cG6cSlpyocMeCMd3Kpl/EmfN5hvOuL3FtVQsw=;
	h=Date:To:From:Subject:Message-Id; b=EnKSSfwGvtMEcC9kSgJDMnY/i2jnjNggWYPwI3bA1ns3oZDR3u1bpLcrVNhaz2OtCrZgB74SbTHJAqYZ719huegLrJsUNUyMYDvF5MVZZ1aJTFdql7/XfrxYUt/jiIZDM1lFg9RGnJTLsuY6q0o3Pu2o8QnQtyYuIy+pUp5rSGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pQcrBZ8t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pQcrBZ8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2CFC4CEF7;
	Sat, 29 Nov 2025 18:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764441713;
	bh=KrCQq5cG6cSlpyocMeCMd3Kpl/EmfN5hvOuL3FtVQsw=;
	h=Date:To:From:Subject:From;
	b=pQcrBZ8ttDQ3YIBjmM024tk146kF4tQi3Ayd20kPeECXE3/QGFkr5tGLsc4zdgA1Y
	 prpzrVp7HkloQ99Z4NDdSE+i79LIc5qqZXnrJjeylPFeFpVF76A7LUn0GGTfVsMEJg
	 8tkruJ3bnhKXZnsW5bUy2F3tgjfWDfX2i1m9GoR8=
Date: Sat, 29 Nov 2025 10:41:53 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,peterx@redhat.com,nathan@kernel.org,morbo@google.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,justinstitt@google.com,ankitkhushwaha.linux@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-uffd-initialize-char-variable-to-null.patch removed from -mm tree
Message-Id: <20251129184153.DA2CFC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm/uffd: initialize char variable to Null
has been removed from the -mm tree.  Its filename was
     selftests-mm-uffd-initialize-char-variable-to-null.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
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


