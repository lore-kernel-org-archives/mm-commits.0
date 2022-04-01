Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FBA3C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  1 Apr 2022 18:29:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351054AbiDASar (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Apr 2022 14:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351064AbiDASap (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 1 Apr 2022 14:30:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682301C1EFE
        for <mm-commits@vger.kernel.org>; Fri,  1 Apr 2022 11:28:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 066B060BA8
        for <mm-commits@vger.kernel.org>; Fri,  1 Apr 2022 18:28:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C923C2BBE4;
        Fri,  1 Apr 2022 18:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648837729;
        bh=DCibZQewi/0BBcb27xyMZjj8pKguysaeJUdBaIHe/zQ=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=ERbQWDyD/kt4XjR3wfgrDYch+DWOKagMys9BqJfWTLIWZPnvmmFBfTkw+g0sn5qxS
         041aI11OKVyKEMKjbPS8Ri65kVWVNmqCyNVWZynpcntwdvZH08pzdcVj/HH9wKUtiC
         mr188EiYOW1f/GBa4X+aB0COI+QX8RSn31OiB7io=
Date:   Fri, 01 Apr 2022 11:28:48 -0700
To:     zhaochongxi2019@email.szu.edu.cn, yuhongf@szu.edu.cn,
        yejiajian2018@email.szu.edu.cn, weizhenliang@huawei.com,
        tangbin@cmss.chinamobile.com, sfr@canb.auug.org.au,
        seanga2@gmail.com, liuyongqiang13@huawei.com,
        georgi.djakov@linaro.org, corbet@lwn.net,
        caoyixuan2019@email.szu.edu.cn, zhangyinan2019@email.szu.edu.cn,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220401112740.351496714b370467a92207a6@linux-foundation.org>
Subject: [patch 13/16] tools/vm/page_owner_sort.c: remove -c option
Message-Id: <20220401182849.5C923C2BBE4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yinan Zhang <zhangyinan2019@email.szu.edu.cn>
Subject: tools/vm/page_owner_sort.c: remove -c option

-c option is used to cull by stacktrace.  Now, --cull option has been
Added in page_owner_sort.c.  Culling by stacktrace is one of the function
of "--cull".  No need to set an extra parameter.  So remove -c option.

Remove parsing of -c when parse parameter and remove "-c" from usage.

This work is coauthored by
        Shenghong Han
        Yixuan Cao
        Chongxi Zhao
        Jiajian Ye
        Yuhong Feng
        Yongqiang Liu

Link: https://lkml.kernel.org/r/20220326085920.1470081-1-zhangyinan2019@email.szu.edu.cn
Signed-off-by: Yinan Zhang <zhangyinan2019@email.szu.edu.cn>
Cc: Chongxi Zhao <zhaochongxi2019@email.szu.edu.cn>
Cc: Georgi Djakov <georgi.djakov@linaro.org>
Cc: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Sean Anderson <seanga2@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Tang Bin <tangbin@cmss.chinamobile.com>
Cc: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Cc: Yongqiang Liu <liuyongqiang13@huawei.com>
Cc: Yuhong Feng <yuhongf@szu.edu.cn>
Cc: Zhenliang Wei <weizhenliang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page_owner_sort.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/tools/vm/page_owner_sort.c~tools-vm-page_owner_sortc-remove-c-option
+++ a/tools/vm/page_owner_sort.c
@@ -441,7 +441,6 @@ static void usage(void)
 		"-n\t\tSort by task command name.\n"
 		"-a\t\tSort by memory allocate time.\n"
 		"-r\t\tSort by memory release time.\n"
-		"-c\t\tCull by comparing stacktrace instead of total block.\n"
 		"-f\t\tFilter out the information of blocks whose memory has been released.\n"
 		"--pid <PID>\tSelect by pid. This selects the information of blocks whose process ID number equals to <PID>.\n"
 		"--tgid <TGID>\tSelect by tgid. This selects the information of blocks whose Thread Group ID number equals to <TGID>.\n"
@@ -466,14 +465,11 @@ int main(int argc, char **argv)
 		{ 0, 0, 0, 0},
 	};
 
-	while ((opt = getopt_long(argc, argv, "acfmnprstP", longopts, NULL)) != -1)
+	while ((opt = getopt_long(argc, argv, "afmnprstP", longopts, NULL)) != -1)
 		switch (opt) {
 		case 'a':
 			cmp = compare_ts;
 			break;
-		case 'c':
-			cull = cull | CULL_STACKTRACE;
-			break;
 		case 'f':
 			filter = filter | FILTER_UNRELEASE;
 			break;
_
