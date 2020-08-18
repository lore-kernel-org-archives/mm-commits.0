Return-Path: <SRS0=0jXN=B4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D314DC433DF
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:40:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADFE520789
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597790421;
	bh=sNA5nXBOJRESC5kyI0/VudBOQig5vtkLt/FAPtueUrI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=rcORD3xwwv1Sjw7HgjPNU48UwlGF6bKz5SDm5DmwdfhIC8N4CgvSrV8/YNhDcMMpQ
	 +/D3IIH/ANc0At5AGI3gKCZu+CfGIMN/7wt3abJhnMSsaAfw+rOwghH4fY6X6XWulH
	 40iDUEnCijNQOB+PEFRvtt+w3ex3s8Rnbl6lI7j8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbgHRWkV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 18:40:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727103AbgHRWkQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 18:40:16 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8275220789;
        Tue, 18 Aug 2020 22:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597790415;
        bh=sNA5nXBOJRESC5kyI0/VudBOQig5vtkLt/FAPtueUrI=;
        h=Date:From:To:Subject:From;
        b=sqb4FW9zdrqUNaoQvfRALb1WAoKga1KvnDmwhUc2tARcRsBTbeMFzObQczQxvBy0+
         Hw9NGrGNAZGJExqQEde5qCFsdxu2Vosd8BYVp6F7kkECJ2VU8aHDb2u9NvC2BmfOkB
         Xuw5lQtisGNovrPV2hrDHlBiQTVCk/6dXmZxsfE8=
Date:   Tue, 18 Aug 2020 15:40:15 -0700
From:   akpm@linux-foundation.org
To:     gregkh@android.com, gregkh@google.com, keescook@chromium.org,
        maz@kernel.org, mm-commits@vger.kernel.org
Subject:  [merged] exec-restore-eacces-of-s_isdir-execve.patch
 removed from -mm tree
Message-ID: <20200818224015.ZvRadDUyj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: exec: restore EACCES of S_ISDIR execve()
has been removed from the -mm tree.  Its filename was
     exec-restore-eacces-of-s_isdir-execve.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: exec: restore EACCES of S_ISDIR execve()

Patch series "Fix S_ISDIR execve() errno".

Fix an errno change for execve() of directories, noticed by Marc Zyngier. 
Along with the fix, include a regression test to avoid seeing this return
in the future.


This patch (of 2):

The return code for attempting to execute a directory has always been
EACCES.  Adjust the S_ISDIR exec test to reflect the old errno instead of
the general EISDIR for other kinds of "open" attempts on directories.

Link: http://lkml.kernel.org/r/20200813231723.2725102-2-keescook@chromium.org
Link: https://lore.kernel.org/lkml/20200813151305.6191993b@why
Fixes: 633fb6ac3980 ("exec: move S_ISREG() check earlier")
Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@google.com>
Tested-by: Greg Kroah-Hartman <gregkh@android.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/namei.c~exec-restore-eacces-of-s_isdir-execve
+++ a/fs/namei.c
@@ -2849,8 +2849,10 @@ static int may_open(const struct path *p
 	case S_IFLNK:
 		return -ELOOP;
 	case S_IFDIR:
-		if (acc_mode & (MAY_WRITE | MAY_EXEC))
+		if (acc_mode & MAY_WRITE)
 			return -EISDIR;
+		if (acc_mode & MAY_EXEC)
+			return -EACCES;
 		break;
 	case S_IFBLK:
 	case S_IFCHR:
_

Patches currently in -mm which might be from keescook@chromium.org are


