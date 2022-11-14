Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73F91C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 14 Nov 2022 23:59:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbiKNX7p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Nov 2022 18:59:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbiKNX7o (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2022 18:59:44 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF53F3F
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2022 15:59:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5D2ABCE135A
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2022 23:59:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81456C433D6;
        Mon, 14 Nov 2022 23:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668470380;
        bh=+9ix0GXWBS2q8CbGZXdwcpRC0ZnA3YdFExFl2cKzKQE=;
        h=Date:To:From:Subject:From;
        b=ee60kv7P9cS35SDOsWFMHPZXCwa4YVeVWOFMxM90uIpUmLVRamcWfbhoEMbZrVcC5
         f7V5ON1+yi6AXlXTYhQO9uMdBvrYKs0hCgyx+ENd5DsHUASA0Q+NoLH71l5by4uIWo
         266AXBk+hrN2VjFWw1y6jn4Q8k+U3HjpBIKg+8IA=
Date:   Mon, 14 Nov 2022 15:59:39 -0800
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org, pcc@google.com,
        lukas.bulwahn@gmail.com, keescook@chromium.org, joe@perches.com,
        dwaipayanray1@gmail.com, apw@canonical.com, bhelgaas@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-add-warning-for-non-lore-mailing-list-urls-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20221114235940.81456C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: warn only for URLs to non-lore archives
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-add-warning-for-non-lore-mailing-list-urls-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-add-warning-for-non-lore-mailing-list-urls-fix.patch

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
From: Bjorn Helgaas <bhelgaas@google.com>
Subject: checkpatch: warn only for URLs to non-lore archives
Date: Mon Nov 14 16:33:12 2022 -0600

Previously we warned for anything that contained the archive hostname, but
some email addresses also contain those hostnames, and we'd rather not
warn about those.  Only warn if we see "http" before the archive hostname.

Link: https://lkml.kernel.org/r/20221114224315.GA939630@bhelgaas
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Peter Collingbourne <pcc@google.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-add-warning-for-non-lore-mailing-list-urls-fix
+++ a/scripts/checkpatch.pl
@@ -3336,7 +3336,7 @@ sub process {
 		}
 
 # Check for mailing list archives other than lore.kernel.org
-		if ($rawline =~ m{\b$obsolete_archives}) {
+		if ($rawline =~ m{http.*\b$obsolete_archives}) {
 			WARN("PREFER_LORE_ARCHIVE",
 			     "Use lore.kernel.org archive links when possible - see https://lore.kernel.org/lists.html\n" . $herecurr);
 		}
_

Patches currently in -mm which might be from bhelgaas@google.com are

checkpatch-add-warning-for-non-lore-mailing-list-urls.patch
checkpatch-add-warning-for-non-lore-mailing-list-urls-fix.patch
ia64-remove-unused-__slow_down_io-and-slow_down_io-definitions.patch

