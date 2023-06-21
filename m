Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FC04EB64D8
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jun 2023 20:06:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbjFUUGS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Jun 2023 16:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbjFUUGR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Jun 2023 16:06:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897C71731
        for <mm-commits@vger.kernel.org>; Wed, 21 Jun 2023 13:06:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 220C6616C0
        for <mm-commits@vger.kernel.org>; Wed, 21 Jun 2023 20:06:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD7FC433C0;
        Wed, 21 Jun 2023 20:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687377973;
        bh=Cy1GeIYcWMKv7U2QbQrK70J1iZ8BFDmDdh6nmr5g2lY=;
        h=Date:To:From:Subject:From;
        b=OHD9OWe7C5E+RmIQ4zTUo3hi1ERfkegqvNzJr49yfFanyGMOVNMGFWRWYtzug+AUB
         rbVGtNcWN496Jb81XDdrWHItfvXLLS4EFkopxlUW2PeI25PdKuCx7gg6Am4Ra526Ud
         jeNUjJfkEDq3Yk2DdXqtNXOKqvL6MgbcPN+a4SuA=
Date:   Wed, 21 Jun 2023 13:06:12 -0700
To:     mm-commits@vger.kernel.org, gregkh@linuxfoundation.org,
        ben.dooks@codethink.co.uk, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + devres-show-which-resource-was-invalid-in-__devm_ioremap_resource.patch added to mm-nonmm-unstable branch
Message-Id: <20230621200613.6BD7FC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: devres: show which resource was invalid in __devm_ioremap_resource()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     devres-show-which-resource-was-invalid-in-__devm_ioremap_resource.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/devres-show-which-resource-was-invalid-in-__devm_ioremap_resource.patch

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
From: Ben Dooks <ben.dooks@codethink.co.uk>
Subject: devres: show which resource was invalid in __devm_ioremap_resource()
Date: Wed, 21 Jun 2023 17:30:50 +0100

The other error prints in this call show the resource which wsan't valid,
so add this to the first print when it checks for basic validity of the
resource.

Link: https://lkml.kernel.org/r/20230621163050.477668-1-ben.dooks@codethink.co.uk
Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/devres.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/devres.c~devres-show-which-resource-was-invalid-in-__devm_ioremap_resource
+++ a/lib/devres.c
@@ -129,7 +129,7 @@ __devm_ioremap_resource(struct device *d
 	BUG_ON(!dev);
 
 	if (!res || resource_type(res) != IORESOURCE_MEM) {
-		dev_err(dev, "invalid resource\n");
+		dev_err(dev, "invalid resource %pR\n", res);
 		return IOMEM_ERR_PTR(-EINVAL);
 	}
 
_

Patches currently in -mm which might be from ben.dooks@codethink.co.uk are

devres-show-which-resource-was-invalid-in-__devm_ioremap_resource.patch

