Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FB21C43469
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 04:20:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26D0223447
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 04:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600489244;
	bh=wzYJ3L9J5PolmCRlU9ZupyCjpYzVfPvDJ9UniCUSiP0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=H/IJAhjDIvBjybkkmwpVTOL2j1Cg5NZtHNBPsWejJCtUe8KOF9DBBGZYH/6nmwS/O
	 fa7XzgWReDJEtfY2i8Cjq6SBkmdjdm4Pa4UFoRpQlF/z4pe2gSvC4ho83b7akiv7oe
	 HYaDn9VH4GjWzImb4F7H4C6P6T0jTL8ZEUKawlmc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgISEUn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 19 Sep 2020 00:20:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgISEUn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 19 Sep 2020 00:20:43 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2852E22211;
        Sat, 19 Sep 2020 04:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600489243;
        bh=wzYJ3L9J5PolmCRlU9ZupyCjpYzVfPvDJ9UniCUSiP0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=a2iLEEU+w+Ka5JQE4HOlz43+9ivfyeQNrvPwNwkTROq9br+QMAh0bBEReqvyfzoei
         /ehp4s2/IvJ2o7l7VB25b5CvzPj6NodmpJhdbG8kxRo684bUJdIrwW+SlmiyOLeJOw
         FBcyhY7oAWqBT37TM7UPCpXmUFsCohHFRyxjTz2w=
Date:   Fri, 18 Sep 2020 21:20:42 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, changbin.du@gmail.com, elver@google.com,
        gregkh@linuxfoundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org
Subject:  [patch 15/15] kcsan: kconfig: move to menu 'Generic
 Kernel Debugging Instruments'
Message-ID: <20200919042042.Ys_o5oSxr%akpm@linux-foundation.org>
In-Reply-To: <20200918211925.7e97f0ef63d92f5cfe5ccbc5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Changbin Du <changbin.du@gmail.com>
Subject: kcsan: kconfig: move to menu 'Generic Kernel Debugging Instruments'

This moves the KCSAN kconfig items under menu 'Generic Kernel Debugging
Instruments' where UBSAN resides.

Link: https://lkml.kernel.org/r/20200904152224.5570-1-changbin.du@gmail.com
Signed-off-by: Changbin Du <changbin.du@gmail.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/lib/Kconfig.debug~kcsan-kconfig-move-to-menu-generic-kernel-debugging-instruments
+++ a/lib/Kconfig.debug
@@ -520,8 +520,8 @@ config DEBUG_FS_ALLOW_NONE
 endchoice
 
 source "lib/Kconfig.kgdb"
-
 source "lib/Kconfig.ubsan"
+source "lib/Kconfig.kcsan"
 
 endmenu
 
@@ -1620,8 +1620,6 @@ config PROVIDE_OHCI1394_DMA_INIT
 
 source "samples/Kconfig"
 
-source "lib/Kconfig.kcsan"
-
 config ARCH_HAS_DEVMEM_IS_ALLOWED
 	bool
 
_
