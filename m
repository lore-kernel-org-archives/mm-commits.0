Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 659A4C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 05:37:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbjBCFhN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 00:37:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbjBCFhM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 00:37:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711643B3DB
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 21:37:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F0EAB828B3
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 05:37:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CEB1C433D2;
        Fri,  3 Feb 2023 05:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675402628;
        bh=3Woeto8dFmHfij2yMkrXEUiWJaywpizjCnnTw8be4Po=;
        h=Date:To:From:Subject:From;
        b=pCaKYsoAOqGZnLXAHNrOpQwPRW1qv9tGqWSRCjsm/Ey4yyXsqL1r4EQb7k969cxD+
         X/Cnmmgpbeqt4Zd316/1Sdz87XoPf71ZlZiwyfFc1Ha0tvLo/M5u82eYgGBsfstIhj
         4Qkskty8HFoTY8kDobBJ/7OU1A3ooklZ36DaeMUk=
Date:   Thu, 02 Feb 2023 21:37:07 -0800
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        fmdefrancesco@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-highmem-add-notes-about-conversions-from-kmap_atomic-v3.patch removed from -mm tree
Message-Id: <20230203053708.8CEB1C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-highmem-add-notes-about-conversions-from-kmap_atomic-v3
has been removed from the -mm tree.  Its filename was
     mm-highmem-add-notes-about-conversions-from-kmap_atomic-v3.patch

This patch was dropped because it was folded into mm-highmem-add-notes-about-conversions-from-kmap_atomic.patch

------------------------------------------------------
From: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Subject: mm-highmem-add-notes-about-conversions-from-kmap_atomic-v3
Date: Thu, 19 Jan 2023 13:39:45 +0100

merge two sentences into one, per Bagas

Link: https://lkml.kernel.org/r/20230119123945.10471-1-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/mm/highmem.rst~mm-highmem-add-notes-about-conversions-from-kmap_atomic-v3
+++ a/Documentation/mm/highmem.rst
@@ -57,8 +57,8 @@ list shows them in order of preference o
   It can be invoked from any context (including interrupts) but the mappings
   can only be used in the context which acquired them.
 
-  This function should always be used. kmap_atomic() and kmap() have been
-  deprecated.
+  This function should always be used, whereas kmap_atomic() and kmap() have
+  been deprecated.
 
   These mappings are thread-local and CPU-local, meaning that the mapping
   can only be accessed from within this thread and the thread is bound to the
_

Patches currently in -mm which might be from fmdefrancesco@gmail.com are

mm-highmem-add-notes-about-conversions-from-kmap_atomic.patch

