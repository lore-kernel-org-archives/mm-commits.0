Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 180FBEB64DB
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:20:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjFSXUq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjFSXUc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:20:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99678F9
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:20:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CDDF60F0D
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8796AC433C0;
        Mon, 19 Jun 2023 23:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216830;
        bh=YRJY++ME/jiCUocBeh5V900NQn6PtrA2FNSwkFBQ6PU=;
        h=Date:To:From:Subject:From;
        b=x1NO5w5WCuUeXSeLEbQiegNuzJa53src050RstWs3xMB3b8j55KMkmMQWzBkHw6dv
         KxapBj92eCJoMe5+/uMcgsM3vdpzRazVNuHkDsTRG0Q+cm3GKxRWAcP1NzughiB/hW
         9ll2u9iDDryP2WXT+/DUF0lsvZpHORnbPykMdD7o=
Date:   Mon, 19 Jun 2023 16:20:30 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        shuah@kernel.org, peterx@redhat.com, nathan@kernel.org,
        david@redhat.com, corbet@lwn.net, jhubbard@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-a-possibly-uninitialized-warning-in-pkey-x86h.patch removed from -mm tree
Message-Id: <20230619232030.8796AC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: fix a "possibly uninitialized" warning in pkey-x86.h
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-a-possibly-uninitialized-warning-in-pkey-x86h.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/mm: fix a "possibly uninitialized" warning in pkey-x86.h
Date: Tue, 6 Jun 2023 00:16:33 -0700

This fixes a real bug, too, because xstate_size()  was assuming that
the stack variable xstate_size was initialized to zero. That's not
guaranteed nor even especially likely.

Link: https://lkml.kernel.org/r/20230606071637.267103-8-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pkey-x86.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/pkey-x86.h~selftests-mm-fix-a-possibly-uninitialized-warning-in-pkey-x86h
+++ a/tools/testing/selftests/mm/pkey-x86.h
@@ -132,7 +132,7 @@ int pkey_reg_xstate_offset(void)
 	unsigned int ecx;
 	unsigned int edx;
 	int xstate_offset;
-	int xstate_size;
+	int xstate_size = 0;
 	unsigned long XSTATE_CPUID = 0xd;
 	int leaf;
 
_

Patches currently in -mm which might be from jhubbard@nvidia.com are


