Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F385C7EE29
	for <mm-commits@archiver.kernel.org>; Thu, 25 May 2023 21:51:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241959AbjEYVvg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 17:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241978AbjEYVvd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 17:51:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F331A4
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 14:50:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C95A164B90
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 21:50:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC4DC433D2;
        Thu, 25 May 2023 21:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685051426;
        bh=iIARUtm0HQm9rWS26wC1Ztnm30PUCMYNjlS+N+bUM4U=;
        h=Date:To:From:Subject:From;
        b=0mUJTGdgteGD3HmqIwUtJLKcCcyMXLOof/AjaIhHysXbdAbPvD9xtkH/EgyNNP49E
         wIOn/jIdcRkUE8h1eTazRXVv3AZwfgkssEKVUVhD+EQIc5PIDflO4/7d2W3bathZpN
         lh78YhRdDmhvQFq33FvzhWvZdDsFNGqkUUUFXvss=
Date:   Thu, 25 May 2023 14:50:25 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-add-a-section-for-the-modules-layer.patch added to mm-unstable branch
Message-Id: <20230525215026.2AC4DC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/mm/damon/design: add a section for the modules layer
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-add-a-section-for-the-modules-layer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-add-a-section-for-the-modules-layer.patch

This patch will later appear in the mm-unstable branch at
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

docs-mm-damon-faq-remove-old-questions.patch
docs-mm-damon-maintainer-profile-fix-typos-and-grammar-errors.patch
docs-mm-damon-design-add-a-section-for-overall-architecture.patch
docs-mm-damon-design-update-the-layout-based-on-the-layers.patch
docs-mm-damon-design-rewrite-configurable-layers.patch
docs-mm-damon-design-add-a-section-for-the-relation-between-core-and-modules-layer.patch
docs-mm-damon-design-add-sections-for-basic-parts-of-damos.patch
docs-mm-damon-design-add-sections-for-advanced-features-of-damos.patch
docs-mm-damon-design-add-a-section-for-damon-core-api.patch
docs-mm-damon-design-add-a-section-for-the-modules-layer.patch

