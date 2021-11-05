Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 370B2C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:45:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 279476135A
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:45:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233656AbhKEUsi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:48:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233721AbhKEUsf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:48:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B29296128E;
        Fri,  5 Nov 2021 20:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145155;
        bh=a5iguRVVsaUX5MP+JBas7djnZS060/ku0HoRGXwJopY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=A8Jjy1nU1XIswAhkdICGoC4dyiB1WwU77YLPcJA1LM+GkKedMX8ie2xqzsAvzJq90
         bGA8Av4bEdgR4Pdt9NUbI82DUZZijBARQgHZDX+Lu4OSeTdqW+FoxKMmZlhjEmg0vg
         g4C1skzVni31OoxDL105dSk6n+eZegPyHxVxTU0k=
Date:   Fri, 05 Nov 2021 13:45:55 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sjpark@amazon.de,
        torvalds@linux-foundation.org
Subject:  [patch 215/262] Documentation/vm: move user guides to
 admin-guide/mm/
Message-ID: <20211105204555.ggENH4V6V%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

