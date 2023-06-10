Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7364C7EE25
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:47:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbjFJAr1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232471AbjFJAqt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:46:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B10A33C06
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:46:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91979652B0
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:46:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECEF3C433D2;
        Sat, 10 Jun 2023 00:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686357967;
        bh=T4ugRwuxGbH+LzWA3RDMEjd68ZjypQHGZfEkrjKT7CI=;
        h=Date:To:From:Subject:From;
        b=A1t6u5cEonsfc3bRpl2iErPm5IMz75hWL8tCjde72P9ebtT6VbzldiSrihQE31Eqt
         3xWZ4LK7B8Az6rEi0zxWsf+ztUtLVTwuNBSkmAhzI0psZ5XnJ/Z16fs5YTqNv7jZLB
         9EcukxS0fBIyP4XLIPyWxkOHeZp4k8+dANc/XiHM=
Date:   Fri, 09 Jun 2023 17:46:06 -0700
To:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        joe@perches.com, gustavoars@kernel.org, dwaipayanray1@gmail.com,
        apw@canonical.com, keescook@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-check-for-0-length-and-1-element-arrays.patch removed from -mm tree
Message-Id: <20230610004606.ECEF3C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: checkpatch: check for 0-length and 1-element arrays
has been removed from the -mm tree.  Its filename was
     checkpatch-check-for-0-length-and-1-element-arrays.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: checkpatch: check for 0-length and 1-element arrays
Date: Thu, 1 Jun 2023 09:07:46 -0700

Fake flexible arrays have been deprecated since last millennium.  Proper
C99 flexible arrays must be used throughout the kernel so
CONFIG_FORTIFY_SOURCE and CONFIG_UBSAN_BOUNDS can provide proper array
bounds checking.

[joe@perches.com: various suggestions]
Link: https://lkml.kernel.org/r/20230601160746.up.948-kees@kernel.org
Link: https://lore.kernel.org/r/20230517204530.never.151-kees@kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Acked-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-check-for-0-length-and-1-element-arrays
+++ a/scripts/checkpatch.pl
@@ -7418,6 +7418,16 @@ sub process {
 			}
 		}
 
+# check for array definition/declarations that should use flexible arrays instead
+		if ($sline =~ /^[\+ ]\s*\}(?:\s*__packed)?\s*;\s*$/ &&
+		    $prevline =~ /^\+\s*(?:\}(?:\s*__packed\s*)?|$Type)\s*$Ident\s*\[\s*(0|1)\s*\]\s*;\s*$/) {
+			if (ERROR("FLEXIBLE_ARRAY",
+				  "Use C99 flexible arrays - see https://docs.kernel.org/process/deprecated.html#zero-length-and-one-element-arrays\n" . $hereprev) &&
+			    $1 == '0' && $fix) {
+				$fixed[$fixlinenr - 1] =~ s/\[\s*0\s*\]/[]/;
+			}
+		}
+
 # nested likely/unlikely calls
 		if ($line =~ /\b(?:(?:un)?likely)\s*\(\s*!?\s*(IS_ERR(?:_OR_NULL|_VALUE)?|WARN)/) {
 			WARN("LIKELY_MISUSE",
_

Patches currently in -mm which might be from keescook@chromium.org are


