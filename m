Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A183191CA
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966110; cv=none; b=eYS6Od0b+AvZSqg8G4huJz19FQohdG8GNClGsBgsCR7S2g6EvPc7zq91LMTN531p81ceSanoyfi0GazKw32rjgWy763Sg8/VXhF/SjDgyl5ly3nRaU5t5DKdjieJUINxh7CsgQC+/1MqzXf9ZTuU685LX0pgZePM60HVTY8+I+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966110; c=relaxed/simple;
	bh=x1/kh/nuHOTVhNGc3KThbWY9VA+n2E+NohKGXz5Js30=;
	h=Date:To:From:Subject:Message-Id; b=KLDHoE3pIonDankoRlncOUsax0tSNOJ+o3lwW/KM+JZR+KUF+uOjfgG0NszBAQQW3LwaOU8rrRXJviAcMq66Wdc1BryW9jCXlrSZVCPZ/DR9u+hUGhkZPna7gpqwgyGVTUPW6pqTkJY1/wR8xEbfPCXaTlRLC5Amai/VogTZyfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mCWu9esf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mCWu9esf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A44CC16AAE;
	Wed, 21 Jan 2026 03:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966110;
	bh=x1/kh/nuHOTVhNGc3KThbWY9VA+n2E+NohKGXz5Js30=;
	h=Date:To:From:Subject:From;
	b=mCWu9esfEpJ0/LcvAbIBXVi2fc+aEQbiZbhVtVSJaEiKqrAwJBcJ0D3+9D61Wplk9
	 iN3La1apH/OceWq45MxRtgkqKU8w4N1u/06e0pIxPoZWkMVYQ18C7zcbriJhBl6kJf
	 mSFqCTMxkvIYYVAj0+vSWHnBQBLy/3T/KJK9VjiM=
Date: Tue, 20 Jan 2026 19:28:29 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,longman@redhat.com,david@kernel.org,broonie@kernel.org,liwang@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-charge_reserved_hugetlbsh-add-waits-with-timeout-helper.patch removed from -mm tree
Message-Id: <20260121032830.0A44CC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm/charge_reserved_hugetlb.sh: add waits with timeout helper
has been removed from the -mm tree.  Its filename was
     selftests-mm-charge_reserved_hugetlbsh-add-waits-with-timeout-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li Wang <liwang@redhat.com>
Subject: selftests/mm/charge_reserved_hugetlb.sh: add waits with timeout helper
Date: Sun, 21 Dec 2025 20:26:39 +0800

The hugetlb cgroup usage wait loops in charge_reserved_hugetlb.sh were
unbounded and could hang forever if the expected cgroup file value never
appears (e.g.  due to write_to_hugetlbfs in Error mapping).

=== Error log ===
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
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
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


