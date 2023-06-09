Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A13BC7EE43
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:33:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233340AbjFIXda (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233016AbjFIXcU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:32:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9071046BD
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E54D60FCA
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B23C4339B;
        Fri,  9 Jun 2023 23:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353389;
        bh=vB1hYNGbYwcN/Y7kE3E0Io4T8ziy9fWl0ECv96H2HRE=;
        h=Date:To:From:Subject:From;
        b=D4CFDnekYdO1SoI8ox0v0ZRqdpyHFo9ozgUdrx03B0Iw9VkDCImJFVCSKPIb9kbrQ
         Zo6DOCZquIE5RFHT4zH5RI41e03NlhAiMV0hDqj1qHIp/0j0kmAlGwQU2KWJeUYJRh
         nrghCPu7daSEwyAc5u4i09h9DlZlnLAIYiWK1u+0=
Date:   Fri, 09 Jun 2023 16:29:48 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-add-a-section-for-the-modules-layer.patch removed from -mm tree
Message-Id: <20230609232949.73B23C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/mm/damon/design: add a section for the modules layer
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-add-a-section-for-the-modules-layer.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: add a section for the modules layer
Date: Thu, 25 May 2023 21:43:14 +0000

Add a section for covering DAMON modules layer to the design document.

Link: https://lkml.kernel.org/r/20230525214314.5204-11-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   61 ++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-add-a-section-for-the-modules-layer
+++ a/Documentation/mm/damon/design.rst
@@ -370,3 +370,64 @@ access-aware applications using DAMON's
 its all features to other kernel components via its application programming
 interface, namely ``include/linux/damon.h``.  Please refer to the API
 :doc:`document </mm/damon/api>` for details of the interface.
+
+
+Modules
+=======
+
+Because the core of DAMON is a framework for kernel components, it doesn't
+provide any direct interface for the user space.  Such interfaces should be
+implemented by each DAMON API user kernel components, instead.  DAMON subsystem
+itself implements such DAMON API user modules, which are supposed to be used
+for general purpose DAMON control and special purpose data access-aware system
+operations, and provides stable application binary interfaces (ABI) for the
+user space.  The user space can build their efficient data access-aware
+applications using the interfaces.
+
+
+General Purpose User Interface Modules
+--------------------------------------
+
+DAMON modules that provide user space ABIs for general purpose DAMON usage in
+runtime.
+
+DAMON user interface modules, namely 'DAMON sysfs interface' and 'DAMON debugfs
+interface' are DAMON API user kernel modules that provide ABIs to the
+user-space.  Please note that DAMON debugfs interface is currently deprecated.
+
+Like many other ABIs, the modules create files on sysfs and debugfs, allow
+users to specify their requests to and get the answers from DAMON by writing to
+and reading from the files.  As a response to such I/O, DAMON user interface
+modules control DAMON and retrieve the results as user requested via the DAMON
+API, and return the results to the user-space.
+
+The ABIs are designed to be used for user space applications development,
+rather than human beings' fingers.  Human users are recommended to use such
+user space tools.  One such Python-written user space tool is available at
+Github (https://github.com/awslabs/damo), Pypi
+(https://pypistats.org/packages/damo), and Fedora
+(https://packages.fedoraproject.org/pkgs/python-damo/damo/).
+
+Please refer to the ABI :doc:`document </admin-guide/mm/damon/usage>` for
+details of the interfaces.
+
+
+Special-Purpose Access-aware Kernel Modules
+-------------------------------------------
+
+DAMON modules that provide user space ABI for specific purpose DAMON usage.
+
+DAMON sysfs/debugfs user interfaces are for full control of all DAMON features
+in runtime.  For each special-purpose system-wide data access-aware system
+operations such as proactive reclamation or LRU lists balancing, the interfaces
+could be simplified by removing unnecessary knobs for the specific purpose, and
+extended for boot-time and even compile time control.  Default values of DAMON
+control parameters for the usage would also need to be optimized for the
+purpose.
+
+To support such cases, yet more DAMON API user kernel modules that provide more
+simple and optimized user space interfaces are available.  Currently, two
+modules for proactive reclamation and LRU lists manipulation are provided.  For
+more detail, please read the usage documents for those
+(:doc:`/admin-guide/mm/damon/reclaim` and
+:doc:`/admin-guide/mm/damon/lru_sort`).
_

Patches currently in -mm which might be from sj@kernel.org are


