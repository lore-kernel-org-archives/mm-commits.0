Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4E78FA3741
	for <mm-commits@archiver.kernel.org>; Mon, 31 Oct 2022 22:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiJaWFg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Oct 2022 18:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiJaWFe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Oct 2022 18:05:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D95014D04
        for <mm-commits@vger.kernel.org>; Mon, 31 Oct 2022 15:05:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3737D6137C
        for <mm-commits@vger.kernel.org>; Mon, 31 Oct 2022 22:05:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83905C433C1;
        Mon, 31 Oct 2022 22:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667253932;
        bh=Co5XfRrz5p9qtjrjEfqk8o0SR2jMLhK1wS2VOPOtusI=;
        h=Date:To:From:Subject:From;
        b=CLAUjlW9IMPnnrHukfUgNovt9HFxZMltjovt980MWYXUPPsiSNT9BdZRX8v5TJof+
         B0PIBqpRGYOf29hFJEJwhNJVJYQ2LqrAa0WEelUUDqQ/WHDzg/PmjVnVs8HgCHjB/N
         tQbpmZjAFAh/Wf5KceQG3Dl44KQXLJPmncCRKAaE=
Date:   Mon, 31 Oct 2022 15:05:31 -0700
To:     mm-commits@vger.kernel.org, yangyingliang@huawei.com,
        thomas.orgis@uni-hamburg.de, ismael@iodev.co.uk,
        wangxiongfeng2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-accounting-procacct-remove-some-unused-variables.patch added to mm-nonmm-unstable branch
Message-Id: <20221031220532.83905C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/accounting/procacct: remove some unused variables
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     tools-accounting-procacct-remove-some-unused-variables.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-accounting-procacct-remove-some-unused-variables.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Subject: tools/accounting/procacct: remove some unused variables
Date: Mon, 31 Oct 2022 17:15:57 +0800

Drop the following unused variables inherited from getdelays.c:

  'aggr_len', 'len2', 'cmd_type', 'tid', 'containerset', 'containerpath'
  and 'sigset'.

Link: https://lkml.kernel.org/r/20221031091557.192180-1-wangxiongfeng2@huawei.com
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Cc: "Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
Cc: Ismael Luceno <ismael@iodev.co.uk>
Cc: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/accounting/procacct.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/tools/accounting/procacct.c~tools-accounting-procacct-remove-some-unused-variables
+++ a/tools/accounting/procacct.c
@@ -261,25 +261,20 @@ void handle_aggr(int mother, struct nlat
 
 int main(int argc, char *argv[])
 {
-	int c, rc, rep_len, aggr_len, len2;
-	int cmd_type = TASKSTATS_CMD_ATTR_UNSPEC;
+	int c, rc, rep_len;
 	__u16 id;
 	__u32 mypid;
 
 	struct nlattr *na;
 	int nl_sd = -1;
 	int len = 0;
-	pid_t tid = 0;
 
 	int fd = 0;
 	int write_file = 0;
 	int maskset = 0;
 	char *logfile = NULL;
-	int containerset = 0;
-	char *containerpath = NULL;
 	int cfd = 0;
 	int forking = 0;
-	sigset_t sigset;
 
 	struct msgtemplate msg;
 
_

Patches currently in -mm which might be from wangxiongfeng2@huawei.com are

tools-accounting-procacct-remove-some-unused-variables.patch

