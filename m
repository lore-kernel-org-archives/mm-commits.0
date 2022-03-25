Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A8F5C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:33:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243019AbiCYBeo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357366AbiCYBdm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5E3BD8AB
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8ADCB826FE
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81147C340EC;
        Fri, 25 Mar 2022 01:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171927;
        bh=OegppEy31f/rVJAZP4q8qjONuai33kFSfN8b45qiV7Y=;
        h=Date:To:From:Subject:From;
        b=K43WUIKoc4QDMQ5XJXHC+8Tw55dOkRTxF4JglD0k2jW7vN72Jp0dpJc4HEQVjP45m
         nFbo8FUU59UprGmPHoxv71Meh8M4f7e//EtpiWdaa9ASsULurjOUOdxM6Sg4t9a3M4
         SB/+iNdS+FfTjrTZr+pjycrzwqM0r+g9sEG7I0i0=
Date:   Thu, 24 Mar 2022 18:32:06 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, guozhengkui@vivo.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] userfaultfd-selftests-fix-uninitialized_varcocci-warning.patch removed from -mm tree
Message-Id: <20220325013207.81147C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd/selftests: fix uninitialized_var.cocci warning
has been removed from the -mm tree.  Its filename was
     userfaultfd-selftests-fix-uninitialized_varcocci-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Guo Zhengkui <guozhengkui@vivo.com>
Subject: userfaultfd/selftests: fix uninitialized_var.cocci warning

Fix following coccicheck warning:
tools/testing/selftests/vm/userfaultfd.c:556:23-24:
WARNING this kind of initialization is deprecated

`unsigned long page_nr = *(&page_nr)` has the same form of
uninitialized_var() macro. I remove the redundant assignement. It has
been tested with gcc (Debian 8.3.0-6) 8.3.0.

The patch which removed uninitialized_var() is:
https://lore.kernel.org/all/20121028102007.GA7547@gmail.com/ And there is
very few "/* GCC */" comments in the Linux kernel code now.

Link: https://lkml.kernel.org/r/20220304082333.9252-1-guozhengkui@vivo.com
Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-fix-uninitialized_varcocci-warning
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -540,7 +540,7 @@ static void continue_range(int ufd, __u6
 static void *locking_thread(void *arg)
 {
 	unsigned long cpu = (unsigned long) arg;
-	unsigned long page_nr = *(&(page_nr)); /* uninitialized warning */
+	unsigned long page_nr;
 	unsigned long long count;
 
 	if (!(bounces & BOUNCE_RANDOM)) {
_

Patches currently in -mm which might be from guozhengkui@vivo.com are


