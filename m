From: akpm@linux-foundation.org
Subject: - mm-debug-write-deadlocks.patch removed from -mm tree
Date: Sun, 04 Feb 2007 01:05:40 -0800
Message-ID: <200702040905.l1495evu026107@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34023 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbXBDJFn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 4 Feb 2007 04:05:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     From: Nick Piggin <npiggin@suse.de>
has been removed from the -mm tree.  Its filename was
     mm-debug-write-deadlocks.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: From: Nick Piggin <npiggin@suse.de>
From: Nick Piggin <npiggin@suse.de>
Return-Path: <npiggin@suse.de>
Received: from localhost (bix [127.0.0.1])
	by localhost.localdomain (8.12.10/8.12.10) with ESMTP id l148oufM016774
	for <akpm@localhost>; Sun, 4 Feb 2007 00:50:57 -0800
Received: from bix [127.0.0.1]
	by localhost with POP3 (fetchmail-6.2.0)
	for akpm@localhost (single-drop); Sun, 04 Feb 2007 00:50:57 -0800 (PST)
Received: from smtp1.osdl.org (smtp1.osdl.org [65.172.181.25])
	by shell0.pdx.osdl.net (8.13.1/8.11.6) with ESMTP id l148odLe025844
	for <akpm@mail.gateway.osdl.net>; Sun, 4 Feb 2007 00:50:39 -0800
Received: from mx2.suse.de (ns2.suse.de [195.135.220.15])
	by smtp1.osdl.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l148oW4Y002450
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <akpm@osdl.org>; Sun, 4 Feb 2007 00:50:34 -0800
Received: from Relay1.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id A4ADB217E4;
	Sun,  4 Feb 2007 09:50:31 +0100 (CET)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Filesystems <linux-fsdevel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>,
        Linux Memory Management <linux-mm@kvack.org>
Message-Id: <20070204063754.23659.28403.sendpatchset@linux.site>
In-Reply-To: <20070204063707.23659.20741.sendpatchset@linux.site>
References: <20070204063707.23659.20741.sendpatchset@linux.site>
Subject: [patch 5/9] mm: debug write deadlocks
Date: Sun,  4 Feb 2007 09:50:28 +0100 (CET)
Received-SPF: none (domain of npiggin@suse.de does not designate permitted sender hosts)
X-MIMEDefang-Filter: osdl$Revision: 1.173 $
X-Scanned-By: MIMEDefang 2.53 on 65.172.181.25
X-Spam-Checker-Version: SpamAssassin 3.0.2 (2004-11-16) on bix
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=2.0 tests=AWL,BAYES_00 autolearn=ham 
	version=3.0.2

Allow CONFIG_DEBUG_VM to switch off the prefaulting logic, to simulate the
difficult race where the page may be unmapped before calling copy_from_user.
Makes the race much easier to hit.

This is useful for demonstration and testing purposes, but is removed in a
subsequent patch.

Signed-off-by: Nick Piggin <npiggin@suse.de>

Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c
+++ linux-2.6/mm/filemap.c
@@ -2103,6 +2103,7 @@ generic_file_buffered_write(struct kiocb
 		if (maxlen > bytes)
 			maxlen = bytes;
 
+#ifndef CONFIG_DEBUG_VM
 		/*
 		 * Bring in the user page that we will copy from _first_.
 		 * Otherwise there's a nasty deadlock on copying from the
@@ -2110,6 +2111,7 @@ generic_file_buffered_write(struct kiocb
 		 * up-to-date.
 		 */
 		fault_in_pages_readable(buf, maxlen);
+#endif
 
 		page = __grab_cache_page(mapping,index,&cached_page,&lru_pvec);
 		if (!page) {

Patches currently in -mm which might be from npiggin@suse.de are

mm-only-mm-debug-write-deadlocks.patch
mm-fix-pagecache-write-deadlocks.patch
mm-fix-pagecache-write-deadlocks-comment.patch
mm-fix-pagecache-write-deadlocks-mm-pagecache-write-deadlocks-efault-fix.patch
mm-fix-pagecache-write-deadlocks-zerolength-fix.patch
mm-fix-pagecache-write-deadlocks-stale-holes-fix.patch
fs-prepare_write-fixes.patch
fs-prepare_write-fixes-fuse-fix.patch
fs-prepare_write-fixes-jffs-fix.patch
fs-prepare_write-fixes-fat-fix.patch
fs-fix-cont-vs-deadlock-patches.patch
git-block.patch
buffer-memorder-fix.patch
sched-avoid-div-in-rebalance_tick.patch
