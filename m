Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CF38C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:32:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbiKOWc1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:32:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238176AbiKOWb6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:31:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4A85F41
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:31:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B17761A60
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:31:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D93C433D6;
        Tue, 15 Nov 2022 22:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551516;
        bh=0zYryRimOra4wblTVAw1QmsydZxfl37K0/siIeyKVP8=;
        h=Date:To:From:Subject:From;
        b=FAVVqGBgE9k+3eRa/SW77r2E0GDLw5FRZNVPnIfRphLgW/U2PhYldSoVpXJ/xYCsm
         O+BHOImeuNF9+ySQln3d+Xnr1Mif1oMbS/9JugMCRShKqv+QvmoOsJaN/DGFkOg5kq
         EZ/zGluw5HP60sdwQRAJVPxgTe5NtaqxQTcboHg4=
Date:   Tue, 15 Nov 2022 14:31:56 -0800
To:     mm-commits@vger.kernel.org, colin.i.king@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-remove-redundant-assignment-to-variable-num.patch removed from -mm tree
Message-Id: <20221115223156.80D93C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/oid_registry.c: remove redundant assignment to variable num
has been removed from the -mm tree.  Its filename was
     lib-remove-redundant-assignment-to-variable-num.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


