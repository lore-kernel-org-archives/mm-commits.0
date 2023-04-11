Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B098C7619A
	for <mm-commits@archiver.kernel.org>; Tue, 11 Apr 2023 04:21:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjDKEVC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Apr 2023 00:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjDKEVA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Apr 2023 00:21:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED2510E6
        for <mm-commits@vger.kernel.org>; Mon, 10 Apr 2023 21:20:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26DDD611EE
        for <mm-commits@vger.kernel.org>; Tue, 11 Apr 2023 04:20:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC28C433D2;
        Tue, 11 Apr 2023 04:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681186858;
        bh=2tZOYszYRoYatDITeWPPZmAedxY53c7AWfKeGDkk+nI=;
        h=Date:To:From:Subject:From;
        b=PaxbegcCYpjfSnRxGlHskzxRCxNfF8C/sz3e8mZAV61GFsF088SJEtbLMw1nBzJ7B
         gaPszda+8xIPJiv7PCZD/XO+w0qly/T0+y/Fti+mMT2WsXMZsnbhERa04X7WAofl8Y
         JGNV16PUNzutQ7p3GoIFJiFN0bCweiIrp5CizSgg=
Date:   Mon, 10 Apr 2023 21:20:57 -0700
To:     mm-commits@vger.kernel.org, trix@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-backing-dev-set-variables-dev_attr_minmax_bytes-storage-class-specifier-to-static.patch added to mm-unstable branch
Message-Id: <20230411042058.7CC28C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: backing-dev: set variables dev_attr_min,max_bytes storage-class-specifier to static
has been added to the -mm mm-unstable branch.  Its filename is
     mm-backing-dev-set-variables-dev_attr_minmax_bytes-storage-class-specifier-to-static.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-backing-dev-set-variables-dev_attr_minmax_bytes-storage-class-specifier-to-static.patch

This patch will later appear in the mm-unstable branch at
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
From: Tom Rix <trix@redhat.com>
Subject: mm: backing-dev: set variables dev_attr_min,max_bytes storage-class-specifier to static
Date: Sat, 8 Apr 2023 10:16:09 -0400

smatch reports
mm/backing-dev.c:266:1: warning: symbol
  'dev_attr_min_bytes' was not declared. Should it be static?
mm/backing-dev.c:294:1: warning: symbol
  'dev_attr_max_bytes' was not declared. Should it be static?

These variables are only used in one file so should be static.

Link: https://lkml.kernel.org/r/20230408141609.2703647-1-trix@redhat.com
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/backing-dev.c~mm-backing-dev-set-variables-dev_attr_minmax_bytes-storage-class-specifier-to-static
+++ a/mm/backing-dev.c
@@ -263,7 +263,7 @@ static ssize_t min_bytes_store(struct de
 
 	return ret;
 }
-DEVICE_ATTR_RW(min_bytes);
+static DEVICE_ATTR_RW(min_bytes);
 
 static ssize_t max_bytes_show(struct device *dev,
 			      struct device_attribute *attr,
@@ -291,7 +291,7 @@ static ssize_t max_bytes_store(struct de
 
 	return ret;
 }
-DEVICE_ATTR_RW(max_bytes);
+static DEVICE_ATTR_RW(max_bytes);
 
 static ssize_t stable_pages_required_show(struct device *dev,
 					  struct device_attribute *attr,
_

Patches currently in -mm which might be from trix@redhat.com are

mm-backing-dev-set-variables-dev_attr_minmax_bytes-storage-class-specifier-to-static.patch

