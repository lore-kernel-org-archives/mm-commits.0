Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81CFEC5479D
	for <mm-commits@archiver.kernel.org>; Mon,  9 Jan 2023 23:54:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjAIXyW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Jan 2023 18:54:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234368AbjAIXyT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2023 18:54:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EDE6DFCC
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 15:54:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40FDBB80AD5
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 23:54:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA96BC433D2;
        Mon,  9 Jan 2023 23:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673308455;
        bh=/9FusseJV5hEARijy2jXasQKFSNdYjBa/NQfhWug3Ys=;
        h=Date:To:From:Subject:From;
        b=VLt/24De6lGFkv5/hzaX2Ump+aEZJuR2hiMCBwSdsR3m7U+M2CnWUIw67gTt0jlCO
         GoBo3i0iN2QbUKGHP4872F6/lgRJXCSsI+2UNu0kwcqWC6MXIbamCo23jpJrOsH/5U
         P0rJlCenJeamNaWBlDR6y+AGxtO/0+FQuKlLJ96Q=
Date:   Mon, 09 Jan 2023 15:54:15 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, bjorn@rivosinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-enable-cross-compilation.patch added to mm-nonmm-unstable branch
Message-Id: <20230109235415.CA96BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: vm: Enable cross-compilation
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-vm-enable-cross-compilation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-enable-cross-compilation.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Björn Töpel <bjorn@rivosinc.com>
Subject: selftests: vm: Enable cross-compilation
Date: Mon, 9 Jan 2023 12:42:51 +0100

Selftests vm builds break when doing cross-compilation.  The Makefile
MACHINE variable incorrectly picks upp the host machine architecture.

If the CROSS_COMPILE variable is set, dig out the target host architecture
from CROSS_COMPILE, instead of calling uname.

Link: https://lkml.kernel.org/r/20230109114251.3349638-1-bjorn@kernel.org
Signed-off-by: Björn Töpel <bjorn@rivosinc.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile |    4 ++++
 1 file changed, 4 insertions(+)

--- a/tools/testing/selftests/mm/Makefile~selftests-vm-enable-cross-compilation
+++ a/tools/testing/selftests/mm/Makefile
@@ -5,7 +5,11 @@ LOCAL_HDRS += $(selfdir)/vm/local_config
 
 include local_config.mk
 
+ifeq ($(CROSS_COMPILE),)
 uname_M := $(shell uname -m 2>/dev/null || echo not)
+else
+uname_M := $(shell echo $(CROSS_COMPILE) | grep -o '^[a-z0-9]\+')
+endif
 MACHINE ?= $(shell echo $(uname_M) | sed -e 's/aarch64.*/arm64/' -e 's/ppc64.*/ppc64/')
 
 # Without this, failed build products remain, with up-to-date timestamps,
_

Patches currently in -mm which might be from bjorn@rivosinc.com are

selftests-vm-enable-cross-compilation.patch

