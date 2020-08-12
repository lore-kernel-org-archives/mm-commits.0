Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F70FC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:01:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62353206F2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597194093;
	bh=JV/IeNcp4Sc+5OEWB3SLcF4YliPq+soA9L+GaRckym0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=o5bSL9YR1bnq/WDyNfArEfBYbGLyz2YSnk08BfTXiwbGp2Sn9cQnmgcfAbSdsS/Kw
	 7OU9QP2ybylfP9kQ8p+hDl7JoBkfQ4sNSa3NVEec0TEZRjNaEFkZVHgxiXAapjA0F8
	 ZM0rxNfXrvxi2+xvB9Jp03hkt40+rpmkGNQbZ5UM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726235AbgHLBBd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:01:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:45008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726173AbgHLBBc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:01:32 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C4E1206B5;
        Wed, 12 Aug 2020 01:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597194091;
        bh=JV/IeNcp4Sc+5OEWB3SLcF4YliPq+soA9L+GaRckym0=;
        h=Date:From:To:Subject:From;
        b=HucncFhSG4EE2MLyLR8ZsBPMZ2w9s28V1Y+Nvwmjoih3jiz2pUS3lHn5G/F71pBH6
         5prpKrd8oQlCEVDypyoqOj+uWHQLrae6V1fN6qwAAgxKAwRXPoiIfGBkrR4C+SM1oP
         upZ4qQ26qpObQcZh5csQnQP5Mx5tHF+43uvpwpQg=
Date:   Tue, 11 Aug 2020 18:01:30 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, natechancellor@gmail.com,
        sfr@canb.auug.org.au, song.bao.hua@hisilicon.com
Subject:  [folded-merged]
 mm-cma-fix-the-name-of-cma-areas-fix.patch removed from -mm tree
Message-ID: <20200812010130.OND-wGOWO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: return cma->name directly in cma_get_name
has been removed from the -mm tree.  Its filename was
     mm-cma-fix-the-name-of-cma-areas-fix.patch

This patch was dropped because it was folded into mm-cma-fix-the-name-of-cma-areas.patch

------------------------------------------------------
From: Nathan Chancellor <natechancellor@gmail.com>
Subject: mm: cma: return cma->name directly in cma_get_name

clang warns:

mm/cma.c:55:14: warning: address of array 'cma->name' will always
evaluate to 'true' [-Wpointer-bool-conversion]
        return cma->name ? cma->name : "(undefined)";
               ~~~~~^~~~ ~
1 warning generated.

After commit e7f0557d7de9 ("mm: cma: fix the name of CMA areas"),
cma->name will be an array with some value worth printing so we do not
need to check for NULL.

Link: https://github.com/ClangBuiltLinux/linux/issues/1063
Link: http://lkml.kernel.org/r/20200623015840.621964-1-natechancellor@gmail.com
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Barry Song <song.bao.hua@hisilicon.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/cma.c~mm-cma-fix-the-name-of-cma-areas-fix
+++ a/mm/cma.c
@@ -52,7 +52,7 @@ unsigned long cma_get_size(const struct
 
 const char *cma_get_name(const struct cma *cma)
 {
-	return cma->name ? cma->name : "(undefined)";
+	return cma->name;
 }
 
 static unsigned long cma_bitmap_aligned_mask(const struct cma *cma,
_

Patches currently in -mm which might be from natechancellor@gmail.com are

mm-cma-fix-the-name-of-cma-areas.patch

