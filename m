Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3932D1FC101
	for <mm-commits@vger.kernel.org>; Sun, 21 Dec 2025 18:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766341968; cv=none; b=CaKq4zK3Gnvz00XcgTQG0mfdVhiU17scj45qCDkWQdWJwhGHITM0Y+Vvt1tvPIpvEW+M84jVst5eFdU0e++PoOX6RqRNp3qI2r9nMla2bLIFsjfSNn7EVSZNo3IF3awwRzwrm8nPfv9x0NFWYyDCfcYrinrc+9CnY2312HXLqP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766341968; c=relaxed/simple;
	bh=VITs3aD4koYCZc38gSRGQ/q6/dzDGFRVfuZVAKhG3Ig=;
	h=Date:To:From:Subject:Message-Id; b=PD5DEeqSgizNwq1FWk0TYQlbr9ehGJtWHpajzyzMGgUBlKWZt4vAjc5XQd+extXX1+qGaU39I5irhp27tLXzmkDTGXcGzrAwdbWA2byOg7u8j9aOClJLHxuXQd5TJMRH+IfqDBJsfkB3lWSOnr81VIhqeAJ4b1hF8c1LKj9zrPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sd1wb55Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sd1wb55Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A602EC4CEFB;
	Sun, 21 Dec 2025 18:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766341967;
	bh=VITs3aD4koYCZc38gSRGQ/q6/dzDGFRVfuZVAKhG3Ig=;
	h=Date:To:From:Subject:From;
	b=sd1wb55YHWWGRVt2r6Bss2gq6zVtTK8lFobtv3eNe5hNiYjZL5JeDNEMSzAThpChU
	 eDMSXo56gf3wLQd8u5kQDSykYHiD48+0BhQ1mGb0ssu4DGLLylIjlypeVStAE0wKZo
	 q7xaimOY1hFGMDycPrJo/v64It2xKkqhYN77AW64=
Date: Sun, 21 Dec 2025 10:32:47 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,longman@redhat.com,david@kernel.org,broonie@kernel.org,liwang@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-charge_reserved_hugetlbsh-add-waits-with-timeout-helper.patch added to mm-new branch
Message-Id: <20251221183247.A602EC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm/charge_reserved_hugetlb.sh: add waits with timeout helper
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-charge_reserved_hugetlbsh-add-waits-with-timeout-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-charge_reserved_hugetlbsh-add-waits-with-timeout-helper.patch

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
Subject: selftests/mm/charge_reserved_hugetlb.sh: add waits with timeout helper
Date: Sun, 21 Dec 2025 20:26:39 +0800

The hugetlb cgroup usage wait loops in charge_reserved_hugetlb.sh were
unbounded and could hang forever if the expected cgroup file value never
appears (e.g.  due to write_to_hugetlbfs in Error mapping).

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
  # write_to_hugetlbfs: Error mapping the file: Cannot allocate memory
  # Waiting for hugetlb memory reservation to reach size 2684354560.
  # 0
  # Waiting for hugetlb memory reservation to reach size 2684354560.
  # 0
  # Waiting for hugetlb memory reservation to reach size 2684354560.
  # 0
  # Waiting for hugetlb memory reservation to reach size 2684354560.
  # 0
  # Waiting for hugetlb memory reservation to reach size 2684354560.
  # 0
  # Waiting for hugetlb memory reservation to reach size 2684354560.
  # 0
  ...

Introduce a small helper, wait_for_file_value(), and use it for:
  - waiting for reservation usage to drop to 0,
  - waiting for reservation usage to reach a given size,
  - waiting for fault usage to reach a given size.

This makes the waits consistent and adds a hard timeout (60 tries with 1s
sleep) so the test fails instead of stalling indefinitely.

Link: https://lkml.kernel.org/r/20251221122639.3168038-4-liwang@redhat.com
Signed-off-by: Li Wang <liwang@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/charge_reserved_hugetlb.sh |   51 +++++-----
 1 file changed, 30 insertions(+), 21 deletions(-)

--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh~selftests-mm-charge_reserved_hugetlbsh-add-waits-with-timeout-helper
+++ a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -100,7 +100,7 @@ function setup_cgroup() {
   echo writing cgroup limit: "$cgroup_limit"
   echo "$cgroup_limit" >$cgroup_path/$name/hugetlb.${MB}MB.$fault_limit_file
 
-  echo writing reseravation limit: "$reservation_limit"
+  echo writing reservation limit: "$reservation_limit"
   echo "$reservation_limit" > \
     $cgroup_path/$name/hugetlb.${MB}MB.$reservation_limit_file
 
@@ -112,41 +112,50 @@ function setup_cgroup() {
   fi
 }
 
+function wait_for_file_value() {
+  local path="$1"
+  local expect="$2"
+  local max_tries=60
+
+  if [[ ! -r "$path" ]]; then
+    echo "ERROR: cannot read '$path', missing or permission denied"
+    return 1
+  fi
+
+  for ((i=1; i<=max_tries; i++)); do
+    local cur="$(cat "$path")"
+    if [[ "$cur" == "$expect" ]]; then
+      return 0
+    fi
+    echo "Waiting for $path to become '$expect' (current: '$cur') (try $i/$max_tries)"
+    sleep 1
+  done
+
+  echo "ERROR: timeout waiting for $path to become '$expect'"
+  return 1
+}
+
 function wait_for_hugetlb_memory_to_get_depleted() {
   local cgroup="$1"
   local path="$cgroup_path/$cgroup/hugetlb.${MB}MB.$reservation_usage_file"
-  # Wait for hugetlbfs memory to get depleted.
-  while [ $(cat $path) != 0 ]; do
-    echo Waiting for hugetlb memory to get depleted.
-    cat $path
-    sleep 0.5
-  done
+
+  wait_for_file_value "$path" "0"
 }
 
 function wait_for_hugetlb_memory_to_get_reserved() {
   local cgroup="$1"
   local size="$2"
-
   local path="$cgroup_path/$cgroup/hugetlb.${MB}MB.$reservation_usage_file"
-  # Wait for hugetlbfs memory to get written.
-  while [ $(cat $path) != $size ]; do
-    echo Waiting for hugetlb memory reservation to reach size $size.
-    cat $path
-    sleep 0.5
-  done
+
+  wait_for_file_value "$path" "$size"
 }
 
 function wait_for_hugetlb_memory_to_get_written() {
   local cgroup="$1"
   local size="$2"
-
   local path="$cgroup_path/$cgroup/hugetlb.${MB}MB.$fault_usage_file"
-  # Wait for hugetlbfs memory to get written.
-  while [ $(cat $path) != $size ]; do
-    echo Waiting for hugetlb memory to reach size $size.
-    cat $path
-    sleep 0.5
-  done
+
+  wait_for_file_value "$path" "$size"
 }
 
 function write_hugetlbfs_and_get_usage() {
_

Patches currently in -mm which might be from liwang@redhat.com are

selftests-mm-write_to_hugetlbfs-parse-s-as-size_t.patch
selftests-mm-charge_reserved_hugetlb-drop-mount-size-for-hugetlbfs.patch
selftests-mm-charge_reserved_hugetlbsh-add-waits-with-timeout-helper.patch

