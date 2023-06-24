Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91D3FEB64D7
	for <mm-commits@archiver.kernel.org>; Sat, 24 Jun 2023 00:04:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbjFXAEd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jun 2023 20:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbjFXAEd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2023 20:04:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F5E51715
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 17:04:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96F7161B3B
        for <mm-commits@vger.kernel.org>; Sat, 24 Jun 2023 00:04:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9571C433C0;
        Sat, 24 Jun 2023 00:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687565071;
        bh=Ax1PP7dSP2htBwJcWvHAm4mHXr2PEZS49a38MJXLWmY=;
        h=Date:To:From:Subject:From;
        b=AwM1TEiTdPfTuOoUDTnZS8ImUZhaJL0HNXOBJY+81uJTZcMz/TMtF1iGze2z0JLOD
         3Z3RlNkjgCPe6mo1iWucJMgIEHwJt0G8B/rjdHd/BmgxeNVVQmSc2gL0sb9akT+Qxm
         QQ5K1qIHwlY8Ts5ogLQesOWj6E1jhNf3BFFegF54=
Date:   Fri, 23 Jun 2023 17:04:30 -0700
To:     mm-commits@vger.kernel.org, gregkh@linuxfoundation.org,
        ben.dooks@codethink.co.uk, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] devres-show-which-resource-was-invalid-in-__devm_ioremap_resource.patch removed from -mm tree
Message-Id: <20230624000430.E9571C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: devres: show which resource was invalid in __devm_ioremap_resource()
has been removed from the -mm tree.  Its filename was
     devres-show-which-resource-was-invalid-in-__devm_ioremap_resource.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


