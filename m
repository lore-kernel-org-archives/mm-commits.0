Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F47BC2BBC7
	for <mm-commits@archiver.kernel.org>; Mon, 10 Jan 2022 21:19:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241502AbiAJVTz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 Jan 2022 16:19:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240732AbiAJVTv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jan 2022 16:19:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04CA7C06173F
        for <mm-commits@vger.kernel.org>; Mon, 10 Jan 2022 13:19:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 890A161470
        for <mm-commits@vger.kernel.org>; Mon, 10 Jan 2022 21:19:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C632FC36AE3;
        Mon, 10 Jan 2022 21:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1641849590;
        bh=TxQEWSU9r+ZtnV/hWCldZ8lJmkQ6Se61bIAWFD81PbU=;
        h=Date:From:To:Subject:From;
        b=kPHdi6cFgx1qRGXJSO7vQHgAh/zNoWD808VHJ0Ib7VMpTVrXB/zSNJ0TX5LYvDXSf
         fwGoCkxbR+7Ij8lGgI0qG1itxLw64ejehg0X8m1lZDlIdl5oDnJEomGxVFZasRazmM
         sGTfkO6cZCfA4ngngVJ8FwWlXvDq/FyN0pqxgVTU=
Date:   Mon, 10 Jan 2022 13:19:49 -0800
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, longman@redhat.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        shuah@kernel.org
Subject:  +
 =?US-ASCII?Q?selftests-vm-make-charge=5Freserved=5Fhugetlbsh-work-with-e?=
 =?US-ASCII?Q?xisting-cgroup-setting.patch?= added to -mm tree
Message-ID: <20220110211949.8GEZTlOd_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: make charge_reserved_hugetlb.sh work with existing cgroup setting
has been added to the -mm tree.  Its filename is
     selftests-vm-make-charge_reserved_hugetlbsh-work-with-existing-cgroup-setting.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-make-charge_reserved_hugetlbsh-work-with-existing-cgroup-setting.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-make-charge_reserved_hugetlbsh-work-with-existing-cgroup-setting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: selftests/vm: make charge_reserved_hugetlb.sh work with existing cgroup setting

The hugetlb cgroup reservation test charge_reserved_hugetlb.sh assume that
no cgroup filesystems are mounted before running the test.  That is not
true in many cases.  As a result, the test fails to run.  Fix that by
querying the current cgroup mount setting and using the existing cgroup
setup instead before attempting to freshly mount a cgroup filesystem.

Similar change is also made for hugetlb_reparenting_test.sh as well,
though it still has problem if cgroup v2 isn't used.

The patched test scripts were run on a centos 8 based system to verify
that they ran properly.

Link: https://lkml.kernel.org/r/20220106201359.1646575-1-longman@redhat.com
Fixes: 29750f71a9b4 ("hugetlb_cgroup: add hugetlb_cgroup reservation tests")
Signed-off-by: Waiman Long <longman@redhat.com>
Acked-by: Mina Almasry <almasrymina@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/charge_reserved_hugetlb.sh  |   34 +++++-----
 tools/testing/selftests/vm/hugetlb_reparenting_test.sh |   21 +++---
 tools/testing/selftests/vm/write_hugetlb_memory.sh     |    2 
 3 files changed, 34 insertions(+), 23 deletions(-)

--- a/tools/testing/selftests/vm/charge_reserved_hugetlb.sh~selftests-vm-make-charge_reserved_hugetlbsh-work-with-existing-cgroup-setting
+++ a/tools/testing/selftests/vm/charge_reserved_hugetlb.sh
@@ -24,19 +24,23 @@ if [[ "$1" == "-cgroup-v2" ]]; then
   reservation_usage_file=rsvd.current
 fi
 
-cgroup_path=/dev/cgroup/memory
-if [[ ! -e $cgroup_path ]]; then
-  mkdir -p $cgroup_path
-  if [[ $cgroup2 ]]; then
+if [[ $cgroup2 ]]; then
+  cgroup_path=$(mount -t cgroup2 | head -1 | awk -e '{print $3}')
+  if [[ -z "$cgroup_path" ]]; then
+    cgroup_path=/dev/cgroup/memory
     mount -t cgroup2 none $cgroup_path
-  else
+    do_umount=1
+  fi
+  echo "+hugetlb" >$cgroup_path/cgroup.subtree_control
+else
+  cgroup_path=$(mount -t cgroup | grep ",hugetlb" | awk -e '{print $3}')
+  if [[ -z "$cgroup_path" ]]; then
+    cgroup_path=/dev/cgroup/memory
     mount -t cgroup memory,hugetlb $cgroup_path
+    do_umount=1
   fi
 fi
-
-if [[ $cgroup2 ]]; then
-  echo "+hugetlb" >/dev/cgroup/memory/cgroup.subtree_control
-fi
+export cgroup_path
 
 function cleanup() {
   if [[ $cgroup2 ]]; then
@@ -108,7 +112,7 @@ function setup_cgroup() {
 
 function wait_for_hugetlb_memory_to_get_depleted() {
   local cgroup="$1"
-  local path="/dev/cgroup/memory/$cgroup/hugetlb.${MB}MB.$reservation_usage_file"
+  local path="$cgroup_path/$cgroup/hugetlb.${MB}MB.$reservation_usage_file"
   # Wait for hugetlbfs memory to get depleted.
   while [ $(cat $path) != 0 ]; do
     echo Waiting for hugetlb memory to get depleted.
@@ -121,7 +125,7 @@ function wait_for_hugetlb_memory_to_get_
   local cgroup="$1"
   local size="$2"
 
-  local path="/dev/cgroup/memory/$cgroup/hugetlb.${MB}MB.$reservation_usage_file"
+  local path="$cgroup_path/$cgroup/hugetlb.${MB}MB.$reservation_usage_file"
   # Wait for hugetlbfs memory to get written.
   while [ $(cat $path) != $size ]; do
     echo Waiting for hugetlb memory reservation to reach size $size.
@@ -134,7 +138,7 @@ function wait_for_hugetlb_memory_to_get_
   local cgroup="$1"
   local size="$2"
 
-  local path="/dev/cgroup/memory/$cgroup/hugetlb.${MB}MB.$fault_usage_file"
+  local path="$cgroup_path/$cgroup/hugetlb.${MB}MB.$fault_usage_file"
   # Wait for hugetlbfs memory to get written.
   while [ $(cat $path) != $size ]; do
     echo Waiting for hugetlb memory to reach size $size.
@@ -574,5 +578,7 @@ for populate in "" "-o"; do
   done     # populate
 done       # method
 
-umount $cgroup_path
-rmdir $cgroup_path
+if [[ $do_umount ]]; then
+  umount $cgroup_path
+  rmdir $cgroup_path
+fi
--- a/tools/testing/selftests/vm/hugetlb_reparenting_test.sh~selftests-vm-make-charge_reserved_hugetlbsh-work-with-existing-cgroup-setting
+++ a/tools/testing/selftests/vm/hugetlb_reparenting_test.sh
@@ -18,19 +18,24 @@ if [[ "$1" == "-cgroup-v2" ]]; then
   usage_file=current
 fi
 
-CGROUP_ROOT='/dev/cgroup/memory'
-MNT='/mnt/huge/'
 
-if [[ ! -e $CGROUP_ROOT ]]; then
-  mkdir -p $CGROUP_ROOT
-  if [[ $cgroup2 ]]; then
+if [[ $cgroup2 ]]; then
+  CGROUP_ROOT=$(mount -t cgroup2 | head -1 | awk -e '{print $3}')
+  if [[ -z "$CGROUP_ROOT" ]]; then
+    CGROUP_ROOT=/dev/cgroup/memory
     mount -t cgroup2 none $CGROUP_ROOT
-    sleep 1
-    echo "+hugetlb +memory" >$CGROUP_ROOT/cgroup.subtree_control
-  else
+    do_umount=1
+  fi
+  echo "+hugetlb +memory" >$CGROUP_ROOT/cgroup.subtree_control
+else
+  CGROUP_ROOT=$(mount -t cgroup | grep ",hugetlb" | awk -e '{print $3}')
+  if [[ -z "$CGROUP_ROOT" ]]; then
+    CGROUP_ROOT=/dev/cgroup/memory
     mount -t cgroup memory,hugetlb $CGROUP_ROOT
+    do_umount=1
   fi
 fi
+MNT='/mnt/huge/'
 
 function get_machine_hugepage_size() {
   hpz=$(grep -i hugepagesize /proc/meminfo)
--- a/tools/testing/selftests/vm/write_hugetlb_memory.sh~selftests-vm-make-charge_reserved_hugetlbsh-work-with-existing-cgroup-setting
+++ a/tools/testing/selftests/vm/write_hugetlb_memory.sh
@@ -14,7 +14,7 @@ want_sleep=$8
 reserve=$9
 
 echo "Putting task in cgroup '$cgroup'"
-echo $$ > /dev/cgroup/memory/"$cgroup"/cgroup.procs
+echo $$ > ${cgroup_path:-/dev/cgroup/memory}/"$cgroup"/cgroup.procs
 
 echo "Method is $method"
 
_

Patches currently in -mm which might be from longman@redhat.com are

selftests-vm-make-charge_reserved_hugetlbsh-work-with-existing-cgroup-setting.patch

