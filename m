Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE2D7EB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:25:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbjFSXZO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbjFSXXb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:23:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8951985
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:22:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D952A60FAF
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:22:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F30CC433C0;
        Mon, 19 Jun 2023 23:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216963;
        bh=3VZJuz+bcgqoz6IadTwB6S/NgjEzSeYidNFBMKp0ZL4=;
        h=Date:To:From:Subject:From;
        b=lRKtbnFP0q0k0I9/C8u+C6l0sWiYSTIDN+USaEABLRSs5oUl62/gRtKCLhyf/2QNs
         urCamIa7WPoDqdIu62Vpn6D/G0Vee4PGZdEVnZPSVnx2R8sbeIfLt3WZGoK5AJK0eQ
         x4RiyxnciLoEuyk/kbKcV23+kQSOk/k44MBlIxqU=
Date:   Mon, 19 Jun 2023 16:22:42 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, shr@devkernel.io,
        david@redhat.com, usama.anjum@collabora.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-remove-wrong-kernel-header-inclusion.patch removed from -mm tree
Message-Id: <20230619232243.3F30CC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: mm: remove wrong kernel header inclusion
has been removed from the -mm tree.  Its filename was
     selftests-mm-remove-wrong-kernel-header-inclusion.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


