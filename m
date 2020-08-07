Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48845C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:45:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C04A2086A
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596779131;
	bh=BYvBMftADKhkthZeyz3Xh/GTwT13fORGun7q1kvfgJE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=sAey0m0M59E/ehv+xpy/hSzMn+D9Q4Eh8Xy5rK2ViMjX3uw9RhdeFtG/rZ/fG9yDE
	 trvu3mLszNgGAvnGfHky42gb9YmeLQ90Z1ZWROpiZsbmFbCYPvmgx4GOs815AW6Dsk
	 IzytxjRFMmokrsXnEXhq8wruG9/CuQP7/NvNbS5M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725379AbgHGFpa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 01:45:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725287AbgHGFpa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 01:45:30 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C803E20866;
        Fri,  7 Aug 2020 05:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596779130;
        bh=BYvBMftADKhkthZeyz3Xh/GTwT13fORGun7q1kvfgJE=;
        h=Date:From:To:Subject:From;
        b=TMLw0tAHq4euk1eYCWvTARpJhP7QNEKZMjK1G+obS9T8W/6soAXUdrlAXtaelEeb4
         yTFZKUVxhYX1vN4zUp8c2WoP2mvO/c+bQQND04IrKMx6KK6x9gOxZtIsUKkhiHeqj/
         UOtwgI4gyeEQx1rplLgcWwC6iU2jle1svgzJ4mEg=
Date:   Thu, 06 Aug 2020 22:45:29 -0700
From:   akpm@linux-foundation.org
To:     hulkci@huawei.com, mm-commits@vger.kernel.org, vbabka@suse.cz,
        weiyongjun1@huawei.com
Subject:  [folded-merged]
 mm-slub-extend-slub_debug-syntax-for-multiple-blocks-fix.patch removed from
 -mm tree
Message-ID: <20200807054529.WlPbBvPXc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: make function parse_slub_debug_flags() static
has been removed from the -mm tree.  Its filename was
     mm-slub-extend-slub_debug-syntax-for-multiple-blocks-fix.patch

This patch was dropped because it was folded into mm-slub-extend-slub_debug-syntax-for-multiple-blocks.patch

------------------------------------------------------
From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: mm, slub: make function parse_slub_debug_flags() static

Fix sparse build warning:

mm/slub.c:1267:6: warning:
 symbol 'parse_slub_debug_flags' was not declared. Should it be static?

Link: http://lkml.kernel.org/r/20200702150522.4940-1-weiyongjun1@huawei.com
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slub.c~mm-slub-extend-slub_debug-syntax-for-multiple-blocks-fix
+++ a/mm/slub.c
@@ -1272,7 +1272,7 @@ out:
  *
  * returns the start of next block if there's any, or NULL
  */
-char *
+static char *
 parse_slub_debug_flags(char *str, slab_flags_t *flags, char **slabs, bool init)
 {
 	bool higher_order_disable = false;
_

Patches currently in -mm which might be from weiyongjun1@huawei.com are

mm-slub-extend-slub_debug-syntax-for-multiple-blocks.patch
lib-test_lockupc-make-symbol-test_works-static.patch
bits-add-tests-of-genmask-fix-2.patch
kcov-make-some-symbols-static.patch

