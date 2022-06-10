Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53246C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jun 2022 16:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346122AbiFJQ3o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Jun 2022 12:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240625AbiFJQ3n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jun 2022 12:29:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB25D56746
        for <mm-commits@vger.kernel.org>; Fri, 10 Jun 2022 09:29:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36584B83637
        for <mm-commits@vger.kernel.org>; Fri, 10 Jun 2022 16:29:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E71ABC34114;
        Fri, 10 Jun 2022 16:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654878580;
        bh=oc2BJ/MGGpSsuVJxClZvqXoJNXnbUrEdVkbexv2CCP4=;
        h=Date:To:From:Subject:From;
        b=k//Arpz+2pIrEN8OhbhLv77TxavvWIUyYs3j+MKui5hnWrUi0eJ0OOve9MmK33NL5
         jy03Pt8M2FpE6/QtMBW818mm0kGZ3ClnZUpJe6XivzbsuCU2gg/WJ0lGBS5qAKw9sm
         g26Iuf3WvQmj16ZLzOwr4RtMne/f7vYyIMIgnJ4I=
Date:   Fri, 10 Jun 2022 09:29:39 -0700
To:     mm-commits@vger.kernel.org, gregkh@linuxfoundation.org,
        david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-memory-hotunplug-section-and-add-myself-as-reviewer.patch added to mm-hotfixes-unstable branch
Message-Id: <20220610162939.E71ABC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add MEMORY HOT(UN)PLUG section and add David as reviewer
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-memory-hotunplug-section-and-add-myself-as-reviewer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-memory-hotunplug-section-and-add-myself-as-reviewer.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/MAINTAINERS~maintainers-add-memory-hotunplug-section-and-add-myself-as-reviewer
+++ a/MAINTAINERS
@@ -12849,6 +12849,18 @@ F:	include/linux/vmalloc.h
 F:	mm/
 F:	tools/testing/selftests/vm/
 
+MEMORY HOT(UN)PLUG
+M:	Andrew Morton <akpm@linux-foundation.org>
+R:	David Hildenbrand <david@redhat.com>
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

maintainers-add-memory-hotunplug-section-and-add-myself-as-reviewer.patch

