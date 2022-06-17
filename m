Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67DA2CCA47F
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:12:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379421AbiFQCMb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379690AbiFQCMX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:12:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B9E64BEA
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:12:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C6BF61C0A
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:12:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D41BAC34114;
        Fri, 17 Jun 2022 02:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655431939;
        bh=TVFUyvcDnBJyy4J+rl866Ajez0PPMEfi7DX2BGr8Kkc=;
        h=Date:To:From:Subject:From;
        b=bC8V4FpLQjHxSYeM1dysIF13toDMa1xQceoYUQv/5hxIWkoY2gnIdaPaYQKqs2fBS
         +Pz2W7pxAUua/Nt00MYseIMrqiBPwiM/mrfAQ3W9ffskELEU5pca3/hI+vKdsczlf9
         V1ekvbZhqYmzwvdLvfgOJOgv0VgSqj3llyQQQRoE=
Date:   Thu, 16 Jun 2022 19:12:19 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        linmiaohe@huawei.com, gregkh@linuxfoundation.org, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-memory-hotunplug-section-and-add-myself-as-reviewer.patch removed from -mm tree
Message-Id: <20220617021219.D41BAC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: MAINTAINERS: add MEMORY HOT(UN)PLUG section and add David as reviewer
has been removed from the -mm tree.  Its filename was
     maintainers-add-memory-hotunplug-section-and-add-myself-as-reviewer.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: MAINTAINERS: add MEMORY HOT(UN)PLUG section and add David as reviewer
Date: Fri, 10 Jun 2022 12:12:58 +0200

There are certainly a lot more files that partially fall into the memory
hot(un)plug category, including parts of mm/sparse.c, mm/page_isolation.c
and mm/page_alloc.c.  Let's only add what's almost completely memory
hot(un)plug related.

Add myself as reviewer so it's easier for contributors to figure out
whom to CC.

Link: https://lkml.kernel.org/r/20220610101258.75738-1-david@redhat.com
Link: https://lkml.kernel.org/r/YqlaE/LYHwB0gpaW@localhost.localdomain
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/MAINTAINERS~maintainers-add-memory-hotunplug-section-and-add-myself-as-reviewer
+++ a/MAINTAINERS
@@ -12858,6 +12858,18 @@ F:	include/linux/vmalloc.h
 F:	mm/
 F:	tools/testing/selftests/vm/
 
+MEMORY HOT(UN)PLUG
+M:	David Hildenbrand <david@redhat.com>
+M:	Oscar Salvador <osalvador@suse.de>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	Documentation/admin-guide/mm/memory-hotplug.rst
+F:	Documentation/core-api/memory-hotplug.rst
+F:	drivers/base/memory.c
+F:	include/linux/memory_hotplug.h
+F:	mm/memory_hotplug.c
+F:	tools/testing/selftests/memory-hotplug/
+
 MEMORY TECHNOLOGY DEVICES (MTD)
 M:	Miquel Raynal <miquel.raynal@bootlin.com>
 M:	Richard Weinberger <richard@nod.at>
_

Patches currently in -mm which might be from david@redhat.com are

mm-mprotect-try-avoiding-write-faults-for-exclusive-anonymous-pages-when-changing-protection.patch

