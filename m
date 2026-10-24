Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832529;
	b=hZKB9Bw+xeUOZWxjFsTokev1LhnigIFC3K8voOXyJhifOCj+2x9owxXgLPr7GcxUNmfG
	 AGsU/o61UOpfLO/D1Yd94liZhtczyvuXC2aB/74DSGrdlFOoJ2d0C+noryRi+JsL5Dkts
	 NYtGstYuq/TPMUMtvUH1T+16Tvjs9cdO6LF/W3vbL9MG0FxU2DGpDwl7TDEgAu//dzXx6
	 /h6teUqOm4VPsyRlu1PfRQ5NJxoN1Qf9iOOCZ7qE18a3t+PBLQZ6QkdQvFlpOst2MfL4y
	 ZLU0exeCk1MtnhyOXbwJ0EDivTTHktk/+/HSGn1RwkgxsghLYutXRFxJsKvd9Sq8JSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832529;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=ByCJCyakaE2T/pMrLWZ8v+xgm9FXw17XYRabj6QopSg=;
	b=YXkEILGLK3yhgiHnbLB4rEOHcfwR5X9Z2Me8j/1yu8VQ+xFHVL5zVaiOrBH6ag7Czrj/
	 /eRmkC48Nk6MDfBAnyRdwxx+7UvG2sSILd7YKekVO650WzgEig5v8lab+nkfoeQRtVixv
	 WCa/ePIoV8XaQ4lK4Sj8H7j/x9QqtVRJ+JkSF0o44DJHkJPNqqsrN5NJ71q/jlfJbebPe
	 D19keOFOYtvpYf5RNLQZq/6bftzSdo3TPi3OJLgEK+SAv3bUtiLWFKIIV6CnlzY8OA32i
	 0Kdu27M/4kx/TIMD5XliDdlpZPig9d9RMnVgkGQmEe407JLEp4itQxovgYVTr+2yfhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WVn0HWMp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8DA606A320
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WVn0HWMp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 580521F01825;
	Sat, 24 Oct 2026 09:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832529;
	bh=ByCJCyakaE2T/pMrLWZ8v+xgm9FXw17XYRabj6QopSg=;
	h=Date:To:From:Subject;
	b=WVn0HWMpvbcrzY3ByiEe14e3Tiym0jBHIH7TLS3DoBuExoaHlzNtFKg+RqaY2dx/4
	 Kd+2x0xruvXruqod6tcDiPko/ir7Ny2dYVjcLZlSS+kJQiRjrpbX5/DM0T2kzJ1SuH
	 j288e8DR1Vk81bb8pEjlzUEsJcxogsu/MRwiHZLE=
Date: Sat, 24 Oct 2026 02:02:08 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,joshua.hahnjy@gmail.com,david@kernel.org,almasrymina@google.com,odys.yuan@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-skip-hugetlb-cgroup-v2-tests-without-the-needed-controllers.patch removed from -mm tree
Message-Id: <20261024090209.580521F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: selftests/mm: skip hugetlb cgroup v2 tests without the needed controllers
has been removed from the -mm tree.  Its filename was
     selftests-mm-skip-hugetlb-cgroup-v2-tests-without-the-needed-controllers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


