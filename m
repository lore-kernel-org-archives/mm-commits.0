Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82A9EC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357443AbiCYBg7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357485AbiCYBfx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864083152E
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:33:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32B84B8261B
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:33:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6371C340ED;
        Fri, 25 Mar 2022 01:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648172022;
        bh=+HYaWM6jq3pKpxV6UgG2khyMn2e1rf6DDUk99AXxiGE=;
        h=Date:To:From:Subject:From;
        b=fvTtMKwapm+YCsWYtmpCvSsK4oIuCw6qOb/EG2HQII76fgp9Nni0BTVxkPpRYKquS
         DTuIBxDGPBm1D46G7TnziR75Qb37/unF+h+jEO4wl9G2t92YN63s5Z/Wp9eM9ZvPmo
         tv3l5xj70vsobv00zn96RPQzj1Oe4jJ8UL445KB0=
Date:   Thu, 24 Mar 2022 18:33:42 -0700
To:     mm-commits@vger.kernel.org, ndesaulniers@google.com,
        nathan@kernel.org, mst@redhat.com, corbet@lwn.net,
        bhelgaas@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] linux-typesh-remove-unnecessary-__bitwise__.patch removed from -mm tree
Message-Id: <20220325013342.C6371C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux/types.h: remove unnecessary __bitwise__
has been removed from the -mm tree.  Its filename was
     linux-typesh-remove-unnecessary-__bitwise__.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bjorn Helgaas <bhelgaas@google.com>
Subject: linux/types.h: remove unnecessary __bitwise__

There are no users of "__bitwise__" except the definition of "__bitwise". 
Remove __bitwise__ and define __bitwise directly.

This is a follow-up to 05de97003c77 ("linux/types.h: enable endian checks
for all sparse builds").

[akpm@linux-foundation.org: change the tools/include/linux/types.h definition also]
Link: https://lkml.kernel.org/r/20220310220927.245704-2-helgaas@kernel.org
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/types.h  |    5 ++---
 tools/include/linux/types.h |    5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

--- a/include/uapi/linux/types.h~linux-typesh-remove-unnecessary-__bitwise__
+++ a/include/uapi/linux/types.h
@@ -20,11 +20,10 @@
  */
 
 #ifdef __CHECKER__
-#define __bitwise__ __attribute__((bitwise))
+#define __bitwise	__attribute__((bitwise))
 #else
-#define __bitwise__
+#define __bitwise
 #endif
-#define __bitwise __bitwise__
 
 typedef __u16 __bitwise __le16;
 typedef __u16 __bitwise __be16;
--- a/tools/include/linux/types.h~linux-typesh-remove-unnecessary-__bitwise__
+++ a/tools/include/linux/types.h
@@ -43,11 +43,10 @@ typedef __u8  u8;
 typedef __s8  s8;
 
 #ifdef __CHECKER__
-#define __bitwise__ __attribute__((bitwise))
+#define __bitwise	__attribute__((bitwise))
 #else
-#define __bitwise__
+#define __bitwise
 #endif
-#define __bitwise __bitwise__
 
 #define __force
 #define __user
_

Patches currently in -mm which might be from bhelgaas@google.com are


