Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13476EB64DC
	for <mm-commits@archiver.kernel.org>; Tue, 11 Jul 2023 18:19:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbjGKSTy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Jul 2023 14:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232187AbjGKSTy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2023 14:19:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C83170E
        for <mm-commits@vger.kernel.org>; Tue, 11 Jul 2023 11:19:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AF14614C6
        for <mm-commits@vger.kernel.org>; Tue, 11 Jul 2023 18:19:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83027C433C7;
        Tue, 11 Jul 2023 18:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689099590;
        bh=fv/oVuG4FIfcT2i5NAPwbliCVCE64W/9BGTBjfU8pG0=;
        h=Date:To:From:Subject:From;
        b=cKCCv1RxcHv+hj7LKnofhBfwOrWadKtQBTN9HnyM1R5tFSF0NMG/KG8potH3cW46U
         SlHwBSy1FrmL0t3FJJEWp3csgDXPjEAvsOCLRtWcjlAobwO+p8vkZek03thQhygn8v
         Ki5eghLC+I7xwPhT4tuxbOZjs2z39NqoUnUu3U3Q=
Date:   Tue, 11 Jul 2023 11:19:49 -0700
To:     mm-commits@vger.kernel.org, osalvador@suse.de, mhocko@suse.com,
        corbet@lwn.net, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-document-the-signal_pending-check-in-offline_pages.patch added to mm-unstable branch
Message-Id: <20230711181950.83027C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: document the signal_pending() check in offline_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory_hotplug-document-the-signal_pending-check-in-offline_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-document-the-signal_pending-check-in-offline_pages.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: document the signal_pending() check in offline_pages()
Date: Tue, 11 Jul 2023 19:40:50 +0200

Let's update the documentation that any signal is sufficient, and add a
comment that not only checking for fatal signals is historical baggage:
changing it now could break existing user space.  although unlikely.

For example, when an app provides a custom SIGALRM handler and triggers
memory offlining, the timeout cmd would no longer stop memory offlining,
because SIGALRM would no longer be considered a fatal signal.

Link: https://lkml.kernel.org/r/20230711174050.603820-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/memory-hotplug.rst |    2 +-
 mm/memory_hotplug.c                             |    5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/memory-hotplug.rst~mm-memory_hotplug-document-the-signal_pending-check-in-offline_pages
+++ a/Documentation/admin-guide/mm/memory-hotplug.rst
@@ -669,7 +669,7 @@ when still encountering permanently unmo
 (-> BUG), memory offlining will keep retrying until it eventually succeeds.
 
 When offlining is triggered from user space, the offlining context can be
-terminated by sending a fatal signal. A timeout based offlining can easily be
+terminated by sending a signal. A timeout based offlining can easily be
 implemented via::
 
 	% timeout $TIMEOUT offline_block | failure_handling
--- a/mm/memory_hotplug.c~mm-memory_hotplug-document-the-signal_pending-check-in-offline_pages
+++ a/mm/memory_hotplug.c
@@ -1843,6 +1843,11 @@ int __ref offline_pages(unsigned long st
 	do {
 		pfn = start_pfn;
 		do {
+			/*
+			 * Historically we always checked for any signal and
+			 * can't limit it to fatal signals without eventually
+			 * breaking user space.
+			 */
 			if (signal_pending(current)) {
 				ret = -EINTR;
 				reason = "signal backoff";
_

Patches currently in -mm which might be from david@redhat.com are

mm-memory_hotplug-document-the-signal_pending-check-in-offline_pages.patch

