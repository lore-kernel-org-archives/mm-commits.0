Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 764BEC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348864AbiCYBgo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357457AbiCYBfx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E850831344
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:33:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 786AB60A66
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:33:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6E1C340EE;
        Fri, 25 Mar 2022 01:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648172023;
        bh=fakVWj/rPBbzwXC666TiciB+pft97hlnKW8zNT/+aP8=;
        h=Date:To:From:Subject:From;
        b=EvzwbE/bCI2AGIRdD9qF71T5ri4XuRQS/RnzBj5kPzqf4UrWueReBxD08IDBmNcpK
         Q7T294nw/gC/29v+c2U2xS+4KYuqMVUuLxlfUtJJIAQKBmQ7jKNcNfvrQvik7Ldn9f
         mYPIxbcEkRsDlUR/NDCMequoOsau11qIgHjHGnek=
Date:   Thu, 24 Mar 2022 18:33:43 -0700
To:     mm-commits@vger.kernel.org, ndesaulniers@google.com,
        nathan@kernel.org, mst@redhat.com, corbet@lwn.net,
        bhelgaas@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] documentation-sparse-add-hints-about-__checker__.patch removed from -mm tree
Message-Id: <20220325013343.CE6E1C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/sparse: add hints about __CHECKER__
has been removed from the -mm tree.  Its filename was
     documentation-sparse-add-hints-about-__checker__.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from bhelgaas@google.com are


