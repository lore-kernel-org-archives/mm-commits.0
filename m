Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F257DC433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:48:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFB9222200
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602632912;
	bh=eUe1ibpAGXyJNEK+fDBIOrv/m4LYVYXKzFatuD7o1og=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=AQSWY9xuM/2TUwNHds3EaqwqBbfe/LauTjuEUOJx5G8MDBj+Cmktl1+ubgNeS/Csd
	 Pu6SiNUXQ+uPDuBUHA5t8eUnDIwcDIsknTxhFL8hLHr2Nw/70cc/P3x0J3QeMZ1OGC
	 5NPEJj+d9LWUZ8C84ByN4+/RS1ZnTrlmlN/VPRUY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389170AbgJMXsc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:48:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:59962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389017AbgJMXsc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:48:32 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D37F21D81;
        Tue, 13 Oct 2020 23:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602632912;
        bh=eUe1ibpAGXyJNEK+fDBIOrv/m4LYVYXKzFatuD7o1og=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GiTkMcU+GRGDSO1jIdM5GcqFYY9rr7HvkMcZPPqiX5kKrIx/e4Bzwk4txjzqbIOb9
         lE0FoKsHSFE8vb2QxuEyJ7rwKTlNIpjn4jn5S4JgG+r4hFPw5FrmDgHaxFVE0kyD2W
         0t/9Y40T1ukMjaMIO7TQZopBxnO8qTKvIlz0VD6M=
Date:   Tue, 13 Oct 2020 16:48:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        luojiaxing@huawei.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 018/181] fs_parse: mark fs_param_bad_value() as
 static
Message-ID: <20201013234830.83aisj1GJ%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
