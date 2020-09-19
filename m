Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 662B2C43468
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 04:20:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28244235F9
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 04:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600489241;
	bh=hnDBDm/0gpMNBjiaT6pFzyQCl1gatJgakUiMWgconGQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Qh2p8V0rD61oD7cC/U/YmIox0YAvT5lzpvBAGz/6hY7ADQuL0v8g/ISVE8+K8khsn
	 iBFiBO/9Q+QArSms2sXj5AnzQTdmqszkXwyk8ZJ/iVyRUCuEteTOk8gQ86O/ElRPzk
	 5lN50bJ7dRTmwBRfvXB1LW/7HmbHGkAP+yuqjr9k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbgISEUk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 19 Sep 2020 00:20:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgISEUk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 19 Sep 2020 00:20:40 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3ADEE22208;
        Sat, 19 Sep 2020 04:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600489240;
        bh=hnDBDm/0gpMNBjiaT6pFzyQCl1gatJgakUiMWgconGQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=UTpcdDVBFiLXJAI26xEqv0xdJ5NaoM52QvWY8w1Y05W9eEFD2WyCNv2zTJPaoMaje
         ZEFIWm2ulBWO4mJ5NeuIYeOskyYF16s/SkaA33OHMnxDrrKxNIUmKhprL5hKKUUSyj
         fMttAMy63ek8B3GplCANZN7LrbRniXVuksKq0PME=
Date:   Fri, 18 Sep 2020 21:20:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, jack@suse.cz,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        tklauser@distanz.ch, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject:  [patch 14/15] fs/fs-writeback.c: adjust
 dirtytime_interval_handler definition to match prototype
Message-ID: <20200919042039.taXFWO2ve%akpm@linux-foundation.org>
In-Reply-To: <20200918211925.7e97f0ef63d92f5cfe5ccbc5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
