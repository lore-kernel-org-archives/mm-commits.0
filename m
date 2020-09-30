Return-Path: <SRS0=jIyd=DH=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E009CC4727F
	for <mm-commits@archiver.kernel.org>; Wed, 30 Sep 2020 22:52:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9A1B2072E
	for <mm-commits@archiver.kernel.org>; Wed, 30 Sep 2020 22:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601506337;
	bh=3YV+yFTJ7D0yebIGtYI//YQE1SRB3h+l8mJjOlSpDqA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=itjjjihGwFYineIqfBuh8XPCCRsJhlQSyrhv82IyG7ey/Y17P0BVZaflD77lm/aJe
	 5Bg0MXMcAsne9OYdMDYS6pVbDymCZ9RGkPnHGsj6ByFNBzclOpfjOWQMAhLIQWAyFx
	 CMHzhlHjls3JyP2n/UA11QTMx6SfEmwaOcF66UzE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731920AbgI3WwR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Sep 2020 18:52:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:60086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731913AbgI3WwP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Sep 2020 18:52:15 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBC762072E;
        Wed, 30 Sep 2020 22:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601506335;
        bh=3YV+yFTJ7D0yebIGtYI//YQE1SRB3h+l8mJjOlSpDqA=;
        h=Date:From:To:Subject:From;
        b=QYe77RfN+Bz9YHmtvptwYi/z08x56LYGK70jkJv9h//qBQwcB82bllc3B94JUsu2o
         DGFnlLxnD24AGzps1C3CaJUD24+qK5j6pJ896xeyMWll6hdUJjNZHzoscRaNI7T8SM
         NgtKCGuemYBgHognpkFd5fU8R1UjXprpafQ4GvBU=
Date:   Wed, 30 Sep 2020 15:52:14 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, jglisse@redhat.com, jhubbard@nvidia.com,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com, shuah@kernel.org
Subject:  +
 selftests-vm-run_vmtestsh-update-and-clean-up-gup_test-invocation.patch
 added to -mm tree
Message-ID: <20200930225214.iLyK9Ff-9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: run_vmtest.sh: update and clean up gup_test inv=
ocation
has been added to the -mm tree.  Its filename is
     selftests-vm-run_vmtestsh-update-and-clean-up-gup_test-invocation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-run_vmtestsh-upd=
ate-and-clean-up-gup_test-invocation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-run_vmtestsh-upd=
ate-and-clean-up-gup_test-invocation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/vm: run_vmtest.sh: update and clean up gup_test invocati=
on

Run benchmarks on the _fast variants of gup and pup, as originally
intended.

Run the new gup_test sub-test: dump pages.  In addition to exercising the
dump_page() call, it also demonstrates the various options you can use to
specify which pages to dump, and how.

Link: https://lkml.kernel.org/r/20200929212747.251804-8-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/run_vmtest.sh |   24 +++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/vm/run_vmtest.sh~selftests-vm-run_vmtestsh-up=
date-and-clean-up-gup_test-invocation
+++ a/tools/testing/selftests/vm/run_vmtest.sh
@@ -124,9 +124,9 @@ else
 fi
=20
 echo "--------------------------------------------"
-echo "running 'gup_test -U' (normal/slow gup)"
+echo "running 'gup_test -u' (fast gup benchmark)"
 echo "--------------------------------------------"
-./gup_test -U
+./gup_test -u
 if [ $? -ne 0 ]; then
 	echo "[FAIL]"
 	exitcode=3D1
@@ -134,10 +134,22 @@ else
 	echo "[PASS]"
 fi
=20
-echo "------------------------------------------"
-echo "running gup_test -b (pin_user_pages)"
-echo "------------------------------------------"
-./gup_test -b
+echo "---------------------------------------------------"
+echo "running gup_test -a (pin_user_pages_fast benchmark)"
+echo "---------------------------------------------------"
+./gup_test -a
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+	exitcode=3D1
+else
+	echo "[PASS]"
+fi
+
+echo "--------------------------------------------------------------"
+echo "running gup_test -ct -F 0x1 0 19 0x1000"
+echo "   Dumps pages 0, 19, and 4096, using pin_user_pages (-F 0x1)"
+echo "--------------------------------------------------------------"
+./gup_test -ct -F 0x1 0 19 0x1000
 if [ $? -ne 0 ]; then
 	echo "[FAIL]"
 	exitcode=3D1
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-dump_page-rename-head_mapcount-head_compound_mapcount.patch
mm-gup-protect-unpin_user_pages-against-npages=3D=3D-errno.patch
selftests-vm-fix-false-build-success-on-the-second-and-later-attempts.patch
selftests-vm-fix-incorrect-gcc-invocation-in-some-cases.patch
mm-gup_benchmark-rename-to-mm-gup_test.patch
selftests-vm-use-a-common-gup_testh.patch
selftests-vm-rename-run_vmtests-run_vmtestssh.patch
selftests-vm-minor-cleanup-makefile-and-gup_testc.patch
selftests-vm-only-some-gup_test-items-are-really-benchmarks.patch
selftests-vm-gup_test-introduce-the-dump_pages-sub-test.patch
selftests-vm-run_vmtestsh-update-and-clean-up-gup_test-invocation.patch
selftests-vm-hmm-tests-remove-the-libhugetlbfs-dependency.patch

