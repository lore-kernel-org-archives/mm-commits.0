Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD453C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:48:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5F9A61108
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:48:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234453AbhKKCv0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:51:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:55736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234449AbhKKCv0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:51:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A02666103C;
        Thu, 11 Nov 2021 02:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598917;
        bh=52Et/IBH06FTfkxcRrlFNrLKiHKh9LgOM6ifj70jyl8=;
        h=Date:From:To:Subject:From;
        b=PurDX+/q9s3LLnRExODXCH17UMXzt0jOCZ1BfLvz5ldPY5Ez5N+Hfw2KrOBWXHLIu
         wPnI9/UjSzHfQN9/f3BLsRAlQLCdKPxiSt0Iw4juVePn1NgZrZCzJw9TFY5hTmIddX
         WkY9u8IlrEh2yeeH7qKNqijcFt3+G/l7Tpaxv4m0=
Date:   Wed, 10 Nov 2021 18:48:37 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sjpark@amazon.de
Subject:  [merged]
 documentation-vm-move-user-guides-to-admin-guide-mm.patch removed from -mm
 tree
Message-ID: <20211111024837.pxQilD14-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/vm: move user guides to admin-guide/mm/
has been removed from the -mm tree.  Its filename was
     documentation-vm-move-user-guides-to-admin-guide-mm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sjpark@amazon.de>
Subject: Documentation/vm: move user guides to admin-guide/mm/

Most memory management user guide documents are in 'admin-guide/mm/', but
two of those are in 'vm/'.  This commit moves the two docs into
'admin-guide/mm' for easier documents finding.

Link: https://lkml.kernel.org/r/20210917123958.3819-2-sj@kernel.org
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/index.rst        |  2 ++
 .../{vm => admin-guide/mm}/swap_numa.rst      |  0
 .../{vm => admin-guide/mm}/zswap.rst          |  0
 Documentation/vm/index.rst                    | 26 ++++---------------
 4 files changed, 7 insertions(+), 21 deletions(-)
 rename Documentation/{vm => admin-guide/mm}/swap_numa.rst (100%)
 rename Documentation/{vm => admin-guide/mm}/zswap.rst (100%)

diff --git a/Documentation/admin-guide/mm/index.rst b/Documentation/admin-guide/mm/index.rst
index cbd19d5e625f..c21b5823f126 100644
--- a/Documentation/admin-guide/mm/index.rst
+++ b/Documentation/admin-guide/mm/index.rst
@@ -37,5 +37,7 @@ the Linux memory management.
    numaperf
    pagemap
    soft-dirty
+   swap_numa
    transhuge
    userfaultfd
+   zswap
diff --git a/Documentation/vm/swap_numa.rst b/Documentation/admin-guide/mm/swap_numa.rst
similarity index 100%
rename from Documentation/vm/swap_numa.rst
rename to Documentation/admin-guide/mm/swap_numa.rst
diff --git a/Documentation/vm/zswap.rst b/Documentation/admin-guide/mm/zswap.rst
similarity index 100%
rename from Documentation/vm/zswap.rst
rename to Documentation/admin-guide/mm/zswap.rst
diff --git a/Documentation/vm/index.rst b/Documentation/vm/index.rst
index b51f0d8992f8..6f5ffef4b716 100644
--- a/Documentation/vm/index.rst
+++ b/Documentation/vm/index.rst
@@ -3,27 +3,11 @@ Linux Memory Management Documentation
 =====================================
 
 This is a collection of documents about the Linux memory management (mm)
-subsystem.  If you are looking for advice on simply allocating memory,
-see the :ref:`memory_allocation`.
-
-User guides for MM features
-===========================
-
-The following documents provide guides for controlling and tuning
-various features of the Linux memory management
-
-.. toctree::
-   :maxdepth: 1
-
-   swap_numa
-   zswap
-
-Kernel developers MM documentation
-==================================
-
-The below documents describe MM internals with different level of
-details ranging from notes and mailing list responses to elaborate
-descriptions of data structures and algorithms.
+subsystem internals with different level of details ranging from notes and
+mailing list responses for elaborating descriptions of data structures and
+algorithms.  If you are looking for advice on simply allocating memory, see the
+:ref:`memory_allocation`.  For controlling and tuning guides, see the
+:doc:`admin guide <../admin-guide/mm/index>`.
 
 .. toctree::
    :maxdepth: 1
-- 
2.17.1


Patches currently in -mm which might be from sjpark@amazon.de are


