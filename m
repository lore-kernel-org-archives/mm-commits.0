Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96984C7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:53:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234407AbjDFCxs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234737AbjDFCx1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:53:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92E193F1
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:53:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71A6C64126
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:53:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5EAC433D2;
        Thu,  6 Apr 2023 02:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749581;
        bh=oISU6anwWj0lOBYLVbiG70WAhUddlDiQ8JWTNI3x74c=;
        h=Date:To:From:Subject:From;
        b=JDhJ6nD4SwzpepBLAvrl1lW6UWAabQdbFJbIO0SicC4M+Naa+STzqEDhTXGpx/iY/
         Gefd2jJYW6zXk8x9HpNw5IhovO1TpImnjAGuifDq7YZwUNbAOYVQlo5Y/aGV+eprwD
         +vprfrhUId2VbDJrswjmY8M0zphiJnB4cpWLpOpU=
Date:   Wed, 05 Apr 2023 19:53:01 -0700
To:     mm-commits@vger.kernel.org, gregkh@linuxfoundation.org,
        error27@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] dca-delete-unnecessary-variable.patch removed from -mm tree
Message-Id: <20230406025301.CC5EAC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: dca: delete unnecessary variable
has been removed from the -mm tree.  Its filename was
     dca-delete-unnecessary-variable.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dan Carpenter <error27@gmail.com>
Subject: dca: delete unnecessary variable
Date: Mon, 27 Feb 2023 13:06:12 +0300

It's more readable to just pass NULL directly instead of using a variable
for that.

Link: https://lkml.kernel.org/r/Y/yAlDytLH0ZNLNz@kili
Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dca/dca-core.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/dca/dca-core.c~dca-delete-unnecessary-variable
+++ a/drivers/dca/dca-core.c
@@ -294,9 +294,7 @@ EXPORT_SYMBOL_GPL(dca3_get_tag);
  */
 u8 dca_get_tag(int cpu)
 {
-	struct device *dev = NULL;
-
-	return dca_common_get_tag(dev, cpu);
+	return dca_common_get_tag(NULL, cpu);
 }
 EXPORT_SYMBOL_GPL(dca_get_tag);
 
_

Patches currently in -mm which might be from error27@gmail.com are


