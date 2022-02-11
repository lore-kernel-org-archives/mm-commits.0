Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D02A0C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 11 Feb 2022 22:05:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240395AbiBKWFr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Feb 2022 17:05:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353917AbiBKWFq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Feb 2022 17:05:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2BDC72
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 14:05:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC0CE611D1
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 22:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077A9C340E9;
        Fri, 11 Feb 2022 22:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644617144;
        bh=3nLzWkUKdH4Q7f1BiM2INLk2Egi9FuzQO/u9pDX/fp8=;
        h=Date:To:From:Subject:From;
        b=JFWgSOytKL1bLrxRO2iRSE5Ftv8irgIN5mkV/o1EwriiUEXwBo6UM8lYXqTa1ge7H
         55HCVozXNan+45npGeUF505jBqfTUv+MjFhaka1d8J72SpngSYqlzReWOxnQQH8PLj
         gsxan7TVdKi2VsL8mf0xuh1CEKV54RbNw7rcEqJ8=
Date:   Fri, 11 Feb 2022 14:05:43 -0800
To:     mm-commits@vger.kernel.org, dmitry.baryshkov@linaro.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] container_ofh-make-container_of-const-aware.patch removed from -mm tree
Message-Id: <20220211220544.077A9C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: container_of.h: make container_of const-aware
has been removed from the -mm tree.  Its filename was
     container_ofh-make-container_of-const-aware.patch

This patch was dropped because it had testing failures

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


