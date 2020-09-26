Return-Path: <SRS0=7eMQ=DD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1D6CC4727D
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 01:58:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C2B2221EB
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 01:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601085504;
	bh=XJE38d24374ivFYcq9s0lypNPkQWY/x6TbLEMhGO4YI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=rNVwy/1DzD9UhHaswZ/YZpHoqHIXWRC/BnEPY/YFN1ZnzWXc89DBDm/YLIm8amJ5I
	 np8zxz15Dw8BdeiJaa3ceOLrF9NH19/CCsEIC+uWdQQo4D0KvG3IiIFJJiM7hsji9Y
	 2DywB70rLtVRWme6vcHklMC+z/nV10m03EognZ8w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729966AbgIZB6Y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Sep 2020 21:58:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:40730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729961AbgIZB6Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 25 Sep 2020 21:58:24 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87ADC20936;
        Sat, 26 Sep 2020 01:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601085503;
        bh=XJE38d24374ivFYcq9s0lypNPkQWY/x6TbLEMhGO4YI=;
        h=Date:From:To:Subject:From;
        b=qUG5rtLiuVzFP/T5wEpEu0SxKsNRas2Q7KPWRd4vBF/4wRMWizLt8SSGksb6NFcf+
         U+hvO6LR0d4hz0dNAO07i3sEEz3gpVVh2yp7jPJRAsqBAYW0R0VZsZ735Jx7Zki8wv
         1WLODQ7Zg976hq6mCk40vf+dlGU3M/ASK+4iVk18=
Date:   Fri, 25 Sep 2020 18:58:23 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, jack@suse.cz, mm-commits@vger.kernel.org,
        tklauser@distanz.ch, viro@zeniv.linux.org.uk
Subject:  [merged]
 fs-adjust-dirtytime_interval_handler-definition-to-match-prototype.patch
 removed from -mm tree
Message-ID: <20200926015823.FhFdRVtYJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/fs-writeback.c: adjust dirtytime_interval_handler definition to match prototype
has been removed from the -mm tree.  Its filename was
     fs-adjust-dirtytime_interval_handler-definition-to-match-prototype.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tobias Klauser <tklauser@distanz.ch>
Subject: fs/fs-writeback.c: adjust dirtytime_interval_handler definition to match prototype

Commit 32927393dc1c ("sysctl: pass kernel pointers to ->proc_handler")
changed ctl_table.proc_handler to take a kernel pointer.  Adjust the
definition of dirtytime_interval_handler to match its prototype in
linux/writeback.h which fixes the following sparse error/warning:

fs/fs-writeback.c:2189:50: warning: incorrect type in argument 3 (different address spaces)
fs/fs-writeback.c:2189:50:    expected void *
fs/fs-writeback.c:2189:50:    got void [noderef] __user *buffer
fs/fs-writeback.c:2184:5: error: symbol 'dirtytime_interval_handler' redeclared with different type (incompatible argument 3 (different address spaces)):
fs/fs-writeback.c:2184:5:    int extern [addressable] [signed] [toplevel] dirtytime_interval_handler( ... )
fs/fs-writeback.c: note: in included file:
./include/linux/writeback.h:374:5: note: previously declared as:
./include/linux/writeback.h:374:5:    int extern [addressable] [signed] [toplevel] dirtytime_interval_handler( ... )

Link: https://lkml.kernel.org/r/20200907093140.13434-1-tklauser@distanz.ch
Fixes: 32927393dc1c ("sysctl: pass kernel pointers to ->proc_handler")
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fs-writeback.c~fs-adjust-dirtytime_interval_handler-definition-to-match-prototype
+++ a/fs/fs-writeback.c
@@ -2184,7 +2184,7 @@ static int __init start_dirtytime_writeb
 __initcall(start_dirtytime_writeback);
 
 int dirtytime_interval_handler(struct ctl_table *table, int write,
-			       void __user *buffer, size_t *lenp, loff_t *ppos)
+			       void *buffer, size_t *lenp, loff_t *ppos)
 {
 	int ret;
 
_

Patches currently in -mm which might be from tklauser@distanz.ch are


