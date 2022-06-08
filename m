Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 335EAC43334
	for <mm-commits@archiver.kernel.org>; Wed,  8 Jun 2022 19:43:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232719AbiFHTnk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Jun 2022 15:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235657AbiFHTn3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jun 2022 15:43:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F422632BC
        for <mm-commits@vger.kernel.org>; Wed,  8 Jun 2022 12:43:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54BCF6175E
        for <mm-commits@vger.kernel.org>; Wed,  8 Jun 2022 19:43:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87C9C34116;
        Wed,  8 Jun 2022 19:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654717407;
        bh=ba2SwDCumCtCzJol444TcZDj6TrzsaFTcdoNxaNfzQk=;
        h=Date:To:From:Subject:From;
        b=NbvcKFd2Be9BwYk95Yz6B93/Osi7+JoXZdWCFMZONPbtKZRz8ZJ8pPPbV8lNAY5NL
         DJ3Qp4dztaeswGdqafrM+BidvfjF6ckJc1pSSb6rtOIs9oZBDoGg8BE+njoyfEeSPe
         IMQDA9NvHrCjx6+CEQAs6mrr4fIIlB4Ra9jfRe7U=
Date:   Wed, 08 Jun 2022 12:43:26 -0700
To:     mm-commits@vger.kernel.org, jstitt007@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] include-uapi-linux-swabh-add-__u16-cast-to-__swab16-conditional.patch removed from -mm tree
Message-Id: <20220608194327.A87C9C34116@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: include/uapi/linux/swab.h: add __u16 cast to __swab16 conditional
has been removed from the -mm tree.  Its filename was
     include-uapi-linux-swabh-add-__u16-cast-to-__swab16-conditional.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Justin Stitt <jstitt007@gmail.com>
Subject: include/uapi/linux/swab.h: add __u16 cast to __swab16 conditional
Date: Tue, 7 Jun 2022 15:20:06 -0700

if __HAVE_BUILTIN_BSWAP16__ is defined then __swab16 utilizes a __u16 cast.
This same cast should be used if __HAVE_BUILTIN_BSWAP16__ is not defined as
well. This should fix loads (at least a few) clang -Wformat warnings
specifically with `ntohs()`

Link: https://github.com/ClangBuiltLinux/linux/issues/378
Link: https://lkml.kernel.org/r/20220607222006.22719-1-jstitt007@gmail.com
Signed-off-by: Justin Stitt <jstitt007@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/swab.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/uapi/linux/swab.h~include-uapi-linux-swabh-add-__u16-cast-to-__swab16-conditional
+++ a/include/uapi/linux/swab.h
@@ -102,7 +102,7 @@ static inline __attribute_const__ __u32
 #define __swab16(x) (__u16)__builtin_bswap16((__u16)(x))
 #else
 #define __swab16(x)				\
-	(__builtin_constant_p((__u16)(x)) ?	\
+	(__u16)(__builtin_constant_p((__u16)(x)) ?	\
 	___constant_swab16(x) :			\
 	__fswab16(x))
 #endif
_

Patches currently in -mm which might be from jstitt007@gmail.com are

include-uapi-linux-swabh-move-explicit-cast-outside-ternary.patch

