Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87883C88CB5
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 20:50:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237691AbjFLUum (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 16:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238410AbjFLUtw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 16:49:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 429511BDA
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 13:47:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D916F629B3
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 20:46:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4E1C4339B;
        Mon, 12 Jun 2023 20:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686602776;
        bh=QT1zm5uZGkBCNr8pCrcwZTU6Lq0/o5bsUQ4yvGP76E0=;
        h=Date:To:From:Subject:From;
        b=cOz6Y+ceUn4p5zL2Qj/bvT+kF5wYtOzvUfaNezRATGhSAb4xP8JrVcFSRFUOGejXI
         v43OdvLVGhAj2yzLDrttTZqaXy7tYjhEuX7mGmnGZPDxsdfzG4oNg6ixoAChz3V6Mo
         RAJzAeeJa84cgy4k9yDDxLbpsLzuBF5mVLsMzKXY=
Date:   Mon, 12 Jun 2023 13:46:15 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, shr@devkernel.io,
        david@redhat.com, usama.anjum@collabora.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-remove-wrong-kernel-header-inclusion.patch added to mm-unstable branch
Message-Id: <20230612204616.3C4E1C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: mm: remove wrong kernel header inclusion
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-remove-wrong-kernel-header-inclusion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-remove-wrong-kernel-header-inclusion.patch

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
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests: mm: remove wrong kernel header inclusion
Date: Mon, 12 Jun 2023 14:53:46 +0500

It is wrong to include unprocessed user header files directly.  They are
processed to "<source_tree>/usr/include" by running "make headers" and
they are included in selftests by kselftest makefiles automatically with
help of KHDR_INCLUDES variable.  These headers should always bulilt first
before building kselftests.

Link: https://lkml.kernel.org/r/20230612095347.996335-1-usama.anjum@collabora.com
Fixes: 07115fcc15b4 ("selftests/mm: add new selftests for KSM")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Stefan Roesch <shr@devkernel.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/Makefile~selftests-mm-remove-wrong-kernel-header-inclusion
+++ a/tools/testing/selftests/mm/Makefile
@@ -29,7 +29,7 @@ MACHINE ?= $(shell echo $(uname_M) | sed
 # LDLIBS.
 MAKEFLAGS += --no-builtin-rules
 
-CFLAGS = -Wall -I $(top_srcdir) -I $(top_srcdir)/tools/include/uapi $(EXTRA_CFLAGS) $(KHDR_INCLUDES)
+CFLAGS = -Wall -I $(top_srcdir) $(EXTRA_CFLAGS) $(KHDR_INCLUDES)
 LDLIBS = -lrt -lpthread
 
 TEST_GEN_PROGS = cow
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-remove-wrong-kernel-header-inclusion.patch
selftests-mm-remove-duplicate-unneeded-defines.patch

