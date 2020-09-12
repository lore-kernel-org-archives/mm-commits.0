Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF8BAC43461
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 19:56:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 713B521D6C
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 19:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599940588;
	bh=9unYwkZUglWt8E7mV6VjeyknH7Y9BgmSwiM0J86Zme8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=cZWvr04KOSMsqrYiRWo9VPrWFbqYIne8JLDtRjX4I1iE/vYAsAV3FAry3o7Vt3lPd
	 mhxTh51Cj4b8ZppWd/1vUS/8euFQDY5shYJ3ljmY8VO+UBMYDU3G2/n83Zyurq6+YV
	 vfiXel/34Djvv4WjRAmFJfo572BLK4/d3D4vqzbc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725880AbgILT42 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 15:56:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgILT4Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 15:56:24 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB4D621531;
        Sat, 12 Sep 2020 19:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599940583;
        bh=9unYwkZUglWt8E7mV6VjeyknH7Y9BgmSwiM0J86Zme8=;
        h=Date:From:To:Subject:From;
        b=G7Ty2dfMdOK6xuQUGCEjwNsavxix/afi6pNjvkp1/D5o5HetSNnhJC/PYlpXh8x0I
         pj+dc9ZbPhwI0JwpiTCejWwC0sd3fEL0rEDWpjrv3zNg9QJZ3IxL3wwyI1/UsYxGEh
         eW291s3L8/HnkgZW7oI6+CC0xoIOhlVaCKrrBvQA=
Date:   Sat, 12 Sep 2020 12:56:23 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, trong@android.com,
        gregkh@linuxfoundation.org, corbet@lwn.net, swboyd@chromium.org
Subject:  +
 idr-document-that-ida_simple_getremove-are-deprecated.patch added to -mm tree
Message-ID: <20200912195623.vsIsR%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/idr.c: document that ida_simple_{get,remove}() are deprecated
has been added to the -mm tree.  Its filename is
     idr-document-that-ida_simple_getremove-are-deprecated.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/idr-document-that-ida_simple_getremove-are-deprecated.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/idr-document-that-ida_simple_getremove-are-deprecated.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

idr-document-calling-context-for-ida-apis-mustnt-use-locks.patch
idr-document-that-ida_simple_getremove-are-deprecated.patch

