Return-Path: <SRS0=RNAI=BY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CB14C433E1
	for <mm-commits@archiver.kernel.org>; Fri, 14 Aug 2020 02:35:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2018820716
	for <mm-commits@archiver.kernel.org>; Fri, 14 Aug 2020 02:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597372537;
	bh=ZTFP3uXQF73asYI6K9rHVN7yBp/d7j/vXaOcWtnDaYM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Kww+x+gdeRyHciphJ9N74x9XBMEHWVwkoqa3HhLnVIQviefXDn8mSm9/BW9WjwMHr
	 DRTAgdGnrE3ebzPA5GeS+FeGFxREW3yhmsbj/VeVq5Ggv2QbMEUhONO87opHpnkIwu
	 T9bGtSzgSxHD6HuOjN28ptt/WyCXWlxpamrUnnzQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgHNCfg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Aug 2020 22:35:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:54970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726564AbgHNCfg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 Aug 2020 22:35:36 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAE7720716;
        Fri, 14 Aug 2020 02:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597372536;
        bh=ZTFP3uXQF73asYI6K9rHVN7yBp/d7j/vXaOcWtnDaYM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=X239+R5YkHO7pAwHgJYmucKHtgpVu9Mi2nY9JWHi7dqauTmOn6T3H1VhCuE9LhAcK
         6FiWCx70nF5+hc8+qFomHVoLHSZytltYTdwM12+YGzMykE2Dif9Sxo8LtfNJBqIj+k
         xS3CNVqeECnW9KQSMrb2J5jrp8RfvMtqVg10/ewc=
Date:   Thu, 13 Aug 2020 19:35:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     keescook@chromium.org, maz@kernel.org, mm-commits@vger.kernel.org
Subject:  + exec-restore-eacces-of-s_isdir-execve.patch added to
 -mm tree
Message-ID: <20200814023535.H8vHiL5Qd%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: exec: restore EACCES of S_ISDIR execve()
has been added to the -mm tree.  Its filename is
     exec-restore-eacces-of-s_isdir-execve.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exec-restore-eacces-of-s_isdir-execve.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/exec-restore-eacces-of-s_isdir-execve.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

exec-restore-eacces-of-s_isdir-execve.patch
selftests-exec-add-file-type-errno-tests.patch

