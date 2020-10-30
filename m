Return-Path: <SRS0=SeUK=EF=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3087C56201
	for <mm-commits@archiver.kernel.org>; Fri, 30 Oct 2020 05:19:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D54C221FF
	for <mm-commits@archiver.kernel.org>; Fri, 30 Oct 2020 05:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604035198;
	bh=ZlHA0rbQMIXQXuyBAcRyHhJuZNnYIY6a0nXIib61DN4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ILE0e4Dk1q0zCmxvaUgtnh+8xqKWhjvg279FGP4h6UaM9vrcxeCrP+F5UhuhiBU83
	 VNW5+Mj2GkQ2yNNcdkTXlt3mc7dEoWR/gdfGzoUjhVyIM6xXcxJGNBOfo8ZHd7r5hd
	 CWGCLJZdBi/EMNhufVJdM95H+0WapD3frijpEX5U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725780AbgJ3FT5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Oct 2020 01:19:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgJ3FT5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Oct 2020 01:19:57 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5A2F20725;
        Fri, 30 Oct 2020 05:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604035197;
        bh=ZlHA0rbQMIXQXuyBAcRyHhJuZNnYIY6a0nXIib61DN4=;
        h=Date:From:To:Subject:From;
        b=yylX3zHlCzixO462nI3P0OVXcnZnUqaV12r5ZDG3bUG+7qWrjTAyL98xOJWPPYW7z
         yoXf7HgnsK/nx5BTNjPIULh2R6NjCRlrrTT9nUIs46bon/xg8M/y69gbaSqMtzpNkG
         LUv6ME5pxXfwv1nnTYhrZ3He2Fv18vTLD0gsMK7U=
Date:   Thu, 29 Oct 2020 22:19:56 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au
Subject:  + kernelh-split-out-mathematical-helpers-fix.patch added
 to -mm tree
Message-ID: <20201030051956.vZWrrRAfN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel.h: split out mathematical helpers fix
has been added to the -mm tree.  Its filename is
     kernelh-split-out-mathematical-helpers-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernelh-split-out-mathematical-helpers-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernelh-split-out-mathematical-helpers-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: kernel.h: split out mathematical helpers fix

fix powerpc build

Link: https://lkml.kernel.org/r/20201029150809.13059608@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/math/div64.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/math/div64.c~kernelh-split-out-mathematical-helpers-fix
+++ a/lib/math/div64.c
@@ -22,6 +22,7 @@
 #include <linux/export.h>
 #include <linux/math.h>
 #include <linux/math64.h>
+#include <linux/log2.h>
 
 /* Not needed on 64bit architectures */
 #if BITS_PER_LONG == 32
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

kernelh-split-out-mathematical-helpers-fix.patch

