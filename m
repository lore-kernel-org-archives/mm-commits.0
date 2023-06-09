Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 544CFC7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232602AbjFIX1t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbjFIX1T (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:27:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7009730E8
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:27:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04A5461ACC
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:27:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59213C433EF;
        Fri,  9 Jun 2023 23:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353237;
        bh=xmGXEYYKu0ddN7wRhNn48pDQe5eYw3/YpbUQowGgXM0=;
        h=Date:To:From:Subject:From;
        b=j8HDVAX8ardBqinHPRts3/wqqqh2kon2jItc8X/lxBwn8PyXFRwhBjbPpd9UylkCc
         86fHQnkzZ1125VzKc7S1CBtNB+bFh8P7XgL67f/SfAP3shC7HlHf+rzAJdbHYfSQrC
         KxhVpK7/u3ypOZkHN462NuXOZ13GF82OJvQhCezE=
Date:   Fri, 09 Jun 2023 16:27:16 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, osalvador@suse.de,
        david@redhat.com, rick.wertenbroek@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_hotplug-fix-format-string-in-warnings.patch removed from -mm tree
Message-Id: <20230609232717.59213C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory_hotplug: fix format string in warnings
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-fix-format-string-in-warnings.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Rick Wertenbroek <rick.wertenbroek@gmail.com>
Subject: mm: memory_hotplug: fix format string in warnings
Date: Wed, 10 May 2023 11:07:57 +0200

The format string in __add_pages and __remove_pages has a typo and prints
e.g., "Misaligned __add_pages start: 0xfc605 end: #fc609" instead of
"Misaligned __add_pages start: 0xfc605 end: 0xfc609" Fix "#%lx" => "%#lx"

Link: https://lkml.kernel.org/r/20230510090758.3537242-1-rick.wertenbroek@gmail.com
Signed-off-by: Rick Wertenbroek <rick.wertenbroek@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-fix-format-string-in-warnings
+++ a/mm/memory_hotplug.c
@@ -325,7 +325,7 @@ int __ref __add_pages(int nid, unsigned
 	}
 
 	if (check_pfn_span(pfn, nr_pages)) {
-		WARN(1, "Misaligned %s start: %#lx end: #%lx\n", __func__, pfn, pfn + nr_pages - 1);
+		WARN(1, "Misaligned %s start: %#lx end: %#lx\n", __func__, pfn, pfn + nr_pages - 1);
 		return -EINVAL;
 	}
 
@@ -525,7 +525,7 @@ void __remove_pages(unsigned long pfn, u
 	map_offset = vmem_altmap_offset(altmap);
 
 	if (check_pfn_span(pfn, nr_pages)) {
-		WARN(1, "Misaligned %s start: %#lx end: #%lx\n", __func__, pfn, pfn + nr_pages - 1);
+		WARN(1, "Misaligned %s start: %#lx end: %#lx\n", __func__, pfn, pfn + nr_pages - 1);
 		return;
 	}
 
_

Patches currently in -mm which might be from rick.wertenbroek@gmail.com are


