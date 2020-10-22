Return-Path: <SRS0=kBw3=D5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73F6EC388F9
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 22:50:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 221572245F
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 22:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603407032;
	bh=auBFNS/7z4CzGAZryrTyivWe1ILfQu9C7Ne9mHJShS0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=BHPUm250fPkGp7Yv6s2Qm31nFE4PbbLtwd0auuAOoFrs9CNOWXMhmK2wcZqBHowSL
	 HI6SzLiL/KA7EnsIDsQA4HrLBG8YpeIDxi3TXP8lKvtkBTII/9n5zHMEuk8q+12U5g
	 0457yB2Y73309/5d6CWQjT/OLYpXbYyHiIuTybMY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373096AbgJVWub (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Oct 2020 18:50:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:36298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S373094AbgJVWub (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Oct 2020 18:50:31 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 965C7221EB;
        Thu, 22 Oct 2020 22:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603407030;
        bh=auBFNS/7z4CzGAZryrTyivWe1ILfQu9C7Ne9mHJShS0=;
        h=Date:From:To:Subject:From;
        b=iUgiDWWzlr58ZepyW5Nt9cq8nggTFjjJj36H1oqNj65iIT5ZR1BU89h3CMcDOdoI8
         8MX8eyx41X/B2wlynExWo2yR2LcjNEntR7gTuIKQqX6UnCRyEafk3iPM5QIjfN/YEZ
         ag9AM6g2fFrIKN6CbBtPKiUm1XooxdMpWzbzEqKY=
Date:   Thu, 22 Oct 2020 15:50:30 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, jglisse@redhat.com, jhubbard@nvidia.com,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com, shuah@kernel.org
Subject:  [to-be-updated]
 selftests-vm-run_vmtestsh-update-and-clean-up-gup_test-invocation.patch
 removed from -mm tree
Message-ID: <20201022225030.rkcDwdymB%akpm@linux-foundation.org>
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
     selftests-vm-run_vmtestsh-update-and-clean-up-gup_test-invocation.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
=46rom: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/vm: run_vmtests.sh: update and clean up gup_test invocat=
ion

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

 tools/testing/selftests/vm/run_vmtests.sh |   24 +++++++++++++++-----
 1 file changed, 18 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/vm/run_vmtests.sh~selftests-vm-run_vmtestsh-u=
pdate-and-clean-up-gup_test-invocation
+++ a/tools/testing/selftests/vm/run_vmtests.sh
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


