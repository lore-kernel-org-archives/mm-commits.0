Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A148CC678D6
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:22:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbjASBWR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:22:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbjASBUJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:20:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF936842C
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:16:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB2FEB81FB6
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:16:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90EA5C433D2;
        Thu, 19 Jan 2023 01:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674091015;
        bh=76FHgZwKO7Wab4CF1FpdJnrCaDAAbOr3KrJFaS0cvRc=;
        h=Date:To:From:Subject:From;
        b=KpFvhE9JH3/p6B9tBXsQe/hp/UYuSBHjJrWMCb8c3Dld+xRKoTn48uoXckvCx5QSe
         CF4FAQ9i/DwjiqA/IQO7IMSIh8v/36ulpKNAJwl2ACfbLIivf08MsE3XPQf1K0mNAL
         PaPSbN9Xc/WNhZjxs3gg5eATMM31m2dL8fPoBzWw=
Date:   Wed, 18 Jan 2023 17:16:55 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, bjorn@rivosinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-vm-enable-cross-compilation.patch removed from -mm tree
Message-Id: <20230119011655.90EA5C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: vm: enable cross-compilation
has been removed from the -mm tree.  Its filename was
     selftests-vm-enable-cross-compilation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Björn Töpel <bjorn@rivosinc.com>
Subject: selftests: vm: enable cross-compilation
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
@@ -5,7 +5,11 @@ LOCAL_HDRS += $(selfdir)/mm/local_config
 
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


