Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2C15C433F5
	for <mm-commits@archiver.kernel.org>; Sat, 26 Feb 2022 03:10:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiBZDLa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Feb 2022 22:11:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiBZDLa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Feb 2022 22:11:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107A32671D9
        for <mm-commits@vger.kernel.org>; Fri, 25 Feb 2022 19:10:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD102B833C6
        for <mm-commits@vger.kernel.org>; Sat, 26 Feb 2022 03:10:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47DF8C340E7;
        Sat, 26 Feb 2022 03:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645845054;
        bh=9w6nj+vfsclp2nD/Fbt10tUJnWck/t9iRVcxDsSPfMk=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=KPLzSg/OHZq1SXQ6oUZ1MvQqVYcLM/KMLnrxH1iZrSG8YUu1pVg0l9tJtlS6sPuDp
         nssA4mGNXvl04woSMBjqp7woE1nvhXyENMLPUPAd0iK5Lf8gwBGXWLMjovqXGfmxU1
         csINX8wKFWnUWbJA1DEOqZryrJxzxXZluu8cJdCU=
Date:   Fri, 25 Feb 2022 19:10:53 -0800
To:     yzaikin@google.com, sfr@canb.auug.org.au, keescook@chromium.org,
        mcgrof@kernel.org, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220225191021.f71538a3f43dc448110e88b6@linux-foundation.org>
Subject: [patch 01/12] MAINTAINERS: add sysctl-next git tree
Message-Id: <20220226031054.47DF8C340E7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Luis Chamberlain <mcgrof@kernel.org>
Subject: MAINTAINERS: add sysctl-next git tree

Add a git tree for sysctls as there's been quite a bit of work lately to
remove all the syctls out of kernel/sysctl.c and move to their respective
places, so coordination has been needed to avoid conflicts.  This tree
will also help soak these changes on linux-next prior to getting to Linus.

Link: https://lkml.kernel.org/r/20220218182736.3694508-1-mcgrof@kernel.org
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-sysctl-next-git-tree
+++ a/MAINTAINERS
@@ -15567,6 +15567,7 @@ M:	Iurii Zaikin <yzaikin@google.com>
 L:	linux-kernel@vger.kernel.org
 L:	linux-fsdevel@vger.kernel.org
 S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git sysctl-next
 F:	fs/proc/proc_sysctl.c
 F:	include/linux/sysctl.h
 F:	kernel/sysctl-test.c
_
