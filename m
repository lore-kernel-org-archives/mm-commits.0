Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6017CC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  6 May 2022 22:38:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355278AbiEFWmm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 May 2022 18:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348461AbiEFWml (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 May 2022 18:42:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79CEE5AA48
        for <mm-commits@vger.kernel.org>; Fri,  6 May 2022 15:38:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1426861766
        for <mm-commits@vger.kernel.org>; Fri,  6 May 2022 22:38:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657B8C385A9;
        Fri,  6 May 2022 22:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651876736;
        bh=Z0oJFNjkG0DVRzmC3BRjYyiU3sSpt+/WCRGi3Qdxisg=;
        h=Date:To:From:Subject:From;
        b=BkFoUodAqNT4ly5NC1IevvlyAZ+6HUm3RHXRSJ+RGrDrEsQFogpIF5FOucN2XbH0w
         nu0jNeQn3okdhGzYsCF8Vd5fRGx0DMXlM4Gxs+3Yw2ztt6rZEBlFd2/a7jK60PpOQy
         ffHixph90aou7CaskduXFNV0Zt45IC/BlTT3nrAM=
Date:   Fri, 06 May 2022 15:38:55 -0700
To:     mm-commits@vger.kernel.org, dmoulding@me.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + init-add-hostname-kernel-parameter-v2.patch added to mm-nonmm-unstable branch
Message-Id: <20220506223856.657B8C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: init-add-hostname-kernel-parameter-v2
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     init-add-hostname-kernel-parameter-v2.patch

This patch should soon appear in the mm-nonmm-unstable branch at
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
From: Dan Moulding <dmoulding@me.com>
Subject: init-add-hostname-kernel-parameter-v2

Link: https://lkml.kernel.org/r/20220506060310.7495-2-dmoulding@me.com
Signed-off-by: Dan Moulding <dmoulding@me.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    4 ++--
 init/version.c                                  |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~init-add-hostname-kernel-parameter-v2
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -1615,6 +1615,8 @@
 			Valid parameters: "on", "off"
 			Default: "on"
 
+	hlt		[BUGS=ARM,SH]
+
 	hostname=	[KNL] Set the hostname (aka UTS nodename).
 			Format: <string>
 			This allows setting the system's hostname during early
@@ -1628,8 +1630,6 @@
 			not exceed the maximum allowed hostname length (usually
 			64 characters) and will be truncated otherwise.
 
-	hlt		[BUGS=ARM,SH]
-
 	hpet=		[X86-32,HPET] option to control HPET usage
 			Format: { enable (default) | disable | force |
 				verbose }
--- a/init/version.c~init-add-hostname-kernel-parameter-v2
+++ a/init/version.c
@@ -41,12 +41,12 @@ static int __init early_hostname(char *a
 {
 	size_t bufsize = sizeof(init_uts_ns.name.nodename);
 	size_t maxlen  = bufsize - 1;
+	size_t arglen;
 
-	strncpy(init_uts_ns.name.nodename, arg, bufsize);
-	if (strlen(arg) > maxlen) {
+	arglen = strlcpy(init_uts_ns.name.nodename, arg, bufsize);
+	if (arglen > maxlen) {
 		pr_warn("hostname parameter exceeds %zd characters and will be truncated",
 			maxlen);
-		init_uts_ns.name.nodename[maxlen] = '\0';
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from dmoulding@me.com are

init-add-hostname-kernel-parameter.patch
init-add-hostname-kernel-parameter-v2.patch

