Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 010D6C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 22:30:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbiJQWac (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 18:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbiJQWaU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 18:30:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB5875386
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 15:29:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 201C36120F
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 22:28:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D883C433D7;
        Mon, 17 Oct 2022 22:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666045733;
        bh=wdpRt/M4arlMqAEWEwBKN6yi0XhpSd941bXjCqd30dE=;
        h=Date:To:From:Subject:From;
        b=go7rbTddaMMx/HiDdyTojJp7wv44VroGIpbWoMOFiPPKqu9Qluwj+X+E4JIeNBNW7
         plDusr3KuM4PQQsw6z185ZnNWUz8kpFsvFH6T8/kJ/tbbl3dKsaHSGTweh5g9txxrS
         anJq2TnQU7i+8SjkeOWvSvsDh3VeGHX8Yqcfea58=
Date:   Mon, 17 Oct 2022 15:28:52 -0700
To:     mm-commits@vger.kernel.org, colin.i.king@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-remove-redundant-assignment-to-variable-num.patch added to mm-nonmm-unstable branch
Message-Id: <20221017222853.6D883C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/oid_registry.c: remove redundant assignment to variable num
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-remove-redundant-assignment-to-variable-num.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-remove-redundant-assignment-to-variable-num.patch

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
From: Colin Ian King <colin.i.king@gmail.com>
Subject: lib/oid_registry.c: remove redundant assignment to variable num
Date: Mon, 17 Oct 2022 22:45:56 +0100

The variable num is being assigned a value that is never read, it is being
re-assigned a new value in both paths if an if-statement.  The assignment
is redundant and can be removed.

Cleans up clang scan build warning:
lib/oid_registry.c:149:3: warning: Value stored to 'num' is
never read [deadcode.DeadStores]

Link: https://lkml.kernel.org/r/20221017214556.863357-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/oid_registry.c |    1 -
 1 file changed, 1 deletion(-)

--- a/lib/oid_registry.c~lib-remove-redundant-assignment-to-variable-num
+++ a/lib/oid_registry.c
@@ -146,7 +146,6 @@ int sprint_oid(const void *data, size_t
 	bufsize -= count;
 
 	while (v < end) {
-		num = 0;
 		n = *v++;
 		if (!(n & 0x80)) {
 			num = n;
_

Patches currently in -mm which might be from colin.i.king@gmail.com are

lib-remove-redundant-assignment-to-variable-num.patch

