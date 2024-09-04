Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70CF974E26
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423537; cv=none; b=ZqSx8fF0lcPhMrTuo4y1crgxLwaXWKfo5RKh+wW514c+1qi85kFx1fZ92pRL69nm+LYxRT7Ht8T5zNeiJy0aQwL+Toe+iVBtq/8fSV7buQDdIz4jpGAdjCz/XCX9ihsRdldscddwM1GeK7+jIkAO6iG5q1yAQOaCIFAQwZodeEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423537; c=relaxed/simple;
	bh=Ze6es5pFM3NL47uHHRCr3NegMdiJIxyY0Q7hzMZ2XeY=;
	h=Date:To:From:Subject:Message-Id; b=iuBY/P2cmcd/RqEnX1ISx0p5PUzs347IlbFyoOhJhQAjiuUbARRVzMMWEBvrBAU7n7QBE0Qiz32qwOv+dCJGidOQbNOtSvYjp5UZb5uaZJvWsZU9WW09zgtOJ5z7+r03e4h8XS0LhRwMRG+TBnkEsc7Onbvzt50EEVnhztAxM18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SGkVeu8g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SGkVeu8g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468E4C4CEC2;
	Wed,  4 Sep 2024 04:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423537;
	bh=Ze6es5pFM3NL47uHHRCr3NegMdiJIxyY0Q7hzMZ2XeY=;
	h=Date:To:From:Subject:From;
	b=SGkVeu8gXlz82EhJRawTeG5xtIc9HutBozU6rehVBO+DyBfC7oxEA7V7n148F2wL7
	 OeXd/Ye2YBS+rQyW0pEYqJ1AgYwVXbwbjCBoMzfLfSgMLAUtZie7iloxQkB8Cw9EPZ
	 Glc2P9ub5yBEiSe0SgA78j8vNmOgR2Bug5SNbcrY=
Date: Tue, 03 Sep 2024 21:18:56 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,muchun.song@linux.dev,mcasquer@redhat.com,almasrymina@google.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-charge_reserved_hugetlbsh-test.patch removed from -mm tree
Message-Id: <20240904041857.468E4C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix charge_reserved_hugetlb.sh test
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-charge_reserved_hugetlbsh-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: selftests/mm: fix charge_reserved_hugetlb.sh test
Date: Wed, 21 Aug 2024 14:31:15 +0200

Currently, running the charge_reserved_hugetlb.sh selftest we can
sometimes observe something like:

  $ ./charge_reserved_hugetlb.sh -cgroup-v2
  ...
  write_result is 0
  After write:
  hugetlb_usage=0
  reserved_usage=10485760
  killing write_to_hugetlbfs
  Received 2.
  Deleting the memory
  Detach failure: Invalid argument
  umount: /mnt/huge: target is busy.

Both cases are issues in the test.

While the unmount error seems to be racy, it will make the test fail:
	$ ./run_vmtests.sh -t hugetlb
	...
	# [FAIL]
	not ok 10 charge_reserved_hugetlb.sh -cgroup-v2 # exit=32

The issue is that we are not waiting for the write_to_hugetlbfs process to
quit.  So it might still have a hugetlbfs file open, about which umount is
not happy.  Fix that by making "killall" wait for the process to quit.

The other error ("Detach failure: Invalid argument") does not seem to
result in a test error, but is misleading.  Turns out write_to_hugetlbfs.c
unconditionally tries to cleanup using shmdt(), even when we only
mmap()'ed a hugetlb file.  Even worse, shmaddr is never even set for the
SHM case.  Fix that as well.

With this change it seems to work as expected.

Link: https://lkml.kernel.org/r/20240821123115.2068812-1-david@redhat.com
Fixes: 29750f71a9b4 ("hugetlb_cgroup: add hugetlb_cgroup reservation tests")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Mario Casquero <mcasquer@redhat.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Tested-by: Mario Casquero <mcasquer@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/charge_reserved_hugetlb.sh |    2 
 tools/testing/selftests/mm/write_to_hugetlbfs.c       |   21 +++++-----
 2 files changed, 13 insertions(+), 10 deletions(-)

--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh~selftests-mm-fix-charge_reserved_hugetlbsh-test
+++ a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -254,7 +254,7 @@ function cleanup_hugetlb_memory() {
   local cgroup="$1"
   if [[ "$(pgrep -f write_to_hugetlbfs)" != "" ]]; then
     echo killing write_to_hugetlbfs
-    killall -2 write_to_hugetlbfs
+    killall -2 --wait write_to_hugetlbfs
     wait_for_hugetlb_memory_to_get_depleted $cgroup
   fi
   set -e
--- a/tools/testing/selftests/mm/write_to_hugetlbfs.c~selftests-mm-fix-charge_reserved_hugetlbsh-test
+++ a/tools/testing/selftests/mm/write_to_hugetlbfs.c
@@ -28,7 +28,7 @@ enum method {
 
 /* Global variables. */
 static const char *self;
-static char *shmaddr;
+static int *shmaddr;
 static int shmid;
 
 /*
@@ -47,15 +47,17 @@ void sig_handler(int signo)
 {
 	printf("Received %d.\n", signo);
 	if (signo == SIGINT) {
-		printf("Deleting the memory\n");
-		if (shmdt((const void *)shmaddr) != 0) {
-			perror("Detach failure");
+		if (shmaddr) {
+			printf("Deleting the memory\n");
+			if (shmdt((const void *)shmaddr) != 0) {
+				perror("Detach failure");
+				shmctl(shmid, IPC_RMID, NULL);
+				exit(4);
+			}
+
 			shmctl(shmid, IPC_RMID, NULL);
-			exit(4);
+			printf("Done deleting the memory\n");
 		}
-
-		shmctl(shmid, IPC_RMID, NULL);
-		printf("Done deleting the memory\n");
 	}
 	exit(2);
 }
@@ -211,7 +213,8 @@ int main(int argc, char **argv)
 			shmctl(shmid, IPC_RMID, NULL);
 			exit(2);
 		}
-		printf("shmaddr: %p\n", ptr);
+		shmaddr = ptr;
+		printf("shmaddr: %p\n", shmaddr);
 
 		break;
 	default:
_

Patches currently in -mm which might be from david@redhat.com are


