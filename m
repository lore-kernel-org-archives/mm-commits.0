Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1906A3A1E6A
	for <mm-commits@vger.kernel.org>; Sun, 21 Dec 2025 18:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766341964; cv=none; b=W3kweubRbhMq983mJJ+xe2wnMWUuE2mm3HA+ekuEk68fH24ipFlfXTZCFzMeFU7VEwsow8uEOgDlr3NooGy15AlTJDWOpPwnfUTBmjjOAB8JedehnJN7a1BeJ4UOpSxmbXscIJIvTLGOS/suuODRePeAr8m/A+8MiPMbVGuiwp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766341964; c=relaxed/simple;
	bh=xx8Iq0M6Q5dMIEkEtUNsaXdvE/o7TWt5g2c6Z9Frkj0=;
	h=Date:To:From:Subject:Message-Id; b=qneJiJwx/Opg8dafXyhoLPO6MScFJ8WUdK1C3FTHFuj6MJW1MrUKqyY5dv/UW/ai/Nkawbe+1VD00QaL1TKDNDvBPeBfTGojV+L+iqiHEcJiNxg2tZbFX9UVFUPGcms2CgmERiFy039wCR6Pnjv+toRgHOAvFnVR73YaPr/kieQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aQuffWAS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aQuffWAS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D02C4CEFB;
	Sun, 21 Dec 2025 18:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766341963;
	bh=xx8Iq0M6Q5dMIEkEtUNsaXdvE/o7TWt5g2c6Z9Frkj0=;
	h=Date:To:From:Subject:From;
	b=aQuffWASd4Knkq53Yhxa3jjxX3Z/TnZgt7U9Kjjj4rQnFW3E32d9WDJ3gk1dShH3g
	 o8wQCn7o6Twp6D5t13XSRJXvFzDJ8HWSuLhJn4DxwmL1v9HH+zs9L0o+aTxXuoV5gZ
	 bhks5ClrxmmJRwQrRxYDD9kfeiR4+/dOyVD7Ahmc=
Date: Sun, 21 Dec 2025 10:32:43 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,longman@redhat.com,david@kernel.org,broonie@kernel.org,liwang@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-write_to_hugetlbfs-parse-s-as-size_t.patch added to mm-new branch
Message-Id: <20251221183243.96D02C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm/write_to_hugetlbfs: parse -s as size_t
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-write_to_hugetlbfs-parse-s-as-size_t.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-write_to_hugetlbfs-parse-s-as-size_t.patch

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
From: Li Wang <liwang@redhat.com>
Subject: selftests/mm/write_to_hugetlbfs: parse -s as size_t
Date: Sun, 21 Dec 2025 20:26:37 +0800

Patch series "selftests/mm: hugetlb cgroup charging: robustness fixes", v3.

This series fixes a few issues in the hugetlb cgroup charging selftests
(write_to_hugetlbfs.c + charge_reserved_hugetlb.sh) that show up on
systems with large hugepages (e.g.  512MB) and when failures cause the
test to wait indefinitely.

On an aarch64 64k page kernel with 512MB hugepages, the test consistently
fails in write_to_hugetlbfs with ENOMEM and then hangs waiting for the
expected usage values.  The root cause is that charge_reserved_hugetlb.sh
mounts hugetlbfs with a fixed size=256M, which is smaller than a single
hugepage, resulting in a mount with size=0 capacity.

In addition, write_to_hugetlbfs previously parsed -s via atoi() into an
int, which can overflow and print negative sizes.

Reproducer / environment:
  - Kernel: 6.12.0-xxx.el10.aarch64+64k
  - Hugepagesize: 524288 kB (512MB)
  - ./charge_reserved_hugetlb.sh -cgroup-v2
  - Observed mount: pagesize=512M,size=0 before this series

After applying the series, the test completes successfully on the above
setup.


This patch (of 3):

write_to_hugetlbfs currently parses the -s size argument with atoi() into
an int.  This silently accepts malformed input, cannot report overflow,
and can truncate large sizes.

--- Error log ---
 # uname -r
 6.12.0-xxx.el10.aarch64+64k

 # ls /sys/kernel/mm/hugepages/hugepages-*
 hugepages-16777216kB/  hugepages-2048kB/  hugepages-524288kB/

 #./charge_reserved_hugetlb.sh -cgroup-v2
 # -----------------------------------------
 ...
 # nr hugepages = 10
 # writing cgroup limit: 5368709120
 # writing reseravation limit: 5368709120
 ...
 # Writing to this path: /mnt/huge/test
 # Writing this size: -1610612736        <--------

Switch the size variable to size_t and parse -s with sscanf("%zu", ...). 
Also print the size using %zu.

This avoids incorrect behavior with large -s values and makes the utility
more robust.

Link: https://lkml.kernel.org/r/20251221122639.3168038-1-liwang@redhat.com
Link: https://lkml.kernel.org/r/20251221122639.3168038-2-liwang@redhat.com
Signed-off-by: Li Wang <liwang@redhat.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/write_to_hugetlbfs.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/write_to_hugetlbfs.c~selftests-mm-write_to_hugetlbfs-parse-s-as-size_t
+++ a/tools/testing/selftests/mm/write_to_hugetlbfs.c
@@ -68,7 +68,7 @@ int main(int argc, char **argv)
 	int key = 0;
 	int *ptr = NULL;
 	int c = 0;
-	int size = 0;
+	size_t size = 0;
 	char path[256] = "";
 	enum method method = MAX_METHOD;
 	int want_sleep = 0, private = 0;
@@ -86,7 +86,10 @@ int main(int argc, char **argv)
 	while ((c = getopt(argc, argv, "s:p:m:owlrn")) != -1) {
 		switch (c) {
 		case 's':
-			size = atoi(optarg);
+			if (sscanf(optarg, "%zu", &size) != 1) {
+				perror("Invalid -s.");
+				exit_usage();
+			}
 			break;
 		case 'p':
 			strncpy(path, optarg, sizeof(path) - 1);
@@ -131,7 +134,7 @@ int main(int argc, char **argv)
 	}
 
 	if (size != 0) {
-		printf("Writing this size: %d\n", size);
+		printf("Writing this size: %zu\n", size);
 	} else {
 		errno = EINVAL;
 		perror("size not found");
_

Patches currently in -mm which might be from liwang@redhat.com are

selftests-mm-write_to_hugetlbfs-parse-s-as-size_t.patch
selftests-mm-charge_reserved_hugetlb-drop-mount-size-for-hugetlbfs.patch
selftests-mm-charge_reserved_hugetlbsh-add-waits-with-timeout-helper.patch

