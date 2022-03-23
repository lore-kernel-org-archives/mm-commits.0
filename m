Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A5BCC4332F
	for <mm-commits@archiver.kernel.org>; Wed, 23 Mar 2022 23:05:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245508AbiCWXHI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Mar 2022 19:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345364AbiCWXHE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2022 19:07:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B217664C
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 16:05:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5521617EA
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 23:05:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A5DC340E9;
        Wed, 23 Mar 2022 23:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648076733;
        bh=huRtLd3IyAZiFcvOlbKYywi3pZj0ri9nk+6yuVYFGUM=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=YIm6DHiilnPB3zgKvBeimHM3MgU8Vhs+kHN9R4MwYfbhDPn8aT/jtyEKas19Oh1bg
         oItp3+oaI/RLslHXEE0K0I267/A7CSGIf5Bt9mOv4LLq8nq54eVGv1RMNYFa5GCv52
         1/9n9ieojojiMvMy9Kg2qpiAmyiRPZr312wMSKyo=
Date:   Wed, 23 Mar 2022 16:05:32 -0700
To:     ndesaulniers@google.com, nathan@kernel.org, mst@redhat.com,
        corbet@lwn.net, bhelgaas@google.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220323160453.65922ced539cbf445b191555@linux-foundation.org>
Subject: [patch 05/41] Documentation/sparse: add hints about __CHECKER__
Message-Id: <20220323230533.28A5DC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>
Subject: Documentation/sparse: add hints about __CHECKER__

Several attributes depend on __CHECKER__, but previously there was no clue
in the tree about when __CHECKER__ might be defined.  Add hints at the
most common places (__kernel, __user, __iomem, __bitwise) and in the
sparse documentation.

Link: https://lkml.kernel.org/r/20220310220927.245704-3-helgaas@kernel.org
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/sparse.rst |    2 ++
 include/linux/compiler_types.h     |    1 +
 include/uapi/linux/types.h         |    1 +
 3 files changed, 4 insertions(+)

--- a/Documentation/dev-tools/sparse.rst~documentation-sparse-add-hints-about-__checker__
+++ a/Documentation/dev-tools/sparse.rst
@@ -100,3 +100,5 @@ have already built it.
 
 The optional make variable CF can be used to pass arguments to sparse.  The
 build system passes -Wbitwise to sparse automatically.
+
+Note that sparse defines the __CHECKER__ preprocessor symbol.
--- a/include/linux/compiler_types.h~documentation-sparse-add-hints-about-__checker__
+++ a/include/linux/compiler_types.h
@@ -4,6 +4,7 @@
 
 #ifndef __ASSEMBLY__
 
+/* sparse defines __CHECKER__; see Documentation/dev-tools/sparse.rst */
 #ifdef __CHECKER__
 /* address spaces */
 # define __kernel	__attribute__((address_space(0)))
--- a/include/uapi/linux/types.h~documentation-sparse-add-hints-about-__checker__
+++ a/include/uapi/linux/types.h
@@ -19,6 +19,7 @@
  * any application/library that wants linux/types.h.
  */
 
+/* sparse defines __CHECKER__; see Documentation/dev-tools/sparse.rst */
 #ifdef __CHECKER__
 #define __bitwise	__attribute__((bitwise))
 #else
_
