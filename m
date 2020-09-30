Return-Path: <SRS0=jIyd=DH=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32387C4741F
	for <mm-commits@archiver.kernel.org>; Wed, 30 Sep 2020 22:52:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E766B20B1F
	for <mm-commits@archiver.kernel.org>; Wed, 30 Sep 2020 22:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601506324;
	bh=7CAgr4YXQrRvZvfWd/e2tCpV6lWmI0XzBPgWmvElygM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=h7ZDpm4v6veokN1BXpgvLwVbkLTtVK2VAyhn6EuBi3MTtXFxE0v4W2NnieGK2XG0w
	 zQxInbEVgyYVWAF8AUQkgUwVg4s2WNW7i1EeEcrtIvUiP+hQu0rU2XFp2+qmjcv7/Y
	 7DAtU/Fqi6TQjY8tCtQnyzD306IzR9TYajETa/z0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731808AbgI3WwE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Sep 2020 18:52:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:59928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731912AbgI3WwD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Sep 2020 18:52:03 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4B8C20719;
        Wed, 30 Sep 2020 22:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601506323;
        bh=7CAgr4YXQrRvZvfWd/e2tCpV6lWmI0XzBPgWmvElygM=;
        h=Date:From:To:Subject:From;
        b=xmRbCoBdvMo0CR0VvDqzoKkdLM8OZsy2ML5mUBNgjncilJlYVA1911Jl/t6qp+S+i
         x5tCqOLcSPeNXWx7Sv76qBdx6cqSLPTA0uo/PFHwuluZLvACfTYDScU2RFA7fuJq1v
         U3vt7qTWu3C8zNOPILZlW16+OzsZbN6LH+5n8VlE=
Date:   Wed, 30 Sep 2020 15:52:02 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, jglisse@redhat.com, jhubbard@nvidia.com,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com, shuah@kernel.org
Subject:  + selftests-vm-rename-run_vmtests-run_vmtestssh.patch
 added to -mm tree
Message-ID: <20200930225202.NJCvt9toX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: rename run_vmtests --> run_vmtests.sh
has been added to the -mm tree.  Its filename is
     selftests-vm-rename-run_vmtests-run_vmtestssh.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-rename-run_vmtes=
ts-run_vmtestssh.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-rename-run_vmtes=
ts-run_vmtestssh.patch

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
Subject: selftests/vm: rename run_vmtests --> run_vmtests.sh

Rename to *.sh, in order to match the conventions of all of the other
items in selftest/vm.

The only reason not to use a .sh suffix a shell script like this, might be
to make it look more like a normal program, but that's not an issue here.

Link: https://lkml.kernel.org/r/20200929212747.251804-4-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/Makefile~selftests-vm-rename-run_vmtests-r=
un_vmtestssh
+++ a/tools/testing/selftests/vm/Makefile
@@ -69,7 +69,7 @@ TEST_GEN_FILES +=3D virtual_address_range
 TEST_GEN_FILES +=3D write_to_hugetlbfs
 endif
=20
-TEST_PROGS :=3D run_vmtests
+TEST_PROGS :=3D run_vmtests.sh
=20
 TEST_FILES :=3D test_vmalloc.sh
=20
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

