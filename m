Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73B91E5B70
	for <mm-commits@vger.kernel.org>; Sat, 17 Oct 2026 02:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792204106; cv=none; b=a5KeE+O6kFQhsLfVctS4zMYzGe3IKkR3nspwSOqkqAQRtMFZIc7sbTawVeSXVxSPI+Fze49hABrlVqxHwQj79sWuNXkHYypnC6plXna37z4pYbsX7tCodxpN/HKpg7DNyUvCkDUsvPumQdBrxgtrYra38820KBDjrBApC4YEHlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792204106; c=relaxed/simple;
	bh=nGs11YgejclGxwj2polcRQ29JlBQqQYfJ2V+w3yGg/8=;
	h=Date:To:From:Subject:Message-Id; b=GpVdSTD2et4cjv/V0L77zBsx+pwPlifudpzyximYj19sqynXbTrvCUmoeaMG3ylFyS9fkVWRy3e8k+lO6aZoz/KaszCXaMJQOvZhGiHsw3SO37Eg1fx42XfN5mtD4SoLEjAEMS5vb95I4eWN7nBC3SDcGYX00/SCNZAYdAcWNr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tJuEEJU2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tJuEEJU2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B3BF1F000C4;
	Sat, 17 Oct 2026 02:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792204104;
	bh=MW5+nxVRjyGEtRx1Lo/C5Q0C7sQ0lBgSwVcIc6Rcjq8=;
	h=Date:To:From:Subject;
	b=tJuEEJU22DpxvLtVjyIaDArgZCGDvusQ7nTbpeGQSUEjutmY74T+iO8p1VqJvximU
	 sjA7gEMz7V/hajd1UfVJS1z3F9YQFE+QsewOD94pDr6u+YgDE4X69Pn3KuUZkrf7W2
	 bEg7Mg0S0YILgwzW2+opgy8PSqpsE/9legX/aC6Q=
Date: Fri, 16 Oct 2026 19:28:23 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,joshua.hahnjy@gmail.com,david@kernel.org,almasrymina@google.com,odys.yuan@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-skip-hugetlb-cgroup-v2-tests-without-the-needed-controllers.patch added to mm-unstable branch
Message-Id: <20261017022824.5B3BF1F000C4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: skip hugetlb cgroup v2 tests without the needed controllers
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-skip-hugetlb-cgroup-v2-tests-without-the-needed-controllers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-skip-hugetlb-cgroup-v2-tests-without-the-needed-controllers.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Qiliang Yuan <odys.yuan@gmail.com>
Subject: selftests/mm: skip hugetlb cgroup v2 tests without the needed controllers
Date: Fri, 16 Oct 2026 20:54:48 +0800

With -cgroup-v2, charge_reserved_hugetlb.sh and
hugetlb_reparenting_test.sh mount a cgroup2 hierarchy on a temporary
directory when none is mounted and enable the hugetlb controller
(hugetlb_reparenting_test.sh also enables memory) in its
cgroup.subtree_control.

On a system that still binds these controllers to cgroup v1, they are not
available in the new hierarchy.  Writing to cgroup.subtree_control fails
with ENOENT, "set -e" aborts the script, the test is reported as failed,
and the temporary cgroup2 mount is left behind.

Check cgroup.controllers first, and skip the test when a controller is
missing, after unmounting the hierarchy and removing the directory the
script created.

With hugetlb and memory bound to cgroup v1, per script:

                                before      after
  result                        fail        skip
  cgroup2 mounts left behind       1           0

Link: https://lore.kernel.org/20261016-bug-selftests-mm-hugetlb-cgroup2-skip-v1-1-7c78883a67b4@gmail.com
Fixes: 29750f71a9b4 ("hugetlb_cgroup: add hugetlb_cgroup reservation tests")
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
---

 tools/testing/selftests/mm/charge_reserved_hugetlb.sh  |    8 ++++++++
 tools/testing/selftests/mm/hugetlb_reparenting_test.sh |   10 ++++++++++
 2 files changed, 18 insertions(+)

--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh~selftests-mm-skip-hugetlb-cgroup-v2-tests-without-the-needed-controllers
+++ a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -39,6 +39,14 @@ if [[ $cgroup2 ]]; then
     mount -t cgroup2 none $cgroup_path
     do_umount=1
   fi
+  if ! grep -qw hugetlb $cgroup_path/cgroup.controllers; then
+    echo "hugetlb controller not available in cgroup v2. Skipping..."
+    if [[ $do_umount ]]; then
+      umount $cgroup_path
+      rmdir $cgroup_path
+    fi
+    exit $ksft_skip
+  fi
   echo "+hugetlb" >$cgroup_path/cgroup.subtree_control
 else
   cgroup_path=$(mount -t cgroup | grep ",hugetlb" | awk '{print $3}')
--- a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh~selftests-mm-skip-hugetlb-cgroup-v2-tests-without-the-needed-controllers
+++ a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
@@ -29,6 +29,16 @@ if [[ $cgroup2 ]]; then
     mount -t cgroup2 none $CGROUP_ROOT
     do_umount=1
   fi
+  for ctrl in hugetlb memory; do
+    if ! grep -qw $ctrl $CGROUP_ROOT/cgroup.controllers; then
+      echo "$ctrl controller not available in cgroup v2. Skipping..."
+      if [[ $do_umount ]]; then
+        umount $CGROUP_ROOT
+        rmdir $CGROUP_ROOT
+      fi
+      exit $ksft_skip
+    fi
+  done
   echo "+hugetlb +memory" >$CGROUP_ROOT/cgroup.subtree_control
 else
   CGROUP_ROOT=$(mount -t cgroup | grep ",hugetlb" | awk '{print $3}')
_

Patches currently in -mm which might be from odys.yuan@gmail.com are

selftests-mm-skip-hugetlb-cgroup-v2-tests-without-the-needed-controllers.patch

