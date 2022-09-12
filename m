Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D555EECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:29:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiILD3A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiILD2v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:28:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4899D275E9
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:28:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD2F160CFB
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:28:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B70C433D6;
        Mon, 12 Sep 2022 03:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953313;
        bh=IOdIEjSOTkW1KapFAua2TbJdjd5B9UPfQ5dYtPvXjcM=;
        h=Date:To:From:Subject:From;
        b=mATWYFU5hrDJ6aJ290GOrrWYXE/YFngBUSlMMe5k3dSw3hANfzGOKa4WEJAPVRlzH
         5Z17OomHoRn4M6XmvNK2i46ZDO6nEbHeU8P9xJAy2xrbHW5KVRugXp+7yUoXaOobRH
         D0v/5FU2i5DHVHruj79M8hCiNh17CXDvpbdt/L80=
Date:   Sun, 11 Sep 2022 20:28:32 -0700
To:     mm-commits@vger.kernel.org, yi.zhang@huawei.com,
        viro@zeniv.linux.org.uk, vbabka@suse.cz, surenb@google.com,
        skhan@linuxfoundation.org, shuah@kernel.org, rppt@linux.ibm.com,
        rppt@kernel.org, peterx@redhat.com, namit@vmware.com,
        mike.kravetz@oracle.com, mgorman@techsingularity.net,
        ldv@altlinux.org, jack@suse.cz, hughd@google.com,
        glebfm@altlinux.org, dave.hansen@linux.intel.com, corbet@lwn.net,
        axelrasmussen@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-vm-add-dev-userfaultfd-test-cases-to-run_vmtestssh.patch removed from -mm tree
Message-Id: <20220912032833.29B70C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: vm: add /dev/userfaultfd test cases to run_vmtests.sh
has been removed from the -mm tree.  Its filename was
     selftests-vm-add-dev-userfaultfd-test-cases-to-run_vmtestssh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: selftests: vm: add /dev/userfaultfd test cases to run_vmtests.sh
Date: Mon, 8 Aug 2022 10:56:14 -0700

This new mode was recently added to the userfaultfd selftest. We want to
exercise both userfaultfd(2) as well as /dev/userfaultfd, so add both
test cases to the script.

Link: https://lkml.kernel.org/r/20220808175614.3885028-6-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dmitry V. Levin <ldv@altlinux.org>
Cc: Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nadav Amit <namit@vmware.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zhang Yi <yi.zhang@huawei.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/run_vmtests.sh |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/vm/run_vmtests.sh~selftests-vm-add-dev-userfaultfd-test-cases-to-run_vmtestssh
+++ a/tools/testing/selftests/vm/run_vmtests.sh
@@ -120,13 +120,16 @@ run_test ./gup_test -a
 # Dump pages 0, 19, and 4096, using pin_user_pages:
 run_test ./gup_test -ct -F 0x1 0 19 0x1000
 
-run_test ./userfaultfd anon 20 16
-# Hugetlb tests require source and destination huge pages. Pass in half the
-# size ($half_ufd_size_MB), which is used for *each*.
-run_test ./userfaultfd hugetlb "$half_ufd_size_MB" 32
-run_test ./userfaultfd hugetlb_shared "$half_ufd_size_MB" 32 "$mnt"/uffd-test
-rm -f "$mnt"/uffd-test
-run_test ./userfaultfd shmem 20 16
+uffd_mods=("" ":dev")
+for mod in "${uffd_mods[@]}"; do
+	run_test ./userfaultfd anon${mod} 20 16
+	# Hugetlb tests require source and destination huge pages. Pass in half
+	# the size ($half_ufd_size_MB), which is used for *each*.
+	run_test ./userfaultfd hugetlb${mod} "$half_ufd_size_MB" 32
+	run_test ./userfaultfd hugetlb_shared${mod} "$half_ufd_size_MB" 32 "$mnt"/uffd-test
+	rm -f "$mnt"/uffd-test
+	run_test ./userfaultfd shmem${mod} 20 16
+done
 
 #cleanup
 umount "$mnt"
_

Patches currently in -mm which might be from axelrasmussen@google.com are


