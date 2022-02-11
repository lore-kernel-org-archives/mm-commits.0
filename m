Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66073C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 11 Feb 2022 18:29:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347914AbiBKS3f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Feb 2022 13:29:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343586AbiBKS3f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Feb 2022 13:29:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690DC184
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 10:29:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0FB06B82A48
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 18:29:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3772C340E9;
        Fri, 11 Feb 2022 18:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644604170;
        bh=NQhkDDSvpEsMB+r3a0MrU7h8yuJmeJWPs0tQs9ZB7mk=;
        h=Date:To:From:Subject:From;
        b=hIyeRw/0ixCIF62lE1aDzMD+ZEV7Eqsjh7Q4wHaSY+xPKvJdcVBwJJ83H0JrLOygl
         /mWL1s/gap42BY3b+ytGyPMQREAkugTW3BOP3DAbfRfLdpwSqeueUcdz2dgIyNHV60
         cTwbLEqdjqJqm3PA/XXCT1ZmiH4ahupna+ncmQOU=
Date:   Fri, 11 Feb 2022 10:29:30 -0800
To:     mm-commits@vger.kernel.org, dmitry.baryshkov@linaro.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + container_ofh-make-container_of-const-aware.patch added to -mm tree
Message-Id: <20220211182930.A3772C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: container_of.h: make container_of const-aware
has been added to the -mm tree.  Its filename is
     container_ofh-make-container_of-const-aware.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/container_ofh-make-container_of-const-aware.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/container_ofh-make-container_of-const-aware.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: container_of.h: make container_of const-aware

container_of() macro has one major drawback.  It does not check whether
the passed ptr has a const pointer, the result will always be a non-const
pointer.  Use a _Generic() construct (supported since gcc 4.9 and Clang
3.0) to teach container_of that if converting a const pointer, the
returned pointer should also have the const modifier.

Link: https://lkml.kernel.org/r/20220210170434.3924169-1-dmitry.baryshkov@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/container_of.h~container_ofh-make-container_of-const-aware
+++ a/include/linux/container_of.h
@@ -19,7 +19,11 @@
 	static_assert(__same_type(*(ptr), ((type *)0)->member) ||	\
 		      __same_type(*(ptr), void),			\
 		      "pointer type mismatch in container_of()");	\
-	((type *)(__mptr - offsetof(type, member))); })
+	_Generic((ptr),							\
+		const typeof(((type *)0)->member)*:			\
+			((const type *)(__mptr - offsetof(type, member))), \
+		default: ((type *)(__mptr - offsetof(type, member)))	\
+	); })
 
 /**
  * container_of_safe - cast a member of a structure out to the containing structure
@@ -35,6 +39,10 @@
 		      __same_type(*(ptr), void),			\
 		      "pointer type mismatch in container_of_safe()");	\
 	IS_ERR_OR_NULL(__mptr) ? ERR_CAST(__mptr) :			\
-		((type *)(__mptr - offsetof(type, member))); })
+	_Generic((ptr),							\
+		const typeof(((type *)0)->member)*:			\
+			((const type *)(__mptr - offsetof(type, member))), \
+		default: ((type *)(__mptr - offsetof(type, member)))	\
+	); })
 
 #endif	/* _LINUX_CONTAINER_OF_H */
_

Patches currently in -mm which might be from dmitry.baryshkov@linaro.org are

container_ofh-make-container_of-const-aware.patch

