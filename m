Return-Path: <SRS0=DYKa=DF=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D246C2D0A8
	for <mm-commits@archiver.kernel.org>; Mon, 28 Sep 2020 23:38:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 476E120774
	for <mm-commits@archiver.kernel.org>; Mon, 28 Sep 2020 23:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601336300;
	bh=wV8Op87+97guqWEs8v9C7otbexg0vxukfyT+Nccx4NI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=y0DG8bmzhxTRW8w9XrPmG2mNmaAriztYHFcO0L65ZCW1fpMomhB62cnOYNv6vYZ5Q
	 yW/0BzT5v+5xK8pcGN8+OsRpup1HgZTx4hAYH4k77JsS1RH+JtBiEzdCbZ+1FnKDpI
	 KYJWi2EIIMTgmwGwliyQcybBJ5SRJo2zxgo+GeOc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgI1XiT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Sep 2020 19:38:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726064AbgI1XiT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Sep 2020 19:38:19 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1ED112076A;
        Mon, 28 Sep 2020 23:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601336299;
        bh=wV8Op87+97guqWEs8v9C7otbexg0vxukfyT+Nccx4NI=;
        h=Date:From:To:Subject:From;
        b=jp2iHytgjvM2wSSPpzkJvJ4jgcMSWXG1py0+uvymJKNEdVVgGLW+gxGzUKjteZNFZ
         eavQw9NBOyu9IwnaTWS161LXpbQLSV67vJ+46jwMwNuU9mGd/kTTTC8ClFNSS84CF3
         6IK/+n/mfrF2wNrF77+W37SueSktuUIkGZd54/1s=
Date:   Mon, 28 Sep 2020 16:38:18 -0700
From:   akpm@linux-foundation.org
To:     luojiaxing@huawei.com, mm-commits@vger.kernel.org
Subject:  + fs_parse-mark-fs_param_bad_value-as-static.patch added
 to -mm tree
Message-ID: <20200928233818.pT9dNG7AC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs_parse: mark fs_param_bad_value() as static
has been added to the -mm tree.  Its filename is
     fs_parse-mark-fs_param_bad_value-as-static.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs_parse-mark-fs_param_bad_value-as-static.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs_parse-mark-fs_param_bad_value-as-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Luo Jiaxing <luojiaxing@huawei.com>
Subject: fs_parse: mark fs_param_bad_value() as static

We found the following warning when build kernel with W=1:

fs/fs_parser.c:192:5: warning: no previous prototype for `fs_param_bad_value' [-Wmissing-prototypes]
int fs_param_bad_value(struct p_log *log, struct fs_parameter *param)
     ^
CC      drivers/usb/gadget/udc/snps_udc_core.o

And no header file define a prototype for this function, so we should mark
it as static.

Link: https://lkml.kernel.org/r/1601293463-25763-1-git-send-email-luojiaxing@huawei.com
Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs_parser.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fs_parser.c~fs_parse-mark-fs_param_bad_value-as-static
+++ a/fs/fs_parser.c
@@ -189,7 +189,7 @@ out:
 }
 EXPORT_SYMBOL(fs_lookup_param);
 
-int fs_param_bad_value(struct p_log *log, struct fs_parameter *param)
+static int fs_param_bad_value(struct p_log *log, struct fs_parameter *param)
 {
 	return inval_plog(log, "Bad value for '%s'", param->key);
 }
_

Patches currently in -mm which might be from luojiaxing@huawei.com are

fs_parse-mark-fs_param_bad_value-as-static.patch

