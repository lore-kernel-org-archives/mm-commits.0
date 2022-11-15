Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5218C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:28:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238483AbiKOW2t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238663AbiKOW2b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:28:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36593E0B0
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:27:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6FAB61A44
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:27:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B7BC433C1;
        Tue, 15 Nov 2022 22:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551259;
        bh=kpJ1xeMpRa2dFFtEivIG7S6H0U6z22h5yVA6yVucYIk=;
        h=Date:To:From:Subject:From;
        b=MZfNxecG4jsHPRn3U83gNgwATPHfVMb3Ba0Rj5rOzVHwWR5X18MukG+2UDeC/xois
         Dcqp1qiaCIYdlEy8PLC1UtPfBPGjlaaeQ+CZNEgG6ewjJms8t8iL0Lu6cDFykwcrhB
         G33Cz+kh2hw89dqwkzXN24kjHlj0MdL9xF5MRLfo=
Date:   Tue, 15 Nov 2022 14:27:38 -0800
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org, pcc@google.com,
        lukas.bulwahn@gmail.com, keescook@chromium.org, joe@perches.com,
        dwaipayanray1@gmail.com, apw@canonical.com, bhelgaas@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] checkpatch-add-warning-for-non-lore-mailing-list-urls-fix.patch removed from -mm tree
Message-Id: <20221115222739.08B7BC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: checkpatch: warn only for URLs to non-lore archives
has been removed from the -mm tree.  Its filename was
     checkpatch-add-warning-for-non-lore-mailing-list-urls-fix.patch

This patch was dropped because it was folded into checkpatch-add-warning-for-non-lore-mailing-list-urls.patch

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
ia64-remove-unused-__slow_down_io-and-slow_down_io-definitions.patch

