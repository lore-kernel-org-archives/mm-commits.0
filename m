Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CB7537F8
	for <mm-commits@vger.kernel.org>; Sun,  6 Apr 2025 22:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743978216; cv=none; b=Nth9VUUkKhKY0h7edyCkzSp+f34MM+oGWZWOJByjdnIGMRROxkvTibFaySJgz4P7PKB2heeM8oIse35VOlM/eWWoCeBolOOdk6KwrfVZPFSqi8I9dAv1MGnS2rTY5Bxuv8J/djUBAmpjSNPMTdX1XNE4OKTf+3e8Uxi92UIC968=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743978216; c=relaxed/simple;
	bh=zWVp2uLaehamwVefv8UveQRuuE0xY2Pcocs9V12Kroo=;
	h=Date:To:From:Subject:Message-Id; b=Z0NbnGu5SbVw7tjqzP7d7SA3g53SXQ0UUnWM3hWaqHNLqZQXzFWoVrETpgloRNBG+IPAr2UiBCf5YRLXuLsH4GxmY8SnKzInkfaOGITS/I4+eyvvcp9OFb9c9LYDEtiKY7cBE/fE38WPvsbt5+GquA1hDzMrgE84WS2lmjBEKuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=erp+1IVr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="erp+1IVr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0AE5C4CEE3;
	Sun,  6 Apr 2025 22:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743978216;
	bh=zWVp2uLaehamwVefv8UveQRuuE0xY2Pcocs9V12Kroo=;
	h=Date:To:From:Subject:From;
	b=erp+1IVrWBMVkio72ZH/26MlIaEvGhCiV0Xp8p33FAah6S4NKr05+GcDSK53Ui8Fw
	 0htaXvf43QWeBaVMh5FYAyWENvgvsZzwWPcVfR9hI0tom23gyAqLL0xPDPzMtddqaf
	 loj618PItA3ITIMH3eKtxXLeN8PmEZJ6gZVX2LOc=
Date: Sun, 06 Apr 2025 15:23:35 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,longman@redhat.com,almasrymina@google.com,aishwarya.tcv@arm.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-generate-a-temporary-mountpoint-for-cgroup-filesystem.patch added to mm-hotfixes-unstable branch
Message-Id: <20250406222335.F0AE5C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: generate a temporary mountpoint for cgroup filesystem
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-generate-a-temporary-mountpoint-for-cgroup-filesystem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-generate-a-temporary-mountpoint-for-cgroup-filesystem.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

selftests-mm-generate-a-temporary-mountpoint-for-cgroup-filesystem.patch

