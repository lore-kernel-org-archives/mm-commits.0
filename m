Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 583CEC433F5
	for <mm-commits@archiver.kernel.org>; Mon, 28 Mar 2022 21:13:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbiC1VPH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 17:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiC1VPG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 17:15:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6447A6EB1E
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 14:13:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F853B81214
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 21:13:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7E6C340F0;
        Mon, 28 Mar 2022 21:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648501999;
        bh=WxxfXJL3ULvQyUllhiMD+ylvy2VG3yMxSNnoDOX0t2o=;
        h=Date:To:From:Subject:From;
        b=Mze1z+xh466uE+jzIlGdRwwtEzADHtZQIDf8evptT3Xg0xewyf6n40epjh86Ucy15
         g5NtpeaGFEfNBOAkM9FvtqPpmaVeSh7i0AOhK1Z0w5YG+dsN2txWOh2kz65KEfv6lF
         w+pV27+R+dNREoY+DFK7FZpXc/WgZBnY6su+pIEI=
Date:   Mon, 28 Mar 2022 14:13:17 -0700
To:     mm-commits@vger.kernel.org, zhaochongxi2019@email.szu.edu.cn,
        yuhongf@szu.edu.cn, yejiajian2018@email.szu.edu.cn,
        weizhenliang@huawei.com, tangbin@cmss.chinamobile.com,
        sfr@canb.auug.org.au, seanga2@gmail.com, liuyongqiang13@huawei.com,
        georgi.djakov@linaro.org, corbet@lwn.net,
        caoyixuan2019@email.szu.edu.cn, zhangyinan2019@email.szu.edu.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-vm-page_owner_sortc-remove-c-option.patch added to -mm tree
Message-Id: <20220328211319.2A7E6C340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page_owner_sort.c: remove -c option
has been added to the -mm tree.  Its filename is
     tools-vm-page_owner_sortc-remove-c-option.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/tools-vm-page_owner_sortc-remove-c-option.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/tools-vm-page_owner_sortc-remove-c-option.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from zhangyinan2019@email.szu.edu.cn are

tools-vm-page_owner_sortc-remove-c-option.patch
doc-vm-page_ownerrst-remove-content-related-to-c-option.patch

