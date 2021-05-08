Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 137E2C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:51:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB25860233
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:51:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbhEHWwv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:52:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229647AbhEHWwu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:52:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CC54610FA;
        Sat,  8 May 2021 22:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514308;
        bh=0uhpm0sm9uyGvxClD1dCTBatfuaxZ6wqQYIrafu6MRc=;
        h=Date:From:To:Subject:From;
        b=qtugk9WluB9Ud9U4bFDY6HbC64dnD+ZOkyYvERVotcFlUhoLEO4Zsezi7/RKoXAs0
         BEG5VfmIBsUXyf9THovPCXDIK4Z2G6T33RhH1essyAS24p7e5miQvELIJnC1ArnFhZ
         59gOX9w6k+nTzNLUU0twotNrWxzF1f1c/kL9R+rE=
Date:   Sat, 08 May 2021 15:51:48 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, mm-commits@vger.kernel.org
Subject:  [merged] proc-save-loc-in-__xlate_proc_name.patch removed
 from -mm tree
Message-ID: <20210508225148.QMeUiOmpl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: save LOC in __xlate_proc_name()
has been removed from the -mm tree.  Its filename was
     proc-save-loc-in-__xlate_proc_name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


