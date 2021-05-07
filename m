Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54740C43460
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:02:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3548061289
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:02:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233908AbhEGBDO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:03:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229637AbhEGBDM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:03:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99DF6611EE;
        Fri,  7 May 2021 01:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349333;
        bh=KhSCk+ZQc5ZKoaI/8/FZbZd7J8mNBUiVzpO9VoBdA30=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=irmUPySYSIuExOEOx6k6JBHWEZuRSvP91D4KgN5Is0vER795LR5irxcQ2MZd9bTOq
         niah9cwKR58E7bvJIWV+b9674stlpk6Mu8REpAR4FLywCCCp4WrZA42whE8S72qi23
         AxpqqOCconUyi/RBJGp3MHEj/S58ukcTbMbCbrTY=
Date:   Thu, 06 May 2021 18:02:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 04/91] proc: save LOC in __xlate_proc_name()
Message-ID: <20210507010213.V8MhqooKS%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: save LOC in __xlate_proc_name()

Can't look at this verbosity anymore.

Link: https://lkml.kernel.org/r/YFYXAp/fgq405qcy@localhost.localdomain
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/fs/proc/generic.c~proc-save-loc-in-__xlate_proc_name
+++ a/fs/proc/generic.c
@@ -166,15 +166,8 @@ static int __xlate_proc_name(const char
 	const char     		*cp = name, *next;
 	struct proc_dir_entry	*de;
 
-	de = *ret;
-	if (!de)
-		de = &proc_root;
-
-	while (1) {
-		next = strchr(cp, '/');
-		if (!next)
-			break;
-
+	de = *ret ?: &proc_root;
+	while ((next = strchr(cp, '/'))) {
 		de = pde_subdir_find(de, cp, next - cp);
 		if (!de) {
 			WARN(1, "name '%s'\n", name);
_
