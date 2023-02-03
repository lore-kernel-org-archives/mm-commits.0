Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85E76C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:42:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbjBCGmu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:42:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232204AbjBCGl2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:41:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD37B2705
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9067C61DA8
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:37:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94EAC433D2;
        Fri,  3 Feb 2023 06:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406279;
        bh=7bBXF1ItwB1rX0MMrQQzYlaKzNnQ0bXzyL2xQ+lLG7w=;
        h=Date:To:From:Subject:From;
        b=fXQ5FIbchoxRpdv4R9giBQUcdeWym9E1S84xHWGxDQNPLLs4Ha3r9G70BZ6zO7VhT
         VBeP4Z7wJP3kBrKDeLrNdsyQ9Dp9k6rkZ1b3U/FmQ0yAR9lc8XWOEjen5K2v7PUwa5
         dJimmK3ahnV/PbkA2hwnmtfCkY0iK+D7Bw+eXKo4=
Date:   Thu, 02 Feb 2023 22:37:58 -0800
To:     mm-commits@vger.kernel.org, rppt@kernel.org, ira.weiny@intel.com,
        fmdefrancesco@gmail.com, corbet@lwn.net, bigeasy@linutronix.de,
        wangdeming@inspur.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] documentation-mm-use-s-higmem-highmem-fix-typo-for-highmem.patch removed from -mm tree
Message-Id: <20230203063758.E94EAC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Documentation: mm: use `s/higmem/highmem/` fix typo for highmem
has been removed from the -mm tree.  Its filename was
     documentation-mm-use-s-higmem-highmem-fix-typo-for-highmem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Deming Wang <wangdeming@inspur.com>
Subject: Documentation: mm: use `s/higmem/highmem/` fix typo for highmem
Date: Tue, 17 Jan 2023 21:54:03 -0500

We should use highmem replace higmem.

Link: https://lkml.kernel.org/r/20230118025403.1531-1-wangdeming@inspur.com
Signed-off-by: Deming Wang <wangdeming@inspur.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Cc: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/mm/highmem.rst~documentation-mm-use-s-higmem-highmem-fix-typo-for-highmem
+++ a/Documentation/mm/highmem.rst
@@ -83,7 +83,7 @@ list shows them in order of preference o
   for pages which are known to not come from ZONE_HIGHMEM. However, it is
   always safe to use kmap_local_page() / kunmap_local().
 
-  While it is significantly faster than kmap(), for the higmem case it
+  While it is significantly faster than kmap(), for the highmem case it
   comes with restrictions about the pointers validity. Contrary to kmap()
   mappings, the local mappings are only valid in the context of the caller
   and cannot be handed to other contexts. This implies that users must
_

Patches currently in -mm which might be from wangdeming@inspur.com are


