Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D459D134D4;
	Sat, 12 Apr 2025 00:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744418003; cv=none; b=rfraOi5XM+hl73ABrYEg4shGRzz3bFYnC+Sz6oNHzTKkLfJdR3A78eclxuevFhvYmUBfwwg8BFuz+Pqm0Fa+FslCFPgYgfL+LdBP8PdubSZvA+dL98mTFRODF8QeAuf4YK47bl5CeRUg2etKxZc1PFrN5sbpgYtlvJ3oTOEr0qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744418003; c=relaxed/simple;
	bh=Hkv+HIlOorc54XLRJEchje1Z/P8tCiOxPuv7lV/G/Gs=;
	h=Date:To:From:Subject:Message-Id; b=Pc/mpqvgm2p9KxAYJXqmT9r+GrALDdz9KCsuNIlEoKlXywq4GY/iCGJ8Nrv/iiA5ziULNaariQCVlzLCE6K8MX43rHd/1LLDL2FxUhwJHT80K67s3T77ZEvXoAKxtKVqEYsSDRzqqCJ7CGOpokYTEW8zpxfT6E8keOjopAmVmjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VOmqxk4A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VOmqxk4A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB6AC4CEE2;
	Sat, 12 Apr 2025 00:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744418003;
	bh=Hkv+HIlOorc54XLRJEchje1Z/P8tCiOxPuv7lV/G/Gs=;
	h=Date:To:From:Subject:From;
	b=VOmqxk4ASySlXJk9EK7gsCETPRLqAZSYADVVE3SLZ27Wcz2LjQNHrsp78Mji3/aWA
	 3zNHI0s2KVGO5n1/Wf7Mdjyi382Ib/lfIg1yULldewsIEqFVuMALZlBUbTmKiKbNDG
	 UpciGOcRgT39p51VqeXIkPgRKgyt01F1Lxc6JrlA=
Date: Fri, 11 Apr 2025 17:33:22 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,longman@redhat.com,almasrymina@google.com,aishwarya.tcv@arm.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-generate-a-temporary-mountpoint-for-cgroup-filesystem.patch removed from -mm tree
Message-Id: <20250412003323.9FB6AC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: generate a temporary mountpoint for cgroup filesystem
has been removed from the -mm tree.  Its filename was
     selftests-mm-generate-a-temporary-mountpoint-for-cgroup-filesystem.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark Brown <broonie@kernel.org>
Subject: selftests/mm: generate a temporary mountpoint for cgroup filesystem
Date: Fri, 04 Apr 2025 17:42:32 +0100

Currently if the filesystem for the cgroups version it wants to use is not
mounted charge_reserved_hugetlb.sh and hugetlb_reparenting_test.sh tests
will attempt to mount it on the hard coded path /dev/cgroup/memory,
deleting that directory when the test finishes.  This will fail if there
is not a preexisting directory at that path, and since the directory is
deleted subsequent runs of the test will fail.  Instead of relying on this
hard coded directory name use mktemp to generate a temporary directory to
use as a mountpoint, fixing both the assumption and the disruption caused
by deleting a preexisting directory.

This means that if the relevant cgroup filesystem is not already mounted
then we rely on having coreutils (which provides mktemp) installed.  I
suspect that many current users are relying on having things automounted
by default, and given that the script relies on bash it's probably not an
unreasonable requirement.

Link: https://lkml.kernel.org/r/20250404-kselftest-mm-cgroup2-detection-v1-1-3dba6d32ba8c@kernel.org
Fixes: 209376ed2a84 ("selftests/vm: make charge_reserved_hugetlb.sh work with existing cgroup setting")
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Aishwarya TCV <aishwarya.tcv@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/charge_reserved_hugetlb.sh  |    4 ++--
 tools/testing/selftests/mm/hugetlb_reparenting_test.sh |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh~selftests-mm-generate-a-temporary-mountpoint-for-cgroup-filesystem
+++ a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -29,7 +29,7 @@ fi
 if [[ $cgroup2 ]]; then
   cgroup_path=$(mount -t cgroup2 | head -1 | awk '{print $3}')
   if [[ -z "$cgroup_path" ]]; then
-    cgroup_path=/dev/cgroup/memory
+    cgroup_path=$(mktemp -d)
     mount -t cgroup2 none $cgroup_path
     do_umount=1
   fi
@@ -37,7 +37,7 @@ if [[ $cgroup2 ]]; then
 else
   cgroup_path=$(mount -t cgroup | grep ",hugetlb" | awk '{print $3}')
   if [[ -z "$cgroup_path" ]]; then
-    cgroup_path=/dev/cgroup/memory
+    cgroup_path=$(mktemp -d)
     mount -t cgroup memory,hugetlb $cgroup_path
     do_umount=1
   fi
--- a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh~selftests-mm-generate-a-temporary-mountpoint-for-cgroup-filesystem
+++ a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
@@ -23,7 +23,7 @@ fi
 if [[ $cgroup2 ]]; then
   CGROUP_ROOT=$(mount -t cgroup2 | head -1 | awk '{print $3}')
   if [[ -z "$CGROUP_ROOT" ]]; then
-    CGROUP_ROOT=/dev/cgroup/memory
+    CGROUP_ROOT=$(mktemp -d)
     mount -t cgroup2 none $CGROUP_ROOT
     do_umount=1
   fi
_

Patches currently in -mm which might be from broonie@kernel.org are


