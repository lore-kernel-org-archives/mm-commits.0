Return-Path: <SRS0=2RlJ=CN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 001C1C43461
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 23:35:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B525A208C7
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 23:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599262551;
	bh=Mnr9anBUyRw4Nw5T3QhBFrDHFr9FXHh+qIzIvxlgVNo=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=c3PaHmPvxPIOXvm523Cdx8dNK0HeMBHewCTrWdT2uK8rhcnQXgR8FlUUcTCTSxr3r
	 lVmE5Ch0+MXNHbHyRDquy/gRUSN3iMkQNgk+DVVmjrEDSRvuVIX+lBGF4gb+/oRgJL
	 +6sDaxeOBLedCqGHZGfwZrtchBmU4n/lLSIfpMjA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728163AbgIDXfv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Sep 2020 19:35:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:38814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726456AbgIDXfu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Sep 2020 19:35:50 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B4E0208FE;
        Fri,  4 Sep 2020 23:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599262549;
        bh=Mnr9anBUyRw4Nw5T3QhBFrDHFr9FXHh+qIzIvxlgVNo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ELwvi10StNI7NthwxdgjAQui7x2z+Dj+0IgjdEjhitKIG7r974/4u2H4YevedeSoO
         eEobwQ9Ho5hLKPGfkPDCBDR4it/EyKw/XvdobGtvUygZjgSscq5v2Us5GB+v0OLSKB
         TdSlPvr4OTeTuIEfg0ujOSw9wHO/JsYwALoCEOzw=
Date:   Fri, 04 Sep 2020 16:35:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, tklauser@distanz.ch,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject:  [patch 09/19] fork: adjust sysctl_max_threads definition
 to match prototype
Message-ID: <20200904233549.BMYcHF_T9%akpm@linux-foundation.org>
In-Reply-To: <20200904163454.4db0e6ce0c4584d2653678a3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Tobias Klauser <tklauser@distanz.ch>
Subject: fork: adjust sysctl_max_threads definition to match prototype

Commit 32927393dc1c ("sysctl: pass kernel pointers to ->proc_handler")
changed ctl_table.proc_handler to take a kernel pointer.  Adjust the
definition of sysctl_max_threads to match its prototype in linux/sysctl.h
which fixes the following sparse error/warning:

kernel/fork.c:3050:47: warning: incorrect type in argument 3 (different address spaces)
kernel/fork.c:3050:47:    expected void *
kernel/fork.c:3050:47:    got void [noderef] __user *buffer
kernel/fork.c:3036:5: error: symbol 'sysctl_max_threads' redeclared with different type (incompatible argument 3 (different address spaces)):
kernel/fork.c:3036:5:    int extern [addressable] [signed] [toplevel] sysctl_max_threads( ... )
kernel/fork.c: note: in included file (through include/linux/key.h, include/linux/cred.h, include/linux/sched/signal.h, include/linux/sched/cputime.h):
./include/linux/sysctl.h:242:5: note: previously declared as:
./include/linux/sysctl.h:242:5:    int extern [addressable] [signed] [toplevel] sysctl_max_threads( ... )

Link: https://lkml.kernel.org/r/20200825093647.24263-1-tklauser@distanz.ch
Fixes: 32927393dc1c ("sysctl: pass kernel pointers to ->proc_handler")
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/fork.c~fork-adjust-sysctl_max_threads-definition-to-match-prototype
+++ a/kernel/fork.c
@@ -3014,7 +3014,7 @@ int unshare_files(struct files_struct **
 }
 
 int sysctl_max_threads(struct ctl_table *table, int write,
-		       void __user *buffer, size_t *lenp, loff_t *ppos)
+		       void *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table t;
 	int ret;
_
