Return-Path: <SRS0=U74d=BZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DATE_IN_PAST_12_24,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42847C433E1
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:11:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 119DA20657
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597529507;
	bh=QBXzTQcMnoIh0FsmTT777HtmQhovmOY+Gre/6iajyjQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=EwCGp7Roj/8qPxSSblfVMze7Hjozmh6u0epjMpE+yV42EuYElXErauZB6nLLCU8BK
	 zsXapERA7XTiUDH0JmTSEgbmVu6br3vJXKofkoo1Y0zmIi+LQtkZ8CJC5S+a4QvSHn
	 dtWvZdZHdHYKzULJTyVfec3VaQcISoZBVGFXgBKM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730050AbgHOWLo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 15 Aug 2020 18:11:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:41790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728120AbgHOWKa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 15 Aug 2020 18:10:30 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7AC2221E2;
        Sat, 15 Aug 2020 00:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597451415;
        bh=QBXzTQcMnoIh0FsmTT777HtmQhovmOY+Gre/6iajyjQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gR7BEoRuMT/2lqlBaWe1qK3fzQfzjgUqlopmugyKrRZ1oiXevSLnYTAE53P00aEMH
         8cg2K+XpFrcoqsDJu0gvyYVtr8dMVPC33gslRMe+1gb/vR8KNoQv8/solUrngnkqbM
         qPErV37clTVoNQ2SacH+LruFmJ16kYwN9IUPSGnQ=
Date:   Fri, 14 Aug 2020 17:30:14 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, gregkh@android.com, gregkh@google.com,
        keescook@chromium.org, linux-mm@kvack.org, maz@kernel.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 04/39] exec: restore EACCES of S_ISDIR execve()
Message-ID: <20200815003014.DWF4Lqhri%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
