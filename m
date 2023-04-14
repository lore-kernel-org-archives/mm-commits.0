Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A02DC77B72
	for <mm-commits@archiver.kernel.org>; Fri, 14 Apr 2023 18:51:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjDNSv5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Apr 2023 14:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjDNSv4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Apr 2023 14:51:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD95265A8
        for <mm-commits@vger.kernel.org>; Fri, 14 Apr 2023 11:51:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46706649D6
        for <mm-commits@vger.kernel.org>; Fri, 14 Apr 2023 18:51:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E52C433EF;
        Fri, 14 Apr 2023 18:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681498314;
        bh=mTrlDSj9QoMjj4efz79aYd0llePFMb1QTZKrmCsHkjs=;
        h=Date:To:From:Subject:From;
        b=m2oTf2LRUV1o0ggQkExEZpQ2ptReTkzuk3g7miZvSNkfgh58uQzvewFT8LAMMs4j3
         1z423e5BAJ73xyBCoVyMFSP0Kzz0SR/SlRrzK3xDoE4i/7Lfzv4axSm5AymEjlzQRk
         qXQkkzhZGD4UkFTUgAnKh7sBjswPN8kNfO3kqrWA=
Date:   Fri, 14 Apr 2023 11:51:53 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        Vincenzo.Frascino@arm.com, tytso@mit.edu, Szabolcs.Nagy@arm.com,
        Mark.Rutland@arm.com, Kevin.Brodsky@arm.com, jlayton@kernel.org,
        David.Laight@ACULAB.com, chuck.lever@oracle.com,
        brauner@kernel.org, Luca.Vizzarro@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memfd-pass-argument-of-memfd_fcntl-as-int.patch added to mm-unstable branch
Message-Id: <20230414185154.90E52C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memfd: pass argument of memfd_fcntl as int
has been added to the -mm mm-unstable branch.  Its filename is
     memfd-pass-argument-of-memfd_fcntl-as-int.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memfd-pass-argument-of-memfd_fcntl-as-int.patch

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
From: Luca Vizzarro <Luca.Vizzarro@arm.com>
Subject: memfd: pass argument of memfd_fcntl as int
Date: Fri, 14 Apr 2023 16:24:58 +0100

The interface for fcntl expects the argument passed for the command
F_ADD_SEALS to be of type int.  The current code wrongly treats it as a
long.  In order to avoid access to undefined bits, we should explicitly
cast the argument to int.

This commit changes the signature of all the related and helper functions
so that they treat the argument as int instead of long.

Link: https://lkml.kernel.org/r/20230414152459.816046-5-Luca.Vizzarro@arm.com
Signed-off-by: Luca Vizzarro <Luca.Vizzarro@arm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Kevin Brodsky <Kevin.Brodsky@arm.com>
Cc: Vincenzo Frascino <Vincenzo.Frascino@arm.com>
Cc: Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: David Laight <David.Laight@ACULAB.com>
Cc: Mark Rutland <Mark.Rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memfd.h |    4 ++--
 mm/memfd.c            |    6 +-----
 2 files changed, 3 insertions(+), 7 deletions(-)

--- a/include/linux/memfd.h~memfd-pass-argument-of-memfd_fcntl-as-int
+++ a/include/linux/memfd.h
@@ -5,9 +5,9 @@
 #include <linux/file.h>
 
 #ifdef CONFIG_MEMFD_CREATE
-extern long memfd_fcntl(struct file *file, unsigned int cmd, unsigned long arg);
+extern long memfd_fcntl(struct file *file, unsigned int cmd, unsigned int arg);
 #else
-static inline long memfd_fcntl(struct file *f, unsigned int c, unsigned long a)
+static inline long memfd_fcntl(struct file *f, unsigned int c, unsigned int a)
 {
 	return -EINVAL;
 }
--- a/mm/memfd.c~memfd-pass-argument-of-memfd_fcntl-as-int
+++ a/mm/memfd.c
@@ -243,16 +243,12 @@ static int memfd_get_seals(struct file *
 	return seals ? *seals : -EINVAL;
 }
 
-long memfd_fcntl(struct file *file, unsigned int cmd, unsigned long arg)
+long memfd_fcntl(struct file *file, unsigned int cmd, unsigned int arg)
 {
 	long error;
 
 	switch (cmd) {
 	case F_ADD_SEALS:
-		/* disallow upper 32bit */
-		if (arg > UINT_MAX)
-			return -EINVAL;
-
 		error = memfd_add_seals(file, arg);
 		break;
 	case F_GET_SEALS:
_

Patches currently in -mm which might be from Luca.Vizzarro@arm.com are

memfd-pass-argument-of-memfd_fcntl-as-int.patch

