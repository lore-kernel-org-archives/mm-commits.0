Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A376CC49EBB
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7804F22CAE
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbgLPAAA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:00:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:34570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726361AbgLOX0l (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:26:41 -0500
Date:   Tue, 15 Dec 2020 15:17:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074239;
        bh=E9xw57Gdp/00PwZkxE+6zZT3m8gFS1+RdGwjkxiwByY=;
        h=From:To:Subject:From;
        b=1vsffxOdn9VIhUgQsqj2jmW+izuWo0IRlVKdjE4rsyM64u6e4sEeXsOYsjxgQh5RH
         zV+3V2VSsiUL7x4aH08gWwzexYIj5OLZdIu2P0v9Tj8n09+R9Yam1vilsXt/Vn47/0
         sbyChAP0N983QH9tCdFrl+ENGccq/x/7mPvdITcw=
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, jglisse@redhat.com, jhubbard@nvidia.com,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com, shuah@kernel.org
Subject:  [merged]
 selftests-vm-run_vmtestssh-update-and-clean-up-gup_test-invocation.patch
 removed from -mm tree
Message-ID: <20201215231719.al3JNQkpx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: run_vmtests.sh: update and clean up gup_test in=
vocation
has been removed from the -mm tree.  Its filename was
     selftests-vm-run_vmtestssh-update-and-clean-up-gup_test-invocation.pat=
ch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/vm: run_vmtests.sh: update and clean up gup_test invocat=
ion

Run benchmarks on the _fast variants of gup and pup, as originally
intended.

Run the new gup_test sub-test: dump pages.  In addition to exercising the
dump_page() call, it also demonstrates the various options you can use to
specify which pages to dump, and how.

Link: https://lkml.kernel.org/r/20201026064021.3545418-8-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/run_vmtests |   28 ++++++++++++++++-------
 1 file changed, 20 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/vm/run_vmtests~selftests-vm-run_vmtestssh-upd=
ate-and-clean-up-gup_test-invocation
+++ a/tools/testing/selftests/vm/run_vmtests
@@ -123,10 +123,10 @@ else
 	echo "[PASS]"
 fi
=20
-echo "--------------------------------------------"
-echo "running 'gup_test -U' (normal/slow gup)"
-echo "--------------------------------------------"
-./gup_test -U
+echo "------------------------------------------------------"
+echo "running: gup_test -u # get_user_pages_fast() benchmark"
+echo "------------------------------------------------------"
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
+echo "------------------------------------------------------"
+echo "running: gup_test -a # pin_user_pages_fast() benchmark"
+echo "------------------------------------------------------"
+./gup_test -a
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+	exitcode=3D1
+else
+	echo "[PASS]"
+fi
+
+echo "------------------------------------------------------------"
+echo "# Dump pages 0, 19, and 4096, using pin_user_pages:"
+echo "running: gup_test -ct -F 0x1 0 19 0x1000 # dump_page() test"
+echo "------------------------------------------------------------"
+./gup_test -ct -F 0x1 0 19 0x1000
 if [ $? -ne 0 ]; then
 	echo "[FAIL]"
 	exitcode=3D1
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

secretmem-test-add-basic-selftest-for-memfd_secret2-fix.patch

