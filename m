Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95D65C43334
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbiGRA0u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiGRA0u (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:26:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1FD2E0ED
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:26:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DB0C60F8C
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:26:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3511C3411E;
        Mon, 18 Jul 2022 00:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658104008;
        bh=/HKbRVAFYCKKtu+5jQcWQ8mwAcsw4zM+Tme6oI33wwQ=;
        h=Date:To:From:Subject:From;
        b=p6DWwPCzLmoZGr5N1dFrM/hURvRZdbkkWjx/fFAVx/QZ6BTXOtib0mDK1HwGQKHHb
         qoU617+dt14p9ah5BsUVcoLGfV8tnwJa2pzsCNxRhQouCEJcqnWh4FvLRFrQjMN1h8
         JuhZdCQQ4ymKalaK2V8NhFTungaGfDH3YNsKDoe8=
Date:   Sun, 17 Jul 2022 17:26:48 -0700
To:     mm-commits@vger.kernel.org, dmoulding@me.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] init-add-hostname-kernel-parameter-v2.patch removed from -mm tree
Message-Id: <20220718002648.D3511C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: init-add-hostname-kernel-parameter-v2
has been removed from the -mm tree.  Its filename was
     init-add-hostname-kernel-parameter-v2.patch

This patch was dropped because it was folded into init-add-hostname-kernel-parameter.patch

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
@@ -1665,6 +1665,8 @@
 			Valid parameters: "on", "off"
 			Default: "on"
 
+	hlt		[BUGS=ARM,SH]
+
 	hostname=	[KNL] Set the hostname (aka UTS nodename).
 			Format: <string>
 			This allows setting the system's hostname during early
@@ -1678,8 +1680,6 @@
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

