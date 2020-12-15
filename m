Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B8C5C2BB48
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:34:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B542223D6
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:34:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgLODd4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:33:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:33812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727046AbgLODFw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:05:52 -0500
Date:   Mon, 14 Dec 2020 19:05:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001512;
        bh=0QVCh/c6irN8m/tEnMHQetV4SqhBqlzJzjKKzXv2rKE=;
        h=From:To:Subject:In-Reply-To:From;
        b=RyQZgrwbA6TiKjlF3vwFTCD96qGS+hcE4tVY4OXZThipq9vZuib7YFM+3sETz+YLI
         dN4Ekd5Bn3Npt2lacCHg5XnhNJswZjnP5pBaTattGNzA+OKMzVNMiV6LN0ELaiwftY
         8dN4FVUgXlN+ZvPieQXu6J3xaLc7+SQlbSZHOYOo=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, jglisse@redhat.com,
        jhubbard@nvidia.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com, shuah@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 034/200] selftests/vm: rename run_vmtests -->
 run_vmtests.sh
Message-ID: <20201215030511.ij1We8F91%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/vm: rename run_vmtests --> run_vmtests.sh

Rename to *.sh, in order to match the conventions of all of the other
items in selftest/vm.

The only reason not to use a .sh suffix a shell script like this, might be
to make it look more like a normal program, but that's not an issue here.

Link: https://lkml.kernel.org/r/20201026064021.3545418-4-jhubbard@nvidia.com
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
@@ -73,7 +73,7 @@ TEST_GEN_FILES +=3D virtual_address_range
 TEST_GEN_FILES +=3D write_to_hugetlbfs
 endif
=20
-TEST_PROGS :=3D run_vmtests
+TEST_PROGS :=3D run_vmtests.sh
=20
 TEST_FILES :=3D test_vmalloc.sh
=20
_
