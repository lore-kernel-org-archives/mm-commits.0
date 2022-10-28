Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45964ECAAA1
	for <mm-commits@archiver.kernel.org>; Fri, 28 Oct 2022 21:48:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbiJ1VsL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Oct 2022 17:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiJ1VsK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2022 17:48:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A813024C10F
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 14:48:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6AAC5B82C12
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 21:48:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0599C433D6;
        Fri, 28 Oct 2022 21:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666993687;
        bh=mjcku2JAtUHZk4zwCGBkL2CSh6asOM5KZe0TuRifUTg=;
        h=Date:To:From:Subject:From;
        b=HCIaOhxBNkgDMGTm5VBI9gpZU8dax/E2yQIbOoDkQrNSQ3OpAbW/Vdf3i4V2pwUW2
         AKlYeSRMldAytoczyGXbGZKPpq+5fzamJemBLg9IUhWJRDITjRK63jfva+U/QX+9HD
         ASDSAKOiDD6F5DBb2fMqbS5QiLTaNHEFwCERiMhE=
Date:   Fri, 28 Oct 2022 14:48:05 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, npache@redhat.com,
        jsavitz@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-enable-running-select-groups-of-tests-fix.patch added to mm-unstable branch
Message-Id: <20221028214806.E0599C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: calculate variables in correct order
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-enable-running-select-groups-of-tests-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-enable-running-select-groups-of-tests-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Joel Savitz <jsavitz@redhat.com>
Subject: selftests/vm: calculate variables in correct order
Date: Fri, 28 Oct 2022 09:26:40 -0400

commit ("selftests/vm: enable running select groups of tests")
unintentionally reversed the ordering of some of the lines of
run_vmtests.sh that calculate values based on system configuration. 
Importantly, $hpgsize_MB is determined from $hpgsize_KB, but this later
value is not read from /proc/meminfo until later, causing userfaultfd
tests to incorrectly fail since $half_ufd_size_MB will always be 0.

Switch these statements around into proper order to fix the invocation of
the userfaultfd tests that use $half_ufd_size_MB.

Link: https://lkml.kernel.org/r/20221028132640.2791026-1-jsavitz@redhat.com
Signed-off-by: Joel Savitz <jsavitz@redhat.com>
Suggested-by: Nico Pache <npache@redhat.com>
Cc: Joel Savitz <jsavitz@redhat.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/tools/testing/selftests/vm/run_vmtests.sh~selftests-vm-enable-running-select-groups-of-tests-fix
+++ a/tools/testing/selftests/vm/run_vmtests.sh
@@ -82,16 +82,6 @@ test_selected() {
 	fi
 }
 
-# Simple hugetlbfs tests have a hardcoded minimum requirement of
-# huge pages totaling 256MB (262144KB) in size.  The userfaultfd
-# hugetlb test requires a minimum of 2 * nr_cpus huge pages.  Take
-# both of these requirements into account and attempt to increase
-# number of huge pages available.
-nr_cpus=$(nproc)
-hpgsize_MB=$((hpgsize_KB / 1024))
-half_ufd_size_MB=$((((nr_cpus * hpgsize_MB + 127) / 128) * 128))
-needmem_KB=$((half_ufd_size_MB * 2 * 1024))
-
 # get huge pagesize and freepages from /proc/meminfo
 while read -r name size unit; do
 	if [ "$name" = "HugePages_Free:" ]; then
@@ -102,6 +92,16 @@ while read -r name size unit; do
 	fi
 done < /proc/meminfo
 
+# Simple hugetlbfs tests have a hardcoded minimum requirement of
+# huge pages totaling 256MB (262144KB) in size.  The userfaultfd
+# hugetlb test requires a minimum of 2 * nr_cpus huge pages.  Take
+# both of these requirements into account and attempt to increase
+# number of huge pages available.
+nr_cpus=$(nproc)
+hpgsize_MB=$((hpgsize_KB / 1024))
+half_ufd_size_MB=$((((nr_cpus * hpgsize_MB + 127) / 128) * 128))
+needmem_KB=$((half_ufd_size_MB * 2 * 1024))
+
 # set proper nr_hugepages
 if [ -n "$freepgs" ] && [ -n "$hpgsize_KB" ]; then
 	nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
_

Patches currently in -mm which might be from jsavitz@redhat.com are

selftests-vm-enable-running-select-groups-of-tests.patch
selftests-vm-enable-running-select-groups-of-tests-fix.patch
selftests-vm-add-ksm-unmerge-tests-fix.patch

