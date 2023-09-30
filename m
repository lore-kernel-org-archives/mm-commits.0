Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE599E7734B
	for <mm-commits@archiver.kernel.org>; Sat, 30 Sep 2023 00:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233970AbjI3AVn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Sep 2023 20:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233929AbjI3AVb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Sep 2023 20:21:31 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA8E21B5;
        Fri, 29 Sep 2023 17:21:28 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869A4C433CC;
        Sat, 30 Sep 2023 00:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696033288;
        bh=MeQMMsZ8qk62I/hyQDThFgnjl1Y7BUpLYvqWlVqNGgs=;
        h=Date:To:From:Subject:From;
        b=uTuY4gdDS/Z+grY/qBUGEqA5nNNG/HGxDweV272L3dPOkRtga8H0PZoMWOvuOh3RX
         0bd4nf2KxLBY50f0J7GotHQv+6aneZFNhykeeOvk3eDUqBu1IqwDjUv+M/omqaPWmm
         D/2H07OJBYy3LDymNAhTPvoaC+ParG0DJtmszLK0=
Date:   Fri, 29 Sep 2023 17:21:28 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        shuah@kernel.org, juntong.deng@outlook.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-fix-awk-usage-in-charge_reserved_hugetlbsh-and-hugetlb_reparenting_testsh-that-may-cause-error.patch removed from -mm tree
Message-Id: <20230930002128.869A4C433CC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: fix awk usage in charge_reserved_hugetlb.sh and hugetlb_reparenting_test.sh that may cause error
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-awk-usage-in-charge_reserved_hugetlbsh-and-hugetlb_reparenting_testsh-that-may-cause-error.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Juntong Deng <juntong.deng@outlook.com>
Subject: selftests/mm: fix awk usage in charge_reserved_hugetlb.sh and hugetlb_reparenting_test.sh that may cause error
Date: Wed, 27 Sep 2023 02:19:44 +0800

According to the awk manual, the -e option does not need to be specified
in front of 'program' (unless you need to mix program-file).

The redundant -e option can cause error when users use awk tools other
than gawk (for example, mawk does not support the -e option).

Error Example:
awk: not an option: -e

Link: https://lkml.kernel.org/r/VI1P193MB075228810591AF2FDD7D42C599C3A@VI1P193MB0752.EURP193.PROD.OUTLOOK.COM
Signed-off-by: Juntong Deng <juntong.deng@outlook.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/charge_reserved_hugetlb.sh  |    4 ++--
 tools/testing/selftests/mm/hugetlb_reparenting_test.sh |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh~selftests-mm-fix-awk-usage-in-charge_reserved_hugetlbsh-and-hugetlb_reparenting_testsh-that-may-cause-error
+++ a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -25,7 +25,7 @@ if [[ "$1" == "-cgroup-v2" ]]; then
 fi
 
 if [[ $cgroup2 ]]; then
-  cgroup_path=$(mount -t cgroup2 | head -1 | awk -e '{print $3}')
+  cgroup_path=$(mount -t cgroup2 | head -1 | awk '{print $3}')
   if [[ -z "$cgroup_path" ]]; then
     cgroup_path=/dev/cgroup/memory
     mount -t cgroup2 none $cgroup_path
@@ -33,7 +33,7 @@ if [[ $cgroup2 ]]; then
   fi
   echo "+hugetlb" >$cgroup_path/cgroup.subtree_control
 else
-  cgroup_path=$(mount -t cgroup | grep ",hugetlb" | awk -e '{print $3}')
+  cgroup_path=$(mount -t cgroup | grep ",hugetlb" | awk '{print $3}')
   if [[ -z "$cgroup_path" ]]; then
     cgroup_path=/dev/cgroup/memory
     mount -t cgroup memory,hugetlb $cgroup_path
--- a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh~selftests-mm-fix-awk-usage-in-charge_reserved_hugetlbsh-and-hugetlb_reparenting_testsh-that-may-cause-error
+++ a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
@@ -20,7 +20,7 @@ fi
 
 
 if [[ $cgroup2 ]]; then
-  CGROUP_ROOT=$(mount -t cgroup2 | head -1 | awk -e '{print $3}')
+  CGROUP_ROOT=$(mount -t cgroup2 | head -1 | awk '{print $3}')
   if [[ -z "$CGROUP_ROOT" ]]; then
     CGROUP_ROOT=/dev/cgroup/memory
     mount -t cgroup2 none $CGROUP_ROOT
@@ -28,7 +28,7 @@ if [[ $cgroup2 ]]; then
   fi
   echo "+hugetlb +memory" >$CGROUP_ROOT/cgroup.subtree_control
 else
-  CGROUP_ROOT=$(mount -t cgroup | grep ",hugetlb" | awk -e '{print $3}')
+  CGROUP_ROOT=$(mount -t cgroup | grep ",hugetlb" | awk '{print $3}')
   if [[ -z "$CGROUP_ROOT" ]]; then
     CGROUP_ROOT=/dev/cgroup/memory
     mount -t cgroup memory,hugetlb $CGROUP_ROOT
_

Patches currently in -mm which might be from juntong.deng@outlook.com are


