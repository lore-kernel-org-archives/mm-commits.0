Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC08BC433C1
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 22:18:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 861046191C
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 22:18:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbhC1WRi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 18:17:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229656AbhC1WRM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 18:17:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A722860233;
        Sun, 28 Mar 2021 22:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616969831;
        bh=3FoEu8aXnEnbCIKPlb8EhqYv2yBWOz786mLbEFmSuaI=;
        h=Date:From:To:Subject:From;
        b=v58aQzI6LTgboNN/kf8XIUSsxACgnriT2Q1tGLPUE7CFVRtyayZ6PMwpX+VOJOZfa
         zYJAPJf8nere/iMUSgB4u0fKbVgW2CaQCwtl4nxaqIO85SPQxVxSI3KqjdF1+zE9L3
         FhM1m+JAHqzaG+xkdMBhRz9WIL+yBim3zMF7M9Wo=
Date:   Sun, 28 Mar 2021 15:17:11 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, mm-commits@vger.kernel.org
Subject:  + proc-save-loc-in-__xlate_proc_name.patch added to -mm
 tree
Message-ID: <20210328221711.7eaMYDo8B%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: save LOC in __xlate_proc_name()
has been added to the -mm tree.  Its filename is
     proc-save-loc-in-__xlate_proc_name.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/proc-save-loc-in-__xlate_proc_name.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/proc-save-loc-in-__xlate_proc_name.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-save-loc-in-__xlate_proc_name.patch
proc-mandate-proc_lseek-in-struct-proc_ops.patch
proc-delete-redundant-subset=pid-check.patch
proc-test-subset=pid.patch

