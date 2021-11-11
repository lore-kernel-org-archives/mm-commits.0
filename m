Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A351DC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:52:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C983610A2
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:52:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234558AbhKKCzG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:55:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:58694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234548AbhKKCzF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:55:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88C5E61075;
        Thu, 11 Nov 2021 02:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599137;
        bh=sHADtfoOuH6BTTWe+OZXCTmpyF2Xs3eJbDqYzRkN2p8=;
        h=Date:From:To:Subject:From;
        b=ZTrup9tnH/FEu6NSsy+3eSeP6wzauIjlsFEjC0Tae3wizTb2eit1UysyasVi+hsIL
         a8vYuaUOt0QSjsy/TPiGZPpqq1OsUrmELeHE2KS6uPR6erZ+DIYcP967bDBoxJKqNQ
         cfFEtdu0OH/ZVROgpW4qaFFCJyDJ8SpYjHHzN3Cw=
Date:   Wed, 10 Nov 2021 18:52:17 -0800
From:   akpm@linux-foundation.org
To:     lucas.demarchi@intel.com, mm-commits@vger.kernel.org
Subject:  [merged]
 lib-string_helpers-add-linux-stringh-for-strlen.patch removed from -mm tree
Message-ID: <20211111025217.Or_Cum3wZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/string_helpers.h: add linux/string.h for strlen()
has been removed from the -mm tree.  Its filename was
     lib-string_helpers-add-linux-stringh-for-strlen.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lucas De Marchi <lucas.demarchi@intel.com>
Subject: include/linux/string_helpers.h: add linux/string.h for strlen()

linux/string_helpers.h uses strlen(), so include the correponding header. 
Otherwise we get a compilation error if it's not also included by whoever
included the helper.

Link: https://lkml.kernel.org/r/20211005212634.3223113-1-lucas.demarchi@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string_helpers.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/string_helpers.h~lib-string_helpers-add-linux-stringh-for-strlen
+++ a/include/linux/string_helpers.h
@@ -4,6 +4,7 @@
 
 #include <linux/bits.h>
 #include <linux/ctype.h>
+#include <linux/string.h>
 #include <linux/types.h>
 
 struct file;
_

Patches currently in -mm which might be from lucas.demarchi@intel.com are


