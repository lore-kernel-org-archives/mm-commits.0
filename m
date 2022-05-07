Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3020DC433EF
	for <mm-commits@archiver.kernel.org>; Sat,  7 May 2022 18:46:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380058AbiEGSt4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 May 2022 14:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231752AbiEGStz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 7 May 2022 14:49:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD27524BFC
        for <mm-commits@vger.kernel.org>; Sat,  7 May 2022 11:46:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B66D61325
        for <mm-commits@vger.kernel.org>; Sat,  7 May 2022 18:46:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C51C385A5;
        Sat,  7 May 2022 18:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651949167;
        bh=QuOzUQz9eir0hCV01dK/pHEeo9xVIiAJ4Nbo6nmHs9U=;
        h=Date:To:From:Subject:From;
        b=fuq8/lt6/IWjw6CAbnUZqWV+9jmnGMW1BQFH9w+S5PBCsfVqwarhKSgXPl6MM/ER/
         kUM9pWm9EMeECfCpbZp2jUT5K7Te61vvw/wciZMwlIhsJHZB/FXWbKbrzJJshSkVoq
         bBzsr5dCNXrVnDcjT+O2Lztk0ZMEQJSLhxfqRihI=
Date:   Sat, 07 May 2022 11:46:06 -0700
To:     mm-commits@vger.kernel.org, andy.shevchenko@gmail.com,
        puyou.lu@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-string_helpers-fix-not-adding-strarray-to-devices-resource-list.patch added to mm-nonmm-unstable branch
Message-Id: <20220507184607.A3C51C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/string_helpers: fix not adding strarray to device's resource list
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-string_helpers-fix-not-adding-strarray-to-devices-resource-list.patch

This patch should soon appear in the mm-nonmm-unstable branch at
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
From: Puyou Lu <puyou.lu@gmail.com>
Subject: lib/string_helpers: fix not adding strarray to device's resource list

Add allocated strarray to device's resource list. This is a must to
automatically release strarray when the device disappears.

Link: https://lkml.kernel.org/r/20220506073623.2679-1-puyou.lu@gmail.com
Fixes: acdb89b6c87a ("lib/string_helpers: Introduce managed variant of kasprintf_strarray()")
Signed-off-by: Puyou Lu <puyou.lu@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string_helpers.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/lib/string_helpers.c~lib-string_helpers-fix-not-adding-strarray-to-devices-resource-list
+++ a/lib/string_helpers.c
@@ -757,6 +757,9 @@ char **devm_kasprintf_strarray(struct de
 		return ERR_PTR(-ENOMEM);
 	}
 
+	ptr->n = n;
+	devres_add(dev, ptr);
+
 	return ptr->array;
 }
 EXPORT_SYMBOL_GPL(devm_kasprintf_strarray);
_

Patches currently in -mm which might be from puyou.lu@gmail.com are

lib-string_helpers-fix-not-adding-strarray-to-devices-resource-list.patch

