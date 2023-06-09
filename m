Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78803C7EE25
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:33:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbjFIXdT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232984AbjFIXcI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:32:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 314F13C32
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1320F63EB7
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D143C4339B;
        Fri,  9 Jun 2023 23:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353385;
        bh=Ce8K5sNEx/7GTpraIR8L5VfwO2PpukEARuFLjsxak8E=;
        h=Date:To:From:Subject:From;
        b=Vz38GWApy1atIiy84P4pIpasOA4l9TQjuhegASN/fqf5EaYiPXI9v8UokqXTq5he+
         eBI0f+/ZRSQZkth63RBNb3Zkpw3UvgrG72pVmXBedy4dVk4xZx7oSeL7O7tJ5eKTwf
         j7CYUHFl/n4vFWZ1YngmqhYn3SLDirx6y1PMBG6k=
Date:   Fri, 09 Jun 2023 16:29:44 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-add-a-section-for-the-relation-between-core-and-modules-layer.patch removed from -mm tree
Message-Id: <20230609232945.6D143C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/mm/damon/design: add a section for the relation between Core and Modules layer
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-add-a-section-for-the-relation-between-core-and-modules-layer.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: add a section for the relation between Core and Modules layer
Date: Thu, 25 May 2023 21:43:10 +0000

Add overall desription of the interface and the relation between the Core
and the Modules layer under 'Overall Architecture' section.

Link: https://lkml.kernel.org/r/20230525214314.5204-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-add-a-section-for-the-relation-between-core-and-modules-layer
+++ a/Documentation/mm/damon/design.rst
@@ -41,6 +41,16 @@ Also, if some architectures or devices s
 check primitives, those will be easily configurable.
 
 
+Programmable Modules
+--------------------
+
+Core layer of DAMON is implemented as a framework, and exposes its application
+programming interface to all kernel space components such as subsystems and
+modules.  For common use cases of DAMON, DAMON subsystem provides kernel
+modules that built on top of the core layer using the API, which can be easily
+used by the user space end users.
+
+
 Operations Set Layer
 ====================
 
_

Patches currently in -mm which might be from sj@kernel.org are


