Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15E4FC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 11 Mar 2022 01:52:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345464AbiCKBxu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Mar 2022 20:53:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345474AbiCKBxt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Mar 2022 20:53:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA4D7B65F8
        for <mm-commits@vger.kernel.org>; Thu, 10 Mar 2022 17:52:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F404B82999
        for <mm-commits@vger.kernel.org>; Fri, 11 Mar 2022 01:52:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361CAC340E8;
        Fri, 11 Mar 2022 01:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646963564;
        bh=OtTyWrAZJ0ftR1JFe7txxH6UF8U6BhgI1qEoo09nus4=;
        h=Date:To:From:Subject:From;
        b=0BAaXybLQQmAXnYNDGoVZFktWb68dkfwI2BkSbbe77o4tfllHWREFlHLqS7B75k6Z
         KWzlKRFBePaRr0RaKckt95yEsaAPy7+D3RtaF+x962iZheXVwLXbJgXavRGkqtauOZ
         MZMrdJPqpN4VdwVR3Jv8GsuzmYTF+JefRhj6xneg=
Date:   Thu, 10 Mar 2022 17:52:43 -0800
To:     mm-commits@vger.kernel.org, ndesaulniers@google.com,
        nathan@kernel.org, mst@redhat.com, corbet@lwn.net,
        bhelgaas@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-sparse-add-hints-about-__checker__.patch added to -mm tree
Message-Id: <20220311015244.361CAC340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/sparse: add hints about __CHECKER__
has been added to the -mm tree.  Its filename is
     documentation-sparse-add-hints-about-__checker__.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/documentation-sparse-add-hints-about-__checker__.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/documentation-sparse-add-hints-about-__checker__.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-typesh-remove-unnecessary-__bitwise__.patch
documentation-sparse-add-hints-about-__checker__.patch

