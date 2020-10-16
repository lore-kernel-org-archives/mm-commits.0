Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34A96C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6E7D2145D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881601;
	bh=BGdElyvPIpVOyPyXmfHemWMasE4MiIhED2ca4Gdb21Y=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=QSkFsb/VOHVfjY7xh0w20DQSne7dqbE2uFiD/EIH6RtJVD/6ZerUbof2IcotbhBsh
	 HRlCVsvfoFaM67+2zStCboztVoMBwzpI35A15aDfSXyuX1Lji35+tfyWjxFQYjLRWD
	 OwdS53HMtxOMjPiPCYo9rS/f3KjQ5xB5wUVSxbuI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409095AbgJPUxV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:53:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:41526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409125AbgJPUxV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:53:21 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B3BD205CB;
        Fri, 16 Oct 2020 20:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881601;
        bh=BGdElyvPIpVOyPyXmfHemWMasE4MiIhED2ca4Gdb21Y=;
        h=Date:From:To:Subject:From;
        b=R5X5mcQ1gf6AVpXmIURuYfYyxJ2RZGCRi3WdXhshVYepE9RoZa5vy3XghTHWB1krp
         jc7hxNGeDpCd4KCpznM6gq41SPfDgQXTQG6HeW57CxRtDliDAR3JUWLwGiN/s3gyt2
         M+e6wm0LVQQ4LhcJQ6M6lqC+5Nf7jdjQTv1tnLIg=
Date:   Fri, 16 Oct 2020 13:53:20 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, gregkh@linuxfoundation.org,
        mm-commits@vger.kernel.org, swboyd@chromium.org, trong@android.com,
        willy@infradead.org
Subject:  [merged]
 idr-document-that-ida_simple_getremove-are-deprecated.patch removed from
 -mm tree
Message-ID: <20201016205320.jgVmGdaws%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/idr.c: document that ida_simple_{get,remove}() are deprecated
has been removed from the -mm tree.  Its filename was
     idr-document-that-ida_simple_getremove-are-deprecated.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen Boyd <swboyd@chromium.org>
Subject: lib/idr.c: document that ida_simple_{get,remove}() are deprecated

These two functions are deprecated.  Users should call ida_alloc() or
ida_free() respectively instead.  Add documentation to this effect until
the macro can be removed.

Link: https://lkml.kernel.org/r/20200910055246.2297797-2-swboyd@chromium.org
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Tri Vo <trong@android.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/linux/idr.h~idr-document-that-ida_simple_getremove-are-deprecated
+++ a/include/linux/idr.h
@@ -314,6 +314,10 @@ static inline void ida_init(struct ida *
 	xa_init_flags(&ida->xa, IDA_INIT_FLAGS);
 }
 
+/*
+ * ida_simple_get() and ida_simple_remove() are deprecated. Use
+ * ida_alloc() and ida_free() instead respectively.
+ */
 #define ida_simple_get(ida, start, end, gfp)	\
 			ida_alloc_range(ida, start, (end) - 1, gfp)
 #define ida_simple_remove(ida, id)	ida_free(ida, id)
_

Patches currently in -mm which might be from swboyd@chromium.org are


