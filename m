Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55FECC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:33:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbiKOWdX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:33:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbiKOWdA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:33:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 505A931205
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:32:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05F39B81B77
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:32:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96B3C433D6;
        Tue, 15 Nov 2022 22:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551551;
        bh=/uTc+RxFXShd8AMxh2qN7wIp2yMrv/I/X7CfUqjfArg=;
        h=Date:To:From:Subject:From;
        b=ZVLHzkNult4foMqVmn/b3DvTDv/qfqb2dRF5iDz2RUC5KWTAXNr/t5KW7vJqL9Nk2
         GdgOM8sHuj6LFPjE3zkdVyU+QNFwt5N+ohN5sRK9R+2Z+YaKxC5MsbUIMPLmP7buW+
         Cz8I4EK7cNgmeimE65itrNVPu5rn3ZHJ4NWNiULk=
Date:   Tue, 15 Nov 2022 14:32:31 -0800
To:     mm-commits@vger.kernel.org, yangyingliang@huawei.com,
        thomas.orgis@uni-hamburg.de, ismael@iodev.co.uk,
        wangxiongfeng2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] tools-accounting-procacct-remove-some-unused-variables.patch removed from -mm tree
Message-Id: <20221115223231.A96B3C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: tools/accounting/procacct: remove some unused variables
has been removed from the -mm tree.  Its filename was
     tools-accounting-procacct-remove-some-unused-variables.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


